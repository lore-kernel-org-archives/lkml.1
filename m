Return-Path: <linux-kernel-owner+w=401wt.eu-S1161544AbXEDXXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161544AbXEDXXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 19:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161560AbXEDXXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 19:23:18 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:40801 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161558AbXEDXXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 19:23:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=I/MI6G6G3YYfBSZBI9MeKCBbFhineXYq9tfW6KCCFY1eWzARmkzqunJi1pgREGqReKZCIFjNZLmOlz3Vl+Le2kFCNENkSuF9N4HYrYoAnS7l6/CROKT78R3JThuLVQYuvGKDbu0BwM4OnCn588c7QJL/C0G1YgFAoWQjP4NejW4=
Message-ID: <463BC019.40305@gmail.com>
Date: Fri, 04 May 2007 19:22:01 -0400
From: Florin Malita <fmalita@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: dedekind@infradead.org, linux-mtd@lists.infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] UBI: dereference after kfree in create_vtbl
References: <463A04A5.5030103@gmail.com> <a781481a0705041442h37453fb6k26d04eb5356e9dc0@mail.gmail.com>
In-Reply-To: <a781481a0705041442h37453fb6k26d04eb5356e9dc0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Satyam,

Satyam Sharma wrote:
> Eeks ... no, wait. You found a (two, actually) bug alright, but fixed
> it wrong. When we fail a write, we *must* add it to the corrupted list
> and _then_ attempt to retry. So, the "if (++tries <= 5)" applies to
> "if (!err) goto retry;" and not to the ubi_scan_add_to_list(). The
> difference is quite subtle here ...

Not being familiar with the code, I was specifically trying to preserve 
the old semantics and only address the use-after-free issue. So if there 
was another bug... well, I guess I succeeded at preserving it ;)

> The correct fix should actually be as follows: (Artem, this is diffed
> on the original vtbl.c)
[snip]
> +    err = ubi_scan_add_to_list(si, new_seb->pnum, new_seb->ec, 
> &si->corr);
> +    kfree(new_seb);
> +    if (++tries <= 5)
>         if (!err)
>             goto retry;

There's a side effect to this change: by unconditionally overwriting err 
we lose the original error code. Then if we're exceeding the number of 
retries we'll end up returning 0 which is probably not what you want.

Return code aside, it seems the only thing ubi_scan_add_to_list() is 
doing is allocate a new struct ubi_scan_leb, initialize some fields with 
values passed from new_seb and then add it to the desired list. But 
copying new_seb to a newly allocated structure and then immediately 
freeing the old one seems redundant - why not just add new_seb to the 
corrupted list and be done? Then we don't have to deal with allocation 
failures in an error path anymore - something like this (diff against 
the original code):

Signed-off-by: Florin Malita <fmalita@gmail.com>
---

diff --git a/drivers/mtd/ubi/vtbl.c b/drivers/mtd/ubi/vtbl.c
index b6fd6bb..2ad2d59 100644
--- a/drivers/mtd/ubi/vtbl.c
+++ b/drivers/mtd/ubi/vtbl.c
@@ -317,14 +317,10 @@ retry:
 	return err;
 
 write_error:
-	kfree(new_seb);
-	/* May be this physical eraseblock went bad, try to pick another one */
-	if (++tries <= 5) {
-		err = ubi_scan_add_to_list(si, new_seb->pnum, new_seb->ec,
-					   &si->corr);
-		if (!err)
-			goto retry;
-	}
+	/* Maybe this physical eraseblock went bad, try to pick another one */
+	list_add_tail(&new_seb->u.list, &si->corr);
+	if (++tries <= 5)
+		goto retry;
 out_free:
 	ubi_free_vid_hdr(ubi, vid_hdr);
 	return err;

