Return-Path: <linux-kernel-owner+w=401wt.eu-S1752754AbZHXQp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbZHXQp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 12:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbZHXQp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 12:45:56 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:19074 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752499AbZHXQpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 12:45:55 -0400
X-Trace: 248567366/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.90.35/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.90.35
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlYIAC9gkkpQKVoj/2dsb2JhbACBU448AcZBhBoF
X-IronPort-AV: E=Sophos;i="4.44,266,1249254000"; 
   d="scan'208";a="248567366"
Date: Mon, 24 Aug 2009 17:45:26 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Ingo Molnar <mingo@elte.hu>
cc: Xiao Guangrong <xiaooguangrong@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, yinghai@kernel.org,
       linux-kernel@vger.kernel.org
Subject: linux-next: reservetop fix disables mem=
Message-ID: <Pine.LNX.4.64.0908241736520.32764@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I find the "mem=" boot parameter disabled in today's linux-next:
reverting the tip commit below fixes that.

Hugh

From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Date: Thu, 20 Aug 2009 12:23:11 +0000 (+0800)
Subject: x86: Fix system crash when loading with "reservetop" parameter
X-Git-Url: http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fmingo%2Flinux-2.6-x86.git;a=commitdiff_plain;h=8126dec32738421afa362114337331337b4be17f

x86: Fix system crash when loading with "reservetop" parameter

The system will die if the kernel is booted with "reservetop"
parameter, in present code, parse "reservetop" parameter after
early_ioremap_init(), and some function still use
early_ioremap() after it.

The problem is, "reservetop" parameter can modify
'FIXADDR_TOP', then the virtual address got by early_ioremap()
is base on old 'FIXADDR_TOP', but the page mapping is base on
new 'FIXADDR_TOP', it will occur page fault, and the IDT is not
prepare yet, so, the system is dead.

So, put parse_early_param() in the front of
early_ioremap_init() in this patch.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: yinghai@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <4A8D402F.4080805@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 63f32d2..02643cc 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -711,6 +711,11 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 #endif
 
+	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
+	*cmdline_p = command_line;
+
+	parse_early_param();
+
 	/* VMI may relocate the fixmap; do this before touching ioremap area */
 	vmi_init();
 
@@ -793,11 +798,6 @@ void __init setup_arch(char **cmdline_p)
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
