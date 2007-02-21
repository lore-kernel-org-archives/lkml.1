Return-Path: <linux-kernel-owner+w=401wt.eu-S1161234AbXBUNil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161234AbXBUNil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 08:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161237AbXBUNil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 08:38:41 -0500
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:58348 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161233AbXBUNie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 08:38:34 -0500
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Organization: IBM
To: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       linux-s390@vger.kernel.org, hpa@zytor.com
Subject: [RFC] [PATCH 1/2] s390: SCSI dump kernel and userspace application
Date: Wed, 21 Feb 2007 14:39:54 +0100
User-Agent: KMail/1.9.4
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702211439.54313.holzheu@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel part of the s390 SCSI dumper: zcore character device driver.

Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Michael Holzheu <holzheu@de.ibm.com>

---
 Documentation/s390/zfcpdump.txt |   41 +
 arch/s390/Kconfig               |    7 
 arch/s390/kernel/early.c        |    3 
 arch/s390/kernel/head64.S       |   43 +
 arch/s390/kernel/ipl.c          |   24 -
 arch/s390/kernel/setup.c        |    3 
 arch/s390/kernel/smp.c          |    1 
 drivers/s390/char/Makefile      |    2 
 drivers/s390/char/sclp.h        |    2 
 drivers/s390/char/sclp_sdias.c  |  248 +++++++++++
 drivers/s390/char/zcore.c       |  885 ++++++++++++++++++++++++++++++++++++++++
 drivers/s390/cio/cio.c          |    1 
 include/asm-s390/ipl.h          |  116 +++++
 include/asm-s390/processor.h    |    5 
 include/asm-s390/sclp.h         |    2 
 include/asm-s390/setup.h        |   75 ---
 16 files changed, 1360 insertions(+), 98 deletions(-)

Index: git-linux-2.6/Documentation/s390/zfcpdump.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ git-linux-2.6/Documentation/s390/zfcpdump.txt	2007-02-21 11:00:15.000000000 +0100
@@ -0,0 +1,41 @@
+s390 SCSI dump tool (zfcpdump)
+
+System z machines (z900 or higher) provide hardware support for creating system
+dumps on SCSI disks. The dump process is initiated by booting a dump tool, which
+has to create a dump of the current (probably crashed) Linux image. In order to
+not overwrite memory of the crashed Linux with data of the dump tool, the
+hardware saves some memory plus the register sets of the boot cpu before the
+dump tool is loaded. There exists an SCLP hardware interface to obtain the saved
+memory afterwards. Currently 32 MB are saved.
+
+This zfcpdump implementation consists of a small Linux dump kernel together with
+a userspace dump tool, which are loaded together into the saved memory region
+below 32 MB. zfcpdump is installed on a SCSI disk using zipl (as contained in the
+s390-tools package) to make the device bootable. The operator of a Linux system
+can then trigger a scsi dump by booting the SCSI disk, where zfcpdump resides on.
+
+The kernel part of zfcpdump is implemented as a character device driver named
+"zcore", which exports memory and registers of the crashed Linux in an s390
+standalone dump format. It can be used in the same way as e.g. /dev/mem. The
+dump format defines a 4K header followed by plain uncompressed memory. The
+register sets are stored in the prefix pages of the different cpus. To build an
+dump enabled kernel with the zcore driver, the kernel config option
+"S390_ZFCPDUMP" has to be set. When reading from /dev/zcore, the first part of
+memory, which has been saved by the hardware is read by the driver via the SCLP
+hardware interface. The second part is just copied from the non overwritten real
+memory.
+
+The userspace application of zfcpdump resides in an intitramfs. It reads from
+/dev/zcore and writes the system dump to a file on a SCSI disk.
+
+To build zfcpdump you have to do the following:
+- Use /arch/s390/zfcpdump/defconfig.zfcpdump as kernel configuration file, which
+  enables the S390_ZFCPDUMP option and sets all other required kernel options.
+- Issue "make zfcpdump" from the toplevel directory of the linux tree to
+  build the userspace application. Note, that the zfcpdump application has a
+  dependency on glibc and libz.
+- Issue "make image" to build the zfcpdump image with initramfs.
+
+The zfcpdump enabled kernel image must be copied to
+/usr/share/zfcpdump/zfcpdump.image, where the zipl tool is looking for the dump
+kernel, when preparing a SCSI dump disk.
Index: git-linux-2.6/arch/s390/Kconfig
===================================================================
--- git-linux-2.6.orig/arch/s390/Kconfig	2007-02-21 10:22:03.000000000 +0100
+++ git-linux-2.6/arch/s390/Kconfig	2007-02-21 11:00:15.000000000 +0100
@@ -512,6 +512,13 @@ config KEXEC
 	  current kernel, and to start another kernel.  It is like a reboot
 	  but is independent of hardware/microcode support.
 
+config S390_ZFCPDUMP
+	bool "zfcp dump kernel"
+	default n
+	help
+	  Select this option if you want to build an zfcp dump enabled kernel.
+	  Do NOT select this option for normal kernels!
+
 endmenu
 
 source "net/Kconfig"
Index: git-linux-2.6/arch/s390/kernel/early.c
===================================================================
--- git-linux-2.6.orig/arch/s390/kernel/early.c	2007-02-21 10:22:04.000000000 +0100
+++ git-linux-2.6/arch/s390/kernel/early.c	2007-02-21 10:56:03.000000000 +0100
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/pfn.h>
 #include <linux/uaccess.h>
+#include <asm/ipl.h>
 #include <asm/lowcore.h>
 #include <asm/processor.h>
 #include <asm/sections.h>
@@ -129,7 +130,7 @@ static noinline __init void detect_machi
 {
 	struct cpuinfo_S390 *cpuinfo = &S390_lowcore.cpu_data;
 
-	asm volatile("stidp %0" : "=m" (S390_lowcore.cpu_data.cpu_id));
+	get_cpu_id(&S390_lowcore.cpu_data.cpu_id);
 
 	/* Running under z/VM ? */
 	if (cpuinfo->cpu_id.version == 0xff)
Index: git-linux-2.6/arch/s390/kernel/head64.S
===================================================================
--- git-linux-2.6.orig/arch/s390/kernel/head64.S	2007-02-21 10:22:04.000000000 +0100
+++ git-linux-2.6/arch/s390/kernel/head64.S	2007-02-21 11:00:15.000000000 +0100
@@ -39,7 +39,42 @@ startup_continue:
 	basr	%r13,0			# get base
 .LPG1:	sll	%r13,1			# remove high order bit
 	srl	%r13,1
+
+#ifdef CONFIG_S390_ZFCPDUMP
+
+	# store all prefix registers:
+
+	la	%r7,0			# base register for 0 page
+	la	%r8,0			# first cpu
+	l	%r11,.Lpref_arr_ptr-.LPG1(%r13)	# address of prefix array
+	lr	%r12,%r11
+	ahi	%r12,(CONFIG_NR_CPUS*4)	# end of prefix array
+	stap	.Lcurrent_cpu+2-.LPG1(%r13)	# store current cpu addr
+1:
+	cl	%r8,.Lcurrent_cpu-.LPG1(%r13)	# is ipl cpu ?
+	je	4f				# if yes get next cpu
+2:
+	lr	%r9,%r7
+	sigp	%r9,%r8,0x9		# stop & store status of cpu
+	brc	8,3f			# accepted
+	brc	4,4f			# status stored: next cpu
+	brc	2,2b			# busy:          try again
+	brc	1,4f			# not op:        next cpu
+3:
+	mvc	0(4,%r11),264(%r7)	# copy prefix register to prefix array
+	ahi	%r11,4			# next element in prefix array
+	clr	%r11,%r12
+	je	5f			# no more space in prefix array
+4:
+	ahi	%r8,1				# next cpu (r8 += 1)
+	cl	%r8,.Llast_cpu-.LPG1(%r13)	# is last possible cpu ?
+	jl	1b				# jump if not last cpu
+5:
+	lhi	%r1,2			# mode 2 = esame for dump
+#else
 	lhi	%r1,1			# mode 1 = esame
+#endif /* CONFIG_S390_ZFCPDUMP */
+
 	mvi	__LC_AR_MODE_ID,1	# set esame flag
 	slr	%r0,%r0 		# set cpuid to zero
 	sigp	%r1,%r0,0x12		# switch to esame mode
@@ -151,6 +186,14 @@ startup_continue:
 .L4malign:.quad 0xffffffffffc00000
 .Lscan2g:.quad	0x80000000 + 0x20000 - 8	# 2GB + 128K - 8
 .Lnop:	.long	0x07000700
+#ifdef CONFIG_S390_ZFCPDUMP
+.Lcurrent_cpu:
+	.long 0x0
+.Llast_cpu:
+	.long 0x0000ffff
+.Lpref_arr_ptr:
+	.long dump_prefix_array
+#endif /* CONFIG_S390_ZFCPDUMP */
 .Lparmaddr:
 	.quad	PARMAREA
 
Index: git-linux-2.6/arch/s390/kernel/ipl.c
===================================================================
--- git-linux-2.6.orig/arch/s390/kernel/ipl.c	2007-02-21 10:22:04.000000000 +0100
+++ git-linux-2.6/arch/s390/kernel/ipl.c	2007-02-21 10:54:51.000000000 +0100
@@ -14,6 +14,7 @@
 #include <linux/delay.h>
 #include <linux/reboot.h>
 #include <linux/ctype.h>
+#include <asm/ipl.h>
 #include <asm/smp.h>
 #include <asm/setup.h>
 #include <asm/cpcmd.h>
@@ -94,27 +95,6 @@ static char *shutdown_action_str(enum sh
 	}
 }
 
-enum diag308_subcode  {
-	DIAG308_IPL   = 3,
-	DIAG308_DUMP  = 4,
-	DIAG308_SET   = 5,
-	DIAG308_STORE = 6,
-};
-
-enum diag308_ipl_type {
-	DIAG308_IPL_TYPE_FCP = 0,
-	DIAG308_IPL_TYPE_CCW = 2,
-};
-
-enum diag308_opt {
-	DIAG308_IPL_OPT_IPL  = 0x10,
-	DIAG308_IPL_OPT_DUMP = 0x20,
-};
-
-enum diag308_rc {
-	DIAG308_RC_OK = 1,
-};
-
 static int diag308_set_works = 0;
 
 static int reipl_capabilities = IPL_TYPE_UNKNOWN;
@@ -134,7 +114,7 @@ static struct ipl_parameter_block *dump_
 
 static enum shutdown_action on_panic_action = SHUTDOWN_STOP;
 
-static int diag308(unsigned long subcode, void *addr)
+int diag308(unsigned long subcode, void *addr)
 {
 	register unsigned long _addr asm("0") = (unsigned long) addr;
 	register unsigned long _rc asm("1") = 0;
Index: git-linux-2.6/arch/s390/kernel/setup.c
===================================================================
--- git-linux-2.6.orig/arch/s390/kernel/setup.c	2007-02-21 10:22:04.000000000 +0100
+++ git-linux-2.6/arch/s390/kernel/setup.c	2007-02-21 10:56:03.000000000 +0100
@@ -41,6 +41,7 @@
 #include <linux/ctype.h>
 #include <linux/reboot.h>
 
+#include <asm/ipl.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
 #include <asm/smp.h>
@@ -106,7 +107,7 @@ void __devinit cpu_init (void)
         /*
          * Store processor id in lowcore (used e.g. in timer_interrupt)
          */
-	asm volatile("stidp %0": "=m" (S390_lowcore.cpu_data.cpu_id));
+	get_cpu_id(&S390_lowcore.cpu_data.cpu_id);
         S390_lowcore.cpu_data.cpu_addr = addr;
 
         /*
Index: git-linux-2.6/arch/s390/kernel/smp.c
===================================================================
--- git-linux-2.6.orig/arch/s390/kernel/smp.c	2007-02-21 10:22:04.000000000 +0100
+++ git-linux-2.6/arch/s390/kernel/smp.c	2007-02-21 10:54:51.000000000 +0100
@@ -31,6 +31,7 @@
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
 #include <linux/timex.h>
+#include <asm/ipl.h>
 #include <asm/setup.h>
 #include <asm/sigp.h>
 #include <asm/pgalloc.h>
Index: git-linux-2.6/drivers/s390/char/Makefile
===================================================================
--- git-linux-2.6.orig/drivers/s390/char/Makefile	2007-02-21 10:22:40.000000000 +0100
+++ git-linux-2.6/drivers/s390/char/Makefile	2007-02-21 11:00:15.000000000 +0100
@@ -29,3 +29,5 @@ obj-$(CONFIG_S390_TAPE_34XX) += tape_34x
 obj-$(CONFIG_S390_TAPE_3590) += tape_3590.o
 obj-$(CONFIG_MONREADER) += monreader.o
 obj-$(CONFIG_MONWRITER) += monwriter.o
+
+obj-$(CONFIG_S390_ZFCPDUMP) += zcore.o sclp_sdias.o
Index: git-linux-2.6/drivers/s390/char/sclp.h
===================================================================
--- git-linux-2.6.orig/drivers/s390/char/sclp.h	2007-02-21 10:22:40.000000000 +0100
+++ git-linux-2.6/drivers/s390/char/sclp.h	2007-02-21 11:01:21.000000000 +0100
@@ -27,6 +27,7 @@
 #define EvTyp_CntlProgIdent	0x0B
 #define EvTyp_SigQuiesce	0x1D
 #define EvTyp_VT220Msg		0x1A
+#define EvTyp_SDIAS		0x1C
 
 #define EvTyp_OpCmd_Mask	0x80000000
 #define EvTyp_Msg_Mask		0x40000000
@@ -36,6 +37,7 @@
 #define EvTyp_CtlProgIdent_Mask	0x00200000
 #define EvTyp_SigQuiesce_Mask	0x00000008
 #define EvTyp_VT220Msg_Mask	0x00000040
+#define EvTyp_SDIAS_Mask	0x00000010
 
 #define GnrlMsgFlgs_DOM		0x8000
 #define GnrlMsgFlgs_SndAlrm	0x4000
Index: git-linux-2.6/drivers/s390/char/sclp_sdias.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ git-linux-2.6/drivers/s390/char/sclp_sdias.c	2007-02-21 11:02:29.000000000 +0100
@@ -0,0 +1,248 @@
+/*
+ * Sclp "store data in absolut storage"
+ *
+ * Copyright IBM Corp. 2003,2007
+ * Author(s): Michael Holzheu
+ */
+
+#include <linux/sched.h>
+#include <asm/sclp.h>
+#include <asm/debug.h>
+#include "sclp.h"
+#include "sclp_rw.h"
+
+#define TRACE(x...) debug_sprintf_event(sdias_dbf, 1, x)
+#define ERROR_MSG(x...) printk ( KERN_ALERT "SDIAS: " x )
+
+#define SDIAS_RETRIES 300
+#define SDIAS_SLEEP_TICKS 50
+
+#define EQ_STORE_DATA	0x0
+#define EQ_SIZE		0x1
+#define DI_FCP_DUMP	0x0
+#define ASA_SIZE_32	0x0
+#define ASA_SIZE_64	0x1
+#define EVSTATE_ALL_STORED	0x0
+#define EVSTATE_NO_DATA		0x3
+#define EVSTATE_PART_STORED	0x10
+
+static struct debug_info *sdias_dbf;
+
+static struct sclp_register sclp_sdias_register = {
+	.send_mask = EvTyp_SDIAS_Mask,
+};
+
+struct sdias_evbuf {
+	struct  evbuf_header hdr;
+	u8	event_qual;
+	u8	data_id;
+	u64	reserved2;
+	u32	event_id;
+	u16	reserved3;
+	u8	asa_size;
+	u8	event_status;
+	u32	reserved4;
+	u32	blk_cnt;
+	u64	asa;
+	u32	reserved5;
+	u32	fbn;
+	u32	reserved6;
+	u32	lbn;
+	u16	reserved7;
+	u16	dbs;
+} __attribute__((packed));
+
+struct sdias_sccb {
+	struct sccb_header  hdr;
+	struct sdias_evbuf  evbuf;
+} __attribute__((packed));
+
+static struct sdias_sccb sccb __attribute__((aligned(4096)));
+
+static int sclp_req_done;
+static wait_queue_head_t sdias_wq;
+static DEFINE_MUTEX(sdias_mutex);
+
+static void sdias_callback(struct sclp_req *request, void *data)
+{
+	struct sdias_sccb *sccb;
+
+	sccb = (struct sdias_sccb *) request->sccb;
+	sclp_req_done = 1;
+	wake_up(&sdias_wq); /* Inform caller, that request is complete */
+	TRACE("callback done\n");
+}
+
+static int sdias_sclp_send(struct sclp_req *req)
+{
+	int retries;
+	int rc;
+
+	for (retries = SDIAS_RETRIES; retries; retries--) {
+		sclp_req_done = 0;
+		TRACE("add request\n");
+		rc = sclp_add_request(req);
+		if (rc) {
+			/* not initiated, wait some time and retry */
+			set_current_state(TASK_INTERRUPTIBLE);
+			TRACE("add request failed: rc = %i\n",rc);
+			schedule_timeout(SDIAS_SLEEP_TICKS);
+			continue;
+		}
+		/* initiated, wait for completion of service call */
+		wait_event(sdias_wq, (sclp_req_done == 1));
+		if (req->status == SCLP_REQ_FAILED) {
+			TRACE("sclp request failed\n");
+			rc = -EIO;
+			continue;
+		}
+		TRACE("request done\n");
+		break;
+	}
+	return rc;
+}
+
+static int sdias_init(void)
+{
+	int rc;
+
+	sdias_dbf = debug_register("dump_sdias", 4, 1, 4 * sizeof(long));
+	debug_register_view(sdias_dbf, &debug_sprintf_view);
+	debug_set_level(sdias_dbf, 6);
+	rc = sclp_register(&sclp_sdias_register);
+	if (rc) {
+		ERROR_MSG("sclp register failed\n");
+		return rc;
+	}
+	init_waitqueue_head(&sdias_wq);
+	TRACE("init done\n");
+	return 0;
+}
+
+/*
+ * Get number of blocks (4K) available in the HSA
+ */
+int sclp_sdias_blk_count(void)
+{
+	struct sclp_req request;
+	int rc;
+
+	mutex_lock(&sdias_mutex);
+
+	memset(&sccb, 0, sizeof(sccb));
+	memset(&request, 0, sizeof(request));
+
+	sccb.hdr.length = sizeof(sccb);
+	sccb.evbuf.hdr.length = sizeof(struct sdias_evbuf);
+	sccb.evbuf.hdr.type = EvTyp_SDIAS;
+	sccb.evbuf.event_qual = EQ_SIZE;
+	sccb.evbuf.data_id = DI_FCP_DUMP;
+	sccb.evbuf.event_id = 4712;
+	sccb.evbuf.dbs = 1;
+
+	request.sccb = &sccb;
+	request.command = SCLP_CMDW_WRITE_EVENT_DATA;
+	request.status = SCLP_REQ_FILLED;
+	request.callback = sdias_callback;
+
+	rc = sdias_sclp_send(&request);
+	if (rc) {
+		ERROR_MSG("sclp_send failed for get_nr_blocks\n");
+		goto out;
+	}
+	if (sccb.hdr.response_code != 0x0020) {
+		TRACE("send failed: %x\n", sccb.hdr.response_code);
+		rc = -EIO;
+		goto out;
+	}
+
+	switch (sccb.evbuf.event_status) {
+		case 0:
+			rc = sccb.evbuf.blk_cnt;
+			break;
+		default:
+			ERROR_MSG("SCLP error: %x\n", sccb.evbuf.event_status);
+			rc = -EIO;
+			goto out;
+	}
+	TRACE("%i blocks\n", rc);
+out:
+	mutex_unlock(&sdias_mutex);
+	return rc;
+}
+
+/*
+ * Copy from HSA to absolute storage (not reentrant):
+ *
+ * @dest     : Address of buffer where data should be copied
+ * @start_blk: Start Block (beginning with 1)
+ * @nr_blks  : Number of 4K blocks to copy
+ *
+ * Return Value: 0 : Requested 'number' of blocks of data copied
+ *		 <0: ERROR - negative event status
+ */
+int sclp_sdias_copy(void *dest, int start_blk, int nr_blks)
+{
+	struct sclp_req request;
+	int rc;
+
+	mutex_lock(&sdias_mutex);
+
+	memset(&sccb, 0, sizeof(sccb));
+	memset(&request, 0, sizeof(request));
+
+	sccb.hdr.length = sizeof(sccb);
+	sccb.evbuf.hdr.length = sizeof(struct sdias_evbuf);
+	sccb.evbuf.hdr.type = EvTyp_SDIAS;
+	sccb.evbuf.hdr.flags = 0;
+	sccb.evbuf.event_qual = EQ_STORE_DATA;
+	sccb.evbuf.data_id = DI_FCP_DUMP;
+	sccb.evbuf.event_id = 4712;
+#ifdef __s390x__
+	sccb.evbuf.asa_size = ASA_SIZE_64;
+#else
+	sccb.evbuf.asa_size = ASA_SIZE_32;
+#endif
+	sccb.evbuf.event_status = 0;
+	sccb.evbuf.blk_cnt = nr_blks;
+	sccb.evbuf.asa = (unsigned long)dest;
+	sccb.evbuf.fbn = start_blk;
+	sccb.evbuf.lbn = 0;
+	sccb.evbuf.dbs = 1;
+
+	request.sccb     = &sccb;
+	request.command  = SCLP_CMDW_WRITE_EVENT_DATA;
+	request.status   = SCLP_REQ_FILLED;
+	request.callback = sdias_callback;
+
+	rc = sdias_sclp_send(&request);
+	if (rc) {
+		ERROR_MSG("sclp_send failed: %x\n", rc);
+		goto out;
+	}
+	if (sccb.hdr.response_code != 0x0020) {
+		TRACE("copy failed: %x\n", sccb.hdr.response_code);
+		rc = -EIO;
+		goto out;
+	}
+
+	switch (sccb.evbuf.event_status) {
+		case EVSTATE_ALL_STORED:
+			TRACE("all stored\n");
+		case EVSTATE_PART_STORED:
+			TRACE("part stored: %i\n", sccb.evbuf.blk_cnt);
+			break;
+		case EVSTATE_NO_DATA:
+			TRACE("no data\n");
+		default:
+			ERROR_MSG("Error from SCLP while copying hsa. "
+				  "Event status = %x\n",
+				sccb.evbuf.event_status);
+			rc = -EIO;
+	}
+out:
+	mutex_unlock(&sdias_mutex);
+	return rc;
+}
+
+device_initcall(sdias_init);
Index: git-linux-2.6/drivers/s390/char/zcore.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ git-linux-2.6/drivers/s390/char/zcore.c	2007-02-21 11:02:16.000000000 +0100
@@ -0,0 +1,885 @@
+/*
+ * zcore character device to export memory content and register sets for
+ * creating system dumps on SCSI disks. /dev/zcore shows the same dump format
+ * as s390 standalone dumps.
+ *
+ * Copyright IBM Corp. 2003,2007
+ * Author(s): Michael Holzheu
+ */
+
+#include <linux/init.h>
+#include <linux/compile.h>
+#include <linux/miscdevice.h>
+#include <asm/ipl.h>
+#include <asm/sclp.h>
+#include <asm/setup.h>
+#include <asm/sigp.h>
+#include <asm/uaccess.h>
+#include <asm/debug.h>
+#include <asm/processor.h>
+#include <asm/irqflags.h>
+
+#define HSA_SIZE	(32<<20) /* 32MB */
+
+#define SA_BASE_S390X	4608
+#define SA_BASE_S390	212
+
+#define DUMP_LOG_LEVEL	2
+
+#define TRACE(x...) debug_sprintf_event(zcore_dbf, 1, x)
+#define MSG(x...) printk( KERN_ALERT x )
+#define ERROR_MSG(x...) printk ( KERN_ALERT "DUMP: " x )
+
+#define FCP_DATA (&IPL_PARMBLOCK_START->ipl_info.fcp)
+
+#define TO_USER		0
+#define TO_KERNEL	1
+
+enum arch_id {
+	ARCH_S390	= 0,
+	ARCH_S390X	= 1,
+};
+
+/* lowcore data */
+
+union cpu_info {
+	struct {
+		u32	ext_save;
+		u64	timer;
+		u64	clk_cmp;
+		u8	pad1[24];
+		u8	psw[8];
+		u32	pref_reg;
+		u8	pad2[20];
+		u32	acc_regs[16];
+		u64	fp_regs[4];
+		u32	gp_regs[16];
+		u32	ctrl_regs[16];
+	}  __attribute__((packed)) s390;
+
+	struct {
+		u64	fp_regs[16];
+		u64	gp_regs[16];
+		u8	psw[16];
+		u8	pad1[8];
+		u32	pref_reg;
+		u32	fp_ctrl_reg;
+		u8	pad2[4];
+		u32	tod_reg;
+		u64	timer;
+		u64	clk_cmp;
+		u8	pad3[8];
+		u32	acc_regs[16];
+		u64	ctrl_regs[16];
+	}  __attribute__((packed)) s390x;
+};
+
+/* dump system info */
+
+struct sys_info {
+	enum arch_id	arch;
+	unsigned long	sa_base;
+	u32		sa_size;
+	int		cpu_count;
+	union cpu_info	*cpu_info;
+	int		cpu_map[NR_CPUS];
+	unsigned long	mem_size;
+	union cpu_info	lc_mask;
+};
+
+/*
+ * dump_prefix_array holds prefix registers for the following scenario:
+ * 64 bit system dumper and 32 bit kernel which is dumped. The array is filled
+ * in s390x/kernel/head*.S and is 0 terminated. The boot cpu is not
+ * contained in the array. The prefix register for a logical cpu x (according
+ * to cpu_logical_map can be found with dump_prefix_array[x-1]
+ */
+unsigned int dump_prefix_array[NR_CPUS] __attribute__((__section__(".data")));
+static struct sys_info sys_info;
+static struct debug_info *zcore_dbf;
+static int hsa_available;
+
+/*
+ * Copy memory from HSA to kernel or user memory (not reentrant):
+ *
+ * @dest:  Kernel or user buffer where memory should be copied to
+ * @src:   Start address within HSA where data should be copied
+ * @count: Size of buffer, which should be copied
+ * @mode:  Either TO_KERNEL or TO_USER
+ */
+static int memcpy_hsa(void *dest, unsigned long src, size_t count, int mode)
+{
+	int offs, blk_num;
+	static char buf[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
+
+	if (count == 0)
+		return 0;
+
+	/* copy first block */
+	offs = 0;
+	if ((src % PAGE_SIZE) != 0) {
+		blk_num = src / PAGE_SIZE + 2;
+		if (sclp_sdias_copy(buf, blk_num, 1)) {
+			TRACE("sclp_sdias_copy() failed\n");
+			return -EIO;
+		}
+		offs = min((PAGE_SIZE - (src % PAGE_SIZE)), count);
+		if (mode == TO_USER) {
+			if (copy_to_user((__force __user void*) dest,
+					 buf + (src % PAGE_SIZE), offs))
+				return -EFAULT;
+		} else
+			memcpy(dest, buf + (src % PAGE_SIZE), offs);
+	}
+	if (offs == count)
+		goto out;
+
+	/* copy middle */
+	for (; (offs + PAGE_SIZE) <= count; offs += PAGE_SIZE) {
+		blk_num = (src + offs) / PAGE_SIZE + 2;
+		if (sclp_sdias_copy(buf, blk_num, 1)) {
+			TRACE("sclp_sdias_copy() failed\n");
+			return -EIO;
+		}
+		if (mode == TO_USER) {
+			if (copy_to_user((__force __user void*) dest + offs,
+					 buf, PAGE_SIZE))
+				return -EFAULT;
+		} else
+			memcpy(dest + offs, buf, PAGE_SIZE);
+	}
+	if (offs == count)
+		goto out;
+
+	/* copy last block */
+	blk_num = (src + offs) / PAGE_SIZE + 2;
+	if (sclp_sdias_copy(buf, blk_num, 1)) {
+		TRACE("sclp_sdias_copy() failed\n");
+		return -EIO;
+	}
+	if (mode == TO_USER) {
+		if (copy_to_user((__force __user void*) dest + offs, buf,
+				 PAGE_SIZE))
+			return -EFAULT;
+	} else
+		memcpy(dest + offs, buf, count - offs);
+out:
+	return 0;
+}
+
+static int memcpy_hsa_user(void __user *dest, unsigned long src, size_t count)
+{
+	return memcpy_hsa((void __force *) dest, src, count, TO_USER);
+}
+
+static int memcpy_hsa_kernel(void *dest, unsigned long src, size_t count)
+{
+	return memcpy_hsa(dest, src, count, TO_KERNEL);
+}
+
+static int memcpy_real(void *dest, unsigned long src, size_t count)
+{
+	unsigned long flags;
+	int rc = -EFAULT;
+	register unsigned long _dest asm("2") = (unsigned long) dest;
+	register unsigned long _len1 asm("3") = (unsigned long) count;
+	register unsigned long _src  asm("4") = src;
+	register unsigned long _len2 asm("5") = (unsigned long) count;
+
+	if (count == 0)
+		return 0;
+	flags = __raw_local_irq_stnsm(0xf8); /* switch to real mode */
+	asm volatile (
+		"0:	mvcle	%1,%2,0x0\n"
+		"1:	jo	0b\n"
+		"	lhi	%0,0x0\n"
+		"2:\n"
+		EX_TABLE(1b,2b)
+		: "+d" (rc)
+		: "d" (_dest), "d" (_src), "d" (_len1), "d" (_len2)
+		: "cc", "memory");
+	__raw_local_irq_ssm(flags);
+
+	return rc;
+}
+
+static int memcpy_real_user(__user void *dest, unsigned long src, size_t count)
+{
+	static char buf[4096];
+	int offs = 0, size;
+
+	while (offs < count) {
+		size = min(sizeof(buf), count - offs);
+		if (memcpy_real(buf, src + offs, size))
+			return -EFAULT;
+		if (copy_to_user(dest + offs, buf, size))
+			return -EFAULT;
+		offs += size;
+	}
+	return 0;
+}
+
+/*
+ * Send a signal to a physical cpu number
+ */
+static sigp_ccode sigp(u16 cpu_addr, sigp_order_code order_code)
+{
+	register unsigned long reg1 asm ("1") = 0;
+	sigp_ccode ccode;
+
+	asm volatile(
+		"	sigp	%1,%2,0(%3)\n"
+		"	ipm	%0\n"
+		"	srl	%0,28\n"
+		: "=d" (ccode)
+		: "d" (reg1), "a" (cpu_addr), "a" (order_code)
+		: "cc" , "memory");
+	return ccode;
+}
+
+/*
+ * Count CPUs
+ */
+static int count_and_map_cpus(void)
+{
+	int cpu_count, rc, cpu;
+	u16 boot_cpu;
+
+	boot_cpu = __cpu_logical_map[0]; /* physical number of cpu */
+	sys_info.cpu_map[0] = boot_cpu;
+	cpu_count = 1;
+	TRACE("boot cpu : %x\n", boot_cpu);
+	for (cpu = 0; cpu <= 65535; cpu++) {
+		if (cpu == boot_cpu)
+			continue;
+		rc = sigp(cpu, sigp_sense);
+		if (rc == sigp_not_operational)
+			continue;
+		else {
+			TRACE("detected cpu: %i (%x)\n", cpu, rc);
+			sys_info.cpu_map[cpu_count] = cpu;
+			cpu_count++;
+		}
+	}
+	return cpu_count;
+}
+
+/*
+ * Print 31 bit CPU info (Registers/PSWs) for tracing
+ */
+static void print_cpu_info_s390(union cpu_info *cpu_info)
+{
+	int i;
+
+	TRACE("psw   : %08x %08x\n",
+		*((int*) cpu_info->s390.psw),
+		*((int*) &(cpu_info->s390.psw[4])));
+	TRACE("prefix: %08x\n",cpu_info->s390.pref_reg);
+	TRACE("clk   : %016Lx\n", (long long) cpu_info->s390.timer);
+	TRACE("clkcmp: %016Lx\n", (long long) cpu_info->s390.clk_cmp);
+	TRACE("gpregs:\n");
+	for (i = 0; i < 16; i += 4) {
+		TRACE("%08x %08x %08x %08x\n",
+			cpu_info->s390.gp_regs[i],
+			cpu_info->s390.gp_regs[i+1],
+			cpu_info->s390.gp_regs[i+2],
+			cpu_info->s390.gp_regs[i+3]);
+	}
+	TRACE("accregs:\n");
+	for (i = 0; i < 16; i += 4) {
+		TRACE("%08x %08x %08x %08x\n",
+			cpu_info->s390.acc_regs[i],
+			cpu_info->s390.acc_regs[i+1],
+			cpu_info->s390.acc_regs[i+2],
+			cpu_info->s390.acc_regs[i+3]);
+	}
+	TRACE("ctrl_regs:\n");
+	for (i = 0; i < 16; i += 4) {
+		TRACE("%08x %08x %08x %08x\n",
+			cpu_info->s390.ctrl_regs[i],
+			cpu_info->s390.ctrl_regs[i+1],
+			cpu_info->s390.ctrl_regs[i+2],
+			cpu_info->s390.ctrl_regs[i+3]);
+	}
+	TRACE("fp_regs:\n");
+	for (i = 0; i < 4; i += 2) {
+		TRACE("%016Lx %016Lx\n",
+			(long long) cpu_info->s390.fp_regs[i],
+			(long long) cpu_info->s390.fp_regs[i+1]);
+	}
+}
+
+/*
+ * Print 64 bit CPU info (Registers/PSWs) for tracing
+ */
+static void print_cpu_info_s390x(union cpu_info *cpu_info)
+{
+	int i;
+
+	TRACE("psw: %016lx %016lx\n",
+		*((unsigned long*) cpu_info->s390x.psw),
+		*((unsigned long*) &(cpu_info->s390x.psw[8])));
+	TRACE("prefix: %08x\n", cpu_info->s390x.pref_reg);
+	TRACE("clk   : %016Lx\n", (long long) cpu_info->s390x.timer);
+	TRACE("clkcmp: %016Lx\n", (long long) cpu_info->s390x.clk_cmp);
+	TRACE("fpctrl: %04x\n",cpu_info->s390x.fp_ctrl_reg);
+	TRACE("todreg: %04x\n",cpu_info->s390x.tod_reg);
+	TRACE("gpregs:\n");
+	for (i = 0; i < 16; i += 2) {
+		TRACE("%016Lx %016Lx\n",
+			(long long) cpu_info->s390x.gp_regs[i],
+			(long long) cpu_info->s390x.gp_regs[i+1]);
+	}
+	TRACE("accregs:\n");
+	for (i = 0; i < 16; i += 4) {
+		TRACE("%08x %08x %08x %08x\n",
+			cpu_info->s390x.acc_regs[i],
+			cpu_info->s390x.acc_regs[i+1],
+			cpu_info->s390x.acc_regs[i+2],
+			cpu_info->s390x.acc_regs[i+3]);
+	}
+	TRACE("ctrl_regs:\n");
+	for (i = 0; i < 16; i+=2) {
+		TRACE("%016Lx %016Lx\n",
+			(long long) cpu_info->s390x.ctrl_regs[i],
+			(long long) cpu_info->s390x.ctrl_regs[i+1]);
+	}
+	TRACE("fp_regs:\n");
+	for (i = 0; i < 16; i+=2) {
+		TRACE("%016Lx %016Lx\n",
+			(long long) cpu_info->s390x.fp_regs[i],
+			(long long) cpu_info->s390x.fp_regs[i+1]);
+	}
+}
+
+/*
+ * Print global data
+ */
+static void print_glob_info(void)
+{
+	TRACE("Architecture  : %i\n", sys_info.arch);
+	TRACE("Number of cpus: %i\n", sys_info.cpu_count);
+	TRACE("Memory size   : %li\n", sys_info.mem_size);
+}
+
+#ifdef __s390x__
+/*
+ * Convert s390x (64 bit) cpu info to s390 (32 bit) cpu info
+ */
+static void s390x_to_s390_regs(union cpu_info *out, union cpu_info *in, int cpu)
+{
+	int i;
+
+	for (i = 0; i < 16; i++) {
+		out->s390.gp_regs[i] = in->s390x.gp_regs[i] & 0x00000000ffffffff;
+		out->s390.acc_regs[i] = in->s390x.acc_regs[i];
+		out->s390.ctrl_regs[i] =
+			in->s390x.ctrl_regs[i] & 0x00000000ffffffff;
+	}
+	/* locore for 31 bit has only space for fpregs 0,2,4,6 */
+	out->s390.fp_regs[0] = in->s390x.fp_regs[0];
+	out->s390.fp_regs[1] = in->s390x.fp_regs[2];
+	out->s390.fp_regs[2] = in->s390x.fp_regs[4];
+	out->s390.fp_regs[3] = in->s390x.fp_regs[6];
+	memcpy(&(out->s390.psw[0]), &(in->s390x.psw[0]), 4);
+	out->s390.psw[1] |= 0x8; /* set bit 12 */
+	memcpy(&(out->s390.psw[4]),&(in->s390x.psw[12]), 4);
+	out->s390.psw[4] |= 0x80; /* set (31bit) addressing bit */
+	out->s390.pref_reg = dump_prefix_array[cpu-1];
+	out->s390.timer = in->s390x.timer;
+	out->s390.clk_cmp = in->s390x.clk_cmp;
+}
+
+#endif
+
+/*
+ * stop a cpu and store status of the cpu
+ */
+static void stop_and_store_status(int cpu)
+{
+	int ccode;
+
+	do {
+		ccode = sigp(sys_info.cpu_map[cpu], sigp_stop_and_store_status);
+	} while (ccode == sigp_busy);
+}
+
+/*
+ * Collect and return cpu info (registers/PSWs) for all existing CPUs
+ */
+static union cpu_info *get_cpu_info(int *count, enum arch_id arch)
+{
+	union cpu_info *info;
+	int i, cpu_count, sa_size;
+	unsigned long sa_base;
+
+	sa_base = sys_info.sa_base;
+	sa_size = sys_info.sa_size;
+
+	cpu_count = count_and_map_cpus();
+
+	info = kmalloc(cpu_count * sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		ERROR_MSG("kmalloc failed: %s: %i\n",__FUNCTION__, __LINE__);
+		return NULL;
+	}
+
+	/* get first lowcore from hsa */
+
+	if (memcpy_hsa_kernel(info, sa_base, sa_size) < 0) {
+		ERROR_MSG("could not copy from HSA\n");
+		goto fail;
+	}
+	if (arch == ARCH_S390)
+		print_cpu_info_s390(&(info[0]));
+	else
+		print_cpu_info_s390x(&(info[0]));
+
+	/* now get the other lowcores with sigp store status */
+
+	for (i = 1; i < cpu_count; i++) {
+		TRACE("get cpu info for cpu: %i\n", i);
+		stop_and_store_status(i);
+		switch (arch) {
+#ifdef __s390x__
+		union cpu_info tmp_info;
+		case ARCH_S390:
+			memcpy_real(&tmp_info, SA_BASE_S390X,
+					sizeof(tmp_info.s390x));
+			s390x_to_s390_regs(&info[i], &tmp_info, i);
+#else
+		case ARCH_S390:
+			memcpy_real(&info[i], sa_base, sa_size);
+#endif
+			print_cpu_info_s390(&(info[i]));
+			break;
+		case ARCH_S390X:
+			memcpy_real(&info[i], sa_base, sa_size);
+			print_cpu_info_s390x(&(info[i]));
+			break;
+		default:
+			ERROR_MSG("dump: unknown arch %x\n", sys_info.arch);
+			goto fail;
+		}
+	}
+	*count = cpu_count;
+	return info;
+fail:
+	kfree(info);
+	return NULL;
+}
+
+void setup_dump(void)
+{
+	static char str[100];
+
+	printk("System Dumper (%s) starting...\n", UTS_MACHINE);
+	sprintf(str,
+		" root=/dev/ram0 rw mem=%iM maxcpus=1 cio_ignore=all,!0.0.%04x",
+		HSA_SIZE>>20, IPL_PARMBLOCK_START->ipl_info.fcp.devno);
+	strcat(COMMAND_LINE, str);
+	console_loglevel = DUMP_LOG_LEVEL;
+}
+
+/*
+ * zcore character device driver
+ */
+
+static DEFINE_MUTEX(zcore_mutex);
+
+#define DUMP_VERSION	0x3
+#define DUMP_MAGIC	0xa8190173618f23fdULL
+#define DUMP_ARCH_S390X	2
+#define DUMP_ARCH_S390	1
+#define HEADER_SIZE	4096
+
+/* dump header dumped according to s390 crash dump format */
+
+struct zcore_header {
+	u64 magic;
+	u32 version;
+	u32 header_size;
+	u32 dump_level;
+	u32 page_size;
+	u64 mem_size;
+	u64 mem_start;
+	u64 mem_end;
+	u32 num_pages;
+	u32 pad1;
+	u64 tod;
+	cpuid_t cpu_id;
+	u32 arch_id;
+	u32 build_arch;
+	char pad2[4016];
+} __attribute__((packed,__aligned__(16)));
+
+static struct zcore_header zcore_header = {
+	.magic		= DUMP_MAGIC,
+	.version	= DUMP_VERSION,
+	.header_size	= 4096,
+	.dump_level	= 0,
+	.page_size	= PAGE_SIZE,
+	.mem_start	= 0,
+#ifdef __s390x__
+	.build_arch	= DUMP_ARCH_S390X,
+#else
+	.build_arch	= DUMP_ARCH_S390,
+#endif
+};
+
+/*
+ * Copy lowcore info to buffer. Use map in order to copy only register parts.
+ *
+ * @buf:    User buffer
+ * @sa:     Pointer to save area
+ * @sa_off: Offset in save area to copy
+ * @len:    Number of bytes to copy
+ */
+static int copy_lc(void __user *buf, void *sa, int sa_off, int len)
+{
+	int i;
+	char *lc_mask = (char*)&sys_info.lc_mask;
+
+	for (i = 0; i < len; i++) {
+		if (!lc_mask[i + sa_off])
+			continue;
+		if (copy_to_user(buf + i, sa + sa_off + i, 1))
+			return -EFAULT;
+	}
+	return 0;
+}
+
+/*
+ * Copy lowcores info to memory, if necessary
+ *
+ * @buf:   User buffer
+ * @addr:  Start address of buffer in dump memory
+ * @count: Size of buffer
+ */
+static int zcore_add_lc(char __user *buf, unsigned long start, size_t count)
+{
+	unsigned long end;
+	int i;
+
+	if (count == 0)
+		return 0;
+
+	end = start + count;
+	for (i = 0; i < sys_info.cpu_count; i++) {
+		unsigned long cp_start, cp_end; /* copy range */
+		unsigned long sa_start, sa_end; /* save area range */
+		unsigned long prefix;
+		unsigned long sa_off, len, buf_off;
+
+		if (sys_info.arch == ARCH_S390)
+			prefix = sys_info.cpu_info[i].s390.pref_reg;
+		else
+			prefix = sys_info.cpu_info[i].s390x.pref_reg;
+
+		sa_start = prefix + sys_info.sa_base;
+		sa_end = prefix + sys_info.sa_base + sys_info.sa_size;
+
+		if (end < sa_start)
+			continue;
+		if (start > sa_end)
+			continue;
+		cp_start = max(start, sa_start);
+		cp_end = min(end, sa_end);
+
+		buf_off = cp_start - start;
+		sa_off = cp_start - sa_start;
+		len = cp_end - cp_start;
+
+		TRACE("copy_lc for: %lx\n", start);
+		if (copy_lc(buf + buf_off, &sys_info.cpu_info[i], sa_off, len))
+			return -EFAULT;
+	}
+	return 0;
+}
+
+/*
+ * Read routine for zcore character device
+ * First 4K are dump header
+ * Next 32MB are HSA Memory
+ * Rest is read from absolute Memory
+ */
+static ssize_t zcore_read(struct file *file, char __user *buf, size_t count,
+			  loff_t *ppos)
+{
+	unsigned long mem_start; /* Start address in memory */
+	size_t mem_offs;          /* Offset in dump memory */
+	size_t hdr_count;         /* Size of header part of output buffer */
+	size_t size;
+	int rc;
+
+	mutex_lock(&zcore_mutex);
+
+	if (*ppos > (sys_info.mem_size + HEADER_SIZE)) {
+		rc = -EINVAL;
+		goto fail;
+	}
+
+	count = min(count, (size_t) (sys_info.mem_size + HEADER_SIZE - *ppos));
+
+	/* Copy dump header */
+	if (*ppos < HEADER_SIZE) {
+		size = min(count, (size_t) (HEADER_SIZE - *ppos));
+		if (copy_to_user(buf, &zcore_header + *ppos, size)) {
+			rc = -EFAULT;
+			goto fail;
+		}
+		hdr_count = size;
+		mem_start = 0;
+	} else {
+		hdr_count = 0;
+		mem_start = *ppos - HEADER_SIZE;
+	}
+
+	mem_offs = 0;
+
+	/* Copy from HSA data */
+	if (*ppos < (HSA_SIZE + HEADER_SIZE)) {
+		size = min((count - hdr_count), (size_t) (HSA_SIZE - mem_start));
+		rc = memcpy_hsa_user(buf + hdr_count, mem_start, size);
+		if (rc)
+			goto fail;
+
+		mem_offs += size;
+	}
+
+	/* Copy from real mem */
+	size = count - mem_offs - hdr_count;
+	rc = memcpy_real_user(buf + hdr_count + mem_offs, mem_start + mem_offs,
+			      size);
+	if (rc)
+		goto fail;
+
+	/*
+	 * Since s390 dump analysis tools like lcrash or crash
+	 * expect register sets in the prefix pages of the cpus,
+	 * we copy them into the read buffer, if necessary.
+	 * buf + hdr_count: Start of memory part of output buffer
+	 * mem_start: Start memory address to copy from
+	 * count - hdr_count: Size of memory area to copy
+	 */
+	if (zcore_add_lc(buf + hdr_count, mem_start, count - hdr_count)) {
+		rc = -EFAULT;
+		goto fail;
+	}
+	*ppos += count;
+fail:
+	mutex_unlock(&zcore_mutex);
+	return (rc < 0) ? rc : count;
+}
+
+static int zcore_open(struct inode *inode, struct file *filp)
+{
+	if (!hsa_available)
+		return -ENOSPC;
+	else
+		return capable(CAP_SYS_RAWIO) ? 0 : -EPERM;
+}
+
+static int zcore_release(struct inode *inode, struct file *filep)
+{
+	diag308(DIAG308_REL_HSA, NULL);
+	hsa_available = 0;
+	return 0;
+}
+
+static loff_t zcore_lseek(struct file *file, loff_t offset, int orig)
+{
+	loff_t rc;
+
+	mutex_lock(&zcore_mutex);
+	switch (orig) {
+	case 0:
+		file->f_pos = offset;
+		rc = file->f_pos;
+		break;
+	case 1:
+		file->f_pos += offset;
+		rc = file->f_pos;
+		break;
+	default:
+		rc = -EINVAL;
+	}
+	mutex_unlock(&zcore_mutex);
+	return rc;
+}
+
+static struct file_operations zcore_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= zcore_lseek,
+	.read		= zcore_read,
+	.open		= zcore_open,
+	.release	= zcore_release,
+};
+
+static struct miscdevice zcore_dev = {
+	.name	= "zcore",
+	.minor	= MISC_DYNAMIC_MINOR,
+	.fops	= &zcore_fops,
+};
+
+/*
+ * Init character device
+ */
+static int __init zcore_init(void)
+{
+	int rc;
+
+	if (sys_info.arch == ARCH_S390X)
+		zcore_header.arch_id = DUMP_ARCH_S390X;
+	else
+		zcore_header.arch_id = DUMP_ARCH_S390;
+	zcore_header.mem_size = sys_info.mem_size;
+	zcore_header.mem_end = sys_info.mem_size;
+	zcore_header.num_pages = sys_info.mem_size / PAGE_SIZE;
+	zcore_header.tod = get_clock();
+	get_cpu_id(&zcore_header.cpu_id);
+	rc = misc_register(&zcore_dev);
+	if (rc)
+		ERROR_MSG("Unable to register zcore device\n");
+	return rc;
+}
+
+static void __init set_s390_lc_mask(union cpu_info *map)
+{
+	memset(&map->s390.ext_save, 0xff, sizeof(map->s390.ext_save));
+	memset(&map->s390.timer, 0xff, sizeof(map->s390.timer));
+	memset(&map->s390.clk_cmp, 0xff, sizeof(map->s390.clk_cmp));
+	memset(&map->s390.psw, 0xff, sizeof(map->s390.psw));
+	memset(&map->s390.pref_reg, 0xff, sizeof(map->s390.pref_reg));
+	memset(&map->s390.acc_regs, 0xff, sizeof(map->s390.acc_regs));
+	memset(&map->s390.fp_regs, 0xff, sizeof(map->s390.fp_regs));
+	memset(&map->s390.gp_regs, 0xff, sizeof(map->s390.gp_regs));
+	memset(&map->s390.ctrl_regs, 0xff, sizeof(map->s390.ctrl_regs));
+}
+
+static void __init set_s390x_lc_mask(union cpu_info *map)
+{
+	memset(&map->s390x.fp_regs, 0xff, sizeof(map->s390x.fp_regs));
+	memset(&map->s390x.gp_regs, 0xff, sizeof(map->s390x.gp_regs));
+	memset(&map->s390x.psw, 0xff, sizeof(map->s390x.psw));
+	memset(&map->s390x.pref_reg, 0xff, sizeof(map->s390x.pref_reg));
+	memset(&map->s390x.fp_ctrl_reg, 0xff, sizeof(map->s390x.fp_ctrl_reg));
+	memset(&map->s390x.tod_reg, 0xff, sizeof(map->s390x.tod_reg));
+	memset(&map->s390x.timer, 0xff, sizeof(map->s390x.timer));
+	memset(&map->s390x.clk_cmp, 0xff, sizeof(map->s390x.clk_cmp));
+	memset(&map->s390x.acc_regs, 0xff, sizeof(map->s390x.acc_regs));
+	memset(&map->s390x.ctrl_regs, 0xff, sizeof(map->s390x.ctrl_regs));
+}
+
+/*
+ * Initialize dump globals for a given architecture
+ */
+
+static int __init sys_info_init(enum arch_id arch)
+{
+	switch (arch) {
+	case ARCH_S390X:
+		MSG("DETECTED 'S390X (64 bit) OS'\n");
+		sys_info.sa_base = SA_BASE_S390X;
+		sys_info.sa_size = sizeof(sys_info.cpu_info[0].s390x);
+		set_s390x_lc_mask(&sys_info.lc_mask);
+		break;
+	case ARCH_S390:
+		MSG("DETECTED 'S390 (32 bit) OS'\n");
+		sys_info.sa_base = SA_BASE_S390;
+		sys_info.sa_size = sizeof(sys_info.cpu_info[0].s390);
+		set_s390_lc_mask(&sys_info.lc_mask);
+		break;
+	default:
+		ERROR_MSG("unknown architecture 0x%x.\n",arch);
+		return -EINVAL;
+	}
+	sys_info.arch = arch;
+	sys_info.cpu_info = get_cpu_info(&sys_info.cpu_count, arch);
+	if (!sys_info.cpu_info) {
+		ERROR_MSG("get cpu info failed\n");
+		kfree(sys_info.cpu_info);
+		return -ENOMEM;
+	}
+	sys_info.mem_size = real_memory_size;
+	print_glob_info();
+
+	return 0;
+}
+
+static int __init check_sdias(void)
+{
+	int rc, act_hsa_size;
+
+	rc = sclp_sdias_blk_count();
+	if (rc < 0) {
+		ERROR_MSG("Could not determine HSA size\n");
+		return rc;
+	}
+	act_hsa_size = (rc - 1) * PAGE_SIZE;
+	if (act_hsa_size < HSA_SIZE) {
+		ERROR_MSG("HSA size too small: %i\n", act_hsa_size);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int __init dump_init(void)
+{
+	unsigned char arch;
+	int rc;
+
+	zcore_dbf = debug_register("dump", 4, 1, 4 * sizeof(long));
+	debug_register_view(zcore_dbf, &debug_sprintf_view);
+	debug_set_level(zcore_dbf, 6);
+
+	TRACE("devno:  %x\n", FCP_DATA->devno);
+	TRACE("wwpn:   %llx\n", (unsigned long long) FCP_DATA->wwpn);
+	TRACE("lun:    %llx\n", (unsigned long long) FCP_DATA->lun);
+	TRACE("prefix: %p\n", lowcore_ptr[0]);
+
+	rc = check_sdias();
+	if (rc) {
+		ERROR_MSG("Dump initialization failed\n");
+		goto failed;
+	}
+
+	rc = memcpy_hsa_kernel(&arch, __LC_AR_MODE_ID, 1);
+	if (rc) {
+		ERROR_MSG("sdial memcpy for arch id failed\n");
+		goto failed;
+	}
+
+#ifndef __s390x__
+	if (arch == ARCH_S390X) {
+		ERROR_MSG("32 bit dumper can't dump 64 bit system!\n");
+		rc = -EINVAL;
+		goto failed;
+	}
+#endif
+
+	/* set lowcore page to absolute 0 */
+	*(lowcore_ptr[0]) = S390_lowcore;
+	set_prefix(0);
+	lowcore_ptr[0] = NULL;
+
+	rc = sys_info_init(arch);
+	if (rc) {
+		ERROR_MSG("arch init failed\n");
+		goto failed;
+	}
+
+	rc = zcore_init();
+	if (rc) {
+		ERROR_MSG("zcore init failed\n");
+		goto failed;
+	}
+	hsa_available = 1;
+	return 0;
+
+failed:
+	diag308(DIAG308_REL_HSA, NULL);
+	return rc;
+}
+
+late_initcall(dump_init);
Index: git-linux-2.6/drivers/s390/cio/cio.c
===================================================================
--- git-linux-2.6.orig/drivers/s390/cio/cio.c	2007-02-21 10:22:40.000000000 +0100
+++ git-linux-2.6/drivers/s390/cio/cio.c	2007-02-21 10:54:51.000000000 +0100
@@ -21,6 +21,7 @@
 #include <asm/irq_regs.h>
 #include <asm/setup.h>
 #include <asm/reset.h>
+#include <asm/ipl.h>
 #include "airq.h"
 #include "cio.h"
 #include "css.h"
Index: git-linux-2.6/include/asm-s390/ipl.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ git-linux-2.6/include/asm-s390/ipl.h	2007-02-21 11:00:15.000000000 +0100
@@ -0,0 +1,116 @@
+/*
+ * s390 (re)ipl support
+ *
+ * Copyright IBM Corp. 2007
+ */
+
+#ifndef _ASM_S390_IPL_H
+#define _ASM_S390_IPL_H
+
+#include <asm/types.h>
+
+#define IPL_PARMBLOCK_ORIGIN	0x2000
+
+#define IPL_PARM_BLK_FCP_LEN (sizeof(struct ipl_list_hdr) + \
+			      sizeof(struct ipl_block_fcp))
+
+#define IPL_PARM_BLK_CCW_LEN (sizeof(struct ipl_list_hdr) + \
+			      sizeof(struct ipl_block_ccw))
+
+#define IPL_MAX_SUPPORTED_VERSION (0)
+
+#define IPL_PARMBLOCK_START	((struct ipl_parameter_block *) \
+				 IPL_PARMBLOCK_ORIGIN)
+#define IPL_PARMBLOCK_SIZE	(IPL_PARMBLOCK_START->hdr.len)
+
+struct ipl_list_hdr {
+	u32 len;
+	u8  reserved1[3];
+	u8  version;
+	u32 blk0_len;
+	u8  pbt;
+	u8  flags;
+	u16 reserved2;
+} __attribute__((packed));
+
+struct ipl_block_fcp {
+	u8  reserved1[313-1];
+	u8  opt;
+	u8  reserved2[3];
+	u16 reserved3;
+	u16 devno;
+	u8  reserved4[4];
+	u64 wwpn;
+	u64 lun;
+	u32 bootprog;
+	u8  reserved5[12];
+	u64 br_lba;
+	u32 scp_data_len;
+	u8  reserved6[260];
+	u8  scp_data[];
+} __attribute__((packed));
+
+struct ipl_block_ccw {
+	u8  load_param[8];
+	u8  reserved1[84];
+	u8  reserved2[2];
+	u16 devno;
+	u8  vm_flags;
+	u8  reserved3[3];
+	u32 vm_parm_len;
+} __attribute__((packed));
+
+struct ipl_parameter_block {
+	struct ipl_list_hdr hdr;
+	union {
+		struct ipl_block_fcp fcp;
+		struct ipl_block_ccw ccw;
+	} ipl_info;
+} __attribute__((packed));
+
+/*
+ * IPL validity flags and parameters as detected in head.S
+ */
+extern u32 ipl_flags;
+extern u16 ipl_devno;
+
+extern unsigned int dump_prefix_array[];
+
+extern void do_reipl(void);
+extern void ipl_save_parameters(void);
+extern void setup_dump(void);
+
+enum {
+	IPL_DEVNO_VALID		= 1,
+	IPL_PARMBLOCK_VALID	= 2,
+	IPL_NSS_VALID		= 4,
+};
+
+/*
+ * DIAG 308 support
+ */
+enum diag308_subcode  {
+	DIAG308_REL_HSA	= 2,
+	DIAG308_IPL	= 3,
+	DIAG308_DUMP	= 4,
+	DIAG308_SET	= 5,
+	DIAG308_STORE	= 6,
+};
+
+enum diag308_ipl_type {
+	DIAG308_IPL_TYPE_FCP	= 0,
+	DIAG308_IPL_TYPE_CCW	= 2,
+};
+
+enum diag308_opt {
+	DIAG308_IPL_OPT_IPL	= 0x10,
+	DIAG308_IPL_OPT_DUMP	= 0x20,
+};
+
+enum diag308_rc {
+	DIAG308_RC_OK	= 1,
+};
+
+extern int diag308(unsigned long subcode, void *addr);
+
+#endif /* _ASM_S390_IPL_H */
Index: git-linux-2.6/include/asm-s390/processor.h
===================================================================
--- git-linux-2.6.orig/include/asm-s390/processor.h	2007-02-21 10:23:12.000000000 +0100
+++ git-linux-2.6/include/asm-s390/processor.h	2007-02-21 10:56:03.000000000 +0100
@@ -36,6 +36,11 @@ typedef struct
         unsigned int unused  : 16;
 } __attribute__ ((packed)) cpuid_t;
 
+static inline void get_cpu_id(cpuid_t *ptr)
+{
+	asm volatile("stidp 0(%1)" : "=m" (*ptr) : "a" (ptr));
+}
+
 struct cpuinfo_S390
 {
         cpuid_t  cpu_id;
Index: git-linux-2.6/include/asm-s390/sclp.h
===================================================================
--- git-linux-2.6.orig/include/asm-s390/sclp.h	2007-02-21 10:23:12.000000000 +0100
+++ git-linux-2.6/include/asm-s390/sclp.h	2007-02-21 11:00:15.000000000 +0100
@@ -35,5 +35,7 @@ struct sclp_readinfo_sccb {
 
 extern struct sclp_readinfo_sccb s390_readinfo_sccb;
 extern void sclp_readinfo_early(void);
+extern int sclp_sdias_blk_count(void);
+extern int sclp_sdias_copy(void *dest, int blk_num, int nr_blks);
 
 #endif /* _ASM_S390_SCLP_H */
Index: git-linux-2.6/include/asm-s390/setup.h
===================================================================
--- git-linux-2.6.orig/include/asm-s390/setup.h	2007-02-21 10:23:12.000000000 +0100
+++ git-linux-2.6/include/asm-s390/setup.h	2007-02-21 11:00:15.000000000 +0100
@@ -16,7 +16,6 @@
 
 #define PARMAREA		0x10400
 #define MEMORY_CHUNKS		16	/* max 0x7fff */
-#define IPL_PARMBLOCK_ORIGIN	0x2000
 
 #ifndef __ASSEMBLY__
 
@@ -41,6 +40,7 @@ struct mem_chunk {
 };
 
 extern struct mem_chunk memory_chunk[];
+extern unsigned long real_memory_size;
 
 #ifdef CONFIG_S390_SWITCH_AMODE
 extern unsigned int switch_amode;
@@ -97,82 +97,9 @@ extern char vmpoff_cmd[];
 #define SET_CONSOLE_3215	do { console_mode = 2; } while (0)
 #define SET_CONSOLE_3270	do { console_mode = 3; } while (0)
 
-struct ipl_list_hdr {
-	u32 len;
-	u8  reserved1[3];
-	u8  version;
-	u32 blk0_len;
-	u8  pbt;
-	u8  flags;
-	u16 reserved2;
-} __attribute__((packed));
-
-struct ipl_block_fcp {
-	u8  reserved1[313-1];
-	u8  opt;
-	u8  reserved2[3];
-	u16 reserved3;
-	u16 devno;
-	u8  reserved4[4];
-	u64 wwpn;
-	u64 lun;
-	u32 bootprog;
-	u8  reserved5[12];
-	u64 br_lba;
-	u32 scp_data_len;
-	u8  reserved6[260];
-	u8  scp_data[];
-} __attribute__((packed));
-
-struct ipl_block_ccw {
-	u8  load_param[8];
-	u8  reserved1[84];
-	u8  reserved2[2];
-	u16 devno;
-	u8  vm_flags;
-	u8  reserved3[3];
-	u32 vm_parm_len;
-} __attribute__((packed));
-
-struct ipl_parameter_block {
-	struct ipl_list_hdr hdr;
-	union {
-		struct ipl_block_fcp fcp;
-		struct ipl_block_ccw ccw;
-	} ipl_info;
-} __attribute__((packed));
-
-#define IPL_PARM_BLK_FCP_LEN (sizeof(struct ipl_list_hdr) + \
-			      sizeof(struct ipl_block_fcp))
-
-#define IPL_PARM_BLK_CCW_LEN (sizeof(struct ipl_list_hdr) + \
-			      sizeof(struct ipl_block_ccw))
-
-#define IPL_MAX_SUPPORTED_VERSION (0)
-
-/*
- * IPL validity flags and parameters as detected in head.S
- */
-extern u32 ipl_flags;
-extern u16 ipl_devno;
-
-extern void do_reipl(void);
-extern void ipl_save_parameters(void);
-
-enum {
-	IPL_DEVNO_VALID	= 1,
-	IPL_PARMBLOCK_VALID = 2,
-	IPL_NSS_VALID = 4,
-};
-
 #define NSS_NAME_SIZE	8
-
 extern char kernel_nss_name[];
 
-#define IPL_PARMBLOCK_START	((struct ipl_parameter_block *) \
-				 IPL_PARMBLOCK_ORIGIN)
-#define IPL_PARMBLOCK_SIZE	(IPL_PARMBLOCK_START->hdr.len)
-
 #else /* __ASSEMBLY__ */
 
 #ifndef __s390x__
