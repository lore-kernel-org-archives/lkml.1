Return-Path: <linux-kernel-owner+w=401wt.eu-S1754239AbXH0BNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbXH0BNX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 21:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbXH0BNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 21:13:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:59341 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669AbXH0BNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 21:13:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,309,1183359600"; 
   d="scan'208";a="284109235"
Subject: [RFC][PATCH 0/2 -mm] kexec based hibernation
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Aug 2007 09:14:05 +0800
Message-Id: <1188177245.3247.36.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 27 Aug 2007 01:13:08.0973 (UTC) FILETIME=[6E08A1D0:01C7E847]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kexec base hibernation has some potential advantages over uswsusp and
TuxOnIce (suspend2). Some most obvious advantages are:

1. The hibernation image size can exceed half of memory size easily.

2. The hibernation image can be written to and read from almost
   anywhere, such as USB disk, NFS.

3. It is possible to eliminate freezer from kexec based hibernation
   implementation.

4. Based on kexec/kdump implementation, the kernel code needed is
   less.


This patch set implements a prototype of kexec based hibernation. The
kernel functionalities added are as follow:

1. Jumping from kexeced kernel back to original kernel. This is used
   by hibernation to save/load necessary state in original kernel and
   jumping back to original kernel after restore the memory of
   original kernel.

2. Add writing support to /dev/oldmem. This is used by hibernation to
   restore the memory of original kernel.


The hibernation process with the patch set is as follow:

1. Boot a kernel A

2. Work under kernel A

3. Kexec another kernel B (crash dump enabled) in kernel A.

4. Save the memory image of kernel A through crash dump (such as "cp
   /proc/vmcore ~"). Save the "jump buffer pfn".

5. Shutdown or reboot


The restore process with the patch set is as follow:

1. Boot a kernel C

2. Kexec another kernel D (crash dump enabled) in kernel C. The memory
   area used by kernel D must be a subset of memory area used by
   kernel B.

3. Restore the memory image of kernel A through /dev/oldmem. Restore
   the "jump buffer pfn".

4. Jump from kernel D back to kernel A

5. Continue work under kernel A


The following user-space tools are needed to implement hibernation and
restore.

1. kexec-tools needs to be patched to support kexec jump. The patch is
   attached in this mail. The precompiled kexec can be download from:
       http://linux-mcr700.sourceforge.net/kjump/kexec

2. Memory image saving tool. Currently, the memory image saving is
   done through: "cp /proc/vmcore <image file>". This will save all
   memory pages of original kernel including the free pages. Maybe the
   crash dump tool "makedumpfile" can be used for this, but it has not
   been tested.

3. Memory image restore tool. A simplest memory image restoring tool
   named "krestore" is implemented. It can be downloaded from
   following URL:
       source: http://linux-mcr700.sourceforge.net/kjump/krestore.tar.gz
       binary: http://linux-mcr700.sourceforge.net/kjump/krestore


Known issues:

1. The kernel B run as a crashdump kernel in reserved memory
   region. This is the biggest constrains of the patch set and planed
   to be eliminated in the future version. That is, instead of
   reserving memory region previously, the needed memory region is
   backupped before kexec and restored after jumping back.

2. Another constrains of the patch set is that the CONFIG_ACPI must be
   turned off to make kexec jump work. Because ACPI will put devices
   into low power state, the kexeced kernel can not be booted properly
   under it. This constrains can be eliminated by separating the
   suspend method and hibernate method of the devices as proposed
   earlier in the LKML.

3. The setup of hibernation/restore is fairly complex. I will continue
   working on simplifying.

4. Memory pages including free pages of kernel A are saved. I think
   the "makedumpfile" tool can be used to exclude "free pages", but I
   have not tested it.

Now, only the i386 architecture is supported. The patch is based on
Linux kernel 2.6.23-rc3-mm1, and has been tested on my IBM T42.


Usage:

1. Compile kernel with following options selected:

CONFIG_X86_32=y
CONFIG_RELOCATABLE=y # not needed strictly, but it is more convenient with it
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y # only needed by kexeced kernel to save/restore memory image
CONFIG_PM=y
CONFIG_KEXEC_JUMP=y

2. Download the kexec-tools-testing git tree, apply the kexec-tools
   kjump patch and compile. The kexec-tools kjump patch is appended
   with the mail. The precompiled kexec can be download from:
       http://linux-mcr700.sourceforge.net/kjump/kexec

3. Download and compile the krestore tool. The source code and
   precompiled binary can be downloaded from the following URL:
       source: http://linux-mcr700.sourceforge.net/kjump/krestore.tar.gz
       binary: http://linux-mcr700.sourceforge.net/kjump/krestore

4. Prepare 3 root partition used by kernel A, kernel B, kernel C,
   refered as /dev/hda, /dev/hdb, /dev/hdc in following text. This is
   not strictly necessary, I use this scheme for testing during
   development.

5. Boot kernel compiled for normal usage (kernel A), the reserved
   crash kernel memory region must be added to kernel command line as
   follow:

   crashkernel=<XX>M@<XX>M

   Where, <XX> should be replaced by the real memory size and
   position. I use 16M@32M in my testing.

6. Load kernel compiled for hibernating usage (kernel B) as a
   crashdump kernel with kexec, the same kernel as that of 5 can be
   used if CONFIG_RELOCATABLE=y and CONFIG_CRASH_DUMP=y are
   selected. The kernel command line option as follow should be
   appended to kernel command line.

   kexec_jump_buf_pfn=`cat /sys/kernel/kexec_jump_buf_pfn`

   The --elf64-core-headers should be specified in command line of
   kexec, because only the 64bit ELF is supported by krestore tool.

   For example, the shell command line can be as follow:

   kexec -p /boot/bzImage --elf64-core-headers --append="root=/dev/hdb
       single kexec_jump_buf_pfn=`cat /sys/kernel/kexec_jump_buf_pfn`"

7. Jump to the hibernating kernel (kernel B) with following shell
   command line:

   kexec -j

8. In the hibernating kernel (kernel B), the memory image of
   hibernated kernel (kernel A) can be saved as follow:

   cp /proc/vmcore .
   cp /sys/kernel/kexec_jump_buf_pfn .

9. Shutdown or reboot in hibernating kernel (kernel B).

10. Boot kernel (kernel C) compiled for normal usage in another root
    file system (/dev/hdc).

11. Load restore kernel (kernel D) in kernel C through kexec. This is
    almost same as step 6. The root file system of kernel D should be
    /dev/hdb.

12. In restore kernel (kernel D), the memory image of kernel A can be
    restored as follow:

    # get backup address through kernel command line
    backup_addr=`cat /proc/cmdline | tr ' ' '\n' | grep kexec_backup | cut -d '=' -f 2`
    cp kexec_jump_buf_pfn /sys/kernel/kexec_jump_buf_pfn
    krestore -b $backup_addr vmcore

13. Jump back to hibernated kernel (kernel A)

    kexec -b


---

Changelog of kexec-tools

A command line option -j/--jump-to is added to support jumping
to/executing the currently loaded kernel. A command line option
-b/--jump-back is added to support jumping back to the original
kernel. The implementation of options is to call corresponding
syscall.

For i386 architecture, the address of backup of 0~640k is passed to
kexeced kernel as a kernel command line option. This is used by
kexeced kernel to restore the backup.

This patch is against kexec-tools-testing git tree.

Index: kexec-tools/kexec/arch/i386/crashdump-x86.c
===================================================================
--- kexec-tools.orig/kexec/arch/i386/crashdump-x86.c	2007-08-17 13:48:51.000000000 +0800
+++ kexec-tools/kexec/arch/i386/crashdump-x86.c	2007-08-17 13:49:50.000000000 +0800
@@ -428,6 +428,29 @@
 	return 0;
 }
 
+/* Adds the kexec_backup= command line parameter to command line. */
+static int cmdline_add_backup(char *cmdline, unsigned long addr)
+{
+	int cmdlen, len, align = 1024;
+	char str[30], *ptr;
+
+	/* Passing in kexec_backup=xxxK format. Saves space required
+	 * in cmdline. Ensure 1K alignment*/
+	if (addr%align)
+		return -1;
+	addr = addr/align;
+	ptr = str;
+	strcpy(str, " kexec_backup=");
+	ptr += strlen(str);
+	ultoa(addr, ptr);
+	strcat(str, "K");
+	len = strlen(str);
+	cmdlen = strlen(cmdline) + len;
+	if (cmdlen > (COMMAND_LINE_SIZE - 1))
+		die("Command line overflow\n");
+	strcat(cmdline, str);
+	return 0;
+}
 
 /*
  * This routine is specific to i386 architecture to maintain the
@@ -575,6 +598,7 @@
 		return -1;
 	cmdline_add_memmap(mod_cmdline, memmap_p);
 	cmdline_add_elfcorehdr(mod_cmdline, elfcorehdr);
+	cmdline_add_backup(mod_cmdline, info->backup_start);
 	return 0;
 }
 
Index: kexec-tools/kexec/kexec-syscall.h
===================================================================
--- kexec-tools.orig/kexec/kexec-syscall.h	2007-08-17 13:48:51.000000000 +0800
+++ kexec-tools/kexec/kexec-syscall.h	2007-08-24 13:44:22.000000000 +0800
@@ -21,6 +21,8 @@
 #define LINUX_REBOOT_CMD_KEXEC_OLD	0x81726354
 #define LINUX_REBOOT_CMD_KEXEC_OLD2	0x18263645
 #define LINUX_REBOOT_CMD_KEXEC		0x45584543
+#define LINUX_REBOOT_CMD_KJUMP_TO	0x3928A5FD
+#define LINUX_REBOOT_CMD_KJUMP_BACK	0x4A39B60E
 
 #ifdef __i386__
 #define __NR_kexec_load		283
@@ -63,6 +65,15 @@
 	return (long) syscall(__NR_reboot, LINUX_REBOOT_MAGIC1, LINUX_REBOOT_MAGIC2, LINUX_REBOOT_CMD_KEXEC, 0);
 }
 
+static inline long kexec_jump_to(void)
+{
+	return (long) syscall(__NR_reboot, LINUX_REBOOT_MAGIC1, LINUX_REBOOT_MAGIC2, LINUX_REBOOT_CMD_KJUMP_TO, 0);
+}
+
+static inline long kexec_jump_back(void)
+{
+	return (long) syscall(__NR_reboot, LINUX_REBOOT_MAGIC1, LINUX_REBOOT_MAGIC2, LINUX_REBOOT_CMD_KJUMP_BACK, 0);
+}
 
 #define KEXEC_ON_CRASH  0x00000001
 #define KEXEC_ARCH_MASK 0xffff0000
Index: kexec-tools/kexec/kexec.c
===================================================================
--- kexec-tools.orig/kexec/kexec.c	2007-08-17 13:48:51.000000000 +0800
+++ kexec-tools/kexec/kexec.c	2007-08-24 13:53:43.000000000 +0800
@@ -716,6 +716,33 @@
 	return -1;
 }
 
+/*
+ *	Jump to the new kernel
+ */
+static int my_jump_to(void)
+{
+	int result;
+
+	result = kexec_jump_to();
+	if (result)
+		fprintf(stderr, "kexec jump to failed: %s\n",
+			strerror(errno));
+	return result;
+}
+
+/*
+ *	Jump back to the original kernel
+ */
+static int my_jump_back(void)
+{
+	int result;
+
+	result = kexec_jump_back();
+	fprintf(stderr, "kexec jump back failed: %s\n",
+		strerror(errno));
+	return -1;
+}
+
 static void version(void)
 {
 	printf(PACKAGE " " VERSION " released " RELEASE_DATE "\n");
@@ -743,6 +770,8 @@
 	       "                      If capture kernel is being unloaded\n"
 	       "                      specify -p with -u.\n"
 	       " -e, --exec           Execute a currently loaded kernel.\n"
+ 	       " -j, --jump-to        Jump to a currently loaded kernel.\n"
+	       " -b, --jump-back      Jump back to the original kernel.\n"
 	       " -t, --type=TYPE      Specify the new kernel is of this type.\n"
 	       "     --mem-min=<addr> Specify the lowest memory address to\n"
 	       "                      load code into.\n"
@@ -773,6 +802,19 @@
 	return ret;
 }
 
+static int kexec_crash_loaded(void)
+{
+	int ret;
+	FILE *fp;
+
+	fp = fopen("/sys/kernel/kexec_crash_loaded", "r");
+	if (fp == NULL)
+		return -1;
+	fscanf(fp, "%d", &ret);
+	fclose(fp);
+	return ret;
+}
+
 /* check we retained the initrd */
 void check_reuse_initrd(void)
 {
@@ -803,6 +845,8 @@
 {
 	int do_load = 1;
 	int do_exec = 0;
+	int do_jump_to = 0;
+	int do_jump_back = 0;
 	int do_shutdown = 1;
 	int do_sync = 1;
 	int do_ifdown = 0;
@@ -858,6 +902,22 @@
 			do_ifdown = 1;
 			do_exec = 1;
 			break;
+		case OPT_JUMP_TO:
+			do_load = 0;
+			do_shutdown = 0;
+			do_sync = 1;
+			do_ifdown = 0;
+			do_exec = 0;
+			do_jump_to = 1;
+			break;
+		case OPT_JUMP_BACK:
+			do_load = 0;
+			do_shutdown = 0;
+			do_sync = 1;
+			do_ifdown = 1;
+			do_exec = 0;
+			do_jump_back = 1;
+			break;
 		case OPT_TYPE:
 			type = optarg;
 			break;
@@ -936,6 +996,9 @@
 	if ((result == 0) && (do_shutdown || do_exec) && !kexec_loaded()) {
 		die("Nothing has been loaded!\n");
 	}
+	if ((result == 0) && do_jump_to && !kexec_crash_loaded()) {
+		die("Nothing has been loaded!\n");
+	}
 	if ((result == 0) && do_shutdown) {
 		result = my_shutdown();
 	}
@@ -949,6 +1012,12 @@
 	if ((result == 0) && do_exec) {
 		result = my_exec();
 	}
+	if ((result == 0) && do_jump_to) {
+		result = my_jump_to();
+	}
+	if ((result == 0) && do_jump_back) {
+		result = my_jump_back();
+	}
 
 	fflush(stdout);
 	fflush(stderr);
Index: kexec-tools/kexec/kexec.h
===================================================================
--- kexec-tools.orig/kexec/kexec.h	2007-08-17 13:48:51.000000000 +0800
+++ kexec-tools/kexec/kexec.h	2007-08-24 11:15:27.000000000 +0800
@@ -156,6 +156,8 @@
 #define OPT_FORCE		'f'
 #define OPT_NOIFDOWN		'x'
 #define OPT_EXEC		'e'
+#define OPT_JUMP_TO		'j'
+#define OPT_JUMP_BACK		'b'
 #define OPT_LOAD		'l'
 #define OPT_UNLOAD		'u'
 #define OPT_TYPE		't'
@@ -172,13 +174,15 @@
 	{ "load",		0, 0, OPT_LOAD }, \
 	{ "unload",		0, 0, OPT_UNLOAD }, \
 	{ "exec",		0, 0, OPT_EXEC }, \
+ 	{ "jump-to",		0, 0, OPT_JUMP_TO }, \
+ 	{ "jump-back",		0, 0, OPT_JUMP_BACK }, \
 	{ "type",		1, 0, OPT_TYPE }, \
 	{ "load-panic",         0, 0, OPT_PANIC }, \
 	{ "mem-min",		1, 0, OPT_MEM_MIN }, \
 	{ "mem-max",		1, 0, OPT_MEM_MAX }, \
 	{ "reuseinitrd",	0, 0, OPT_REUSE_INITRD }, \
 
-#define KEXEC_OPT_STR "hvdfxluet:p"
+#define KEXEC_OPT_STR "hvdfxluejbt:p"
 
 extern void die(char *fmt, ...);
 extern void *xmalloc(size_t size);
