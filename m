Return-Path: <linux-kernel-owner+w=401wt.eu-S1751561AbXI0Bub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561AbXI0Bub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 21:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbXI0BuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 21:50:23 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:48182 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751380AbXI0BuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 21:50:22 -0400
Message-ID: <390857819.00313@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Thu, 27 Sep 2007 09:50:16 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Kumar Gala <galak@kernel.crashing.org>,
       Pete Zaitcev <zaitcev@redhat.com>, Greg KH <greg@kroah.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] writeback: remove unnecessary wait in
	throttle_vm_writeout()
Message-ID: <20070927015016.GA11080@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We don't want to introduce pointless delays in throttle_vm_writeout()
when the writeback limits are not yet exceeded, do we?

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Pete Zaitcev <zaitcev@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/page-writeback.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- linux-2.6.23-rc8-mm1.orig/mm/page-writeback.c
+++ linux-2.6.23-rc8-mm1/mm/page-writeback.c
@@ -507,16 +507,6 @@ void throttle_vm_writeout(gfp_t gfp_mask
 	long background_thresh;
 	long dirty_thresh;
 
-	if ((gfp_mask & (__GFP_FS|__GFP_IO)) != (__GFP_FS|__GFP_IO)) {
-		/*
-		 * The caller might hold locks which can prevent IO completion
-		 * or progress in the filesystem.  So we cannot just sit here
-		 * waiting for IO to complete.
-		 */
-		congestion_wait(WRITE, HZ/10);
-		return;
-	}
-
         for ( ; ; ) {
 		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
 
@@ -530,6 +520,14 @@ void throttle_vm_writeout(gfp_t gfp_mask
 			global_page_state(NR_WRITEBACK) <= dirty_thresh)
                         	break;
                 congestion_wait(WRITE, HZ/10);
+
+		/*
+		 * The caller might hold locks which can prevent IO completion
+		 * or progress in the filesystem.  So we cannot just sit here
+		 * waiting for IO to complete.
+		 */
+		if ((gfp_mask & (__GFP_FS|__GFP_IO)) != (__GFP_FS|__GFP_IO))
+			break;
         }
 }
 

