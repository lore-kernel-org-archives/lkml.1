Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbYKVJKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbYKVJKk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 04:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbYKVJKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 04:10:24 -0500
Received: from mail-gx0-f29.google.com ([209.85.217.29]:42166 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbYKVJKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 04:10:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=CIOXuzb6AT6iT6G5s36ELBVizxIRYorY5sswaqm3TG2iIW+BuECBVf9FuIwXM+KRPy
         0NPXoozWyEEO3qGCFH7BJNiUM49z88MwfCPglYCYdQM3jTGhxV4bikgnnxjJMG1yRvr2
         TmtVweYbj5pGHEQSyya7pd/IiCWXAjjSSzRnk=
Message-ID: <4927CC79.5060405@gmail.com>
Date: Sat, 22 Nov 2008 17:10:17 +0800
From: jia zhang <jia.zhang2008@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: mingo@redhat.com
CC: linux-kernel@vger.kernel.org
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

 b/arch/x86/kernel/irq_64.c |    7 ++++---
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
