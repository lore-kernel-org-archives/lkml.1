Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbXGOHOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbXGOHOV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 03:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbXGOHON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 03:14:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:31607 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972AbXGOHOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 03:14:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,539,1175497200"; 
   d="scan'208";a="250603023"
Subject: [PATH 0/1] Kexec jump - v2 - the first step to kexec based
	hibernation
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, david@lang.hm
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 15 Jul 2007 15:13:13 +0800
Message-Id: <1184483593.1898.98.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 15 Jul 2007 07:14:08.0179 (UTC) FILETIME=[BC29F030:01C7C6AF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The changelog between v1 and v2

1. The kexec jump implementation is put into the kexec/kdump
   framework instead of software suspend framework. The device
   and CPU state save/restore code of software suspend is called
   when needed.

2. The same code path is used for both kexec a new kernel and jump
   back to original kernel.

The complete changelog of the patch is as follow:

---

Kexec base hibernation has some potential advantages over uswsusp and
TuxOnIce (suspend2). Some most obvious advantages are:

1. The hibernation image size can exceed half of memory size easily.
2. The hibernation image can be written to and read from almost
   anywhere, such as USB disk, NFS.

This patch implements the functionality of "jumping from kexeced
kernel to original kernel". That is, the following sequence is
possible:

1. Boot a kernel A
2. Work under kernel A
3. Kexec another kernel B in kernel A
4. Work under kernel B
5. Jump from kernel B to kernel A
6. Continue work under kernel A

This is the first step to implement kexec based hibernation. If the
memory image of kernel A is written to or read from a permanent media
in step 4, a preliminary version of kexec based hibernation can be
implemented.

The kernel B run as a crashdump kernel in reserved memory region. This
is the biggest constrains of the patch. It is planed to be eliminated
in the future version. That is, instead of reserving memory region
previously, the needed memory region is backupped before kexec and
restored after jumping back.

Another constrains of the patch is that the CONFIG_ACPI must be turned
off to make kexec jump work. Because ACPI will put devices into low
power state, the kexeced kernel can not be booted properly under
it. This constrains can be eliminated by separating the suspend method
and hibernate method of the devices as proposed earlier in the LKML.

The kexec jump is implemented in the framework of kexec/kdump. In
sys_reboot, a new command named LINUX_REBOOT_CMD_KJUMP is defined to
trigger the jumping to (executing) the new kernel or jump back to the
original kernel.

Now, only the i386 architecture is supported. The patch is based on
Linux kernel 2.6.22, and has been tested on my IBM T42.

Usage:

1. Compile kernel with following options selected:

CONFIG_X86_32=y
CONFIG_RELOCATABLE=y # not needed strictly, but it is more convenient with it
CONFIG_KEXEC=y
CONFIG_PM=y
CONFIG_KEXEC_JUMP=y

2. Compile the kexec-tools with kdump and kjump patches, the
   kdump patch can be found at:

http://lse.sourceforge.net/kdump/patches/kexec-tools-1.101-kdump10.patch

   While, the kexec-tools kjump patch is appended with the mail.

3. Boot kernel compiled for normal usage, the reserved crash kernel
   memory region must be added to kernel command line as following:

   crashkernel=<XX>M@<XX>M

   Where, <XX> should be replaced by the real memory size and position.

4. Load kernel compiled for hibernating usage as a crashdump kernel
   with kexec, the same kernel as that of 3 can be used if
   CONFIG_RELOCATABLE=y is selected. The kernel command line option as
   following must be appended to kernel command line.

   kexec_jump_buf_pfn=`cat /sys/kernel/kexec_jump_buf_pfn`

   For example, the shell command line can be as follow:

   kexec -p /boot/vmlinux --args-linux --append="root=/dev/hdb signal
       kexec_jump_buf_pfn=`cat /sys/kernel/kexec_jump_buf_pfn`"

5. Boot the hibernating kernel with following shell command line:

   kexec -j

6. In the kexec booted kernel, trigger the jumping back with following
   shell command.

   kexec -j

---

changelog of kexec-tools

A new command line option -j/--jump is added to support
jumping/executing the currently loaded kernel or jumping back to the
original kernel. The implementation of -j/--jump is to call
corresponding syscall.

For i386 architecture, the address of backup of 0~640k is passed to
kexeced kernel as a kernel command line option. This is used by
kexeced kernel to restore the backup.

---

Index: kexec-tools-1.101/kexec/arch/i386/crashdump-x86.c
===================================================================
--- kexec-tools-1.101.orig/kexec/arch/i386/crashdump-x86.c	2007-07-08 23:00:25.000000000 +0800
+++ kexec-tools-1.101/kexec/arch/i386/crashdump-x86.c	2007-07-14 17:06:45.000000000 +0800
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
@@ -724,5 +747,6 @@
 		return -1;
 	cmdline_add_memmap(mod_cmdline, memmap_p);
 	cmdline_add_elfcorehdr(mod_cmdline, elfcorehdr);
+	cmdline_add_backup(mod_cmdline, info->backup_start);
 	return 0;
 }
Index: kexec-tools-1.101/kexec/kexec-syscall.h
===================================================================
--- kexec-tools-1.101.orig/kexec/kexec-syscall.h	2007-07-14 17:24:52.000000000 +0800
+++ kexec-tools-1.101/kexec/kexec-syscall.h	2007-07-14 17:27:10.000000000 +0800
@@ -21,6 +21,7 @@
 #define LINUX_REBOOT_CMD_KEXEC_OLD	0x81726354
 #define LINUX_REBOOT_CMD_KEXEC_OLD2	0x18263645
 #define LINUX_REBOOT_CMD_KEXEC		0x45584543
+#define LINUX_REBOOT_CMD_KJUMP		0x3928A5FD
 
 #ifdef __i386__
 #define __NR_kexec_load		283
@@ -60,6 +61,10 @@
 	return (long) syscall(__NR_reboot, LINUX_REBOOT_MAGIC1, LINUX_REBOOT_MAGIC2, LINUX_REBOOT_CMD_KEXEC, 0);
 }
 
+static inline long kexec_jump(void)
+{
+	return (long) syscall(__NR_reboot, LINUX_REBOOT_MAGIC1, LINUX_REBOOT_MAGIC2, LINUX_REBOOT_CMD_KJUMP, 0);
+}
 
 #define KEXEC_ON_CRASH  0x00000001
 #define KEXEC_ARCH_MASK 0xffff0000
Index: kexec-tools-1.101/kexec/kexec.c
===================================================================
--- kexec-tools-1.101.orig/kexec/kexec.c	2007-07-14 16:57:26.000000000 +0800
+++ kexec-tools-1.101/kexec/kexec.c	2007-07-14 21:04:51.000000000 +0800
@@ -660,6 +660,17 @@
 	return -1;
 }
 
+/*
+ *	Jump to the new kernel
+ */
+static int my_jump(void)
+{
+	int result;
+
+	result = kexec_jump();
+	return result;
+}
+
 static void version(void)
 {
 	printf("kexec " VERSION " released " RELEASE_DATE "\n");
@@ -683,6 +694,7 @@
 		" -p, --load-panic     Load the new kernel for use on panic.\n"
 		" -u, --unload         Unload the current kexec target kernel.\n"
 		" -e, --exec           Execute a currently loaded kernel.\n"
+		" -j, --jump           Jump to a currently loaded kernel or jump back to the previous kernel.\n"
 		" -t, --type=TYPE      Specify the new kernel is of this type.\n"
 		"     --mem-min=<addr> Specify the lowest memory addres to load code into.\n"
 		"     --mem-max=<addr> Specify the highest memory addres to load code into.\n"
@@ -715,6 +727,7 @@
 {
 	int do_load = 1;
 	int do_exec = 0;
+	int do_jump = 0;
 	int do_shutdown = 1;
 	int do_sync = 1;
 	int do_ifdown = 0;
@@ -768,6 +781,14 @@
 			do_ifdown = 1;
 			do_exec = 1;
 			break;
+		case OPT_JUMP:
+			do_load = 0;
+			do_shutdown = 0;
+			do_sync = 1;
+			do_ifdown = 0;
+			do_exec = 0;
+			do_jump = 1;
+			break;
 		case OPT_TYPE:
 			type = optarg;
 			break;
@@ -833,6 +854,9 @@
 	if ((result == 0) && do_exec) {
 		result = my_exec();
 	}
+	if ((result == 0) && do_jump) {
+		result = my_jump();
+	}
 
 	fflush(stdout);
 	fflush(stderr);
Index: kexec-tools-1.101/kexec/kexec.h
===================================================================
--- kexec-tools-1.101.orig/kexec/kexec.h	2007-07-14 17:09:28.000000000 +0800
+++ kexec-tools-1.101/kexec/kexec.h	2007-07-14 17:10:43.000000000 +0800
@@ -151,6 +151,7 @@
 #define OPT_FORCE		'f'
 #define OPT_NOIFDOWN		'x'
 #define OPT_EXEC		'e'
+#define OPT_JUMP		'j'
 #define OPT_LOAD		'l'
 #define OPT_UNLOAD		'u'
 #define OPT_TYPE		't'
@@ -166,12 +167,13 @@
 	{ "load",		0, 0, OPT_LOAD }, \
 	{ "unload",		0, 0, OPT_UNLOAD }, \
 	{ "exec",		0, 0, OPT_EXEC }, \
+	{ "jump",		0, 0, OPT_JUMP }, \
 	{ "type",		1, 0, OPT_TYPE }, \
 	{ "load-panic",         0, 0, OPT_PANIC }, \
 	{ "mem-min",		1, 0, OPT_MEM_MIN }, \
 	{ "mem-max",		1, 0, OPT_MEM_MAX }, \
 
-#define KEXEC_OPT_STR "hvdfxluet:p"
+#define KEXEC_OPT_STR "hvdfxluejt:p"
 
 extern void die(char *fmt, ...);
 extern void *xmalloc(size_t size);
