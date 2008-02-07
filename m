Return-Path: <linux-kernel-owner+w=401wt.eu-S933883AbYBGUKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933883AbYBGUKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:10:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757980AbYBGUEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:04:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:38645 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761693AbYBGUEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:04:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ET4m/YqFVntD5g9vnlingbUfJ1O08AWTx3MNNbmcUaQrqztnrgUF9F9HVWiFjaogceVdrnopk1PME6vlRl2psZKxV/jzkJFNmZnusDdC8ahXgoGM8y1rv1JP7Kbkm569Ek5TnmACjIoUDjU6J3aKXEUHFPdEvOrvLtsAbUXLqKo=
Message-ID: <6101e8c40802071204n6613b13ue72b8df64f7a8522@mail.gmail.com>
Date: Thu, 7 Feb 2008 21:04:01 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {14+1} - NM!!! - Race condition in userspace testcase - on top of 2.6.22.17
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

aka: do_anonymous_page-race.patch

From: Andrea Arcangeli <andrea@suse.de>
Subject: Race condition in userspace testcase
References: 46948, LTC11574

NOT IN MAINLINE

Additional Comment #103 From Andrea Arcangeli 2004-10-15 19:41
the last patch I attached is the safest I believe.

I'm not sure if a lock_unlock or lock_unlock is always guaranteed to happen
after the I/O, and this makes sure no race can happen anymore.

---
 fs/bio.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/bio.c	2007-07-08 19:32:17.000000000 -0400
+++ b/fs/bio.c	2007-08-27 14:01:21.000000000 -0400
@@ -1028,6 +1028,15 @@ void bio_endio(struct bio *bio, unsigned
 	bio->bi_size -= bytes_done;
 	bio->bi_sector += (bytes_done >> 9);

+	if (bio_data_dir(bio) == READ)
+		/*
+		 * If the current cpu has written to the page by hand
+		 * without dma, we must enforce ordering to be sure
+		 * this written data will be visible before we expose
+		 * the page contents to other cpus (for example with
+		 * a set_pte).
+		 */
+		smp_wmb();
 	if (bio->bi_end_io)
 		bio->bi_end_io(bio, bytes_done, error);
 }


-- 
Thanks,
Oliver
