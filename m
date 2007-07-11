Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbXGKHbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbXGKHbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 03:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbXGKHbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 03:31:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:57856 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbXGKHba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 03:31:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,525,1175497200"; 
   d="scan'208";a="248994243"
Subject: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
From: "Huang, Ying" <ying.huang@intel.com>
To: Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 11 Jul 2007 15:30:31 +0000
Message-Id: <1184167831.12556.13.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 11 Jul 2007 07:31:21.0288 (UTC) FILETIME=[7A4ADC80:01C7C38D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kexec base hibernation has some potential advantages over uswsusp and
suspend2. Some most obvious advantages are:

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

The kernel B is run as a crashdump kernel in reserved memory
region. This is the biggest constrains of the patch. It is planed to
be eliminated in the next version. That is, instead of reserving memory
region previously, the needed memory region is backuped before kexec
and restored after jumping back.

Another constrains of the patch is that the CONFIG_ACPI must be turned
off to make kexec jump work. Because ACPI will put devices into low
power state, the kexeced kernel can not be booted properly under
it. This constrains can be eliminated by separating the suspend method
and hibernation method of the devices as proposed earlier in the LKML.

The kexec jump is implemented in the framework of software suspend. In
fact, the kexec based hibernation can be seen as just implementing the
image writing and reading method of software suspend with a kexeced
Linux kernel.

Now, only the i386 architecture is supported. The patch is based on
Linux kernel 2.6.22, and has been tested on my IBM T42.

Usage:

1. Compile kernel with following options selected:

CONFIG_X86_32=y
CONFIG_RELOCATABLE=y # not needed strictly, but it is more convenient with it
CONFIG_KEXEC=y
CONFIG_SOFTWARE_SUSPEND=y
CONFIG_KEXEC_HIBERNATION=y

2. Compile the kexec-tools with kdump and kjump patches added, the
   kdump patch can be found at:

http://lse.sourceforge.net/kdump/patches/kexec-tools-1.101-dkump10.patch

   While, the kexec-tools kjump patch is appended with the mail.

3. Boot compiled kernel, the reserved crash kernel memory region must
   be added to kernel command line as following:

   crashkernel=<XX>M@<XX>M

   Where, <XX> should be replaced by the real memory size and position.
Kexec jump - The first step to kexec base hibernation

Kexec base hibernation has some potential advantages over uswsusp and
suspend2. Some most obvious advantages are:

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

The kernel B is run as a crashdump kernel in reserved memory
region. This is the biggest constrains of the patch. It is planed to
be eliminated in the next version. That is, instead of reserving memory
region previously, the needed memory region is backuped before kexec
and restored after jumping back.

Another constrains of the patch is that the CONFIG_ACPI must be turned
off to make kexec jump work. Because ACPI will put devices into low
power state, the kexeced kernel can not be booted properly under
it. This constrains can be eliminated by separating the suspend method
and hibernation method of the devices as proposed earlier in the LKML.

The kexec jump is implemented in the framework of software suspend. In
fact, the kexec based hibernation can be seen as just implementing the
image writing and reading method of software suspend with a kexeced
Linux kernel.

Now, only the i386 architecture is supported. The patch is based on
Linux kernel 2.6.22, and has been tested on my IBM T42.

Usage:

1. Compile kernel with following options selected:

CONFIG_X86_32=y
CONFIG_RELOCATABLE=y # not needed strictly, but it is more convenient with it
CONFIG_KEXEC=y
CONFIG_SOFTWARE_SUSPEND=y
CONFIG_KEXEC_HIBERNATION=y

2. Compile the kexec-tools with kdump and kjump patches added, the
   kdump patch can be found at:

http://lse.sourceforge.net/kdump/patches/kexec-tools-1.101-dkump10.patch

   While, the kexec-tools kjump patch is appended with the mail.

3. Boot compiled kernel, the reserved crash kernel memory region must
   be added to kernel command line as following:

   crashkernel=<XX>M@<XX>M

   Where, <XX> should be replaced by the real memory size and position.

4. Switch hibernation image operations, through shell command as follow:

   echo kexec > /sys/power/hibernation_image_ops

5. Boot the kexeced kernel as a crashdump kernel, the same kernel can
   be used if CONFIG_RELOCATABLE=y is selected. The kernel command
   line option as following must be appended to kernel command line.

   kexec_jump_buf_pfn=`cat /sys/kernel/kexec_jump_buf_pfn`

6. In the kexec booted kernel, switch hibernation image operations, as
   in 4.

7. In the kexec booted kernel, trigger the jumping back with following
   shell command.

   echo <a>:<b> > /sys/power/resume

   Where <a> and <b> is non-negative integer, at least one of them must
   be non-zero.

Hibernation image operations

This patch make it possible to have multiple implementations of
hibernation image operations such as write, read, check, etc, and they
can be switched at run time through writing the
"/sys/power/hibernation_image_ops". The uswsusp is the default
implementation.

Signed-off-by: Huang Ying <ying.huang@intel.com>

Kexec jump

This patch provide the kexec based implementation of hibernation image
operation. Now, only jumping between original kernel and kexeced
kernel is supported, real image write/read/check will be provided in
next patches.

Signed-off-by: Huang Ying <ying.huang@intel.com>

4. Switch hibernation image operations, through shell command as follow:

   echo kexec > /sys/power/hibernation_image_ops

5. Boot the kexeced kernel as a crashdump kernel, the same kernel Kexec jump - The first step to kexec base hibernation

Kexec base hibernation has some potential advantages over uswsusp and
suspend2. Some most obvious advantages are:

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

The kernel B is run as a crashdump kernel in reserved memory
region. This is the biggest constrains of the patch. It is planed to
be eliminated in the next version. That is, instead of reserving memory
region previously, the needed memory region is backuped before kexec
and restored after jumping back.

Another constrains of the patch is that the CONFIG_ACPI must be turned
off to make kexec jump work. Because ACPI will put devices into low
power state, the kexeced kernel can not be booted properly under
it. This constrains can be eliminated by separating the suspend method
and hibernation method of the devices as proposed earlier in the LKML.

The kexec jump is implemented in the framework of software suspend. In
fact, the kexec based hibernation can be seen as just implementing the
image writing and reading method of software suspend with a kexeced
Linux kernel.

Now, only the i386 architecture is supported. The patch is based on
Linux kernel 2.6.22, and has been tested on my IBM T42.

Usage:

1. Compile kernel with following options selected:

CONFIG_X86_32=y
CONFIG_RELOCATABLE=y # not needed strictly, but it is more convenient with it
CONFIG_KEXEC=y
CONFIG_SOFTWARE_SUSPEND=y
CONFIG_KEXEC_HIBERNATION=y

2. Compile the kexec-tools with kdump and kjump patches added, the
   kdump patch can be found at:

http://lse.sourceforge.net/kdump/patches/kexec-tools-1.101-dkump10.patch

   While, the kexec-tools kjump patch is appended with the mail.

3. Boot compiled kernel, the reserved crash kernel memory region must
   be added to kernel command line as following:

   crashkernel=<XX>M@<XX>M

   Where, <XX> should be replaced by the real memory size and position.

4. Switch hibernation image operations, through shell command as follow:

   echo kexec > /sys/power/hibernation_image_ops

5. Boot the kexeced kernel as a crashdump kernel, the same kernel can
   be used if CONFIG_RELOCATABLE=y is selected. The kernel command
   line option as following must be appended to kernel command line.

   kexec_jump_buf_pfn=`cat /sys/kernel/kexec_jump_buf_pfn`

6. In the kexec booted kernel, switch hibernation image operations, as
   in 4.

7. In the kexec booted kernel, trigger the jumping back with following
   shell command.

   echo <a>:<b> > /sys/power/resume

   Where <a> and <b> is non-negative integer, at least one of them must
   be non-zero.

Hibernation image operations

This patch make it possible to have multiple implementations of
hibernation image operations such as write, read, check, etc, and they
can be switched at run time through writing the
"/sys/power/hibernation_image_ops". The uswsusp is the default
implementation.

Signed-off-by: Huang Ying <ying.huang@intel.com>

Kexec jump

This patch provide the kexec based implementation of hibernation image
operation. Now, only jumping between original kernel and kexeced
kernel is supported, real image write/read/check will be provided in
next patches.

Signed-off-by: Huang Ying <ying.huang@intel.com>
can
   be used if CONFIG_RELOCATABLE=y is selected. The kernel command
   line option as following must be appended to kernel command line.

   kexec_jump_buf_pfn=`cat /sys/kernel/kexec_jump_buf_pfn`

6. In the kexec booted kernel, switch hibernation image operations, as
   in 4.

7. In the kexec booted kernel, trigger the jumping back with following
   shell command.

   echo <a>:<b> > /sys/power/resume

   Where <a> and <b> is non-negative integer, at least one of them must
   be non-zero.

Index: kexec-tools-1.101/kexec/arch/i386/crashdump-x86.c
===================================================================
--- kexec-tools-1.101.orig/kexec/arch/i386/crashdump-x86.c	2007-07-08 15:00:25.000000000 +0000
+++ kexec-tools-1.101/kexec/arch/i386/crashdump-x86.c	2007-07-09 22:58:46.000000000 +0000
@@ -428,6 +428,33 @@
 	return 0;
 }
 
+/* Adds the kexec_backup= command line parameter to command line. */
+static int cmdline_add_backup(char *cmdline, unsigned long addr)
+{
+	int cmdlen, len, align = 1024;
+	char str[30], *ptr;
+
+	/* Passing in kexec_backup=xxxK format. Saves space required in cmdline.
+	 * Ensure 1K alignment*/
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
+#if 0
+		printf("Command line after adding backup\n");
+		printf("%s\n", cmdline);
+#endif
+	return 0;
+}
 
 /*
  * This routine is specific to i386 architecture to maintain the
@@ -724,5 +751,6 @@
 		return -1;
 	cmdline_add_memmap(mod_cmdline, memmap_p);
 	cmdline_add_elfcorehdr(mod_cmdline, elfcorehdr);
+	cmdline_add_backup(mod_cmdline, info->backup_start);
 	return 0;
 }
