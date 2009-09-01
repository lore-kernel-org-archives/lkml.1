Return-Path: <linux-kernel-owner+w=401wt.eu-S1753002AbZIAHzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbZIAHzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 03:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbZIAHzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 03:55:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63119 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbZIAHzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 03:55:52 -0400
Message-ID: <4A9CD362.9010906@cn.fujitsu.com>
Date: Tue, 01 Sep 2009 15:55:14 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>, Yinghai Lu <yinghai@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zachary Amsden <zach@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] x86: introduce parse_early_param_alone() to parse param
 early (Was Re: linux-next: reservetop fix disables mem= )
References: <Pine.LNX.4.64.0908241736520.32764@sister.anvils> <4A92D029.8090807@kernel.org> <4A948C4A.8040004@cn.fujitsu.com>
In-Reply-To: <4A948C4A.8040004@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I find the broken patch is still in -tip tree:

Commit-ID:  8126dec32738421afa362114337331337b4be17f
Gitweb:     http://git.kernel.org/tip/8126dec32738421afa362114337331337b4be17f
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Thu, 20 Aug 2009 20:23:11 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 21 Aug 2009 16:40:30 +0200

x86: Fix system crash when loading with "reservetop" parameter

So, this patch is base on it.
---------------------------------------------
Subject: [RFC][PATCH] x86: introduce parse_early_param_alone() to parse param before parse_early_param()

Sometimes, we should parse specific boot parameter alone before
parse_early_param(), such as "reservetop" and "early_ioremap_debug",
like below:

> The main problem is that can't parse 'reservetop' and 'mem'/'memmap'
> parameters at the same time, because we should parse 'mem'/'memmap'
> after e820 map detected, and it might use early_memremap() during
> e820 map detecting, so we should call early_ioremap_init() before it,
> 'reservetop' parameter can change 'FIXADDR_TOP', so we parse
> 'reservetop' first,
> 
> like below sequences:
>   ......
>   ___parse 'reservetop'___  ->
>   early_ioremap_init()	  ->
>   setup_memory_map(); /* might call early_memremap()*/  ->
>   parse_setup_data(); /* might call early_memremap()*/  ->
>   e820_reserve_setup_data();	->
>   ___parse 'mem'/'memmap' and other parameters___
>   ......
> 
> (the same as 'early_ioremap_debug' parameter)
> 
> So, I'm afraid that we need separate parse 'reservetop'/
> 'early_ioremap_debug' parameters early
> 

This patch introduce a new api named parse_early_param_alone() to
do this.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kernel/setup.c |   33 ++++++++++++++++++------------
 include/linux/init.h    |    1 +
 init/main.c             |   50 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 71 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 83ea092..f241c12 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -696,10 +696,28 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 #endif
 
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
 
-	parse_early_param();
+	/*
+	 * We should parse "reservetop" and "early_ioremap_debug" before
+	 * early_ioremap_init().
+	 */
+	parse_early_param_alone("reservetop");
+	parse_early_param_alone("early_ioremap_debug");
 
 	/* VMI may relocate the fixmap; do this before touching ioremap area */
 	vmi_init();
@@ -770,18 +788,7 @@ void __init setup_arch(char **cmdline_p)
 	bss_resource.start = virt_to_phys(&__bss_start);
 	bss_resource.end = virt_to_phys(&__bss_stop)-1;
 
-#ifdef CONFIG_CMDLINE_BOOL
-#ifdef CONFIG_CMDLINE_OVERRIDE
-	strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
-#else
-	if (builtin_cmdline[0]) {
-		/* append boot loader cmdline to builtin */
-		strlcat(builtin_cmdline, " ", COMMAND_LINE_SIZE);
-		strlcat(builtin_cmdline, boot_command_line, COMMAND_LINE_SIZE);
-		strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
-	}
-#endif
-#endif
+	parse_early_param();
 
 #ifdef CONFIG_X86_64
 	check_efer();
diff --git a/include/linux/init.h b/include/linux/init.h
index b30f694..4e0082a 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -242,6 +242,7 @@ struct obs_kernel_param {
 	__setup_param(str, fn, fn, 1)
 
 /* Relies on boot_command_line being set */
+void __init parse_early_param_alone(char * param);
 void __init parse_early_param(void);
 void __init parse_early_options(char *cmdline);
 #endif /* __ASSEMBLY__ */
diff --git a/init/main.c b/init/main.c
index 0ec75ce..d7d155b 100644
--- a/init/main.c
+++ b/init/main.c
@@ -477,6 +477,11 @@ static int __init do_early_param(char *param, char *val)
 	struct obs_kernel_param *p;
 
 	for (p = __setup_start; p < __setup_end; p++) {
+
+		/* Skip it if it has been parsed in do_early_param_alone() */
+		if (unlikely(p->early == -1))
+			continue;
+
 		if ((p->early && strcmp(param, p->str) == 0) ||
 		    (strcmp(param, "console") == 0 &&
 		     strcmp(p->str, "earlycon") == 0)
@@ -490,6 +495,51 @@ static int __init do_early_param(char *param, char *val)
 	return 0;
 }
 
+static char *alone_param __initdata;
+
+static int __init do_early_param_alone(char *param, char *val)
+{
+	struct obs_kernel_param *p;
+
+	BUG_ON(!alone_param);
+
+	if (strcmp(param, alone_param))
+		return 0;
+
+	for (p = __setup_start; p < __setup_end; p++) {
+		if (p->early && strcmp(param, p->str) == 0) {
+
+			WARN(p->early != 1, "%s is not a early param or "
+			     "it has been parsed\n", p->str);
+
+			if (p->setup_func(val) != 0)
+				printk(KERN_WARNING
+				       "Malformed early option '%s'\n", param);
+			/*
+			 * Set p->early to -1 to avoid parse_early_param()
+			 * and obsolete_checksetup() parse it again.
+			 */
+			p->early = -1;
+		}
+	}
+	/* We accept everything at this stage. */
+	return 0;
+}
+
+/*
+ * Parse specific boot parameter alone before parse_early_param().
+ * Note: only early params can do this.
+ */
+void __init parse_early_param_alone(char *param)
+{
+       static __initdata char tmp_cmdline[COMMAND_LINE_SIZE];
+
+       alone_param = param;
+       strlcpy(tmp_cmdline, boot_command_line, COMMAND_LINE_SIZE);
+       parse_args("early param alone", tmp_cmdline, NULL, 0,
+		  do_early_param_alone);
+}
+
 void __init parse_early_options(char *cmdline)
 {
 	parse_args("early options", cmdline, NULL, 0, do_early_param);
-- 
1.6.1.2


