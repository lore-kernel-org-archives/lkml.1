Return-Path: <linux-kernel-owner+w=401wt.eu-S1752344AbZISSeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbZISSeL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 14:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbZISSeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 14:34:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:43481 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbZISSeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 14:34:09 -0400
Date: Sat, 19 Sep 2009 18:33:42 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AB51DFD.2000904@kernel.org>
References: <4AB51DFD.2000904@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] Revert 'x86: Fix system crash when loading with "reservetop" parameter'
Message-ID: <tip-eda6da9286ad5b35b1eb70f6368958a8ee41a9dd@git.kernel.org>
Git-Commit-ID: eda6da9286ad5b35b1eb70f6368958a8ee41a9dd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 19 Sep 2009 18:33:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eda6da9286ad5b35b1eb70f6368958a8ee41a9dd
Gitweb:     http://git.kernel.org/tip/eda6da9286ad5b35b1eb70f6368958a8ee41a9dd
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sat, 19 Sep 2009 11:07:57 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 19 Sep 2009 20:31:33 +0200

Revert 'x86: Fix system crash when loading with "reservetop" parameter'

After close looking, commit 8126dec3 will break:

 1. some cpu feature  in early stage too, like cpu_has_x2apic
 2. will break built-in-command line
 3. will break other memmap= and mem=
 4. early_dbgp and early_console that will use early_ioremap to access mmio (?)

So revert it.

Reported-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
Cc: Andrew Morton <akpm@linux-foundation.org>,
LKML-Reference: <4AB51DFD.2000904@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/setup.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 19f15c4..f5baa2a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -712,21 +712,6 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 #endif
 
-	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
-	*cmdline_p = command_line;
-
-#ifdef CONFIG_X86_64
-	/*
-	 * Must call this twice: Once just to detect whether hardware doesn't
-	 * support NX (so that the early EHCI debug console setup can safely
-	 * call set_fixmap(), and then again after parsing early parameters to
-	 * honor the respective command line option.
-	 */
-	check_efer();
-#endif
-
-	parse_early_param();
-
 	/* VMI may relocate the fixmap; do this before touching ioremap area */
 	vmi_init();
 
@@ -809,6 +794,21 @@ void __init setup_arch(char **cmdline_p)
 #endif
 #endif
 
+	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
+	*cmdline_p = command_line;
+
+#ifdef CONFIG_X86_64
+	/*
+	 * Must call this twice: Once just to detect whether hardware doesn't
+	 * support NX (so that the early EHCI debug console setup can safely
+	 * call set_fixmap(), and then again after parsing early parameters to
+	 * honor the respective command line option.
+	 */
+	check_efer();
+#endif
+
+	parse_early_param();
+
 #ifdef CONFIG_X86_64
 	check_efer();
 #endif
