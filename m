Return-Path: <linux-kernel-owner+w=401wt.eu-S1759434AbZBXRdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434AbZBXRdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:33:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757265AbZBXRcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:32:55 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:35705 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756731AbZBXRcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:32:54 -0500
X-Greylist: delayed 587 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Feb 2009 12:32:54 EST
Message-ID: <49A42CF3.9010302@mev.co.uk>
Date: Tue, 24 Feb 2009 17:22:59 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] [UIO] Take offset into account when determining number of
 pages that can be mapped
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Feb 2009 17:23:00.0451 (UTC) FILETIME=[8AD0C330:01C996A4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Abbott <abbotti@mev.co.uk>

If a UIO memory region does not start on a page boundary but straddles one,
the number of actual pages that overlap the memory region may be calculated
incorrectly because the offset isn't taken into account.  If userspace sets
the mmap length to offset+size, it may fail with -EINVAL if UIO thinks it's
trying to allocate too many pages.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
diff -urp linux-2.6.29-rc6/drivers/uio/uio.c linux-2.6.29-rc6.new/drivers/uio/uio.c
--- linux-2.6.29-rc6/drivers/uio/uio.c	2009-02-24 16:37:07.000000000 +0000
+++ linux-2.6.29-rc6.new/drivers/uio/uio.c	2009-02-24 16:43:16.000000000 +0000
@@ -686,7 +686,8 @@ static int uio_mmap(struct file *filep, 
 		return -EINVAL;
 
 	requested_pages = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
-	actual_pages = (idev->info->mem[mi].size + PAGE_SIZE -1) >> PAGE_SHIFT;
+	actual_pages = ((idev->info->mem[mi].addr & ~PAGE_MASK)
+			+ idev->info->mem[mi].size + PAGE_SIZE -1) >> PAGE_SHIFT;
 	if (requested_pages > actual_pages)
 		return -EINVAL;
 


