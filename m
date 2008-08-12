Return-Path: <linux-kernel-owner+w=401wt.eu-S1752923AbYHLTuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbYHLTuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 15:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbYHLTtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 15:49:55 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:14413 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbYHLTtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 15:49:53 -0400
X-BigFish: VPS-33(zz1432R98dR936eQ1805Mzz10d3izzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <48A1EA04.7090102@am.sony.com>
Date: Tue, 12 Aug 2008 12:52:36 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, linux kernel <linux-kernel@vger.kernel.org>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] bootup: Add built-in kernel command line for x86 (v2)
References: <489A1844.3090502@am.sony.com> <20080811191012.GA16553@elte.hu> <48A091B7.6050601@zytor.com>
In-Reply-To: <48A091B7.6050601@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Aug 2008 19:49:38.0238 (UTC) FILETIME=[8DBD85E0:01C8FCB4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow x86 to support a built-in kernel command line.  The built-in
command line can override the one provided by the boot loader, for
those cases where the boot loader is broken or it is difficult
to change the command line in the the boot loader.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
---
 arch/x86/Kconfig        |   45 +++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup.c |   16 ++++++++++++++++
 2 files changed, 61 insertions(+), 0 deletions(-)

H. Peter Anvin wrote:
> Ingo Molnar wrote:
>> Best would be to make it really apparent in the code that nothing
>> changes if this config option is not set. Preferably there should be
>> no extra code at all in that case.
>>
>
> I would like to see this:
[...Nested ifdefs...]

OK. This version changes absolutely nothing if CONFIG_CMDLINE_BOOL is not
set (the default).  Also, no space is appended even when CONFIG_CMDLINE_BOOL
is set, but the builtin string is empty.  This is less sloppy all the way
around, IMHO.

Note that I use the same option names as on other arches for
this feature.

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3d0f2b6..f7bbbd7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1393,6 +1393,51 @@ config COMPAT_VDSO

 	  If unsure, say Y.

+config CMDLINE_BOOL
+	bool "Built-in kernel command line"
+	default n
+	help
+	  Allow for specifying boot arguments to the kernel at
+	  build time.  On some systems (e.g. embedded ones), it is
+	  necessary or convenient to provide some or all of the
+	  kernel boot arguments with the kernel itself (that is,
+	  to not rely on the boot loader to provide them.)
+
+	  To compile command line arguments into the kernel,
+         set this option to 'Y', then fill in the
+	  the boot arguments in CONFIG_CMDLINE.
+
+	  Systems with fully functional boot loaders (i.e. non-embedded)
+	  should leave this option set to 'N'.
+
+config CMDLINE
+	string "Built-in kernel command string"
+	depends on CMDLINE_BOOL
+	default ""
+	help
+	  Enter arguments here that should be compiled into the kernel
+	  image and used at boot time.  If the boot loader provides a
+	  command line at boot time, it is appended to this string to
+	  form the full kernel command line, when the system boots.
+
+	  However, you can use the CONFIG_CMDLINE_OVERRIDE option to
+	  change this behavior.
+
+         In most cases, the command line (whether built-in or provided
+	  by the boot loader) should specify the device for the root
+	  file system.
+
+config CMDLINE_OVERRIDE
+	bool "Built-in command line overrides boot loader arguments"
+	default n
+	depends on CMDLINE_BOOL
+	help
+	  Set this option to 'Y' to have the kernel ignore the boot loader
+	  command line, and use ONLY the built-in command line.
+
+	  This is used to work around broken boot loaders.  This should
+	  be set to 'N' under normal conditions.
+
 endmenu

 config ARCH_ENABLE_MEMORY_HOTPLUG
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 2d88858..492610c 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -223,6 +223,9 @@ unsigned long saved_video_mode;
 #define RAMDISK_LOAD_FLAG		0x4000

 static char __initdata command_line[COMMAND_LINE_SIZE];
+#ifdef CONFIG_CMDLINE_BOOL
+static char __initdata builtin_cmdline[COMMAND_LINE_SIZE] = CONFIG_CMDLINE;
+#endif

 #if defined(CONFIG_EDD) || defined(CONFIG_EDD_MODULE)
 struct edd edd;
@@ -665,6 +668,19 @@ void __init setup_arch(char **cmdline_p)
 	bss_resource.start = virt_to_phys(&__bss_start);
 	bss_resource.end = virt_to_phys(&__bss_stop)-1;

+#ifdef CONFIG_CMDLINE_BOOL
+#ifdef CONFIG_CMDLINE_OVERRIDE
+	strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
+#else
+	if (builtin_cmdline[0]) {
+		/* append boot loader cmdline to builtin */
+		strlcat(builtin_cmdline, " ", COMMAND_LINE_SIZE);
+		strlcat(builtin_cmdline, boot_command_line, COMMAND_LINE_SIZE);
+		strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
+	}
+#endif
+#endif
+
 	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;

-- 
1.5.6

