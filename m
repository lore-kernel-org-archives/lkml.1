Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbYGRFFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbYGRFFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 01:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbYGRFEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 01:04:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:23129 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbYGRFEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 01:04:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=pUa/tbGHYrwbnEh/hks28NExn/BJ4LUQgBEfiTxokgzWzC5JvpmBNzj73vzL2Q1zMW
         vO80rEOIfK9m04Y7g6z6VbjrJkoLN4A6jOY3pAyL0fRqBgaDSk37VGuYwo18WeA8TqST
         eFwi4AgEviKt4pD0WG6q3nybc0ajfqUzO10+4=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, hjk@linutronix.de, gregkh@suse.de,
       akpm@linux-foundation.org
Date: Fri, 18 Jul 2008 14:04:51 +0900
Message-Id: <20080718050451.16250.38058.sendpatchset@rx1.opensource.se>
In-Reply-To: <20080718050402.16250.25213.sendpatchset@rx1.opensource.se>
References: <20080718050402.16250.25213.sendpatchset@rx1.opensource.se>
Subject: [PATCH 06/06] uio: Support multiple UIO_MEM_LOGICAL/VIRTUAL pages
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

This patch improves the UIO_MEM_LOGICAL and UIO_MEM_VIRTUAL page
fault code to support more than one page of data. Memory allocated
from the slab is however not supported, so a check for that is added
and the documentation gets a little update.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 Documentation/DocBook/uio-howto.tmpl |    2 +-
 drivers/uio/uio.c                    |   10 ++++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

--- 0001/Documentation/DocBook/uio-howto.tmpl
+++ work/Documentation/DocBook/uio-howto.tmpl	2008-07-18 12:45:22.000000000 +0900
@@ -376,7 +376,7 @@ Here's a description of the fields of <v
 <varname>int memtype</varname>: Required if the mapping is used. Set this to
 <varname>UIO_MEM_PHYS</varname> if you you have physical memory on your
 card to be mapped. Use <varname>UIO_MEM_LOGICAL</varname> for logical
-memory (e.g. allocated with <function>kmalloc()</function>). There's also
+memory (e.g. allocated with <function>alloc_pages()</function>). There's also
 <varname>UIO_MEM_VIRTUAL</varname> for virtual memory.
 </para></listitem>
 
--- 0006/drivers/uio/uio.c
+++ work/drivers/uio/uio.c	2008-07-18 12:49:38.000000000 +0900
@@ -455,12 +455,15 @@ static void uio_vma_close(struct vm_area
 static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct uio_mem *imem = vma->vm_private_data;
+	unsigned long vaddr = imem->addr;
 	struct page *page;
 
+	vaddr += (vmf->pgoff - vma->vm_pgoff) << PAGE_SHIFT;
+
 	if (imem->memtype == UIO_MEM_LOGICAL)
-		page = virt_to_page(imem->addr);
+		page = virt_to_page(vaddr);
 	else
-		page = vmalloc_to_page((void *)imem->addr);
+		page = vmalloc_to_page((void *)vaddr);
 	get_page(page);
 	vmf->page = page;
 	return 0;
@@ -521,6 +524,9 @@ static int uio_mmap(struct file *filep, 
 		case UIO_MEM_PHYS:
 			return uio_mmap_physical(vma, imem);
 		case UIO_MEM_LOGICAL:
+			if (virt_to_page(imem->addr)->flags & (1 << PG_slab))
+				return -EINVAL; /* kmalloc() not supported */
+			/* fall-through */
 		case UIO_MEM_VIRTUAL:
 			return uio_mmap_logical(vma, imem);
 		default:
