Return-Path: <linux-kernel-owner+w=401wt.eu-S1757383AbYKWBvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbYKWBvy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 20:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754951AbYKWBvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 20:51:44 -0500
Received: from ag-out-0708.google.com ([72.14.246.250]:9127 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938AbYKWBvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 20:51:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=xqnQdyImafZVJ6bi8/WKr0P+g+pF64Rw6TuicUkzjvk9RNKuoDMTlhgoSPnm/D+k9F
         C+nIqLS3bIJ+UydjSnQyaYXu5RuazJXRdoMaRIcXTbcCmbUJ1xwEog6I9nn77+wPPc3X
         XBFisREevHmyEeqafNjg/pY49St6CEbtGDg98=
Message-ID: <4928B72D.20901@gmail.com>
Date: Sun, 23 Nov 2008 09:51:41 +0800
From: jia zhang <jia.zhang2008@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>, hpa@zytor.com
Subject: [PATCH] x86_64: fix the check point in stack_overflow_check
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stack_overflow_check() should consider the stack usage of pt_regs, and thus it could warn us in advance. Additionally, it looks a bit good that the warning time starts at INITIAL_JIFFIES.

Signed-off-by: jia zhang <jia.zhang2008@gmail.com>
---
Assume at the moment rsp get close to the check point before interrupt arrives.
When interrupt really happens, thread_info will be partly overrode.

 arch/x86/kernel/irq_64.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -29,11 +29,12 @@
 static inline void stack_overflow_check(struct pt_regs *regs)
 {
 	u64 curbase = (u64)task_stack_page(current);
-	static unsigned long warned = -60*HZ;
+	static unsigned long warned = INITIAL_JIFFIES - 60*HZ;
 
 	if (regs->sp >= curbase && regs->sp <= curbase + THREAD_SIZE &&
-	    regs->sp <  curbase + sizeof(struct thread_info) + 128 &&
-	    time_after(jiffies, warned + 60*HZ)) {
+			regs->sp < curbase + sizeof(struct thread_info) +
+			sizeof(struct pt_regs) + 128 &&
+			time_after(jiffies, warned + 60*HZ)) {
 		printk("do_IRQ: %s near stack overflow (cur:%Lx,sp:%lx)\n",
 		       current->comm, curbase, regs->sp);
 		show_stack(NULL,NULL);

