Return-Path: <linux-kernel-owner+w=401wt.eu-S1759114AbZCYAne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759114AbZCYAne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756716AbZCYAaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:19 -0400
Received: from kroah.org ([198.145.64.141]:54143 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756864AbZCYAaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:30:10 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ian Abbott <abbotti@mev.co.uk>, "Hans J. Koch" <hjk@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 37/61] UIO: Take offset into account when determining number of pages that can be mapped
Date: Tue, 24 Mar 2009 17:26:41 -0700
Message-Id: <1237940825-22904-37-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
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
Cc: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/uio.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 68a4965..03efb06 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -708,7 +708,8 @@ static int uio_mmap(struct file *filep, struct vm_area_struct *vma)
 		return -EINVAL;
 
 	requested_pages = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
-	actual_pages = (idev->info->mem[mi].size + PAGE_SIZE -1) >> PAGE_SHIFT;
+	actual_pages = ((idev->info->mem[mi].addr & ~PAGE_MASK)
+			+ idev->info->mem[mi].size + PAGE_SIZE -1) >> PAGE_SHIFT;
 	if (requested_pages > actual_pages)
 		return -EINVAL;
 
-- 
1.6.2

