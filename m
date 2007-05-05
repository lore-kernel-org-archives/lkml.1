Return-Path: <linux-kernel-owner+w=401wt.eu-S1767956AbXEEDza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767956AbXEEDza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 23:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423980AbXEEDza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 23:55:30 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:25630 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422891AbXEEDz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 23:55:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sBtPwL8nCWRs/mxGka/enbeBEdOYMF/lGbCNvOKV1IVQ3p38ULDary7n6vHDE3rQX4lQRU1qWjI89XatZ6YnYnRHeYoROB9xmxAywi8yq7o6NEDcshocaTQUfys2vnv7UXQZmMeswHeSi4zGFbBGX8SkqIqGH+5ShTghEHhFxMg=
Message-ID: <a781481a0705042055u5e9ba060w95da83b0fbeff76a@mail.gmail.com>
Date: Sat, 5 May 2007 09:25:27 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Florin Malita" <fmalita@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] UBI: dereference after kfree in create_vtbl
Cc: dedekind@infradead.org, linux-mtd@lists.infradead.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <463BC019.40305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <463A04A5.5030103@gmail.com>
	 <a781481a0705041442h37453fb6k26d04eb5356e9dc0@mail.gmail.com>
	 <463BC019.40305@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/5/07, Florin Malita <fmalita@gmail.com> wrote:
> Hi Satyam,
>
> Satyam Sharma wrote:
> > Eeks ... no, wait. You found a (two, actually) bug alright, but fixed
> > it wrong. When we fail a write, we *must* add it to the corrupted list
> > and _then_ attempt to retry. So, the "if (++tries <= 5)" applies to
> > "if (!err) goto retry;" and not to the ubi_scan_add_to_list(). The
> > difference is quite subtle here ...
>
> Not being familiar with the code, I was specifically trying to preserve
> the old semantics and only address the use-after-free issue. So if there
> was another bug... well, I guess I succeeded at preserving it ;)
>
> > The correct fix should actually be as follows: (Artem, this is diffed
> > on the original vtbl.c)
> [snip]
> > +    err = ubi_scan_add_to_list(si, new_seb->pnum, new_seb->ec,
> > &si->corr);
> > +    kfree(new_seb);
> > +    if (++tries <= 5)
> >         if (!err)
> >             goto retry;
>
> There's a side effect to this change: by unconditionally overwriting err
> we lose the original error code. Then if we're exceeding the number of
> retries we'll end up returning 0 which is probably not what you want.

You're absolutely right. We must preserve and return the original
(write error) return code and not the spurious ENOMEM / 0 that would
come from ubi_scan_add_to_list. I had noticed this too, but this time
_I_ preserved the (flawed) old semantics which leads to this problem.
Wow ... so you actually found 3 bugs here in ~3 lines of code :-)

I tried going deeper into this, but the lifetime semantics of a struct
ubi_scan_leb in this driver are quite ... weird indeed.

> Return code aside, it seems the only thing ubi_scan_add_to_list() is
> doing is allocate a new struct ubi_scan_leb, initialize some fields with
> values passed from new_seb and then add it to the desired list. But
> copying new_seb to a newly allocated structure and then immediately
> freeing the old one seems redundant - why not just add new_seb to the
> corrupted list and be done? Then we don't have to deal with allocation
> failures in an error path anymore - something like this (diff against
> the original code):

Again, I saw that too, but would still prefer using the higher level
function ubi_scan_add_to_list() to add to the corrupted list, but with
a different identifier for the return value to avoid overwriting err.
list_add_tail seems best left as an implementation detail below
ubi_scan_add_to_list(), IMO. So if it fails in the error path, we'd
have to return with the original (write error) return value and the
ENOMEM sort of goes ... unreturned. Alas!

Artem would have to step in here to verify if there really is a good
reason why we kmalloc a fresh ubi_scan_leb every time we want to add
one to a list. If possible, the best solution would be to change
ubi_scan_add_to_list() to take in a valid struct ubi_scan_leb and just
add that to the specified list (using list_add_tail or whatever) --
and leave allocation up to callers, though this likely requires a
major cleanup of this driver w.r.t. ubi_scan_leb lifetime semantics.
ubi_scan_add_used() was such a horror!

If adding an existing ubi_scan_leb is fine, but we can't really change
ubi_scan_add_to_list right now, then I'd much rather see a
__ubi_scan_add_to_list() that does the list_add_tail (and those
associated debug printk messages: btw are those printk's the only
reason why we're carrying that ubi_scan_info into
ubi_scan_add_to_list?). So ubi_scan_add_to_list() just wraps a kmalloc
over it -- that way, callers who want a new eraseblock alloced before
adding it to a list can use ubi_scan_add_to_list() and those that
already hold a valid one (like us) could use __ubi_scan_add_to_list()
directly.

I see Andrew merged the previous fix, so this is on top of that,
though I'm not sure if this half-solution should actually go in --
hopefully that verbose comment / changelog will irritate Artem enough
to fix all this for good :-)

---

drivers/mtd/ubi/vtbl.c:create_vtbl() uses ubi_scan_add_to_list() in
the write error path. That can itself return with an ENOMEM error, in
which case we give up but return from create_vtbl() with the original
write error.

A robust solution would be to fix ubi_scan_add_to_list() to just take
in a valid eraseblock and simply add it to the specified list using
list_add_tail, and thus never fail. This would likely require a major
cleanup of this driver.

Alternatively, we could introduce and use a void
__ubi_scan_add_to_list() here that does this and make
ubi_scan_add_to_list() simply wrap a kmalloc over it, to avoid
changing existing users.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>

---

 drivers/mtd/ubi/vtbl.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

---

diff -ruNp a/drivers/mtd/ubi/vtbl.c b/drivers/mtd/ubi/vtbl.c
--- a/drivers/mtd/ubi/vtbl.c	2007-05-05 06:17:04.000000000 +0530
+++ b/drivers/mtd/ubi/vtbl.c	2007-05-05 09:23:43.000000000 +0530
@@ -260,7 +260,7 @@ bad:
 static int create_vtbl(const struct ubi_device *ubi, struct ubi_scan_info *si,
 		       int copy, void *vtbl)
 {
-	int err, tries = 0;
+	int add_err, err, tries = 0;
 	static struct ubi_vid_hdr *vid_hdr;
 	struct ubi_scan_volume *sv;
 	struct ubi_scan_leb *new_seb, *old_seb = NULL;
@@ -317,12 +317,19 @@ retry:
 	return err;

 write_error:
-	/* May be this physical eraseblock went bad, try to pick another one */
-	err = ubi_scan_add_to_list(si, new_seb->pnum, new_seb->ec, &si->corr);
+	/*
+	 * May be this physical eraseblock went bad, so add it to the corrupted
+	 * list. Note that ubi_scan_add_to_list() allocates a new eraseblock
+	 * and could fail with ENOMEM. In that case we give up and return with
+	 * the original write error -- the ENOMEM is effectively lost.
+	 */
+	add_err = ubi_scan_add_to_list(si, new_seb->pnum, new_seb->ec, &si->corr);
 	kfree(new_seb);
+	if (add_err)
+		goto out_free;
+	/* Try to pick another one */
 	if (++tries <= 5)
-		if (!err)
-			goto retry;
+		goto retry;
 out_free:
 	ubi_free_vid_hdr(ubi, vid_hdr);
 	return err;
