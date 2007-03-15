Return-Path: <linux-kernel-owner+w=401wt.eu-S933864AbXCOWRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933864AbXCOWRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932167AbXCOWPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:15:31 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33684 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402AbXCOWPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:25 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 14 of 33] IB/ipath - fix port sharing on powerpc
X-Mercurial-Node: 62da2fb770b66310ac06ba0190bf2bed2a5a764f
Message-Id: <62da2fb770b66310ac06.1173995098@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:44:58 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Ralph Campbell <ralph.campbell@qlogic.com>
# Date 1173994465 25200
# Node ID 62da2fb770b66310ac06ba0190bf2bed2a5a764f
# Parent  aaee8124e3bc44ec423b5e1c46ef90ede9f21483
IB/ipath - fix port sharing on powerpc

The port sharing feature mixed kernel virtual addresses as well as
physical addresses for the offset used to describe the mmap address to map
the InfiniPath hardware into user space.  This had a conflict on powerpc.
The new scheme converts it to a physical address so it doesn't conflict
with chip addresses and yet still fits in 40/44 bits so it isn't truncated
by 32-bit applications calling mmap64().

Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r aaee8124e3bc -r 62da2fb770b6 drivers/infiniband/hw/ipath/ipath_file_ops.c
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c	Thu Mar 15 14:34:25 2007 -0700
@@ -41,12 +41,6 @@
 #include "ipath_kernel.h"
 #include "ipath_common.h"
 
-/*
- * mmap64 doesn't allow all 64 bits for 32-bit applications
- * so only use the low 43 bits.
- */
-#define MMAP64_MASK	0x7FFFFFFFFFFUL
-
 static int ipath_open(struct inode *, struct file *);
 static int ipath_close(struct inode *, struct file *);
 static ssize_t ipath_write(struct file *, const char __user *, size_t,
@@ -62,6 +56,24 @@ static const struct file_operations ipat
 	.poll = ipath_poll,
 	.mmap = ipath_mmap
 };
+
+/*
+ * Convert kernel virtual addresses to physical addresses so they don't
+ * potentially conflict with the chip addresses used as mmap offsets.
+ * It doesn't really matter what mmap offset we use as long as we can
+ * interpret it correctly. 
+ */
+static u64 cvt_kvaddr(void *p)
+{
+	struct page *page;
+	u64 paddr = 0;
+
+	page = vmalloc_to_page(p);
+	if (page)
+		paddr = page_to_pfn(page) << PAGE_SHIFT;
+
+	return paddr;
+}
 
 static int ipath_get_base_info(struct file *fp,
 			       void __user *ubase, size_t ubase_size)
@@ -173,15 +185,14 @@ static int ipath_get_base_info(struct fi
 		kinfo->spi_piocnt = dd->ipath_pbufsport / subport_cnt;
 		kinfo->spi_piobufbase = (u64) pd->port_piobufs +
 			dd->ipath_palign * kinfo->spi_piocnt * slave;
-		kinfo->__spi_uregbase = ((u64) pd->subport_uregbase +
-			PAGE_SIZE * slave) & MMAP64_MASK;
-
-		kinfo->spi_rcvhdr_base = ((u64) pd->subport_rcvhdr_base +
-			pd->port_rcvhdrq_size * slave) & MMAP64_MASK;
+		kinfo->__spi_uregbase = cvt_kvaddr(pd->subport_uregbase +
+			PAGE_SIZE * slave);
+
+		kinfo->spi_rcvhdr_base = cvt_kvaddr(pd->subport_rcvhdr_base +
+			pd->port_rcvhdrq_size * slave);
 		kinfo->spi_rcvhdr_tailaddr = 0;
-		kinfo->spi_rcv_egrbufs = ((u64) pd->subport_rcvegrbuf +
-			dd->ipath_rcvegrcnt * dd->ipath_rcvegrbufsize * slave) &
-			MMAP64_MASK;
+		kinfo->spi_rcv_egrbufs = cvt_kvaddr(pd->subport_rcvegrbuf +
+			dd->ipath_rcvegrcnt * dd->ipath_rcvegrbufsize * slave);
 	}
 
 	kinfo->spi_pioindex = (kinfo->spi_piobufbase - dd->ipath_piobufbase) /
@@ -199,11 +210,11 @@ static int ipath_get_base_info(struct fi
 	if (master) {
 		kinfo->spi_runtime_flags |= IPATH_RUNTIME_MASTER;
 		kinfo->spi_subport_uregbase =
-			(u64) pd->subport_uregbase & MMAP64_MASK;
+			cvt_kvaddr(pd->subport_uregbase);
 		kinfo->spi_subport_rcvegrbuf =
-			(u64) pd->subport_rcvegrbuf & MMAP64_MASK;
+			cvt_kvaddr(pd->subport_rcvegrbuf);
 		kinfo->spi_subport_rcvhdr_base =
-			(u64) pd->subport_rcvhdr_base & MMAP64_MASK;
+			cvt_kvaddr(pd->subport_rcvhdr_base);
 		ipath_cdbg(PROC, "port %u flags %x %llx %llx %llx\n",
 			kinfo->spi_port, kinfo->spi_runtime_flags,
 			(unsigned long long) kinfo->spi_subport_uregbase,
@@ -1131,13 +1142,11 @@ static int mmap_kvaddr(struct vm_area_st
 	struct ipath_devdata *dd;
 	void *addr;
 	size_t size;
-	int ret;
+	int ret = 0;
 
 	/* If the port is not shared, all addresses should be physical */
-	if (!pd->port_subport_cnt) {
-		ret = -EINVAL;
-		goto bail;
-	}
+	if (!pd->port_subport_cnt)
+		goto bail;
 
 	dd = pd->port_dd;
 	size = pd->port_rcvegrbuf_chunks * pd->port_rcvegrbuf_size;
@@ -1149,33 +1158,28 @@ static int mmap_kvaddr(struct vm_area_st
 	if (subport == 0) {
 		unsigned num_slaves = pd->port_subport_cnt - 1;
 
-		if (pgaddr == ((u64) pd->subport_uregbase & MMAP64_MASK)) {
+		if (pgaddr == cvt_kvaddr(pd->subport_uregbase)) {
 			addr = pd->subport_uregbase;
 			size = PAGE_SIZE * num_slaves;
-		} else if (pgaddr == ((u64) pd->subport_rcvhdr_base &
-				      MMAP64_MASK)) {
+		} else if (pgaddr == cvt_kvaddr(pd->subport_rcvhdr_base)) {
 			addr = pd->subport_rcvhdr_base;
 			size = pd->port_rcvhdrq_size * num_slaves;
-		} else if (pgaddr == ((u64) pd->subport_rcvegrbuf &
-				      MMAP64_MASK)) {
+		} else if (pgaddr == cvt_kvaddr(pd->subport_rcvegrbuf)) {
 			addr = pd->subport_rcvegrbuf;
 			size *= num_slaves;
-		} else {
-			ret = -EINVAL;
+		} else
 			goto bail;
-		}
-	} else if (pgaddr == (((u64) pd->subport_uregbase +
-			       PAGE_SIZE * (subport - 1)) & MMAP64_MASK)) {
+	} else if (pgaddr == cvt_kvaddr(pd->subport_uregbase +
+					PAGE_SIZE * (subport - 1))) {
 		addr = pd->subport_uregbase + PAGE_SIZE * (subport - 1);
 		size = PAGE_SIZE;
-	} else if (pgaddr == (((u64) pd->subport_rcvhdr_base +
-			       pd->port_rcvhdrq_size * (subport - 1)) &
-			      MMAP64_MASK)) {
+	} else if (pgaddr == cvt_kvaddr(pd->subport_rcvhdr_base +
+				pd->port_rcvhdrq_size * (subport - 1))) {
 		addr = pd->subport_rcvhdr_base +
 			pd->port_rcvhdrq_size * (subport - 1);
 		size = pd->port_rcvhdrq_size;
-	} else if (pgaddr == (((u64) pd->subport_rcvegrbuf +
-			       size * (subport - 1)) & MMAP64_MASK)) {
+	} else if (pgaddr == cvt_kvaddr(pd->subport_rcvegrbuf +
+			       size * (subport - 1))) {
 		addr = pd->subport_rcvegrbuf + size * (subport - 1);
 		/* rcvegrbufs are read-only on the slave */
 		if (vma->vm_flags & VM_WRITE) {
@@ -1190,10 +1194,8 @@ static int mmap_kvaddr(struct vm_area_st
 		 * with mprotect.
 		 */
 		vma->vm_flags &= ~VM_MAYWRITE;
-	} else {
-		ret = -EINVAL;
-		goto bail;
-	}
+	} else
+		goto bail;
 	len = vma->vm_end - vma->vm_start;
 	if (len > size) {
 		ipath_cdbg(MM, "FAIL: reqlen %lx > %zx\n", len, size);
@@ -1204,7 +1206,7 @@ static int mmap_kvaddr(struct vm_area_st
 	vma->vm_pgoff = (unsigned long) addr >> PAGE_SHIFT;
 	vma->vm_ops = &ipath_file_vm_ops;
 	vma->vm_flags |= VM_RESERVED | VM_DONTEXPAND;
-	ret = 0;
+	ret = 1;
 
 bail:
 	return ret;
@@ -1264,8 +1266,10 @@ static int ipath_mmap(struct file *fp, s
 	 * Check for kernel virtual addresses first, anything else must
 	 * match a HW or memory address.
 	 */
-	if (pgaddr >= (1ULL<<40)) {
-		ret = mmap_kvaddr(vma, pgaddr, pd, subport_fp(fp));
+	ret = mmap_kvaddr(vma, pgaddr, pd, subport_fp(fp));
+	if (ret) {
+		if (ret > 0)
+			ret = 0;
 		goto bail;
 	}
 
@@ -1411,7 +1415,7 @@ static int init_subports(struct ipath_de
 	 */
 	if (uinfo->spu_subport_cnt <= 1)
 		goto bail;
-	if (uinfo->spu_subport_cnt > 4) {
+	if (uinfo->spu_subport_cnt > INFINIPATH_MAX_SUBPORT) {
 		ret = -EINVAL;
 		goto bail;
 	}
