Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbZAZXdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbZAZXdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 18:33:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbZAZXdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 18:33:36 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:4168 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbZAZXdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 18:33:35 -0500
Subject: Re: [PATCH] Fix BUG: using smp_processor_id() in preemptible code
 in print_fatal_signal()
From: Ed Swierk <eswierk@aristanetworks.com>
To: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       rml@tech9.net, linux-kernel@vger.kernel.org
In-Reply-To: <20090126231555.GB6556@elte.hu>
References: <1233010818.14510.11.camel@localhost.localdomain>
	 <20090126231555.GB6556@elte.hu>
Content-Type: text/plain
Date: Mon, 26 Jan 2009 15:33:31 -0800
Message-Id: <1233012811.14510.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-27 at 00:15 +0100, Ingo Molnar wrote:
> This trades a (harmless) debug warning against a potential deadlock or 
> even a crash, because print_fatal_signal() can do this:
> 
>                         __get_user(insn, (unsigned char *)(regs->ip + i));
> 
> which will work without a fault most of the time but might also generate a 
> pagefault and schedule away from atomic context.

Ouch!

> So please add preempt_disable()+preempt_enable() calls around the 
> show_regs() call instead.

Take 2:

With print-fatal-signals=1 on a kernel with CONFIG_PREEMPT=y, sending an
unexpected signal to a process causes a BUG: using smp_processor_id() in
preemptible code.

get_signal_to_deliver() releases the siglock before calling
print_fatal_signal(), which calls show_regs(), which calls
smp_processor_id(), which is not supposed to be called from a
preemptible thread.

Signed-off-by: Ed Swierk <eswierk@aristanetworks.com>

---
Index: linux-2.6.27.4/kernel/signal.c
===================================================================
--- linux-2.6.27.4.orig/kernel/signal.c
+++ linux-2.6.27.4/kernel/signal.c
@@ -890,7 +890,9 @@ static void print_fatal_signal(struct pt
 	}
 #endif
 	printk("\n");
+	preempt_disable();
 	show_regs(regs);
+	preempt_enable();
 }
 
 static int __init setup_print_fatal_signals(char *str)


