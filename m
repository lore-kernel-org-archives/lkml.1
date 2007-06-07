Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbXFGLFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbXFGLFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 07:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbXFGLEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 07:04:54 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:4887 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbXFGLEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 07:04:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=qePapN7wtfnQTXhO89lBxua1LqHtfmAR3tX7Y71Wsg/ZvfeKj+GWj5ItyVWAEzyskLDJw/WuY7fnnAaHcv5h0QTogd5AvBs+gvlFxilDC7F0su6HBjdyBdD+C9aTY59FOAlvHbmOVtd6vHaKMbMU8EMKY3AoMcgO0puTyU8KQMY=
Message-ID: <a781481a0706070404r67a02caoc1b8b0f3a8f0f00b@mail.gmail.com>
Date: Thu, 7 Jun 2007 16:34:52 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386/x86_64: NMI watchdog: Remove spurious local_irq_enable() in check_nmi_watchdog()
Cc: "Ingo Molnar" <mingo@redhat.com>, "Andi Kleen" <ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There appears to be a spurious local_irq_enable() in the
check_nmi_watchdog() of both i386 and x86_64, I cannot see
when are interrupts being disabled before it. In fact we
seem to be allocating with GFP_KERNEL and calling
smp_call_function() just before this call, which suggests
this call to local_irq_enable() is spurious and can be
removed.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/nmi.c   |    1 -
 arch/x86_64/kernel/nmi.c |    1 -
 2 files changed, 2 deletions(-)

---

diff -ruNp a/arch/i386/kernel/nmi.c b/arch/i386/kernel/nmi.c
--- a/arch/i386/kernel/nmi.c	2007-06-07 12:46:34.000000000 +0530
+++ b/arch/i386/kernel/nmi.c	2007-06-07 15:37:57.000000000 +0530
@@ -94,7 +94,6 @@ static int __init check_nmi_watchdog(voi

 	for_each_possible_cpu(cpu)
 		prev_nmi_count[cpu] = per_cpu(irq_stat, cpu).__nmi_count;
-	local_irq_enable();
 	mdelay((20*1000)/nmi_hz); // wait 20 ticks

 	for_each_possible_cpu(cpu) {
diff -ruNp a/arch/x86_64/kernel/nmi.c b/arch/x86_64/kernel/nmi.c
--- a/arch/x86_64/kernel/nmi.c	2007-06-07 12:46:39.000000000 +0530
+++ b/arch/x86_64/kernel/nmi.c	2007-06-07 15:34:19.000000000 +0530
@@ -104,7 +104,6 @@ int __init check_nmi_watchdog (void)

 	for (cpu = 0; cpu < NR_CPUS; cpu++)
 		counts[cpu] = cpu_pda(cpu)->__nmi_count;
-	local_irq_enable();
 	mdelay((20*1000)/nmi_hz); // wait 20 ticks

 	for_each_online_cpu(cpu) {
