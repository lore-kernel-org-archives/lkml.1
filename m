Return-Path: <linux-kernel-owner+w=401wt.eu-S932331AbXKQThe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331AbXKQThe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 14:37:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764968AbXKQThJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 14:37:09 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39789 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763902AbXKQThH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 14:37:07 -0500
Date: Sat, 17 Nov 2007 11:35:01 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de
Subject: Re: [patch] Printk kernel version in WARN_ON
Message-ID: <20071117113501.5e3e0d43@laptopd505.fenrus.org>
In-Reply-To: <20071117104652.8240af62.akpm@linux-foundation.org>
References: <20071117101552.2a7f34cb@laptopd505.fenrus.org>
	<20071117102720.251107d7.akpm@linux-foundation.org>
	<20071117103947.5b2052f8@laptopd505.fenrus.org>
	<20071117104652.8240af62.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Nov 2007 10:46:52 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> > by ... not too much at least, gcc ought to be quite good at merging
> > same-strings into one, so it's just one extra pointer argument
> > 
> 
> I think I knew that.  At 1000 callsites.

ok so how about putting the same into dump_stack() instead? (see below)
added bonus is that it's now present for all dumps that use
dump_stack(), not just WARN_ON()
(the format I copied from the exact line used by oopses)



Subject: printk kernel version in WARN_ON and other dump_stack users
From: Arjan van de Ven <arjan@linux.intel.com>

today, all oopses contain a version number of the kernel, which is nice
because the people who actually do bother to read the oops get this
vital bit of information always without having to ask the reporter in
another round trip.

However, WARN_ON() and many other dump_stack() users right now lack this 
information; the patch below adds this. This information is essential for 
getting people to use their time effectively when looking at these things;
in addition, it's essential for tools that try to collect statistics about defects.

Please consider, maybe even for 2.6.24 since its so simple and
important for long term quality processes

The code is identical between 32/64 bit; a lot of this code should be unified over time,
the patch keeps the identical-ness in tact.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>



--- linux-2.6.24-rc3/arch/x86/kernel/traps_32.c.org	2007-11-17 11:26:17.000000000 -0800
+++ linux-2.6.24-rc3/arch/x86/kernel/traps_32.c	2007-11-17 11:29:12.000000000 -0800
@@ -283,6 +283,11 @@ void dump_stack(void)
 {
 	unsigned long stack;
 
+	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
+		current->pid, current->comm, print_tainted(),
+		init_utsname()->release,
+		(int)strcspn(init_utsname()->version, " "),
+		init_utsname()->version);
 	show_trace(current, NULL, &stack);
 }
 
--- linux-2.6.24-rc3/arch/x86/kernel/traps_64.c.org	2007-11-17 11:26:25.000000000 -0800
+++ linux-2.6.24-rc3/arch/x86/kernel/traps_64.c	2007-11-17 11:29:22.000000000 -0800
@@ -400,6 +400,12 @@ void show_stack(struct task_struct *tsk,
 void dump_stack(void)
 {
 	unsigned long dummy;
+
+	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
+		current->pid, current->comm, print_tainted(),
+		init_utsname()->release,
+		(int)strcspn(init_utsname()->version, " "),
+		init_utsname()->version);
 	show_trace(NULL, NULL, &dummy);
 }
 


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
