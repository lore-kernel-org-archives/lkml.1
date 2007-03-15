Return-Path: <linux-kernel-owner+w=401wt.eu-S1422984AbXCOW1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422984AbXCOW1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbXCOWP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:15:27 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33687 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401AbXCOWPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:24 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 15 of 33] IB/ipath - allow receive ports mapped into userspace
	to be shared
X-Mercurial-Node: 5ff8f23d0e61169f598ab1d93aa6324d88c17921
Message-Id: <5ff8f23d0e61169f598a.1173995099@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:44:59 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Mark Debbage <mark.debbage@qlogic.com>
# Date 1173994465 25200
# Node ID 5ff8f23d0e61169f598ab1d93aa6324d88c17921
# Parent  62da2fb770b66310ac06ba0190bf2bed2a5a764f
IB/ipath - allow receive ports mapped into userspace to be shared

Improve port-sharing performance by allowing any process to receive
packets from the shared hardware port under a spin lock for mutual
exclusion. Previously, one process was nominated as the master and
that process was responsible for receiving all packets from the shared
hardware port and either consuming them or forwarding them to their
destination. This led to starvation problems for other processes when
the master process was busy in computation phases.

Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r 62da2fb770b6 -r 5ff8f23d0e61 drivers/infiniband/hw/ipath/ipath_common.h
--- a/drivers/infiniband/hw/ipath/ipath_common.h	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_common.h	Thu Mar 15 14:34:25 2007 -0700
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006 QLogic, Inc. All rights reserved.
+ * Copyright (c) 2006, 2007 QLogic Corporation. All rights reserved.
  * Copyright (c) 2003, 2004, 2005, 2006 PathScale, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -318,10 +318,16 @@ struct ipath_base_info {
 	/* address of readonly memory copy of the rcvhdrq tail register. */
 	__u64 spi_rcvhdr_tailaddr;
 
-	/* shared memory pages for subports if IPATH_RUNTIME_MASTER is set */
+	/* shared memory pages for subports if port is shared */
 	__u64 spi_subport_uregbase;
 	__u64 spi_subport_rcvegrbuf;
 	__u64 spi_subport_rcvhdr_base;
+
+	/* shared memory page for hardware port if it is shared */
+	__u64 spi_port_uregbase;
+	__u64 spi_port_rcvegrbuf;
+	__u64 spi_port_rcvhdr_base;
+	__u64 spi_port_rcvhdr_tailaddr;
 
 } __attribute__ ((aligned(8)));
 
@@ -346,7 +352,7 @@ struct ipath_base_info {
  * may not be implemented; the user code must deal with this if it
  * cares, or it must abort after initialization reports the difference.
  */
-#define IPATH_USER_SWMINOR 3
+#define IPATH_USER_SWMINOR 4
 
 #define IPATH_USER_SWVERSION ((IPATH_USER_SWMAJOR<<16) | IPATH_USER_SWMINOR)
 
@@ -420,7 +426,7 @@ struct ipath_user_info {
 #define IPATH_CMD_TID_UPDATE	19	/* update expected TID entries */
 #define IPATH_CMD_TID_FREE	20	/* free expected TID entries */
 #define IPATH_CMD_SET_PART_KEY	21	/* add partition key */
-#define IPATH_CMD_SLAVE_INFO	22	/* return info on slave processes */
+#define __IPATH_CMD_SLAVE_INFO	22	/* return info on slave processes (for old user code) */
 #define IPATH_CMD_ASSIGN_PORT	23	/* allocate HCA and port */
 #define IPATH_CMD_USER_INIT 	24	/* set up userspace */
 
@@ -432,7 +438,7 @@ struct ipath_port_info {
 	__u16 port;		/* port on unit assigned to caller */
 	__u16 subport;		/* subport on unit assigned to caller */
 	__u16 num_ports;	/* number of ports available on unit */
-	__u16 num_subports;	/* number of subport slaves opened on port */
+	__u16 num_subports;	/* number of subports opened on port */
 };
 
 struct ipath_tid_info {
diff -r 62da2fb770b6 -r 5ff8f23d0e61 drivers/infiniband/hw/ipath/ipath_file_ops.c
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c	Thu Mar 15 14:34:25 2007 -0700
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006 QLogic, Inc. All rights reserved.
+ * Copyright (c) 2006, 2007 QLogic Corporation. All rights reserved.
  * Copyright (c) 2003, 2004, 2005, 2006 PathScale, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -99,7 +99,7 @@ static int ipath_get_base_info(struct fi
 	sz = sizeof(*kinfo);
 	/* If port sharing is not requested, allow the old size structure */
 	if (!shared)
-		sz -= 3 * sizeof(u64);
+		sz -= 7 * sizeof(u64);
 	if (ubase_size < sz) {
 		ipath_cdbg(PROC,
 			   "Base size %zu, need %zu (version mismatch?)\n",
@@ -177,38 +177,30 @@ static int ipath_get_base_info(struct fi
 		kinfo->spi_piobufbase = (u64) pd->port_piobufs +
 			dd->ipath_palign *
 			(dd->ipath_pbufsport - kinfo->spi_piocnt);
-		kinfo->__spi_uregbase = (u64) dd->ipath_uregbase +
-			dd->ipath_palign * pd->port_port;
 	} else {
 		unsigned slave = subport_fp(fp) - 1;
 
 		kinfo->spi_piocnt = dd->ipath_pbufsport / subport_cnt;
 		kinfo->spi_piobufbase = (u64) pd->port_piobufs +
 			dd->ipath_palign * kinfo->spi_piocnt * slave;
+	}
+	if (shared) {
+		kinfo->spi_port_uregbase = (u64) dd->ipath_uregbase +
+			dd->ipath_palign * pd->port_port;
+		kinfo->spi_port_rcvegrbuf = kinfo->spi_rcv_egrbufs;
+		kinfo->spi_port_rcvhdr_base = kinfo->spi_rcvhdr_base;
+		kinfo->spi_port_rcvhdr_tailaddr = kinfo->spi_rcvhdr_tailaddr;
+
 		kinfo->__spi_uregbase = cvt_kvaddr(pd->subport_uregbase +
-			PAGE_SIZE * slave);
+			PAGE_SIZE * subport_fp(fp));
 
 		kinfo->spi_rcvhdr_base = cvt_kvaddr(pd->subport_rcvhdr_base +
-			pd->port_rcvhdrq_size * slave);
+			pd->port_rcvhdrq_size * subport_fp(fp));
 		kinfo->spi_rcvhdr_tailaddr = 0;
 		kinfo->spi_rcv_egrbufs = cvt_kvaddr(pd->subport_rcvegrbuf +
-			dd->ipath_rcvegrcnt * dd->ipath_rcvegrbufsize * slave);
-	}
-
-	kinfo->spi_pioindex = (kinfo->spi_piobufbase - dd->ipath_piobufbase) /
-		dd->ipath_palign;
-	kinfo->spi_pioalign = dd->ipath_palign;
-
-	kinfo->spi_qpair = IPATH_KD_QP;
-	kinfo->spi_piosize = dd->ipath_ibmaxlen;
-	kinfo->spi_mtu = dd->ipath_ibmaxlen;	/* maxlen, not ibmtu */
-	kinfo->spi_port = pd->port_port;
-	kinfo->spi_subport = subport_fp(fp);
-	kinfo->spi_sw_version = IPATH_KERN_SWVERSION;
-	kinfo->spi_hw_version = dd->ipath_revision;
-
-	if (master) {
-		kinfo->spi_runtime_flags |= IPATH_RUNTIME_MASTER;
+			pd->port_rcvegrbuf_chunks * pd->port_rcvegrbuf_size *
+			subport_fp(fp));
+
 		kinfo->spi_subport_uregbase =
 			cvt_kvaddr(pd->subport_uregbase);
 		kinfo->spi_subport_rcvegrbuf =
@@ -222,7 +214,24 @@ static int ipath_get_base_info(struct fi
 			(unsigned long long) kinfo->spi_subport_rcvhdr_base);
 	}
 
-	if (copy_to_user(ubase, kinfo, sizeof(*kinfo)))
+	kinfo->spi_pioindex = (kinfo->spi_piobufbase - dd->ipath_piobufbase) /
+		dd->ipath_palign;
+	kinfo->spi_pioalign = dd->ipath_palign;
+
+	kinfo->spi_qpair = IPATH_KD_QP;
+	kinfo->spi_piosize = dd->ipath_ibmaxlen;
+	kinfo->spi_mtu = dd->ipath_ibmaxlen;	/* maxlen, not ibmtu */
+	kinfo->spi_port = pd->port_port;
+	kinfo->spi_subport = subport_fp(fp);
+	kinfo->spi_sw_version = IPATH_KERN_SWVERSION;
+	kinfo->spi_hw_version = dd->ipath_revision;
+
+	if (master) {
+		kinfo->spi_runtime_flags |= IPATH_RUNTIME_MASTER;
+	}
+
+	sz = (ubase_size < sizeof(*kinfo)) ? ubase_size : sizeof(*kinfo);
+	if (copy_to_user(ubase, kinfo, sz))
 		ret = -EFAULT;
 
 bail:
@@ -1152,50 +1161,47 @@ static int mmap_kvaddr(struct vm_area_st
 	size = pd->port_rcvegrbuf_chunks * pd->port_rcvegrbuf_size;
 
 	/*
-	 * Master has all the slave uregbase, rcvhdrq, and
-	 * rcvegrbufs mmapped.
+	 * Each process has all the subport uregbase, rcvhdrq, and
+	 * rcvegrbufs mmapped - as an array for all the processes,
+	 * and also separately for this process.
 	 */
-	if (subport == 0) {
-		unsigned num_slaves = pd->port_subport_cnt - 1;
-
-		if (pgaddr == cvt_kvaddr(pd->subport_uregbase)) {
-			addr = pd->subport_uregbase;
-			size = PAGE_SIZE * num_slaves;
-		} else if (pgaddr == cvt_kvaddr(pd->subport_rcvhdr_base)) {
-			addr = pd->subport_rcvhdr_base;
-			size = pd->port_rcvhdrq_size * num_slaves;
-		} else if (pgaddr == cvt_kvaddr(pd->subport_rcvegrbuf)) {
-			addr = pd->subport_rcvegrbuf;
-			size *= num_slaves;
-		} else
-			goto bail;
-	} else if (pgaddr == cvt_kvaddr(pd->subport_uregbase +
-					PAGE_SIZE * (subport - 1))) {
-		addr = pd->subport_uregbase + PAGE_SIZE * (subport - 1);
-		size = PAGE_SIZE;
-	} else if (pgaddr == cvt_kvaddr(pd->subport_rcvhdr_base +
-				pd->port_rcvhdrq_size * (subport - 1))) {
-		addr = pd->subport_rcvhdr_base +
-			pd->port_rcvhdrq_size * (subport - 1);
-		size = pd->port_rcvhdrq_size;
-	} else if (pgaddr == cvt_kvaddr(pd->subport_rcvegrbuf +
-			       size * (subport - 1))) {
-		addr = pd->subport_rcvegrbuf + size * (subport - 1);
-		/* rcvegrbufs are read-only on the slave */
-		if (vma->vm_flags & VM_WRITE) {
-			dev_info(&dd->pcidev->dev,
-				 "Can't map eager buffers as "
-				 "writable (flags=%lx)\n", vma->vm_flags);
-			ret = -EPERM;
-			goto bail;
-		}
-		/*
-		 * Don't allow permission to later change to writeable
-		 * with mprotect.
-		 */
-		vma->vm_flags &= ~VM_MAYWRITE;
-	} else
-		goto bail;
+	if (pgaddr == cvt_kvaddr(pd->subport_uregbase)) {
+		addr = pd->subport_uregbase;
+		size = PAGE_SIZE * pd->port_subport_cnt;
+	} else if (pgaddr == cvt_kvaddr(pd->subport_rcvhdr_base)) {
+		addr = pd->subport_rcvhdr_base;
+		size = pd->port_rcvhdrq_size * pd->port_subport_cnt;
+	} else if (pgaddr == cvt_kvaddr(pd->subport_rcvegrbuf)) {
+		addr = pd->subport_rcvegrbuf;
+		size *= pd->port_subport_cnt;
+        } else if (pgaddr == cvt_kvaddr(pd->subport_uregbase +
+                                        PAGE_SIZE * subport)) {
+                addr = pd->subport_uregbase + PAGE_SIZE * subport;
+                size = PAGE_SIZE;
+        } else if (pgaddr == cvt_kvaddr(pd->subport_rcvhdr_base +
+                                pd->port_rcvhdrq_size * subport)) {
+                addr = pd->subport_rcvhdr_base +
+                        pd->port_rcvhdrq_size * subport;
+                size = pd->port_rcvhdrq_size;
+        } else if (pgaddr == cvt_kvaddr(pd->subport_rcvegrbuf +
+                               size * subport)) {
+                addr = pd->subport_rcvegrbuf + size * subport;
+                /* rcvegrbufs are read-only on the slave */
+                if (vma->vm_flags & VM_WRITE) {
+                        dev_info(&dd->pcidev->dev,
+                                 "Can't map eager buffers as "
+                                 "writable (flags=%lx)\n", vma->vm_flags);
+                        ret = -EPERM;
+                        goto bail;
+                }
+                /*
+                 * Don't allow permission to later change to writeable
+                 * with mprotect.
+                 */
+                vma->vm_flags &= ~VM_MAYWRITE;
+	} else {
+		goto bail;
+	}
 	len = vma->vm_end - vma->vm_start;
 	if (len > size) {
 		ipath_cdbg(MM, "FAIL: reqlen %lx > %zx\n", len, size);
@@ -1273,14 +1279,13 @@ static int ipath_mmap(struct file *fp, s
 		goto bail;
 	}
 
+	ureg = dd->ipath_uregbase + dd->ipath_palign * pd->port_port;
 	if (!pd->port_subport_cnt) {
 		/* port is not shared */
-		ureg = dd->ipath_uregbase + dd->ipath_palign * pd->port_port;
 		piocnt = dd->ipath_pbufsport;
 		piobufs = pd->port_piobufs;
 	} else if (!subport_fp(fp)) {
 		/* caller is the master */
-		ureg = dd->ipath_uregbase + dd->ipath_palign * pd->port_port;
 		piocnt = (dd->ipath_pbufsport / pd->port_subport_cnt) +
 			 (dd->ipath_pbufsport % pd->port_subport_cnt);
 		piobufs = pd->port_piobufs +
@@ -1289,7 +1294,6 @@ static int ipath_mmap(struct file *fp, s
 		unsigned slave = subport_fp(fp) - 1;
 
 		/* caller is a slave */
-		ureg = 0;
 		piocnt = dd->ipath_pbufsport / pd->port_subport_cnt;
 		piobufs = pd->port_piobufs + dd->ipath_palign * piocnt * slave;
 	}
@@ -1303,9 +1307,6 @@ static int ipath_mmap(struct file *fp, s
 		ret = ipath_mmap_mem(vma, pd, PAGE_SIZE, 0,
 			      	     (void *) dd->ipath_pioavailregs_dma,
 				     "pioavail registers");
-	else if (subport_fp(fp))
-		/* Subports don't mmap the physical receive buffers */
-		ret = -EINVAL;
 	else if (pgaddr == pd->port_rcvegr_phys)
 		ret = mmap_rcvegrbufs(vma, pd);
 	else if (pgaddr == (u64) pd->port_rcvhdrq_phys)
@@ -1403,32 +1404,41 @@ static int init_subports(struct ipath_de
 			 const struct ipath_user_info *uinfo)
 {
 	int ret = 0;
-	unsigned num_slaves;
+	unsigned num_subports;
 	size_t size;
 
-	/* Old user binaries don't know about subports */
-	if ((uinfo->spu_userversion & 0xffff) != IPATH_USER_SWMINOR)
-		goto bail;
 	/*
 	 * If the user is requesting zero or one port,
 	 * skip the subport allocation.
 	 */
 	if (uinfo->spu_subport_cnt <= 1)
 		goto bail;
+
+	/* Old user binaries don't know about new subport implementation */
+	if ((uinfo->spu_userversion & 0xffff) != IPATH_USER_SWMINOR) {
+		dev_info(&dd->pcidev->dev,
+			 "Mismatched user minor version (%d) and driver "
+                         "minor version (%d) while port sharing. Ensure "
+                         "that driver and library are from the same "
+                         "release.\n", 
+                         (int) (uinfo->spu_userversion & 0xffff),
+	                 IPATH_USER_SWMINOR);
+		goto bail;
+	}
 	if (uinfo->spu_subport_cnt > INFINIPATH_MAX_SUBPORT) {
 		ret = -EINVAL;
 		goto bail;
 	}
 
-	num_slaves = uinfo->spu_subport_cnt - 1;
-	pd->subport_uregbase = vmalloc(PAGE_SIZE * num_slaves);
+	num_subports = uinfo->spu_subport_cnt;
+	pd->subport_uregbase = vmalloc(PAGE_SIZE * num_subports);
 	if (!pd->subport_uregbase) {
 		ret = -ENOMEM;
 		goto bail;
 	}
 	/* Note: pd->port_rcvhdrq_size isn't initialized yet. */
 	size = ALIGN(dd->ipath_rcvhdrcnt * dd->ipath_rcvhdrentsize *
-		     sizeof(u32), PAGE_SIZE) * num_slaves;
+		     sizeof(u32), PAGE_SIZE) * num_subports;
 	pd->subport_rcvhdr_base = vmalloc(size);
 	if (!pd->subport_rcvhdr_base) {
 		ret = -ENOMEM;
@@ -1437,7 +1447,7 @@ static int init_subports(struct ipath_de
 
 	pd->subport_rcvegrbuf = vmalloc(pd->port_rcvegrbuf_chunks *
 					pd->port_rcvegrbuf_size *
-					num_slaves);
+					num_subports);
 	if (!pd->subport_rcvegrbuf) {
 		ret = -ENOMEM;
 		goto bail_rhdr;
@@ -1447,6 +1457,11 @@ static int init_subports(struct ipath_de
 	pd->port_subport_id = uinfo->spu_subport_id;
 	pd->active_slaves = 1;
 	set_bit(IPATH_PORT_MASTER_UNINIT, &pd->port_flag);
+	memset(pd->subport_uregbase, 0, PAGE_SIZE * num_subports);
+	memset(pd->subport_rcvhdr_base, 0, size);
+	memset(pd->subport_rcvegrbuf, 0, pd->port_rcvegrbuf_chunks *
+				         pd->port_rcvegrbuf_size *
+				         num_subports);
 	goto bail;
 
 bail_rhdr:
@@ -1588,7 +1603,7 @@ static int find_best_unit(struct file *f
 		if (curcpu != -1) {
 			if (npresent) {
 				prefunit = curcpu / (ncpus / npresent);
-				ipath_dbg("%s[%u] %d chips, %d cpus, "
+				ipath_cdbg(PROC,"%s[%u] %d chips, %d cpus, "
 					  "%d cpus/chip, select unit %d\n",
 					  current->comm, current->pid,
 					  npresent, ncpus, ncpus / npresent,
@@ -2086,7 +2101,7 @@ static ssize_t ipath_write(struct file *
 		dest = &cmd.cmd.part_key;
 		src = &ucmd->cmd.part_key;
 		break;
-	case IPATH_CMD_SLAVE_INFO:
+	case __IPATH_CMD_SLAVE_INFO:
 		copy = sizeof(cmd.cmd.slave_mask_addr);
 		dest = &cmd.cmd.slave_mask_addr;
 		src = &ucmd->cmd.slave_mask_addr;
@@ -2152,7 +2167,7 @@ static ssize_t ipath_write(struct file *
 	case IPATH_CMD_SET_PART_KEY:
 		ret = ipath_set_part_key(pd, cmd.cmd.part_key);
 		break;
-	case IPATH_CMD_SLAVE_INFO:
+	case __IPATH_CMD_SLAVE_INFO:
 		ret = ipath_get_slave_info(pd,
 					   (void __user *) (unsigned long)
 					   cmd.cmd.slave_mask_addr);
