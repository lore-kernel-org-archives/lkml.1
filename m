Return-Path: <linux-kernel-owner+w=401wt.eu-S965856AbXCLNwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965856AbXCLNwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 09:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965860AbXCLNwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 09:52:10 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:38705 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965831AbXCLNwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 09:52:07 -0400
Date: Mon, 12 Mar 2007 14:52:13 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Please pull git390 'for-linus' branch
Message-ID: <20070312135213.GD11426@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'for-linus' branch of

	git://git390.osdl.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

 arch/s390/kernel/compat_wrapper.S |   17 +++++++++++++++++
 arch/s390/kernel/debug.c          |    2 +-
 arch/s390/kernel/early.c          |   10 ++++++++--
 arch/s390/kernel/ipl.c            |    9 ++++-----
 arch/s390/kernel/syscalls.S       |    3 ++-
 drivers/s390/cio/qdio.c           |   26 ++++++++++++++++++--------
 include/asm-s390/ipl.h            |    5 +++++
 include/asm-s390/unistd.h         |    3 ++-
 8 files changed, 57 insertions(+), 18 deletions(-)

Heiko Carstens (3):
      [S390] memory detection: fix off by one bug.
      [S390] Wire up compat_sys_epoll_pwait.
      [S390] Wire up sys_utimes.

Jean Delvare (1):
      [S390] strlcpy is smart enough

Michael Holzheu (1):
      [S390] reboot from and dump to SCSI under z/VM fails.

Ursula Braun (1):
      [S390] cio: qdio slsb setup

diff --git a/arch/s390/kernel/compat_wrapper.S b/arch/s390/kernel/compat_wrapper.S
index 9790129..32a69a1 100644
--- a/arch/s390/kernel/compat_wrapper.S
+++ b/arch/s390/kernel/compat_wrapper.S
@@ -1665,3 +1665,20 @@ sys_getcpu_wrapper:
 	llgtr	%r3,%r3			# unsigned *
 	llgtr	%r4,%r4			# struct getcpu_cache *
 	jg	sys_getcpu
+
+	.globl	compat_sys_epoll_pwait_wrapper
+compat_sys_epoll_pwait_wrapper:
+	lgfr	%r2,%r2			# int
+	llgtr	%r3,%r3			# struct compat_epoll_event *
+	lgfr	%r4,%r4			# int
+	lgfr	%r5,%r5			# int
+	llgtr	%r6,%r6			# compat_sigset_t *
+	llgf	%r0,164(%r15)		# compat_size_t
+	stg	%r0,160(%r15)
+	jg	compat_sys_epoll_pwait
+
+	.globl	compat_sys_utimes_wrapper
+compat_sys_utimes_wrapper:
+	llgtr	%r2,%r2			# char *
+	llgtr	%r3,%r3			# struct compat_timeval *
+	jg	compat_sys_utimes
diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index eca3fe5..dca6eaf 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -268,7 +268,7 @@ debug_info_alloc(char *name, int pages_per_area, int nr_areas, int buf_size,
 	rc->level          = level;
 	rc->buf_size       = buf_size;
 	rc->entry_size     = sizeof(debug_entry_t) + buf_size;
-	strlcpy(rc->name, name, sizeof(rc->name)-1);
+	strlcpy(rc->name, name, sizeof(rc->name));
 	memset(rc->views, 0, DEBUG_MAX_VIEWS * sizeof(struct debug_view *));
 	memset(rc->debugfs_entries, 0 ,DEBUG_MAX_VIEWS *
 		sizeof(struct dentry*));
diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index afca1c6..5e47936 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -141,9 +141,9 @@ static noinline __init void detect_machine_type(void)
 		machine_flags |= 4;
 }
 
+#ifdef CONFIG_64BIT
 static noinline __init int memory_fast_detect(void)
 {
-
 	unsigned long val0 = 0;
 	unsigned long val1 = 0xc;
 	int ret = -ENOSYS;
@@ -161,9 +161,15 @@ static noinline __init int memory_fast_detect(void)
 	if (ret || val0 != val1)
 		return -ENOSYS;
 
-	memory_chunk[0].size = val0;
+	memory_chunk[0].size = val0 + 1;
 	return 0;
 }
+#else
+static inline int memory_fast_detect(void)
+{
+	return -ENOSYS;
+}
+#endif
 
 #define ADDR2G	(1UL << 31)
 
diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index d125a4e..f731185 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -839,7 +839,7 @@ static int __init reipl_ccw_init(void)
 	}
 	reipl_block_ccw->hdr.len = IPL_PARM_BLK_CCW_LEN;
 	reipl_block_ccw->hdr.version = IPL_PARM_BLOCK_VERSION;
-	reipl_block_ccw->hdr.blk0_len = sizeof(reipl_block_ccw->ipl_info.ccw);
+	reipl_block_ccw->hdr.blk0_len = IPL_PARM_BLK0_CCW_LEN;
 	reipl_block_ccw->hdr.pbt = DIAG308_IPL_TYPE_CCW;
 	/* check if read scp info worked and set loadparm */
 	if (SCCB_VALID)
@@ -880,8 +880,7 @@ static int __init reipl_fcp_init(void)
 	} else {
 		reipl_block_fcp->hdr.len = IPL_PARM_BLK_FCP_LEN;
 		reipl_block_fcp->hdr.version = IPL_PARM_BLOCK_VERSION;
-		reipl_block_fcp->hdr.blk0_len =
-			sizeof(reipl_block_fcp->ipl_info.fcp);
+		reipl_block_fcp->hdr.blk0_len = IPL_PARM_BLK0_FCP_LEN;
 		reipl_block_fcp->hdr.pbt = DIAG308_IPL_TYPE_FCP;
 		reipl_block_fcp->ipl_info.fcp.opt = DIAG308_IPL_OPT_IPL;
 	}
@@ -930,7 +929,7 @@ static int __init dump_ccw_init(void)
 	}
 	dump_block_ccw->hdr.len = IPL_PARM_BLK_CCW_LEN;
 	dump_block_ccw->hdr.version = IPL_PARM_BLOCK_VERSION;
-	dump_block_ccw->hdr.blk0_len = sizeof(reipl_block_ccw->ipl_info.ccw);
+	dump_block_ccw->hdr.blk0_len = IPL_PARM_BLK0_CCW_LEN;
 	dump_block_ccw->hdr.pbt = DIAG308_IPL_TYPE_CCW;
 	dump_capabilities |= IPL_TYPE_CCW;
 	return 0;
@@ -954,7 +953,7 @@ static int __init dump_fcp_init(void)
 	}
 	dump_block_fcp->hdr.len = IPL_PARM_BLK_FCP_LEN;
 	dump_block_fcp->hdr.version = IPL_PARM_BLOCK_VERSION;
-	dump_block_fcp->hdr.blk0_len = sizeof(dump_block_fcp->ipl_info.fcp);
+	dump_block_fcp->hdr.blk0_len = IPL_PARM_BLK0_FCP_LEN;
 	dump_block_fcp->hdr.pbt = DIAG308_IPL_TYPE_FCP;
 	dump_block_fcp->ipl_info.fcp.opt = DIAG308_IPL_OPT_DUMP;
 	dump_capabilities |= IPL_TYPE_FCP;
diff --git a/arch/s390/kernel/syscalls.S b/arch/s390/kernel/syscalls.S
index a52c444..c774f10 100644
--- a/arch/s390/kernel/syscalls.S
+++ b/arch/s390/kernel/syscalls.S
@@ -320,4 +320,5 @@ SYSCALL(sys_tee,sys_tee,sys_tee_wrapper)
 SYSCALL(sys_vmsplice,sys_vmsplice,compat_sys_vmsplice_wrapper)
 NI_SYSCALL							/* 310 sys_move_pages */
 SYSCALL(sys_getcpu,sys_getcpu,sys_getcpu_wrapper)
-SYSCALL(sys_epoll_pwait,sys_epoll_pwait,sys_ni_syscall)
+SYSCALL(sys_epoll_pwait,sys_epoll_pwait,compat_sys_epoll_pwait_wrapper)
+SYSCALL(sys_utimes,sys_utimes,compat_sys_utimes_wrapper)
diff --git a/drivers/s390/cio/qdio.c b/drivers/s390/cio/qdio.c
index 5b1e3ff..05fac07 100644
--- a/drivers/s390/cio/qdio.c
+++ b/drivers/s390/cio/qdio.c
@@ -210,9 +210,11 @@ again:
 		goto again;
 	}
 	if (rc < 0) {
-                QDIO_DBF_TEXT3(1,trace,"sqberr");
-                sprintf(dbf_text,"%2x,%2x,%d,%d",tmp_cnt,*cnt,ccq,q_no);
-                QDIO_DBF_TEXT3(1,trace,dbf_text);
+		QDIO_DBF_TEXT3(1,trace,"sqberr");
+		sprintf(dbf_text,"%2x,%2x",tmp_cnt,*cnt);
+		QDIO_DBF_TEXT3(1,trace,dbf_text);
+		sprintf(dbf_text,"%d,%d",ccq,q_no);
+		QDIO_DBF_TEXT3(1,trace,dbf_text);
 		q->handler(q->cdev,QDIO_STATUS_ACTIVATE_CHECK_CONDITION|
 				QDIO_STATUS_LOOK_FOR_ERROR,
 				0, 0, 0, -1, -1, q->int_parm);
@@ -1250,7 +1252,6 @@ qdio_is_inbound_q_done(struct qdio_q *q)
 	if (!no_used) {
 		QDIO_DBF_TEXT4(0,trace,"inqisdnA");
 		QDIO_DBF_HEX4(0,trace,&q,sizeof(void*));
-		QDIO_DBF_TEXT4(0,trace,dbf_text);
 		return 1;
 	}
 	if (irq->is_qebsm) {
@@ -3371,10 +3372,15 @@ qdio_do_qdio_fill_input(struct qdio_q *q, unsigned int qidx,
 			unsigned int count, struct qdio_buffer *buffers)
 {
 	struct qdio_irq *irq = (struct qdio_irq *) q->irq_ptr;
+	int tmp = 0;
+
 	qidx &= (QDIO_MAX_BUFFERS_PER_Q - 1);
 	if (irq->is_qebsm) {
-		while (count)
-			set_slsb(q, &qidx, SLSB_CU_INPUT_EMPTY, &count);
+		while (count) {
+			tmp = set_slsb(q, &qidx, SLSB_CU_INPUT_EMPTY, &count);
+			if (!tmp)
+				return;
+		}
 		return;
 	}
 	for (;;) {
@@ -3390,11 +3396,15 @@ qdio_do_qdio_fill_output(struct qdio_q *q, unsigned int qidx,
 			 unsigned int count, struct qdio_buffer *buffers)
 {
 	struct qdio_irq *irq = (struct qdio_irq *) q->irq_ptr;
+	int tmp = 0;
 
 	qidx &= (QDIO_MAX_BUFFERS_PER_Q - 1);
 	if (irq->is_qebsm) {
-		while (count)
-			set_slsb(q, &qidx, SLSB_CU_OUTPUT_PRIMED, &count);
+		while (count) {
+			tmp = set_slsb(q, &qidx, SLSB_CU_OUTPUT_PRIMED, &count);
+			if (!tmp)
+				return;
+		}
 		return;
 	}
 
diff --git a/include/asm-s390/ipl.h b/include/asm-s390/ipl.h
index 660f782..0eb6408 100644
--- a/include/asm-s390/ipl.h
+++ b/include/asm-s390/ipl.h
@@ -14,9 +14,13 @@
 #define IPL_PARM_BLK_FCP_LEN (sizeof(struct ipl_list_hdr) + \
 			      sizeof(struct ipl_block_fcp))
 
+#define IPL_PARM_BLK0_FCP_LEN (sizeof(struct ipl_block_fcp) + 8)
+
 #define IPL_PARM_BLK_CCW_LEN (sizeof(struct ipl_list_hdr) + \
 			      sizeof(struct ipl_block_ccw))
 
+#define IPL_PARM_BLK0_CCW_LEN (sizeof(struct ipl_block_ccw) + 8)
+
 #define IPL_MAX_SUPPORTED_VERSION (0)
 
 #define IPL_PARMBLOCK_START	((struct ipl_parameter_block *) \
@@ -58,6 +62,7 @@ struct ipl_block_ccw {
 	u8  vm_flags;
 	u8  reserved3[3];
 	u32 vm_parm_len;
+	u8  reserved4[80];
 } __attribute__((packed));
 
 struct ipl_parameter_block {
diff --git a/include/asm-s390/unistd.h b/include/asm-s390/unistd.h
index fb6fef9..5c6f00d 100644
--- a/include/asm-s390/unistd.h
+++ b/include/asm-s390/unistd.h
@@ -250,8 +250,9 @@
 /* Number 310 is reserved for new sys_move_pages */
 #define __NR_getcpu		311
 #define __NR_epoll_pwait	312
+#define __NR_utimes		313
 
-#define NR_syscalls 313
+#define NR_syscalls 314
 
 /* 
  * There are some system calls that are not present on 64 bit, some
