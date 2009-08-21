Return-Path: <linux-kernel-owner+w=401wt.eu-S932336AbZHUOnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbZHUOnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 10:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932314AbZHUOno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 10:43:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:56610 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932268AbZHUOnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 10:43:42 -0400
Date: Fri, 21 Aug 2009 14:43:06 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, xiaoguangrong@cn.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de,
       xiaoguangrong@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <4A8D402F.4080805@cn.fujitsu.com>
References: <4A8D402F.4080805@cn.fujitsu.com>
Subject: [tip:x86/urgent] x86: Fix system crash when loading with "reservetop" parameter
Message-ID: <tip-8126dec32738421afa362114337331337b4be17f@git.kernel.org>
Git-Commit-ID: 8126dec32738421afa362114337331337b4be17f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 21 Aug 2009 14:43:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8126dec32738421afa362114337331337b4be17f
Gitweb:     http://git.kernel.org/tip/8126dec32738421afa362114337331337b4be17f
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Thu, 20 Aug 2009 20:23:11 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 21 Aug 2009 16:40:30 +0200

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
 arch/x86/kernel/setup.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

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
