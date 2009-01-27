Return-Path: <linux-kernel-owner+w=401wt.eu-S1754416AbZA0BeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbZA0BeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 20:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZA0BeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 20:34:06 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:13968 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbZA0BeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 20:34:04 -0500
Subject: Re: [PATCH] Fix BUG: using smp_processor_id() in preemptible code
 in print_fatal_signal()
From: Ed Swierk <eswierk@aristanetworks.com>
To: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       rml@tech9.net, linux-kernel@vger.kernel.org
In-Reply-To: <20090127004124.GA10632@redhat.com>
References: <1233010818.14510.11.camel@localhost.localdomain>
	 <20090126231555.GB6556@elte.hu>
	 <1233012811.14510.18.camel@localhost.localdomain>
	 <20090126233732.GA23128@elte.hu>  <20090127004124.GA10632@redhat.com>
Content-Type: text/plain
Date: Mon, 26 Jan 2009 17:34:00 -0800
Message-Id: <1233020040.14510.121.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-27 at 01:41 +0100, Oleg Nesterov wrote:
> Ed, Ingo, but isn't it better to just use raw_smp_processor_id() in
> __show_regs() ? This is only debug info, the printed CPU doesn't
> have the "exact" meaning.

I guess it doesn't really matter which CPU the signal handling thread
happened to be running on, but are there other situations where
show_regs() is always expected to print the correct CPU (and if not, why
bother printing the CPU at all)?  Disabling preemption here seems the
safest approach and doesn't add much overhead. 

> And, without the comment, it is not easy to see why print_fatal_signal()
> disables preeemption before show_regs().

Agreed; here's an updated patch.

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
-	show_regs(regs);
+	preempt_disable();
+	show_regs(regs); /* calls smp_processor_id(), preemption not allowed */
+	preempt_enable();
 }
 
 static int __init setup_print_fatal_signals(char *str)


