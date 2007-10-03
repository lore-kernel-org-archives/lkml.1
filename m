Return-Path: <linux-kernel-owner+w=401wt.eu-S1757086AbXJCIHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086AbXJCIHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 04:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753210AbXJCIG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 04:06:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34929 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbXJCIGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 04:06:25 -0400
Message-ID: <47034D80.2080408@cn.fujitsu.com>
Date: Wed, 03 Oct 2007 17:06:24 +0900
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] signal(i386): alternative signal stack wraparound occurs
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

This patch is for i386,version is 2.6.23-rc8.

Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com>

diff -pur linux-2.6.23-rc8.orig/arch/i386/kernel/signal.c linux-2.6.23-rc8/arch/i386/kernel/signal.c
--- linux-2.6.23-rc8.orig/arch/i386/kernel/signal.c	2007-09-26 09:44:08.000000000 +0900
+++ linux-2.6.23-rc8/arch/i386/kernel/signal.c	2007-09-26 13:14:25.000000000 +0900
@@ -332,6 +332,10 @@ static int setup_frame(int sig, struct k

  	frame = get_sigframe(ka, regs, sizeof(*frame));

+	if ((ka->sa.sa_flags & SA_ONSTACK) &&
+		!sas_ss_flags((unsigned long)frame))
+		goto give_sigsegv;
+
  	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
  		goto give_sigsegv;

@@ -425,6 +429,10 @@ static int setup_rt_frame(int sig, struc

  	frame = get_sigframe(ka, regs, sizeof(*frame));

+	if ((ka->sa.sa_flags & SA_ONSTACK) &&
+		!sas_ss_flags((unsigned long)frame))
+		goto give_sigsegv;
+
  	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
  		goto give_sigsegv;


