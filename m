Return-Path: <linux-kernel-owner+w=401wt.eu-S1754268AbXL0Wjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbXL0Wjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 17:39:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbXL0Wjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 17:39:40 -0500
Received: from mailbox2.myri.com ([64.172.73.26]:1846 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752028AbXL0Wjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 17:39:40 -0500
Message-ID: <4774297B.1060305@myri.com>
Date: Thu, 27 Dec 2007 17:38:51 -0500
From: Loic Prylli <loic@myri.com>
User-Agent: Thunderbird/2.0.0.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix x86 iounmap() calling ioremap_change_attr() with a size
 that's too big.
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The get_vm_area() allocates one extra guard page, and stores the augmented
size in area->size. But the ioremap/iounmap code on x86 relies on finding
the original size in area->size (otherwise it does change the attribute
of some random device in the linear-map by using a wrong size in
ioremap_change_attr() ). The problem is avoided by not using an extra guard
page for VM_IOREMAP allocations (if somebody can think of an easy way to
store the original size across ioremap()/iounmap() calls, that could be
a more elegant solution).

Signed-off-by: Loic Prylli <loic@myri.com>
---
 mm/vmalloc.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index af77e17..efd0093 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -196,9 +196,10 @@ static struct vm_struct *__get_vm_area_node(unsigned long size, unsigned long fl
 		return NULL;
 
 	/*
-	 * We always allocate a guard page.
+	 * We allocate a guard page (except for ioremap() which relies on area->size == size)
 	 */
-	size += PAGE_SIZE;
+	if (!(flags & VM_IOREMAP))
+	    size += PAGE_SIZE;
 
 	write_lock(&vmlist_lock);
 	for (p = &vmlist; (tmp = *p) != NULL ;p = &tmp->next) {
-- 
1.5.2.2



