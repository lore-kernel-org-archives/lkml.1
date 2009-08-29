Return-Path: <linux-kernel-owner+w=401wt.eu-S1752386AbZH2N6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbZH2N6b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 09:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbZH2N6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 09:58:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:36497 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbZH2N61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 09:58:27 -0400
Date: Sat, 29 Aug 2009 13:58:06 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yhlu.kernel@gmail.com, jbeulich@novell.com, JBeulich@novell.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yhlu.kernel@gmail.com, jbeulich@novell.com, JBeulich@novell.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A97F3BD02000078000121B9@vpn.id2.novell.com>
References: <4A97F3BD02000078000121B9@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/pat] x86: Fix earlyprintk=dbgp for machines without NX
Message-ID: <tip-47d25003cbd9e9030a95f7ccc4e70fec6aa7b844@git.kernel.org>
Git-Commit-ID: 47d25003cbd9e9030a95f7ccc4e70fec6aa7b844
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 29 Aug 2009 13:58:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  47d25003cbd9e9030a95f7ccc4e70fec6aa7b844
Gitweb:     http://git.kernel.org/tip/47d25003cbd9e9030a95f7ccc4e70fec6aa7b844
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Fri, 28 Aug 2009 14:11:57 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 29 Aug 2009 15:47:32 +0200

x86: Fix earlyprintk=dbgp for machines without NX

Since parse_early_param() may (e.g. for earlyprintk=dbgp)
involve calls to page table manipulation functions (here
set_fixmap_nocache()), NX hardware support must be determined
before calling that function (so that __supported_pte_mask gets
properly set up).

But the call after parse_early_param() can also not go away, as
that will honor eventual command line specified disabling of
the NX functionality.

( This will then just result in whatever mappings got
  established during parse_early_param() having the NX bit set
  despite it being disabled on the command line, but I think
  that's tolerable).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
LKML-Reference: <4A97F3BD02000078000121B9@vpn.id2.novell.com>
[ merged to x86/pat to resolve a conflict. ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/setup.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 02643cc..eb1f1e6 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -714,6 +714,16 @@ void __init setup_arch(char **cmdline_p)
 	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
 
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
 	parse_early_param();
 
 	/* VMI may relocate the fixmap; do this before touching ioremap area */
