Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbZHTMXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbZHTMXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 08:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbZHTMXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 08:23:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50058 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753622AbZHTMXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 08:23:41 -0400
Message-ID: <4A8D402F.4080805@cn.fujitsu.com>
Date: Thu, 20 Aug 2009 20:23:11 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, yinghai@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: [PATCH] x86: fix system die when load with "reservetop" parameter
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The system will die if the kernel is booted with "reservetop" parameter,
in present code, parse "reservetop" parameter after early_ioremap_init(),
and some function still use early_ioremap() after it.

The problem is, "reservetop" parameter can modify 'FIXADDR_TOP', then the
virtual address got by early_ioremap() is base on old 'FIXADDR_TOP', but
the page mapping is base on new 'FIXADDR_TOP', it will occur page fault,
and the IDT is not prepare yet, so, the system is dead.

So, put parse_early_param() in the front of early_ioremap_init() in this
patch.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kernel/setup.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 26fce55..aad6149 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -713,6 +713,11 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 #endif
 
+	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
+	*cmdline_p = command_line;
+
+	parse_early_param();
+
 	/* VMI may relocate the fixmap; do this before touching ioremap area */
 	vmi_init();
 
@@ -795,11 +800,6 @@ void __init setup_arch(char **cmdline_p)
 #endif
 #endif
 
-	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
-	*cmdline_p = command_line;
-
-	parse_early_param();
-
 #ifdef CONFIG_X86_64
 	check_efer();
 #endif
-- 
1.6.1.2


