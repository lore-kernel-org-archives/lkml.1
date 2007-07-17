Return-Path: <linux-kernel-owner+w=401wt.eu-S932241AbXGQMXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241AbXGQMXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 08:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758560AbXGQMVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 08:21:37 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:57766 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764979AbXGQMVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 08:21:31 -0400
Subject: Please pull git390 'for-linus' branch
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain
Organization: IBM Corporation
Date: Tue, 17 Jul 2007 14:24:06 +0200
Message-Id: <1184675046.21357.47.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'for-linus' branch of

	git://git390.osdl.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

 arch/s390/defconfig           |  110 ++----
 arch/s390/kernel/dis.c        |    7 +-
 arch/s390/kernel/stacktrace.c |   26 +-
 drivers/s390/char/Kconfig     |    6 +
 drivers/s390/char/Makefile    |    1 +
 drivers/s390/char/vmcp.c      |   89 +++--
 drivers/s390/char/vmcp.h      |    4 +-
 drivers/s390/char/vmur.c      |  906 +++++++++++++++++++++++++++++++++++++++++
 drivers/s390/char/vmur.h      |  104 +++++
 drivers/s390/cio/device.c     |    2 +-
 drivers/s390/cio/qdio.c       |   16 +-
 11 files changed, 1126 insertions(+), 145 deletions(-)
 create mode 100644 drivers/s390/char/vmur.c
 create mode 100644 drivers/s390/char/vmur.h

Christian Borntraeger (2):
      [S390] Fix disassembly of RX_URRD, SI_URD & PC-relative instructions.
      [S390] vmcp cleanup

Cornelia Huck (1):
      [S390] cio: Dont print trailing \0 in modalias_show().

Frank Munzert (1):
      [S390] z/VM unit record device driver

Frank Pavlic (1):
      [S390] qdio: output queue stall on FCP and network devices

Heiko Carstens (1):
      [S390] Simplify stack trace.

Jan Glauber (1):
      [S390] Fix broken logic, SIGA flags must be bitwise ORed

Martin Schwidefsky (1):
      [S390] Update default configuration.

diff --git a/arch/s390/defconfig b/arch/s390/defconfig
index 485b60c..2aae23d 100644
--- a/arch/s390/defconfig
+++ b/arch/s390/defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.21
-# Thu May 10 15:18:19 2007
+# Linux kernel version: 2.6.22
+# Tue Jul 17 12:50:23 2007
 #
 CONFIG_MMU=y
 CONFIG_ZONE_DMA=y
@@ -32,12 +32,11 @@ CONFIG_LOCALVERSION=""
 CONFIG_LOCALVERSION_AUTO=y
 CONFIG_SWAP=y
 CONFIG_SYSVIPC=y
-# CONFIG_IPC_NS is not set
 CONFIG_SYSVIPC_SYSCTL=y
 CONFIG_POSIX_MQUEUE=y
 # CONFIG_BSD_PROCESS_ACCT is not set
 # CONFIG_TASKSTATS is not set
-# CONFIG_UTS_NS is not set
+# CONFIG_USER_NS is not set
 CONFIG_AUDIT=y
 # CONFIG_AUDITSYSCALL is not set
 CONFIG_IKCONFIG=y
@@ -61,20 +60,19 @@ CONFIG_BUG=y
 CONFIG_ELF_CORE=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
+CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
+CONFIG_SIGNALFD=y
+CONFIG_TIMERFD=y
+CONFIG_EVENTFD=y
 CONFIG_SHMEM=y
 CONFIG_VM_EVENT_COUNTERS=y
-CONFIG_SLUB_DEBUG=y
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
 # CONFIG_SLOB is not set
 CONFIG_RT_MUTEXES=y
 # CONFIG_TINY_SHMEM is not set
 CONFIG_BASE_SMALL=0
-
-#
-# Loadable module support
-#
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_MODULE_FORCE_UNLOAD is not set
@@ -82,12 +80,9 @@ CONFIG_MODVERSIONS=y
 # CONFIG_MODULE_SRCVERSION_ALL is not set
 CONFIG_KMOD=y
 CONFIG_STOP_MACHINE=y
-
-#
-# Block layer
-#
 CONFIG_BLOCK=y
 # CONFIG_BLK_DEV_IO_TRACE is not set
+CONFIG_BLK_DEV_BSG=y
 
 #
 # IO Schedulers
@@ -151,6 +146,7 @@ CONFIG_FLAT_NODE_MEM_MAP=y
 CONFIG_SPLIT_PTLOCK_CPUS=4
 CONFIG_RESOURCES_64BIT=y
 CONFIG_ZONE_DMA_FLAG=1
+CONFIG_VIRT_TO_BUS=y
 CONFIG_HOLES_IN_ZONE=y
 
 #
@@ -248,25 +244,13 @@ CONFIG_IPV6_SIT=y
 # CONFIG_IPV6_MULTIPLE_TABLES is not set
 # CONFIG_NETWORK_SECMARK is not set
 # CONFIG_NETFILTER is not set
-
-#
-# DCCP Configuration (EXPERIMENTAL)
-#
 # CONFIG_IP_DCCP is not set
-
-#
-# SCTP Configuration (EXPERIMENTAL)
-#
 CONFIG_IP_SCTP=m
 # CONFIG_SCTP_DBG_MSG is not set
 # CONFIG_SCTP_DBG_OBJCNT is not set
 # CONFIG_SCTP_HMAC_NONE is not set
 # CONFIG_SCTP_HMAC_SHA1 is not set
 CONFIG_SCTP_HMAC_MD5=y
-
-#
-# TIPC Configuration (EXPERIMENTAL)
-#
 # CONFIG_TIPC is not set
 # CONFIG_ATM is not set
 # CONFIG_BRIDGE is not set
@@ -293,6 +277,7 @@ CONFIG_NET_SCH_CBQ=m
 # CONFIG_NET_SCH_HTB is not set
 # CONFIG_NET_SCH_HFSC is not set
 CONFIG_NET_SCH_PRIO=m
+CONFIG_NET_SCH_RR=m
 CONFIG_NET_SCH_RED=m
 CONFIG_NET_SCH_SFQ=m
 CONFIG_NET_SCH_TEQL=m
@@ -317,10 +302,14 @@ CONFIG_CLS_U32_MARK=y
 CONFIG_NET_CLS_RSVP=m
 CONFIG_NET_CLS_RSVP6=m
 # CONFIG_NET_EMATCH is not set
-# CONFIG_NET_CLS_ACT is not set
+CONFIG_NET_CLS_ACT=y
+CONFIG_NET_ACT_POLICE=y
+# CONFIG_NET_ACT_GACT is not set
+# CONFIG_NET_ACT_MIRRED is not set
+# CONFIG_NET_ACT_PEDIT is not set
+# CONFIG_NET_ACT_SIMP is not set
 CONFIG_NET_CLS_POLICE=y
 # CONFIG_NET_CLS_IND is not set
-CONFIG_NET_ESTIMATOR=y
 
 #
 # Network testing
@@ -329,6 +318,7 @@ CONFIG_NET_ESTIMATOR=y
 # CONFIG_NET_TCPPROBE is not set
 # CONFIG_AF_RXRPC is not set
 # CONFIG_RFKILL is not set
+# CONFIG_NET_9P is not set
 # CONFIG_PCMCIA is not set
 CONFIG_CCW=y
 
@@ -345,15 +335,8 @@ CONFIG_PREVENT_FIRMWARE_BUILD=y
 # CONFIG_DEBUG_DRIVER is not set
 # CONFIG_DEBUG_DEVRES is not set
 CONFIG_SYS_HYPERVISOR=y
-
-#
-# Connector - unified userspace <-> kernelspace linker
-#
 # CONFIG_CONNECTOR is not set
-
-#
-# Block devices
-#
+CONFIG_BLK_DEV=y
 # CONFIG_BLK_DEV_COW_COMMON is not set
 CONFIG_BLK_DEV_LOOP=m
 # CONFIG_BLK_DEV_CRYPTOLOOP is not set
@@ -376,17 +359,15 @@ CONFIG_DASD_ECKD=y
 CONFIG_DASD_FBA=y
 CONFIG_DASD_DIAG=y
 CONFIG_DASD_EER=y
-
-#
-# Misc devices
-#
-# CONFIG_BLINK is not set
+CONFIG_MISC_DEVICES=y
+# CONFIG_EEPROM_93CX6 is not set
 
 #
 # SCSI device support
 #
 # CONFIG_RAID_ATTRS is not set
 CONFIG_SCSI=y
+# CONFIG_SCSI_DMA is not set
 # CONFIG_SCSI_TGT is not set
 CONFIG_SCSI_NETLINK=y
 CONFIG_SCSI_PROC_FS=y
@@ -447,40 +428,21 @@ CONFIG_DM_MIRROR=y
 CONFIG_DM_ZERO=y
 CONFIG_DM_MULTIPATH=y
 # CONFIG_DM_MULTIPATH_EMC is not set
+# CONFIG_DM_MULTIPATH_RDAC is not set
 # CONFIG_DM_DELAY is not set
-
-#
-# Network device support
-#
 CONFIG_NETDEVICES=y
+# CONFIG_NETDEVICES_MULTIQUEUE is not set
+# CONFIG_IFB is not set
 CONFIG_DUMMY=m
 CONFIG_BONDING=m
+# CONFIG_MACVLAN is not set
 CONFIG_EQUALIZER=m
 CONFIG_TUN=m
-
-#
-# Ethernet (10 or 100Mbit)
-#
 CONFIG_NET_ETHERNET=y
 # CONFIG_MII is not set
-
-#
-# Ethernet (1000 Mbit)
-#
-
-#
-# Ethernet (10000 Mbit)
-#
-CONFIG_MLX4_DEBUG=y
-
-#
-# Token Ring devices
-#
+CONFIG_NETDEV_1000=y
+CONFIG_NETDEV_10000=y
 # CONFIG_TR is not set
-
-#
-# Wan interfaces
-#
 # CONFIG_WAN is not set
 
 #
@@ -511,10 +473,6 @@ CONFIG_CCWGROUP=y
 CONFIG_UNIX98_PTYS=y
 CONFIG_LEGACY_PTYS=y
 CONFIG_LEGACY_PTY_COUNT=256
-
-#
-# Watchdog Cards
-#
 # CONFIG_WATCHDOG is not set
 CONFIG_HW_RANDOM=m
 # CONFIG_R3964 is not set
@@ -554,6 +512,8 @@ CONFIG_S390_TAPE_34XX=m
 # CONFIG_VMCP is not set
 # CONFIG_MONREADER is not set
 CONFIG_MONWRITER=m
+CONFIG_S390_VMUR=m
+# CONFIG_POWER_SUPPLY is not set
 
 #
 # File systems
@@ -655,7 +615,6 @@ CONFIG_SUNRPC=y
 # CONFIG_NCP_FS is not set
 # CONFIG_CODA_FS is not set
 # CONFIG_AFS_FS is not set
-# CONFIG_9P_FS is not set
 
 #
 # Partition Types
@@ -712,6 +671,7 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 CONFIG_HEADERS_CHECK=y
 CONFIG_DEBUG_KERNEL=y
+# CONFIG_SCHED_DEBUG is not set
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
 # CONFIG_DEBUG_SLAB is not set
@@ -740,10 +700,6 @@ CONFIG_FORCED_INLINING=y
 #
 # CONFIG_KEYS is not set
 # CONFIG_SECURITY is not set
-
-#
-# Cryptographic options
-#
 CONFIG_CRYPTO=y
 CONFIG_CRYPTO_ALGAPI=y
 CONFIG_CRYPTO_BLKCIPHER=y
@@ -782,10 +738,7 @@ CONFIG_CRYPTO_FCRYPT=m
 # CONFIG_CRYPTO_CRC32C is not set
 CONFIG_CRYPTO_CAMELLIA=m
 # CONFIG_CRYPTO_TEST is not set
-
-#
-# Hardware crypto devices
-#
+CONFIG_CRYPTO_HW=y
 # CONFIG_CRYPTO_SHA1_S390 is not set
 # CONFIG_CRYPTO_SHA256_S390 is not set
 # CONFIG_CRYPTO_DES_S390 is not set
@@ -800,6 +753,7 @@ CONFIG_ZCRYPT=m
 CONFIG_BITREVERSE=m
 # CONFIG_CRC_CCITT is not set
 # CONFIG_CRC16 is not set
+# CONFIG_CRC_ITU_T is not set
 CONFIG_CRC32=m
 # CONFIG_LIBCRC32C is not set
 CONFIG_PLIST=y
diff --git a/arch/s390/kernel/dis.c b/arch/s390/kernel/dis.c
index a057ebf..d305731 100644
--- a/arch/s390/kernel/dis.c
+++ b/arch/s390/kernel/dis.c
@@ -240,8 +240,8 @@ static const unsigned char formats[][7] = {
 	[INSTR_RXY_FRRD]  = { 0xff, F_8,D20_20,X_12,B_16,0,0 },/* e.g. ley   */
 	[INSTR_RX_FRRD]	  = { 0xff, F_8,D_20,X_12,B_16,0,0 },  /* e.g. ae    */
 	[INSTR_RX_RRRD]	  = { 0xff, R_8,D_20,X_12,B_16,0,0 },  /* e.g. l     */
-	[INSTR_RX_URRD]	  = { 0x00, U4_8,D_20,X_12,B_16,0,0 }, /* e.g. bc    */
-	[INSTR_SI_URD]	  = { 0x00, D_20,B_16,U8_8,0,0,0 },    /* e.g. cli   */
+	[INSTR_RX_URRD]	  = { 0xff, U4_8,D_20,X_12,B_16,0,0 }, /* e.g. bc    */
+	[INSTR_SI_URD]	  = { 0xff, D_20,B_16,U8_8,0,0,0 },    /* e.g. cli   */
 	[INSTR_SIY_URD]	  = { 0xff, D20_20,B_16,U8_8,0,0,0 },  /* e.g. tmy   */
 	[INSTR_SSE_RDRD]  = { 0xff, D_20,B_16,D_36,B_32,0,0 }, /* e.g. mvsdk */
 	[INSTR_SS_L0RDRD] = { 0xff, D_20,L8_8,B_16,D_36,B_32,0 },
@@ -1190,7 +1190,8 @@ static int print_insn(char *buffer, unsigned char *code, unsigned long addr)
 			else if (operand->flags & OPERAND_CR)
 				ptr += sprintf(ptr, "%%c%i", value);
 			else if (operand->flags & OPERAND_PCREL)
-				ptr += sprintf(ptr, "%lx", value + addr);
+				ptr += sprintf(ptr, "%lx", (signed int) value
+								      + addr);
 			else if (operand->flags & OPERAND_SIGNED)
 				ptr += sprintf(ptr, "%i", value);
 			else
diff --git a/arch/s390/kernel/stacktrace.c b/arch/s390/kernel/stacktrace.c
index 515ff90..da69247 100644
--- a/arch/s390/kernel/stacktrace.c
+++ b/arch/s390/kernel/stacktrace.c
@@ -12,7 +12,6 @@
 #include <linux/kallsyms.h>
 
 static unsigned long save_context_stack(struct stack_trace *trace,
-					unsigned int *skip,
 					unsigned long sp,
 					unsigned long low,
 					unsigned long high)
@@ -28,10 +27,10 @@ static unsigned long save_context_stack(struct stack_trace *trace,
 		sf = (struct stack_frame *)sp;
 		while(1) {
 			addr = sf->gprs[8] & PSW_ADDR_INSN;
-			if (!(*skip))
+			if (!trace->skip)
 				trace->entries[trace->nr_entries++] = addr;
 			else
-				(*skip)--;
+				trace->skip--;
 			if (trace->nr_entries >= trace->max_entries)
 				return sp;
 			low = sp;
@@ -48,10 +47,10 @@ static unsigned long save_context_stack(struct stack_trace *trace,
 			return sp;
 		regs = (struct pt_regs *)sp;
 		addr = regs->psw.addr & PSW_ADDR_INSN;
-		if (!(*skip))
+		if (!trace->skip)
 			trace->entries[trace->nr_entries++] = addr;
 		else
-			(*skip)--;
+			trace->skip--;
 		if (trace->nr_entries >= trace->max_entries)
 			return sp;
 		low = sp;
@@ -65,20 +64,17 @@ void save_stack_trace(struct stack_trace *trace)
 	unsigned long orig_sp, new_sp;
 
 	orig_sp = sp & PSW_ADDR_INSN;
-
-	new_sp = save_context_stack(trace, &trace->skip, orig_sp,
-				S390_lowcore.panic_stack - PAGE_SIZE,
-				S390_lowcore.panic_stack);
+	new_sp = save_context_stack(trace, orig_sp,
+				    S390_lowcore.panic_stack - PAGE_SIZE,
+				    S390_lowcore.panic_stack);
 	if (new_sp != orig_sp)
 		return;
-	new_sp = save_context_stack(trace, &trace->skip, new_sp,
-				S390_lowcore.async_stack - ASYNC_SIZE,
-				S390_lowcore.async_stack);
+	new_sp = save_context_stack(trace, new_sp,
+				    S390_lowcore.async_stack - ASYNC_SIZE,
+				    S390_lowcore.async_stack);
 	if (new_sp != orig_sp)
 		return;
-
-	save_context_stack(trace, &trace->skip, new_sp,
+	save_context_stack(trace, new_sp,
 			   S390_lowcore.thread_info,
 			   S390_lowcore.thread_info + THREAD_SIZE);
-	return;
 }
diff --git a/drivers/s390/char/Kconfig b/drivers/s390/char/Kconfig
index 66102a1..a3d095d 100644
--- a/drivers/s390/char/Kconfig
+++ b/drivers/s390/char/Kconfig
@@ -164,3 +164,9 @@ config MONWRITER
 	help
 	  Character device driver for writing z/VM monitor service records
 
+config S390_VMUR
+	tristate "z/VM unit record device driver"
+	default "m"
+	help
+	  Character device driver for z/VM reader, puncher and printer.
+
diff --git a/drivers/s390/char/Makefile b/drivers/s390/char/Makefile
index c210784..130de19 100644
--- a/drivers/s390/char/Makefile
+++ b/drivers/s390/char/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_S390_TAPE_34XX) += tape_34xx.o
 obj-$(CONFIG_S390_TAPE_3590) += tape_3590.o
 obj-$(CONFIG_MONREADER) += monreader.o
 obj-$(CONFIG_MONWRITER) += monwriter.o
+obj-$(CONFIG_S390_VMUR) += vmur.o
 
 zcore_mod-objs := sclp_sdias.o zcore.o
 obj-$(CONFIG_ZFCPDUMP) += zcore_mod.o
diff --git a/drivers/s390/char/vmcp.c b/drivers/s390/char/vmcp.c
index 82e6a6b..2f419b0 100644
--- a/drivers/s390/char/vmcp.c
+++ b/drivers/s390/char/vmcp.c
@@ -1,7 +1,7 @@
 /*
- * Copyright (C) 2004,2005 IBM Corporation
+ * Copyright IBM Corp. 2004,2007
  * Interface implementation for communication with the z/VM control program
- * Author(s): Christian Borntraeger <cborntra@de.ibm.com>
+ * Author(s): Christian Borntraeger <borntraeger@de.ibm.com>
  *
  *
  * z/VMs CP offers the possibility to issue commands via the diagnose code 8
@@ -22,9 +22,11 @@
 #include "vmcp.h"
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Christian Borntraeger <cborntra@de.ibm.com>");
+MODULE_AUTHOR("Christian Borntraeger <borntraeger@de.ibm.com>");
 MODULE_DESCRIPTION("z/VM CP interface");
 
+#define PRINTK_HEADER "vmcp: "
+
 static debug_info_t *vmcp_debug;
 
 static int vmcp_open(struct inode *inode, struct file *file)
@@ -40,7 +42,7 @@ static int vmcp_open(struct inode *inode, struct file *file)
 	session->bufsize = PAGE_SIZE;
 	session->response = NULL;
 	session->resp_size = 0;
-	init_MUTEX(&session->mutex);
+	mutex_init(&session->mutex);
 	file->private_data = session;
 	return nonseekable_open(inode, file);
 }
@@ -57,37 +59,37 @@ static int vmcp_release(struct inode *inode, struct file *file)
 }
 
 static ssize_t
-vmcp_read(struct file *file, char __user * buff, size_t count, loff_t * ppos)
+vmcp_read(struct file *file, char __user *buff, size_t count, loff_t *ppos)
 {
 	size_t tocopy;
 	struct vmcp_session *session;
 
 	session = (struct vmcp_session *)file->private_data;
-	if (down_interruptible(&session->mutex))
+	if (mutex_lock_interruptible(&session->mutex))
 		return -ERESTARTSYS;
 	if (!session->response) {
-		up(&session->mutex);
+		mutex_unlock(&session->mutex);
 		return 0;
 	}
 	if (*ppos > session->resp_size) {
-		up(&session->mutex);
+		mutex_unlock(&session->mutex);
 		return 0;
 	}
 	tocopy = min(session->resp_size - (size_t) (*ppos), count);
-	tocopy = min(tocopy,session->bufsize - (size_t) (*ppos));
+	tocopy = min(tocopy, session->bufsize - (size_t) (*ppos));
 
 	if (copy_to_user(buff, session->response + (*ppos), tocopy)) {
-		up(&session->mutex);
+		mutex_unlock(&session->mutex);
 		return -EFAULT;
 	}
-	up(&session->mutex);
+	mutex_unlock(&session->mutex);
 	*ppos += tocopy;
 	return tocopy;
 }
 
 static ssize_t
-vmcp_write(struct file *file, const char __user * buff, size_t count,
-	   loff_t * ppos)
+vmcp_write(struct file *file, const char __user *buff, size_t count,
+	   loff_t *ppos)
 {
 	char *cmd;
 	struct vmcp_session *session;
@@ -103,24 +105,23 @@ vmcp_write(struct file *file, const char __user * buff, size_t count,
 	}
 	cmd[count] = '\0';
 	session = (struct vmcp_session *)file->private_data;
-	if (down_interruptible(&session->mutex)) {
+	if (mutex_lock_interruptible(&session->mutex)) {
 		kfree(cmd);
 		return -ERESTARTSYS;
 	}
 	if (!session->response)
 		session->response = (char *)__get_free_pages(GFP_KERNEL
-						| __GFP_REPEAT 	| GFP_DMA,
+						| __GFP_REPEAT | GFP_DMA,
 						get_order(session->bufsize));
 	if (!session->response) {
-		up(&session->mutex);
+		mutex_unlock(&session->mutex);
 		kfree(cmd);
 		return -ENOMEM;
 	}
 	debug_text_event(vmcp_debug, 1, cmd);
-	session->resp_size = cpcmd(cmd, session->response,
-				     session->bufsize,
-				     &session->resp_code);
-	up(&session->mutex);
+	session->resp_size = cpcmd(cmd, session->response, session->bufsize,
+				   &session->resp_code);
+	mutex_unlock(&session->mutex);
 	kfree(cmd);
 	*ppos = 0;		/* reset the file pointer after a command */
 	return count;
@@ -145,12 +146,12 @@ static long vmcp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	int temp;
 
 	session = (struct vmcp_session *)file->private_data;
-	if (down_interruptible(&session->mutex))
+	if (mutex_lock_interruptible(&session->mutex))
 		return -ERESTARTSYS;
 	switch (cmd) {
 	case VMCP_GETCODE:
 		temp = session->resp_code;
-		up(&session->mutex);
+		mutex_unlock(&session->mutex);
 		return put_user(temp, (int __user *)arg);
 	case VMCP_SETBUF:
 		free_pages((unsigned long)session->response,
@@ -161,14 +162,14 @@ static long vmcp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			session->bufsize = PAGE_SIZE;
 			temp = -EINVAL;
 		}
-		up(&session->mutex);
+		mutex_unlock(&session->mutex);
 		return temp;
 	case VMCP_GETSIZE:
 		temp = session->resp_size;
-		up(&session->mutex);
+		mutex_unlock(&session->mutex);
 		return put_user(temp, (int __user *)arg);
 	default:
-		up(&session->mutex);
+		mutex_unlock(&session->mutex);
 		return -ENOIOCTLCMD;
 	}
 }
@@ -180,7 +181,7 @@ static const struct file_operations vmcp_fops = {
 	.read		= vmcp_read,
 	.write		= vmcp_write,
 	.unlocked_ioctl	= vmcp_ioctl,
-	.compat_ioctl	= vmcp_ioctl
+	.compat_ioctl	= vmcp_ioctl,
 };
 
 static struct miscdevice vmcp_dev = {
@@ -194,26 +195,38 @@ static int __init vmcp_init(void)
 	int ret;
 
 	if (!MACHINE_IS_VM) {
-		printk(KERN_WARNING
-		       "z/VM CP interface is only available under z/VM\n");
+		PRINT_WARN("z/VM CP interface is only available under z/VM\n");
 		return -ENODEV;
 	}
-	ret = misc_register(&vmcp_dev);
-	if (!ret)
-		printk(KERN_INFO "z/VM CP interface loaded\n");
-	else
-		printk(KERN_WARNING
-		       "z/VM CP interface not loaded. Could not register misc device.\n");
 	vmcp_debug = debug_register("vmcp", 1, 1, 240);
-	debug_register_view(vmcp_debug, &debug_hex_ascii_view);
-	return ret;
+	if (!vmcp_debug) {
+		PRINT_ERR("z/VM CP interface not loaded. Could not register "
+			   "debug feature\n");
+		return -ENOMEM;
+	}
+	ret = debug_register_view(vmcp_debug, &debug_hex_ascii_view);
+	if (ret) {
+		PRINT_ERR("z/VM CP interface not loaded. Could not register "
+			  "debug feature view. Error code: %d\n", ret);
+		debug_unregister(vmcp_debug);
+		return ret;
+	}
+	ret = misc_register(&vmcp_dev);
+	if (ret) {
+		PRINT_ERR("z/VM CP interface not loaded. Could not register "
+			   "misc device. Error code: %d\n", ret);
+		debug_unregister(vmcp_debug);
+		return ret;
+	}
+	PRINT_INFO("z/VM CP interface loaded\n");
+	return 0;
 }
 
 static void __exit vmcp_exit(void)
 {
-	WARN_ON(misc_deregister(&vmcp_dev) != 0);
+	misc_deregister(&vmcp_dev);
 	debug_unregister(vmcp_debug);
-	printk(KERN_INFO "z/VM CP interface unloaded.\n");
+	PRINT_INFO("z/VM CP interface unloaded.\n");
 }
 
 module_init(vmcp_init);
diff --git a/drivers/s390/char/vmcp.h b/drivers/s390/char/vmcp.h
index 8a5975f..6a99394 100644
--- a/drivers/s390/char/vmcp.h
+++ b/drivers/s390/char/vmcp.h
@@ -12,8 +12,8 @@
  * The idea of this driver is based on cpint from Neale Ferguson
  */
 
-#include <asm/semaphore.h>
 #include <linux/ioctl.h>
+#include <linux/mutex.h>
 
 #define VMCP_GETCODE _IOR(0x10, 1, int)
 #define VMCP_SETBUF _IOW(0x10, 2, int)
@@ -26,5 +26,5 @@ struct vmcp_session {
 	int resp_code;
 	/* As we use copy_from/to_user, which might     *
 	 * sleep and cannot use a spinlock              */
-	struct semaphore mutex;
+	struct mutex mutex;
 };
diff --git a/drivers/s390/char/vmur.c b/drivers/s390/char/vmur.c
new file mode 100644
index 0000000..e90b0f8
--- /dev/null
+++ b/drivers/s390/char/vmur.c
@@ -0,0 +1,906 @@
+/*
+ * Linux driver for System z and s390 unit record devices
+ * (z/VM virtual punch, reader, printer)
+ *
+ * Copyright IBM Corp. 2001, 2007
+ * Authors: Malcolm Beattie <beattiem@uk.ibm.com>
+ *	    Michael Holzheu <holzheu@de.ibm.com>
+ *	    Frank Munzert <munzert@de.ibm.com>
+ */
+
+#include <linux/cdev.h>
+
+#include <asm/uaccess.h>
+#include <asm/cio.h>
+#include <asm/ccwdev.h>
+#include <asm/debug.h>
+
+#include "vmur.h"
+
+/*
+ * Driver overview
+ *
+ * Unit record device support is implemented as a character device driver.
+ * We can fit at least 16 bits into a device minor number and use the
+ * simple method of mapping a character device number with minor abcd
+ * to the unit record device with devno abcd.
+ * I/O to virtual unit record devices is handled as follows:
+ * Reads: Diagnose code 0x14 (input spool file manipulation)
+ * is used to read spool data page-wise.
+ * Writes: The CCW used is WRITE_CCW_CMD (0x01). The device's record length
+ * is available by reading sysfs attr reclen. Each write() to the device
+ * must specify an integral multiple (maximal 511) of reclen.
+ */
+
+static char ur_banner[] = "z/VM virtual unit record device driver";
+
+MODULE_AUTHOR("IBM Corporation");
+MODULE_DESCRIPTION("s390 z/VM virtual unit record device driver");
+MODULE_LICENSE("GPL");
+
+#define PRINTK_HEADER "vmur: "
+
+static dev_t ur_first_dev_maj_min;
+static struct class *vmur_class;
+static struct debug_info *vmur_dbf;
+
+/* We put the device's record length (for writes) in the driver_info field */
+static struct ccw_device_id ur_ids[] = {
+	{ CCWDEV_CU_DI(READER_PUNCH_DEVTYPE, 80) },
+	{ CCWDEV_CU_DI(PRINTER_DEVTYPE, 132) },
+	{ /* end of list */ }
+};
+
+MODULE_DEVICE_TABLE(ccw, ur_ids);
+
+static int ur_probe(struct ccw_device *cdev);
+static void ur_remove(struct ccw_device *cdev);
+static int ur_set_online(struct ccw_device *cdev);
+static int ur_set_offline(struct ccw_device *cdev);
+
+static struct ccw_driver ur_driver = {
+	.name		= "vmur",
+	.owner		= THIS_MODULE,
+	.ids		= ur_ids,
+	.probe		= ur_probe,
+	.remove		= ur_remove,
+	.set_online	= ur_set_online,
+	.set_offline	= ur_set_offline,
+};
+
+/*
+ * Allocation, freeing, getting and putting of urdev structures
+ */
+static struct urdev *urdev_alloc(struct ccw_device *cdev)
+{
+	struct urdev *urd;
+
+	urd = kzalloc(sizeof(struct urdev), GFP_KERNEL);
+	if (!urd)
+		return NULL;
+	urd->cdev = cdev;
+	urd->reclen = cdev->id.driver_info;
+	ccw_device_get_id(cdev, &urd->dev_id);
+	mutex_init(&urd->io_mutex);
+	mutex_init(&urd->open_mutex);
+	return urd;
+}
+
+static void urdev_free(struct urdev *urd)
+{
+	kfree(urd);
+}
+
+/*
+ * This is how the character device driver gets a reference to a
+ * ur device. When this call returns successfully, a reference has
+ * been taken (by get_device) on the underlying kobject. The recipient
+ * of this urdev pointer must eventually drop it with urdev_put(urd)
+ * which does the corresponding put_device().
+ */
+static struct urdev *urdev_get_from_devno(u16 devno)
+{
+	char bus_id[16];
+	struct ccw_device *cdev;
+
+	sprintf(bus_id, "0.0.%04x", devno);
+	cdev = get_ccwdev_by_busid(&ur_driver, bus_id);
+	if (!cdev)
+		return NULL;
+
+	return cdev->dev.driver_data;
+}
+
+static void urdev_put(struct urdev *urd)
+{
+	put_device(&urd->cdev->dev);
+}
+
+/*
+ * Low-level functions to do I/O to a ur device.
+ *     alloc_chan_prog
+ *     do_ur_io
+ *     ur_int_handler
+ *
+ * alloc_chan_prog allocates and builds the channel program
+ *
+ * do_ur_io issues the channel program to the device and blocks waiting
+ * on a completion event it publishes at urd->io_done. The function
+ * serialises itself on the device's mutex so that only one I/O
+ * is issued at a time (and that I/O is synchronous).
+ *
+ * ur_int_handler catches the "I/O done" interrupt, writes the
+ * subchannel status word into the scsw member of the urdev structure
+ * and complete()s the io_done to wake the waiting do_ur_io.
+ *
+ * The caller of do_ur_io is responsible for kfree()ing the channel program
+ * address pointer that alloc_chan_prog returned.
+ */
+
+
+/*
+ * alloc_chan_prog
+ * The channel program we use is write commands chained together
+ * with a final NOP CCW command-chained on (which ensures that CE and DE
+ * are presented together in a single interrupt instead of as separate
+ * interrupts unless an incorrect length indication kicks in first). The
+ * data length in each CCW is reclen. The caller must ensure that count
+ * is an integral multiple of reclen.
+ * The channel program pointer returned by this function must be freed
+ * with kfree. The caller is responsible for checking that
+ * count/reclen is not ridiculously large.
+ */
+static struct ccw1 *alloc_chan_prog(char *buf, size_t count, size_t reclen)
+{
+	size_t num_ccws;
+	struct ccw1 *cpa;
+	int i;
+
+	TRACE("alloc_chan_prog(%p, %zu, %zu)\n", buf, count, reclen);
+
+	/*
+	 * We chain a NOP onto the writes to force CE+DE together.
+	 * That means we allocate room for CCWs to cover count/reclen
+	 * records plus a NOP.
+	 */
+	num_ccws = count / reclen + 1;
+	cpa = kmalloc(num_ccws * sizeof(struct ccw1), GFP_KERNEL | GFP_DMA);
+	if (!cpa)
+		return NULL;
+
+	for (i = 0; count; i++) {
+		cpa[i].cmd_code = WRITE_CCW_CMD;
+		cpa[i].flags = CCW_FLAG_CC | CCW_FLAG_SLI;
+		cpa[i].count = reclen;
+		cpa[i].cda = __pa(buf);
+		buf += reclen;
+		count -= reclen;
+	}
+	/* The following NOP CCW forces CE+DE to be presented together */
+	cpa[i].cmd_code = CCW_CMD_NOOP;
+	cpa[i].flags = 0;
+	cpa[i].count = 0;
+	cpa[i].cda = 0;
+
+	return cpa;
+}
+
+static int do_ur_io(struct urdev *urd, struct ccw1 *cpa)
+{
+	int rc;
+	struct ccw_device *cdev = urd->cdev;
+	DECLARE_COMPLETION(event);
+
+	TRACE("do_ur_io: cpa=%p\n", cpa);
+
+	rc = mutex_lock_interruptible(&urd->io_mutex);
+	if (rc)
+		return rc;
+
+	urd->io_done = &event;
+
+	spin_lock_irq(get_ccwdev_lock(cdev));
+	rc = ccw_device_start(cdev, cpa, 1, 0, 0);
+	spin_unlock_irq(get_ccwdev_lock(cdev));
+
+	TRACE("do_ur_io: ccw_device_start returned %d\n", rc);
+	if (rc)
+		goto out;
+
+	wait_for_completion(&event);
+	TRACE("do_ur_io: I/O complete\n");
+	rc = 0;
+
+out:
+	mutex_unlock(&urd->io_mutex);
+	return rc;
+}
+
+/*
+ * ur interrupt handler, called from the ccw_device layer
+ */
+static void ur_int_handler(struct ccw_device *cdev, unsigned long intparm,
+			   struct irb *irb)
+{
+	struct urdev *urd;
+
+	TRACE("ur_int_handler: intparm=0x%lx cstat=%02x dstat=%02x res=%u\n",
+	      intparm, irb->scsw.cstat, irb->scsw.dstat, irb->scsw.count);
+
+	if (!intparm) {
+		TRACE("ur_int_handler: unsolicited interrupt\n");
+		return;
+	}
+	urd = cdev->dev.driver_data;
+	/* On special conditions irb is an error pointer */
+	if (IS_ERR(irb))
+		urd->io_request_rc = PTR_ERR(irb);
+	else if (irb->scsw.dstat == (DEV_STAT_CHN_END | DEV_STAT_DEV_END))
+		urd->io_request_rc = 0;
+	else
+		urd->io_request_rc = -EIO;
+
+	complete(urd->io_done);
+}
+
+/*
+ * reclen sysfs attribute - The record length to be used for write CCWs
+ */
+static ssize_t ur_attr_reclen_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct urdev *urd = dev->driver_data;
+
+	return sprintf(buf, "%zu\n", urd->reclen);
+}
+
+static DEVICE_ATTR(reclen, 0444, ur_attr_reclen_show, NULL);
+
+static int ur_create_attributes(struct device *dev)
+{
+	return device_create_file(dev, &dev_attr_reclen);
+}
+
+static void ur_remove_attributes(struct device *dev)
+{
+	device_remove_file(dev, &dev_attr_reclen);
+}
+
+/*
+ * diagnose code 0x210 - retrieve device information
+ * cc=0  normal completion, we have a real device
+ * cc=1  CP paging error
+ * cc=2  The virtual device exists, but is not associated with a real device
+ * cc=3  Invalid device address, or the virtual device does not exist
+ */
+static int get_urd_class(struct urdev *urd)
+{
+	static struct diag210 ur_diag210;
+	int cc;
+
+	ur_diag210.vrdcdvno = urd->dev_id.devno;
+	ur_diag210.vrdclen = sizeof(struct diag210);
+
+	cc = diag210(&ur_diag210);
+	switch (cc) {
+	case 0:
+		return -ENOTSUPP;
+	case 2:
+		return ur_diag210.vrdcvcla; /* virtual device class */
+	case 3:
+		return -ENODEV;
+	default:
+		return -EIO;
+	}
+}
+
+/*
+ * Allocation and freeing of urfile structures
+ */
+static struct urfile *urfile_alloc(struct urdev *urd)
+{
+	struct urfile *urf;
+
+	urf = kzalloc(sizeof(struct urfile), GFP_KERNEL);
+	if (!urf)
+		return NULL;
+	urf->urd = urd;
+
+	TRACE("urfile_alloc: urd=%p urf=%p rl=%zu\n", urd, urf,
+	      urf->dev_reclen);
+
+	return urf;
+}
+
+static void urfile_free(struct urfile *urf)
+{
+	TRACE("urfile_free: urf=%p urd=%p\n", urf, urf->urd);
+	kfree(urf);
+}
+
+/*
+ * The fops implementation of the character device driver
+ */
+static ssize_t do_write(struct urdev *urd, const char __user *udata,
+			size_t count, size_t reclen, loff_t *ppos)
+{
+	struct ccw1 *cpa;
+	char *buf;
+	int rc;
+
+	/* Data buffer must be under 2GB line for fmt1 CCWs: hence GFP_DMA */
+	buf = kmalloc(count, GFP_KERNEL | GFP_DMA);
+	if (!buf)
+		return -ENOMEM;
+
+	if (copy_from_user(buf, udata, count)) {
+		rc = -EFAULT;
+		goto fail_kfree_buf;
+	}
+
+	cpa = alloc_chan_prog(buf, count, reclen);
+	if (!cpa) {
+		rc = -ENOMEM;
+		goto fail_kfree_buf;
+	}
+
+	rc = do_ur_io(urd, cpa);
+	if (rc)
+		goto fail_kfree_cpa;
+
+	if (urd->io_request_rc) {
+		rc = urd->io_request_rc;
+		goto fail_kfree_cpa;
+	}
+	*ppos += count;
+	rc = count;
+fail_kfree_cpa:
+	kfree(cpa);
+fail_kfree_buf:
+	kfree(buf);
+	return rc;
+}
+
+static ssize_t ur_write(struct file *file, const char __user *udata,
+			size_t count, loff_t *ppos)
+{
+	struct urfile *urf = file->private_data;
+
+	TRACE("ur_write: count=%zu\n", count);
+
+	if (count == 0)
+		return 0;
+
+	if (count % urf->dev_reclen)
+		return -EINVAL;	/* count must be a multiple of reclen */
+
+	if (count > urf->dev_reclen * MAX_RECS_PER_IO)
+		count = urf->dev_reclen * MAX_RECS_PER_IO;
+
+	return do_write(urf->urd, udata, count, urf->dev_reclen, ppos);
+}
+
+static int do_diag_14(unsigned long rx, unsigned long ry1,
+		      unsigned long subcode)
+{
+	register unsigned long _ry1 asm("2") = ry1;
+	register unsigned long _ry2 asm("3") = subcode;
+	int rc = 0;
+
+	asm volatile(
+#ifdef CONFIG_64BIT
+		"   sam31\n"
+		"   diag    %2,2,0x14\n"
+		"   sam64\n"
+#else
+		"   diag    %2,2,0x14\n"
+#endif
+		"   ipm     %0\n"
+		"   srl     %0,28\n"
+		: "=d" (rc), "+d" (_ry2)
+		: "d" (rx), "d" (_ry1)
+		: "cc");
+
+	TRACE("diag 14: subcode=0x%lx, cc=%i\n", subcode, rc);
+	return rc;
+}
+
+/*
+ * diagnose code 0x14 subcode 0x0028 - position spool file to designated
+ *				       record
+ * cc=0  normal completion
+ * cc=2  no file active on the virtual reader or device not ready
+ * cc=3  record specified is beyond EOF
+ */
+static int diag_position_to_record(int devno, int record)
+{
+	int cc;
+
+	cc = do_diag_14(record, devno, 0x28);
+	switch (cc) {
+	case 0:
+		return 0;
+	case 2:
+		return -ENOMEDIUM;
+	case 3:
+		return -ENODATA; /* position beyond end of file */
+	default:
+		return -EIO;
+	}
+}
+
+/*
+ * diagnose code 0x14 subcode 0x0000 - read next spool file buffer
+ * cc=0  normal completion
+ * cc=1  EOF reached
+ * cc=2  no file active on the virtual reader, and no file eligible
+ * cc=3  file already active on the virtual reader or specified virtual
+ *	 reader does not exist or is not a reader
+ */
+static int diag_read_file(int devno, char *buf)
+{
+	int cc;
+
+	cc = do_diag_14((unsigned long) buf, devno, 0x00);
+	switch (cc) {
+	case 0:
+		return 0;
+	case 1:
+		return -ENODATA;
+	case 2:
+		return -ENOMEDIUM;
+	default:
+		return -EIO;
+	}
+}
+
+static ssize_t diag14_read(struct file *file, char __user *ubuf, size_t count,
+			   loff_t *offs)
+{
+	size_t len, copied, res;
+	char *buf;
+	int rc;
+	u16 reclen;
+	struct urdev *urd;
+
+	urd = ((struct urfile *) file->private_data)->urd;
+	reclen = ((struct urfile *) file->private_data)->file_reclen;
+
+	rc = diag_position_to_record(urd->dev_id.devno, *offs / PAGE_SIZE + 1);
+	if (rc == -ENODATA)
+		return 0;
+	if (rc)
+		return rc;
+
+	len = min((size_t) PAGE_SIZE, count);
+	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	copied = 0;
+	res = (size_t) (*offs % PAGE_SIZE);
+	do {
+		rc = diag_read_file(urd->dev_id.devno, buf);
+		if (rc == -ENODATA) {
+			break;
+		}
+		if (rc)
+			goto fail;
+		if (reclen)
+			*((u16 *) &buf[FILE_RECLEN_OFFSET]) = reclen;
+		len = min(count - copied, PAGE_SIZE - res);
+		if (copy_to_user(ubuf + copied, buf + res, len)) {
+			rc = -EFAULT;
+			goto fail;
+		}
+		res = 0;
+		copied += len;
+	} while (copied != count);
+
+	*offs += copied;
+	rc = copied;
+fail:
+	kfree(buf);
+	return rc;
+}
+
+static ssize_t ur_read(struct file *file, char __user *ubuf, size_t count,
+		       loff_t *offs)
+{
+	struct urdev *urd;
+	int rc;
+
+	TRACE("ur_read: count=%zu ppos=%li\n", count, (unsigned long) *offs);
+
+	if (count == 0)
+		return 0;
+
+	urd = ((struct urfile *) file->private_data)->urd;
+	rc = mutex_lock_interruptible(&urd->io_mutex);
+	if (rc)
+		return rc;
+	rc = diag14_read(file, ubuf, count, offs);
+	mutex_unlock(&urd->io_mutex);
+	return rc;
+}
+
+/*
+ * diagnose code 0x14 subcode 0x0fff - retrieve next file descriptor
+ * cc=0  normal completion
+ * cc=1  no files on reader queue or no subsequent file
+ * cc=2  spid specified is invalid
+ */
+static int diag_read_next_file_info(struct file_control_block *buf, int spid)
+{
+	int cc;
+
+	cc = do_diag_14((unsigned long) buf, spid, 0xfff);
+	switch (cc) {
+	case 0:
+		return 0;
+	default:
+		return -ENODATA;
+	}
+}
+
+static int verify_device(struct urdev *urd)
+{
+	struct file_control_block fcb;
+	char *buf;
+	int rc;
+
+	switch (urd->class) {
+	case DEV_CLASS_UR_O:
+		return 0; /* no check needed here */
+	case DEV_CLASS_UR_I:
+		/* check for empty reader device (beginning of chain) */
+		rc = diag_read_next_file_info(&fcb, 0);
+		if (rc)
+			return rc;
+
+		/* open file on virtual reader	*/
+		buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		if (!buf)
+			return -ENOMEM;
+		rc = diag_read_file(urd->dev_id.devno, buf);
+		kfree(buf);
+
+		if ((rc != 0) && (rc != -ENODATA)) /* EOF does not hurt */
+			return rc;
+		return 0;
+	default:
+		return -ENOTSUPP;
+	}
+}
+
+static int get_file_reclen(struct urdev *urd)
+{
+	struct file_control_block fcb;
+	int rc;
+
+	switch (urd->class) {
+	case DEV_CLASS_UR_O:
+		return 0;
+	case DEV_CLASS_UR_I:
+		rc = diag_read_next_file_info(&fcb, 0);
+		if (rc)
+			return rc;
+		break;
+	default:
+		return -ENOTSUPP;
+	}
+	if (fcb.file_stat & FLG_CP_DUMP)
+		return 0;
+
+	return fcb.rec_len;
+}
+
+static int ur_open(struct inode *inode, struct file *file)
+{
+	u16 devno;
+	struct urdev *urd;
+	struct urfile *urf;
+	unsigned short accmode;
+	int rc;
+
+	accmode = file->f_flags & O_ACCMODE;
+
+	if (accmode == O_RDWR)
+		return -EACCES;
+
+	/*
+	 * We treat the minor number as the devno of the ur device
+	 * to find in the driver tree.
+	 */
+	devno = MINOR(file->f_dentry->d_inode->i_rdev);
+
+	urd = urdev_get_from_devno(devno);
+	if (!urd)
+		return -ENXIO;
+
+	if (file->f_flags & O_NONBLOCK) {
+		if (!mutex_trylock(&urd->open_mutex)) {
+			rc = -EBUSY;
+			goto fail_put;
+		}
+	} else {
+		if (mutex_lock_interruptible(&urd->open_mutex)) {
+			rc = -ERESTARTSYS;
+			goto fail_put;
+		}
+	}
+
+	TRACE("ur_open\n");
+
+	if (((accmode == O_RDONLY) && (urd->class != DEV_CLASS_UR_I)) ||
+	    ((accmode == O_WRONLY) && (urd->class != DEV_CLASS_UR_O))) {
+		TRACE("ur_open: unsupported dev class (%d)\n", urd->class);
+		rc = -EACCES;
+		goto fail_unlock;
+	}
+
+	rc = verify_device(urd);
+	if (rc)
+		goto fail_unlock;
+
+	urf = urfile_alloc(urd);
+	if (!urf) {
+		rc = -ENOMEM;
+		goto fail_unlock;
+	}
+
+	urf->dev_reclen = urd->reclen;
+	rc = get_file_reclen(urd);
+	if (rc < 0)
+		goto fail_urfile_free;
+	urf->file_reclen = rc;
+	file->private_data = urf;
+	return 0;
+
+fail_urfile_free:
+	urfile_free(urf);
+fail_unlock:
+	mutex_unlock(&urd->open_mutex);
+fail_put:
+	urdev_put(urd);
+	return rc;
+}
+
+static int ur_release(struct inode *inode, struct file *file)
+{
+	struct urfile *urf = file->private_data;
+
+	TRACE("ur_release\n");
+	mutex_unlock(&urf->urd->open_mutex);
+	urdev_put(urf->urd);
+	urfile_free(urf);
+	return 0;
+}
+
+static loff_t ur_llseek(struct file *file, loff_t offset, int whence)
+{
+	loff_t newpos;
+
+	if ((file->f_flags & O_ACCMODE) != O_RDONLY)
+		return -ESPIPE; /* seek allowed only for reader */
+	if (offset % PAGE_SIZE)
+		return -ESPIPE; /* only multiples of 4K allowed */
+	switch (whence) {
+	case 0: /* SEEK_SET */
+		newpos = offset;
+		break;
+	case 1: /* SEEK_CUR */
+		newpos = file->f_pos + offset;
+		break;
+	default:
+		return -EINVAL;
+	}
+	file->f_pos = newpos;
+	return newpos;
+}
+
+static struct file_operations ur_fops = {
+	.owner	 = THIS_MODULE,
+	.open	 = ur_open,
+	.release = ur_release,
+	.read	 = ur_read,
+	.write	 = ur_write,
+	.llseek  = ur_llseek,
+};
+
+/*
+ * ccw_device infrastructure:
+ *     ur_probe gets its own ref to the device (i.e. get_device),
+ *     creates the struct urdev, the device attributes, sets up
+ *     the interrupt handler and validates the virtual unit record device.
+ *     ur_remove removes the device attributes, frees the struct urdev
+ *     and drops (put_device) the ref to the device we got in ur_probe.
+ */
+static int ur_probe(struct ccw_device *cdev)
+{
+	struct urdev *urd;
+	int rc;
+
+	TRACE("ur_probe: cdev=%p state=%d\n", cdev, *(int *) cdev->private);
+
+	if (!get_device(&cdev->dev))
+		return -ENODEV;
+
+	urd = urdev_alloc(cdev);
+	if (!urd) {
+		rc = -ENOMEM;
+		goto fail;
+	}
+	rc = ur_create_attributes(&cdev->dev);
+	if (rc) {
+		rc = -ENOMEM;
+		goto fail;
+	}
+	cdev->dev.driver_data = urd;
+	cdev->handler = ur_int_handler;
+
+	/* validate virtual unit record device */
+	urd->class = get_urd_class(urd);
+	if (urd->class < 0) {
+		rc = urd->class;
+		goto fail;
+	}
+	if ((urd->class != DEV_CLASS_UR_I) && (urd->class != DEV_CLASS_UR_O)) {
+		rc = -ENOTSUPP;
+		goto fail;
+	}
+
+	return 0;
+
+fail:
+	urdev_free(urd);
+	put_device(&cdev->dev);
+	return rc;
+}
+
+static void ur_remove(struct ccw_device *cdev)
+{
+	struct urdev *urd = cdev->dev.driver_data;
+
+	TRACE("ur_remove\n");
+	if (cdev->online)
+		ur_set_offline(cdev);
+	ur_remove_attributes(&cdev->dev);
+	urdev_free(urd);
+	put_device(&cdev->dev);
+}
+
+static int ur_set_online(struct ccw_device *cdev)
+{
+	struct urdev *urd;
+	int minor, major, rc;
+	char node_id[16];
+
+	TRACE("ur_set_online: cdev=%p state=%d\n", cdev,
+	      *(int *) cdev->private);
+
+	if (!try_module_get(ur_driver.owner))
+		return -EINVAL;
+
+	urd = (struct urdev *) cdev->dev.driver_data;
+	minor = urd->dev_id.devno;
+	major = MAJOR(ur_first_dev_maj_min);
+
+	urd->char_device = cdev_alloc();
+	if (!urd->char_device) {
+		rc = -ENOMEM;
+		goto fail_module_put;
+	}
+
+	cdev_init(urd->char_device, &ur_fops);
+	urd->char_device->dev = MKDEV(major, minor);
+	urd->char_device->owner = ur_fops.owner;
+
+	rc = cdev_add(urd->char_device, urd->char_device->dev, 1);
+	if (rc)
+		goto fail_free_cdev;
+	if (urd->cdev->id.cu_type == READER_PUNCH_DEVTYPE) {
+		if (urd->class == DEV_CLASS_UR_I)
+			sprintf(node_id, "vmrdr-%s", cdev->dev.bus_id);
+		if (urd->class == DEV_CLASS_UR_O)
+			sprintf(node_id, "vmpun-%s", cdev->dev.bus_id);
+	} else if (urd->cdev->id.cu_type == PRINTER_DEVTYPE) {
+		sprintf(node_id, "vmprt-%s", cdev->dev.bus_id);
+	} else {
+		rc = -ENOTSUPP;
+		goto fail_free_cdev;
+	}
+
+	urd->device = device_create(vmur_class, NULL, urd->char_device->dev,
+					"%s", node_id);
+	if (IS_ERR(urd->device)) {
+		rc = PTR_ERR(urd->device);
+		TRACE("ur_set_online: device_create rc=%d\n", rc);
+		goto fail_free_cdev;
+	}
+
+	return 0;
+
+fail_free_cdev:
+	cdev_del(urd->char_device);
+fail_module_put:
+	module_put(ur_driver.owner);
+
+	return rc;
+}
+
+static int ur_set_offline(struct ccw_device *cdev)
+{
+	struct urdev *urd;
+
+	TRACE("ur_set_offline: cdev=%p cdev->private=%p state=%d\n",
+		cdev, cdev->private, *(int *) cdev->private);
+	urd = (struct urdev *) cdev->dev.driver_data;
+	device_destroy(vmur_class, urd->char_device->dev);
+	cdev_del(urd->char_device);
+	module_put(ur_driver.owner);
+
+	return 0;
+}
+
+/*
+ * Module initialisation and cleanup
+ */
+static int __init ur_init(void)
+{
+	int rc;
+	dev_t dev;
+
+	if (!MACHINE_IS_VM) {
+		PRINT_ERR("%s is only available under z/VM.\n", ur_banner);
+		return -ENODEV;
+	}
+
+	vmur_dbf = debug_register("vmur", 4, 1, 4 * sizeof(long));
+	if (!vmur_dbf)
+		return -ENOMEM;
+	rc = debug_register_view(vmur_dbf, &debug_sprintf_view);
+	if (rc)
+		goto fail_free_dbf;
+
+	debug_set_level(vmur_dbf, 6);
+
+	rc = ccw_driver_register(&ur_driver);
+	if (rc)
+		goto fail_free_dbf;
+
+	rc = alloc_chrdev_region(&dev, 0, NUM_MINORS, "vmur");
+	if (rc) {
+		PRINT_ERR("alloc_chrdev_region failed: err = %d\n", rc);
+		goto fail_unregister_driver;
+	}
+	ur_first_dev_maj_min = MKDEV(MAJOR(dev), 0);
+
+	vmur_class = class_create(THIS_MODULE, "vmur");
+	if (IS_ERR(vmur_class)) {
+		rc = PTR_ERR(vmur_class);
+		goto fail_unregister_region;
+	}
+	PRINT_INFO("%s loaded.\n", ur_banner);
+	return 0;
+
+fail_unregister_region:
+	unregister_chrdev_region(ur_first_dev_maj_min, NUM_MINORS);
+fail_unregister_driver:
+	ccw_driver_unregister(&ur_driver);
+fail_free_dbf:
+	debug_unregister(vmur_dbf);
+	return rc;
+}
+
+static void __exit ur_exit(void)
+{
+	class_destroy(vmur_class);
+	unregister_chrdev_region(ur_first_dev_maj_min, NUM_MINORS);
+	ccw_driver_unregister(&ur_driver);
+	debug_unregister(vmur_dbf);
+	PRINT_INFO("%s unloaded.\n", ur_banner);
+}
+
+module_init(ur_init);
+module_exit(ur_exit);
diff --git a/drivers/s390/char/vmur.h b/drivers/s390/char/vmur.h
new file mode 100644
index 0000000..16d0a4e
--- /dev/null
+++ b/drivers/s390/char/vmur.h
@@ -0,0 +1,104 @@
+/*
+ * Linux driver for System z and s390 unit record devices
+ * (z/VM virtual punch, reader, printer)
+ *
+ * Copyright IBM Corp. 2001, 2007
+ * Authors: Malcolm Beattie <beattiem@uk.ibm.com>
+ *	    Michael Holzheu <holzheu@de.ibm.com>
+ *	    Frank Munzert <munzert@de.ibm.com>
+ */
+
+#ifndef _VMUR_H_
+#define _VMUR_H_
+
+#define DEV_CLASS_UR_I 0x20 /* diag210 unit record input device class */
+#define DEV_CLASS_UR_O 0x10 /* diag210 unit record output device class */
+/*
+ * we only support z/VM's default unit record devices:
+ * both in SPOOL directory control statement and in CP DEFINE statement
+ *	RDR defaults to 2540 reader
+ *	PUN defaults to 2540 punch
+ *	PRT defaults to 1403 printer
+ */
+#define READER_PUNCH_DEVTYPE	0x2540
+#define PRINTER_DEVTYPE		0x1403
+
+/* z/VM spool file control block SFBLOK */
+struct file_control_block {
+	char reserved_1[8];
+	char user_owner[8];
+	char user_orig[8];
+	__s32 data_recs;
+	__s16 rec_len;
+	__s16 file_num;
+	__u8  file_stat;
+	__u8  dev_type;
+	char  reserved_2[6];
+	char  file_name[12];
+	char  file_type[12];
+	char  create_date[8];
+	char  create_time[8];
+	char  reserved_3[6];
+	__u8  file_class;
+	__u8  sfb_lok;
+	__u64 distr_code;
+	__u32 reserved_4;
+	__u8  current_starting_copy_number;
+	__u8  sfblock_cntrl_flags;
+	__u8  reserved_5;
+	__u8  more_status_flags;
+	char  rest[200];
+} __attribute__ ((packed));
+
+#define FLG_CP_DUMP 0x10
+
+/*
+ * A struct urdev is created for each ur device that is made available
+ * via the ccw_device driver model.
+ */
+struct urdev {
+	struct ccw_device *cdev;	/* Backpointer to ccw device */
+	struct mutex io_mutex;		/* Serialises device IO */
+	struct mutex open_mutex;	/* Serialises access to device */
+	struct completion *io_done;	/* do_ur_io waits; irq completes */
+	struct device *device;
+	struct cdev *char_device;
+	struct ccw_dev_id dev_id;	/* device id */
+	size_t reclen;			/* Record length for *write* CCWs */
+	int class;			/* VM device class */
+	int io_request_rc;		/* return code from I/O request */
+};
+
+/*
+ * A struct urfile is allocated at open() time for each device and
+ * freed on release().
+ */
+struct urfile {
+	struct urdev *urd;
+	unsigned int flags;
+	size_t dev_reclen;
+	__u16 file_reclen;
+};
+
+/*
+ * Device major/minor definitions.
+ */
+
+#define UR_MAJOR 0	/* get dynamic major */
+/*
+ * We map minor numbers directly to device numbers (0-FFFF) for simplicity.
+ * This avoids having to allocate (and manage) slot numbers.
+ */
+#define NUM_MINORS 65536
+
+/* Limiting each I/O to 511 records limits chan prog to 4KB (511 r/w + 1 NOP) */
+#define MAX_RECS_PER_IO		511
+#define WRITE_CCW_CMD		0x01
+
+#define TRACE(x...) debug_sprintf_event(vmur_dbf, 1, x)
+#define CCWDEV_CU_DI(cutype, di) \
+		CCW_DEVICE(cutype, 0x00), .driver_info = (di)
+
+#define FILE_RECLEN_OFFSET	4064 /* reclen offset in spool data block */
+
+#endif /* _VMUR_H_ */
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index 6b264bd..001682e 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -272,7 +272,7 @@ modalias_show (struct device *dev, struct device_attribute *attr, char *buf)
 	struct ccw_device_id *id = &(cdev->id);
 	int len;
 
-	len = snprint_alias(buf, PAGE_SIZE, id, "\n") + 1;
+	len = snprint_alias(buf, PAGE_SIZE, id, "\n");
 
 	return len > PAGE_SIZE ? PAGE_SIZE : len;
 }
diff --git a/drivers/s390/cio/qdio.c b/drivers/s390/cio/qdio.c
index e70aeb7..ed026a1 100644
--- a/drivers/s390/cio/qdio.c
+++ b/drivers/s390/cio/qdio.c
@@ -166,9 +166,9 @@ qdio_check_ccq(struct qdio_q *q, unsigned int ccq)
 {
 	char dbf_text[15];
 
-	if (ccq == 0 || ccq == 32 || ccq == 96)
+	if (ccq == 0 || ccq == 32)
 		return 0;
-	if (ccq == 97)
+	if (ccq == 96 || ccq == 97)
 		return 1;
 	/*notify devices immediately*/
 	sprintf(dbf_text,"%d", ccq);
@@ -2306,8 +2306,8 @@ qdio_get_ssqd_information(struct qdio_irq *irq_ptr)
 	if (!ssqd_area) {
 	        QDIO_PRINT_WARN("Could not get memory for chsc. Using all " \
 				"SIGAs for sch x%x.\n", irq_ptr->schid.sch_no);
-		irq_ptr->qdioac = CHSC_FLAG_SIGA_INPUT_NECESSARY ||
-				  CHSC_FLAG_SIGA_OUTPUT_NECESSARY ||
+		irq_ptr->qdioac = CHSC_FLAG_SIGA_INPUT_NECESSARY |
+				  CHSC_FLAG_SIGA_OUTPUT_NECESSARY |
 				  CHSC_FLAG_SIGA_SYNC_NECESSARY; /* all flags set */
 		irq_ptr->is_qebsm = 0;
 		irq_ptr->sch_token = 0;
@@ -2328,8 +2328,8 @@ qdio_get_ssqd_information(struct qdio_irq *irq_ptr)
 		QDIO_PRINT_WARN("CHSC returned cc %i. Using all " \
 				"SIGAs for sch 0.%x.%x.\n", result,
 				irq_ptr->schid.ssid, irq_ptr->schid.sch_no);
-		qdioac = CHSC_FLAG_SIGA_INPUT_NECESSARY ||
-			CHSC_FLAG_SIGA_OUTPUT_NECESSARY ||
+		qdioac = CHSC_FLAG_SIGA_INPUT_NECESSARY |
+			CHSC_FLAG_SIGA_OUTPUT_NECESSARY |
 			CHSC_FLAG_SIGA_SYNC_NECESSARY; /* all flags set */
 		irq_ptr->is_qebsm  = 0;
 		goto out;
@@ -2340,8 +2340,8 @@ qdio_get_ssqd_information(struct qdio_irq *irq_ptr)
 				"is 0x%x. Using all SIGAs for sch 0.%x.%x.\n",
 				ssqd_area->response.code,
 				irq_ptr->schid.ssid, irq_ptr->schid.sch_no);
-		qdioac = CHSC_FLAG_SIGA_INPUT_NECESSARY ||
-			CHSC_FLAG_SIGA_OUTPUT_NECESSARY ||
+		qdioac = CHSC_FLAG_SIGA_INPUT_NECESSARY |
+			CHSC_FLAG_SIGA_OUTPUT_NECESSARY |
 			CHSC_FLAG_SIGA_SYNC_NECESSARY; /* all flags set */
 		irq_ptr->is_qebsm  = 0;
 		goto out;


