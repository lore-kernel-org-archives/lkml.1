Return-Path: <linux-kernel-owner+w=401wt.eu-S1031711AbXEDVmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031711AbXEDVmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 17:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031719AbXEDVmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 17:42:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:14350 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031711AbXEDVmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 17:42:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TqUDH7QF1vHv5J+r4TPsoxVZfUpL18bZl4k7Xg0Eu27aIS9HesDMV8XB9LQlFONlrFZw2MHQISrq5yawo4PruoYcQwqIkV4g5YktG4lhyyTJ40x6H57HRRaMPcM89dvhlscXRrvweTRY+B2y3mYmwnHxj0GTBmw6DtT+/Vz8pio=
Message-ID: <a781481a0705041442h37453fb6k26d04eb5356e9dc0@mail.gmail.com>
Date: Sat, 5 May 2007 03:12:02 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Florin Malita" <fmalita@gmail.com>
Subject: Re: [PATCH] UBI: dereference after kfree in create_vtbl
Cc: dedekind@infradead.org, linux-mtd@lists.infradead.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <463A04A5.5030103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <463A04A5.5030103@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florin, Artem,

On 5/3/07, Florin Malita <fmalita@gmail.com> wrote:
> [...]
>  write_error:
> -       kfree(new_seb);
> -       /* May be this physical eraseblock went bad, try to pick another one */
> -       if (++tries <= 5) {
> +       /* Maybe this physical eraseblock went bad, try to pick another one */
> +       if (++tries <= 5)
>                 err = ubi_scan_add_to_list(si, new_seb->pnum, new_seb->ec,
>                                            &si->corr);
> -               if (!err)
> -                       goto retry;
> -       }
> +       kfree(new_seb);
> +       if (!err)
> +               goto retry;

Eeks ... no, wait. You found a (two, actually) bug alright, but fixed
it wrong. When we fail a write, we *must* add it to the corrupted list
and _then_ attempt to retry. So, the "if (++tries <= 5)" applies to
"if (!err) goto retry;" and not to the ubi_scan_add_to_list(). The
difference is quite subtle here ...

The correct fix should actually be as follows: (Artem, this is diffed
on the original vtbl.c)

---

Fix write_error logic in drivers/mtd/ubi/vtbl.c:create_vtbl(). On a
write failure, we add the corrupted physical eraseblock to the
corrupted list, and then attempt to retry (upto a maximum of 5 times).
Also, fix an oops by pushing kfree(new_seb) below after dereferencing
it for ubi_scan_add_to_list().

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Signed-off-by: Florin Malita <fmalita@gmail.com>

---

 drivers/mtd/ubi/vtbl.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

---

diff -ruNp a/drivers/mtd/ubi/vtbl.c b/drivers/mtd/ubi/vtbl.c
--- a/drivers/mtd/ubi/vtbl.c	2007-04-20 18:42:17.000000000 +0530
+++ b/drivers/mtd/ubi/vtbl.c	2007-05-05 03:01:32.000000000 +0530
@@ -317,14 +317,12 @@ retry:
 	return err;

 write_error:
-	kfree(new_seb);
 	/* May be this physical eraseblock went bad, try to pick another one */
-	if (++tries <= 5) {
-		err = ubi_scan_add_to_list(si, new_seb->pnum, new_seb->ec,
-					   &si->corr);
+	err = ubi_scan_add_to_list(si, new_seb->pnum, new_seb->ec, &si->corr);
+	kfree(new_seb);
+	if (++tries <= 5)
 		if (!err)
 			goto retry;
-	}
 out_free:
 	ubi_free_vid_hdr(ubi, vid_hdr);
 	return err;
