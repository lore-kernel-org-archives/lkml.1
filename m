Return-Path: <linux-kernel-owner+w=401wt.eu-S1762189AbXHQGQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762189AbXHQGQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 02:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbXHQGQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 02:16:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:16440 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758467AbXHQGQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 02:16:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,274,1183359600"; 
   d="scan'208";a="280205748"
Subject: Re: [linux-pm] Re: [PATH 1/1] Kexec jump - v2 - kexec jump
From: "Huang, Ying" <ying.huang@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: david@lang.hm, nigel@nigel.suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
In-Reply-To: <20070816102635.GA2039@elf.ucw.cz>
References: <1184483639.1898.99.camel@caritas-dev.intel.com>
	 <20070731095101.GA1774@elf.ucw.cz>
	 <1185954978.1363.23.camel@caritas-dev.intel.com>
	 <20070816102635.GA2039@elf.ucw.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 17 Aug 2007 14:15:49 +0800
Message-Id: <1187331349.28497.9.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 17 Aug 2007 06:15:18.0410 (UTC) FILETIME=[FBE3AEA0:01C7E095]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Pavel,

On Thu, 2007-08-16 at 12:26 +0200, Pavel Machek wrote:
> Ping... is there some next version?
> 
> I'm stuck at the tools side currently. kexec-1.101 just won't load the
> kernel properly, and kexec-testing from git does not know -j option. I
> tried hand-patching it, but got lots of scary rejects.
> 
> Is there chance for a patch against kexec-testing?

I have some other work to do recently. So the next version will delay
for some while. :(

But now, I have a patch against kexec-tools-testing.

Best Regards,
Huang Ying

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
+++ kexec-tools/kexec/kexec-syscall.h	2007-08-17 13:49:50.000000000 +0800
@@ -21,6 +21,7 @@
 #define LINUX_REBOOT_CMD_KEXEC_OLD	0x81726354
 #define LINUX_REBOOT_CMD_KEXEC_OLD2	0x18263645
 #define LINUX_REBOOT_CMD_KEXEC		0x45584543
+#define LINUX_REBOOT_CMD_KJUMP		0x3928A5FD
 
 #ifdef __i386__
 #define __NR_kexec_load		283
@@ -63,6 +64,10 @@
 	return (long) syscall(__NR_reboot, LINUX_REBOOT_MAGIC1, LINUX_REBOOT_MAGIC2, LINUX_REBOOT_CMD_KEXEC, 0);
 }
 
+static inline long kexec_jump(void)
+{
+	return (long) syscall(__NR_reboot, LINUX_REBOOT_MAGIC1, LINUX_REBOOT_MAGIC2, LINUX_REBOOT_CMD_KJUMP, 0);
+}
 
 #define KEXEC_ON_CRASH  0x00000001
 #define KEXEC_ARCH_MASK 0xffff0000
Index: kexec-tools/kexec/kexec.c
===================================================================
--- kexec-tools.orig/kexec/kexec.c	2007-08-17 13:48:51.000000000 +0800
+++ kexec-tools/kexec/kexec.c	2007-08-17 13:49:50.000000000 +0800
@@ -716,6 +716,17 @@
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
 	printf(PACKAGE " " VERSION " released " RELEASE_DATE "\n");
@@ -743,6 +754,7 @@
 	       "                      If capture kernel is being unloaded\n"
 	       "                      specify -p with -u.\n"
 	       " -e, --exec           Execute a currently loaded kernel.\n"
+ 	       " -j, --jump           Jump to a currently loaded kernel or jump back to the previous kernel.\n"
 	       " -t, --type=TYPE      Specify the new kernel is of this type.\n"
 	       "     --mem-min=<addr> Specify the lowest memory address to\n"
 	       "                      load code into.\n"
@@ -803,6 +815,7 @@
 {
 	int do_load = 1;
 	int do_exec = 0;
+	int do_jump = 0;
 	int do_shutdown = 1;
 	int do_sync = 1;
 	int do_ifdown = 0;
@@ -858,6 +871,14 @@
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
@@ -949,6 +970,9 @@
 	if ((result == 0) && do_exec) {
 		result = my_exec();
 	}
+	if ((result == 0) && do_jump) {
+		result = my_jump();
+	}
 
 	fflush(stdout);
 	fflush(stderr);
Index: kexec-tools/kexec/kexec.h
===================================================================
--- kexec-tools.orig/kexec/kexec.h	2007-08-17 13:48:51.000000000 +0800
+++ kexec-tools/kexec/kexec.h	2007-08-17 13:49:50.000000000 +0800
@@ -156,6 +156,7 @@
 #define OPT_FORCE		'f'
 #define OPT_NOIFDOWN		'x'
 #define OPT_EXEC		'e'
+#define OPT_JUMP		'j'
 #define OPT_LOAD		'l'
 #define OPT_UNLOAD		'u'
 #define OPT_TYPE		't'
@@ -172,13 +173,14 @@
 	{ "load",		0, 0, OPT_LOAD }, \
 	{ "unload",		0, 0, OPT_UNLOAD }, \
 	{ "exec",		0, 0, OPT_EXEC }, \
+ 	{ "jump",		0, 0, OPT_JUMP }, \
 	{ "type",		1, 0, OPT_TYPE }, \
 	{ "load-panic",         0, 0, OPT_PANIC }, \
 	{ "mem-min",		1, 0, OPT_MEM_MIN }, \
 	{ "mem-max",		1, 0, OPT_MEM_MAX }, \
 	{ "reuseinitrd",	0, 0, OPT_REUSE_INITRD }, \
 
-#define KEXEC_OPT_STR "hvdfxluet:p"
+#define KEXEC_OPT_STR "hvdfxluejt:p"
 
 extern void die(char *fmt, ...);
 extern void *xmalloc(size_t size);
