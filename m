Return-Path: <linux-kernel-owner+w=401wt.eu-S933087AbYBGUDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087AbYBGUDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757156AbYBGUDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:03:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:38645 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbYBGUDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:03:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=SNCzrqPvISvIbyJq/SGA8Y4I2BjncpXQCrTfLma56uPL/Szn1wopC3aGbh7po4p/q+19XLxM60maM6o+yzE4NCHzZOV4rFxfUjditVNHmbWwheId8jvyPPkgf/davsR8gMEMzBbhack4TuteIrkfsv2t0Ji71ZU5Th5qyJIs7QY=
Message-ID: <6101e8c40802071203r5d56f6d6m330a4d7a15e4642b@mail.gmail.com>
Date: Thu, 7 Feb 2008 21:03:11 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {01/14} - cciss: fix memory leak - on top of 2.6.22.17
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

aka: cciss-fix_memory_leak.patch

>From f2912a1223c0917a7b4e054f18086209137891ea Mon Sep 17 00:00:00 2001
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Tue, 31 Jul 2007 00:39:39 -0700
Subject: [PATCH] cciss: fix memory leak

There's a memory leak in the cciss driver.

mainline: f2912a1223c0917a7b4e054f18086209137891ea

in alloc_cciss_hba() we may leak sizeof(ctlr_info_t) bytes if a
call to alloc_disk(1 << NWD_SHIFT) fails.
This patch should fix the issue.

Spotted by the Coverity checker.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 1be82d5..a11b2bd 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3227,12 +3227,15 @@ static int alloc_cciss_hba(void)
 	for (i = 0; i < MAX_CTLR; i++) {
 		if (!hba[i]) {
 			ctlr_info_t *p;
+
 			p = kzalloc(sizeof(ctlr_info_t), GFP_KERNEL);
 			if (!p)
 				goto Enomem;
 			p->gendisk[0] = alloc_disk(1 << NWD_SHIFT);
-			if (!p->gendisk[0])
+			if (!p->gendisk[0]) {
+				kfree(p);
 				goto Enomem;
+			}
 			hba[i] = p;
 			return i;
 		}

-- 
Thanks,
Oliver
