Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbXEEP2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbXEEP2n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 11:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755545AbXEEP2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 11:28:42 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:17421 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525AbXEEP2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 11:28:40 -0400
Message-ID: <a781481a0705050632y6ffa11a3qeb89f5e6e92da681@mail.gmail.com>
Date: Sat, 5 May 2007 19:02:44 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: dedekind@infradead.org
Subject: Re: [PATCH] UBI: dereference after kfree in create_vtbl
Cc: "Florin Malita" <fmalita@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-mtd@lists.infradead.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <1178366959.3659.95.camel@sauron>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <463A04A5.5030103@gmail.com>
	 <a781481a0705041442h37453fb6k26d04eb5356e9dc0@mail.gmail.com>
	 <463BC019.40305@gmail.com>
	 <a781481a0705042055u5e9ba060w95da83b0fbeff76a@mail.gmail.com>
	 <1178366959.3659.95.camel@sauron>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/5/07, Artem Bityutskiy <dedekind@infradead.org> wrote:
> [...]
> I've put the fix here:
> http://git.infradead.org/?p=users/dedekind/ubi-2.6.git;a=commit;h=5125237efb6a3309fbf5b9a7a21aaf716787f2a2

> write_error:
> 	if (err == -EIO && ++tries <= 5) {
> 		/*
> 		 * Probably this physical eraseblock went bad, try to pick
> 		 * another one.
> 		 */
> 		list_add_tail(&new_seb->u.list, &si->corr);
> 		goto retry;
> 	}
> 	kfree(new_seb);
> out_free:
> 	ubi_free_vid_hdr(ubi, vid_hdr);
> 	return err;

Ummm ...

1. "if (err == -EIO)" applies to adding new_seb to the corrupted list,
and not to retrying. We wouldn't want _not_ to retry if there's some
other error, or would we?
2. "if (++tries <= 5)" applies to "goto retry" and not to adding
new_seb to the corrupted list. If we hit write failure for the 5th
time and err == -EIO, we should still be adding it to corrupted list,
but not retry, of course. Otherwise we would add the first 4 write
failure (with -EIO) eraseblocks to si->corr, but the 5th _similar_
case is ... just freed?

So:

write_error:
	/*
	 * Probably this physical eraseblock went bad, add it to the
	 * corrupted list. Else, just release it.
	 */
	if (err == -EIO)
		/* list_add_tail(&new_seb->u.list, &si->corr); */
		__ubi_scan_add_to_list(si, new_seb, &si->corr);
	else
		kfree(new_seb);
	/* Try to pick another one */
	if (++tries <= 5)
		goto retry;
out_free:
	ubi_free_vid_hdr(ubi, vid_hdr);
	return err;

And in case you want to avoid the list_add_tail there, the following
(I'm fine with whichever way, of course):

diff -ruNp a/drivers/mtd/ubi/scan.c b/drivers/mtd/ubi/scan.c
--- a/drivers/mtd/ubi/scan.c	2007-05-05 10:52:47.000000000 +0530
+++ b/drivers/mtd/ubi/scan.c	2007-05-05 11:47:26.000000000 +0530
@@ -55,29 +55,37 @@ static int paranoid_check_si(const struc
 static struct ubi_ec_hdr *ech;
 static struct ubi_vid_hdr *vidh;

-int ubi_scan_add_to_list(struct ubi_scan_info *si, int pnum, int ec,
-			 struct list_head *list)
+void __ubi_scan_add_to_list(struct ubi_scan_info *si,
+			    struct ubi_scan_leb *seb,
+			    struct list_head *list)
 {
-	struct ubi_scan_leb *seb;
-
 	if (list == &si->free)
-		dbg_bld("add to free: PEB %d, EC %d", pnum, ec);
+		dbg_bld("add to free: PEB %d, EC %d", seb->pnum, seb->ec);
 	else if (list == &si->erase)
-		dbg_bld("add to erase: PEB %d, EC %d", pnum, ec);
+		dbg_bld("add to erase: PEB %d, EC %d", seb->pnum, seb->ec);
 	else if (list == &si->corr)
-		dbg_bld("add to corrupted: PEB %d, EC %d", pnum, ec);
+		dbg_bld("add to corrupted: PEB %d, EC %d", seb->pnum, seb->ec);
 	else if (list == &si->alien)
-		dbg_bld("add to alien: PEB %d, EC %d", pnum, ec);
+		dbg_bld("add to alien: PEB %d, EC %d", seb->pnum, seb->ec);
 	else
 		BUG();

+	list_add_tail(&seb->u.list, list);
+}
+
+int ubi_scan_add_to_list(struct ubi_scan_info *si, int pnum, int ec,
+			 struct list_head *list)
+{
+	struct ubi_scan_leb *seb;
+
 	seb = kmalloc(sizeof(struct ubi_scan_leb), GFP_KERNEL);
 	if (unlikely(!seb))
 		return -ENOMEM;

 	seb->pnum = pnum;
 	seb->ec = ec;
-	list_add_tail(&seb->u.list, list);
+	__ubi_scan_add_to_list(si, seb, list);
+
 	return 0;
 }

diff -ruNp a/drivers/mtd/ubi/scan.h b/drivers/mtd/ubi/scan.h
--- a/drivers/mtd/ubi/scan.h	2007-05-05 10:55:24.000000000 +0530
+++ b/drivers/mtd/ubi/scan.h	2007-05-05 10:55:01.000000000 +0530
@@ -147,6 +147,9 @@ static inline void ubi_scan_move_to_list
 		list_add_tail(&seb->u.list, list);
 }

+void __ubi_scan_add_to_list(struct ubi_scan_info *si,
+			    struct ubi_scan_leb *seb,
+			    struct list_head *list);
 int ubi_scan_add_to_list(struct ubi_scan_info *si, int pnum, int ec,
 			 struct list_head *list);
 int ubi_scan_add_used(const struct ubi_device *ubi, struct ubi_scan_info *si,
