Return-Path: <linux-kernel-owner+w=401wt.eu-S1757579AbXJCIHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbXJCIHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 04:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbXJCIGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 04:06:37 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35417 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbXJCIGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 04:06:34 -0400
Message-ID: <47034D84.8050505@cn.fujitsu.com>
Date: Wed, 03 Oct 2007 17:06:28 +0900
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: ak@suse.de, discuss@x86-64.org
Subject: [PATCH 3/3] signal(x86-64): alternative signal stack wraparound occurs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing alternative signal stack wraparound.

If a process uses alternative signal stack by using sigaltstack()
and that stack overflow, stack wraparound occurs.
This patch checks whether the signal frame is on the alternative
stack. If the frame is not on there, kill a signal SIGSEGV to the process forcedly
then the process will be terminated.

This patch is for x86-64,version is 2.6.23-rc8.

Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com>

diff -pur linux-2.6.23-rc8.orig/arch/x86_64/ia32/ia32_signal.c 
linux-2.6.23-rc8/arch/x86_64/ia32/ia32_signal.c
--- linux-2.6.23-rc8.orig/arch/x86_64/ia32/ia32_signal.c	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.23-rc8/arch/x86_64/ia32/ia32_signal.c	2007-09-26 12:09:07.000000000 +0900
@@ -428,6 +428,10 @@ int ia32_setup_frame(int sig, struct k_s

  	frame = get_sigframe(ka, regs, sizeof(*frame));

+	if ((ka->sa.sa_flags & SA_ONSTACK)
+		&& (sas_ss_flags((unsigned long) frame) == 0))
+		goto give_sigsegv;
+
  	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
  		goto give_sigsegv;

@@ -518,6 +522,10 @@ int ia32_setup_rt_frame(int sig, struct

  	frame = get_sigframe(ka, regs, sizeof(*frame));

+	if ((ka->sa.sa_flags & SA_ONSTACK)
+		&& (sas_ss_flags((unsigned long) frame) == 0))
+		goto give_sigsegv;
+
  	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
  		goto give_sigsegv;

diff -pur linux-2.6.23-rc8.orig/arch/x86_64/kernel/signal.c linux-2.6.23-rc8/arch/x86_64/kernel/signal.c
--- linux-2.6.23-rc8.orig/arch/x86_64/kernel/signal.c	2007-09-26 09:44:09.000000000 +0900
+++ linux-2.6.23-rc8/arch/x86_64/kernel/signal.c	2007-09-26 12:09:31.000000000 +0900
@@ -235,6 +235,10 @@ static int setup_rt_frame(int sig, struc
  	} else
  		frame = get_stack(ka, regs, sizeof(struct rt_sigframe)) - 8;

+	if ((ka->sa.sa_flags & SA_ONSTACK)
+		&& (sas_ss_flags((unsigned long) frame) == 0))
+		goto give_sigsegv;
+
  	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
  		goto give_sigsegv;


