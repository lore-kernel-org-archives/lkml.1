Return-Path: <linux-kernel-owner+w=401wt.eu-S1751267AbZH1NLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267AbZH1NLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 09:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbZH1NLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 09:11:54 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:32941 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbZH1NLy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 09:11:54 -0400
Message-Id: <4A97F3BD02000078000121B9@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 28 Aug 2009 14:11:57 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <yhlu.kernel@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: fix earlyprintk=dbgp for machines without NX
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since parse_early_param() may (e.g. for earlyprintk=dbgp) involve calls
to page table manipulation functions (here set_fixmap_nocache()), NX
hardware support must be determined before calling that function (so
that __supported_pte_mask gets properly set up). But the call after
parse_early_param() can also not go away, as that will honor eventual
command line specified disabling of the NX functionality (this will
then just result in whatever mappings got established during
parse_early_param() having the NX bit set despite it being disabled on
the command line, but I think that's tolerable).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- linux-2.6.31-rc8/arch/x86/kernel/setup.c	2009-08-28 14:57:38.000000000 +0200
+++ 2.6.31-rc8-x86_64-check-efer-earlier/arch/x86/kernel/setup.c	2009-08-28 14:52:33.000000000 +0200
@@ -796,6 +796,16 @@ void __init setup_arch(char **cmdline_p)
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
 
 #ifdef CONFIG_X86_64



