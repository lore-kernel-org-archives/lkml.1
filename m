Return-Path: <linux-kernel-owner+w=401wt.eu-S1422927AbYHFVfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422927AbYHFVfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759095AbYHFV3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:29:10 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:35358 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbYHFV3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:29:07 -0400
X-BigFish: VPS-12(zz14c3M936eQzz10d3izz2f39iz2fh6bh63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
Message-ID: <489A1844.3090502@am.sony.com>
Date: Wed, 6 Aug 2008 14:31:48 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] bootup: Add built-in kernel command line for x86
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Aug 2008 21:28:53.0044 (UTC) FILETIME=[6C9A4F40:01C8F80B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for a built-in command line for x86 architectures.
The Kconfig help gives the major rationale for this addition.

Note that this option is available for many other arches, and
its use is widespread in embedded projects.

This patch addresses concerns that were raised with an
earlier version, regarding precedence between the built-in
command line and the command line provided by the boot
loader.

See the thread at http://lkml.org/lkml/2006/6/11/115
for details.

The default behavior is to append the boot loader string
to this one.  However, there is a mechanism (leading '!')
to force the built-in string to override the boot loader
string.

This implementation covers some important cases mentioned
in the previous thread, namely:
 * boot loaders that can't pass args to the kernel
 * boot loaders that pass incorrect args to the kernel
 * automated testing of kernel command line options,
 without having to address lots of different bootloaders

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
---

Note: If you're copied on this, it's because you seemed
interested in this the last time it was submitted.

This particular implementation adds a space to the
front of the command line, in the default case where
the built-in string is empty.  I don't think this is a
problem, but comments are welcome.  It would be trivial
to remove the extra space, and require people who set
the string to know what they are doing, and add their
own space at the end of the string in the .config.


 arch/x86/Kconfig        |   24 ++++++++++++++++++++++++
 arch/x86/kernel/setup.c |   11 +++++++++++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3d0f2b6..63c181e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1393,6 +1393,30 @@ config COMPAT_VDSO

 	  If unsure, say Y.

+config CMDLINE
+	string "Initial kernel command string"
+	default ""
+	help
+	  On some systems (e.g. embedded ones), there is no way for the
+	  boot loader to pass arguments to the kernel.  On some systems,
+	  the arguments passed by the boot loader are incorrect.  For these
+	  platforms, you can supply command-line options at build
+	  time by entering them here. These will be compiled into the kernel
+	  image and used at boot time.
+
+	  If the boot loader provides a command line at boot time, it is
+	  appended to this string.  To have the kernel ignore the boot loader
+	  command line, and use ONLY the string specified here, use an
+	  exclamation point as the first character of the string.
+	  Example: "!root=/dev/hda1 ro"
+
+         In most cases, the command line (whether built-in or provided
+	  by the boot loader) should specify the device for the root
+	  file system.
+
+	  Systems with fully functional boot loaders (i.e. non-embedded)
+	  should leave this string blank.
+
 endmenu

 config ARCH_ENABLE_MEMORY_HOTPLUG
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 2d88858..298bcee 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -223,6 +223,7 @@ unsigned long saved_video_mode;
 #define RAMDISK_LOAD_FLAG		0x4000

 static char __initdata command_line[COMMAND_LINE_SIZE];
+static char __initdata builtin_cmdline[COMMAND_LINE_SIZE] = CONFIG_CMDLINE;

 #if defined(CONFIG_EDD) || defined(CONFIG_EDD_MODULE)
 struct edd edd;
@@ -665,6 +666,16 @@ void __init setup_arch(char **cmdline_p)
 	bss_resource.start = virt_to_phys(&__bss_start);
 	bss_resource.end = virt_to_phys(&__bss_stop)-1;

+	/* append boot loader cmdline to builtin, unless builtin overrides it */
+	if (builtin_cmdline[0] != '!') {
+		strlcat(builtin_cmdline, " ", COMMAND_LINE_SIZE);
+		strlcat(builtin_cmdline, boot_command_line, COMMAND_LINE_SIZE);
+		strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
+	} else {
+		strlcpy(boot_command_line, &builtin_cmdline[1],
+			COMMAND_LINE_SIZE);
+	}
+
 	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;

-- 
1.5.6


