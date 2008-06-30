Return-Path: <linux-kernel-owner+w=401wt.eu-S1760122AbYF3QzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122AbYF3QzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 12:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbYF3Qyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 12:54:55 -0400
Received: from DSL212-235-53-3.bb.netvision.net.il ([212.235.53.3]:53444 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbYF3Qyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 12:54:54 -0400
From: Benny Halevy <bhalevy@panasas.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Benny Halevy <bhalevy@panasas.com>
Subject: [PATCH] mm: fix uninitialized variables for find_vma_prepare callers
Date: Mon, 30 Jun 2008 19:54:42 +0300
Message-Id: <1214844882-22560-1-git-send-email-bhalevy@panasas.com>
X-Mailer: git-send-email 1.5.6.GIT
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc 4.3.0 correctly emits the following warnings.
When a vma covering addr is found, find_vma_prepare indeed returns without
setting pprev, rb_link, and rb_parent.

/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c: In function ‘insert_vm_struct’:
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:2085: warning: ‘rb_parent’ may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:2085: warning: ‘rb_link’ may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:2084: warning: ‘prev’ may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c: In function ‘copy_vma’:
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:2124: warning: ‘rb_parent’ may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:2124: warning: ‘rb_link’ may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:2123: warning: ‘prev’ may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c: In function ‘do_brk’:
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:1951: warning: ‘rb_parent’ may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:1951: warning: ‘rb_link’ may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:1949: warning: ‘prev’ may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c: In function ‘mmap_region’:
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:1092: warning: ‘rb_parent’ may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:1092: warning: ‘rb_link’ may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:1089: warning: ‘prev’ may be used uninitialized in this function

Signed-off-by: Benny Halevy <bhalevy@panasas.com>
---
 mm/mmap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 3354fdd..81b9873 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -366,7 +366,7 @@ find_vma_prepare(struct mm_struct *mm, unsigned long addr,
 		if (vma_tmp->vm_end > addr) {
 			vma = vma_tmp;
 			if (vma_tmp->vm_start <= addr)
-				return vma;
+				break;
 			__rb_link = &__rb_parent->rb_left;
 		} else {
 			rb_prev = __rb_parent;
-- 
1.5.6.GIT

