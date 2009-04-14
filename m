Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbZDNCF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbZDNCF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 22:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZDNCFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 22:05:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:34457 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbZDNCFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 22:05:45 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, akpm@linux-foundation.org, npiggin@suse.de
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/5] mmap: don't assume f_op->mmap() doesn't change vma->vm_file
Date: Tue, 14 Apr 2009 11:04:18 +0900
Message-Id: <1239674662-31318-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1239674662-31318-1-git-send-email-tj@kernel.org>
References: <1239674662-31318-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 02:04:27 +0000 (UTC)
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
index 4a38411..46a7ae5 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1194,6 +1194,7 @@ munmap_back:
 		vma->vm_file = file;
 		get_file(file);
 		error = file->f_op->mmap(file, vma);
+		file = vma->vm_file;
 		if (error)
 			goto unmap_and_free_vma;
 		if (vm_flags & VM_EXECUTABLE)
-- 
1.6.0.2

