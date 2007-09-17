Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbXIQIc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbXIQIc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbXIQIcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:23 -0400
Received: from il.qumranet.com ([82.166.9.18]:45222 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbXIQIcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:22 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Nguyen Anh Quynh <aquynh@gmail.com>
Subject: [PATCH 001/104] KVM: Fix *nopage() in kvm_main.c
Date: Mon, 17 Sep 2007 10:30:43 +0200
Message-Id: <11900179461472-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nguyen Anh Quynh <aquynh@gmail.com>

*nopage() in kvm_main.c should only store the type of mmap() fault if
the pointers are not NULL. This patch fixes the problem.

Signed-off-by: Nguyen Anh Quynh <aquynh@gmail.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index cd05579..36a458f 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -2285,7 +2285,6 @@ static struct page *kvm_vcpu_nopage(struct vm_area_struct *vma,
 	unsigned long pgoff;
 	struct page *page;
 
-	*type = VM_FAULT_MINOR;
 	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 	if (pgoff == 0)
 		page = virt_to_page(vcpu->run);
@@ -2294,6 +2293,9 @@ static struct page *kvm_vcpu_nopage(struct vm_area_struct *vma,
 	else
 		return NOPAGE_SIGBUS;
 	get_page(page);
+	if (type != NULL)
+		*type = VM_FAULT_MINOR;
+
 	return page;
 }
 
@@ -2768,12 +2770,14 @@ static struct page *kvm_vm_nopage(struct vm_area_struct *vma,
 	unsigned long pgoff;
 	struct page *page;
 
-	*type = VM_FAULT_MINOR;
 	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 	page = gfn_to_page(kvm, pgoff);
 	if (!page)
 		return NOPAGE_SIGBUS;
 	get_page(page);
+	if (type != NULL)
+		*type = VM_FAULT_MINOR;
+
 	return page;
 }
 
-- 
1.5.3

