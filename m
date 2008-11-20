Return-Path: <linux-kernel-owner+w=401wt.eu-S1759099AbYKTPCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759099AbYKTPCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756643AbYKTOxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:53:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:58669 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757427AbYKTOxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:53:03 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, akpm@linux-foundation.org, npiggin@suse.de
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/6] mmap: don't assume f_op->mmap() doesn't change vma->vm_file
Date: Thu, 20 Nov 2008 23:52:15 +0900
Message-Id: <1227192740-10532-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1227192740-10532-1-git-send-email-tj@kernel.org>
References: <1227192740-10532-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 20 Nov 2008 14:52:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmap_region() assumes that vma->vm_file isn't changed by f_op->mmap()
and continues to use cache file after f_op->mmap() returns.  Don't
assume that.  This will be used by FUSE to redirect mmap to
shmem_file.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Nick Piggin <npiggin@suse.de>
---
 mm/mmap.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index d4855a6..2e4e0b5 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1177,6 +1177,7 @@ munmap_back:
 		vma->vm_file = file;
 		get_file(file);
 		error = file->f_op->mmap(file, vma);
+		file = vma->vm_file;
 		if (error)
 			goto unmap_and_free_vma;
 		if (vm_flags & VM_EXECUTABLE)
-- 
1.5.6

