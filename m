Return-Path: <linux-kernel-owner+w=401wt.eu-S939029AbZDJRSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939029AbZDJRSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 13:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938988AbZDJRRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 13:17:18 -0400
Received: from www.tglx.de ([62.245.132.106]:46841 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938979AbZDJRRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 13:17:16 -0400
Date: Fri, 10 Apr 2009 19:16:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Subject: Re: [2.6.29-git12] BUG: scheduling while atomic:
 swapper/0/0x10000100
In-Reply-To: <8db1092f0904100952x64048907gea6bbaf25488de26@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0904101854250.21577@localhost.localdomain>
References: <8db1092f0904070037q426fd8dcx4aa48c70e40b5d6c@mail.gmail.com>  <20090409212028.7b2aa88c.akpm@linux-foundation.org>  <8db1092f0904100340g7b7eb310y805e8680a32e3ac8@mail.gmail.com>  <alpine.LFD.2.00.0904101329170.21577@localhost.localdomain> 
 <8db1092f0904100747w297a0daas9ebd05486d06e706@mail.gmail.com>  <alpine.LFD.2.00.0904101819070.21577@localhost.localdomain> <8db1092f0904100952x64048907gea6bbaf25488de26@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Apr 2009, Maciej Rutecki wrote:
> 2009/4/10 Thomas Gleixner <tglx@linutronix.de>:
> 
> >
> > Is this with my patch applied ?
> 
> Yes. I didn't observe any change.

Hmm. Ok, so the check in do_IRQ did not trigger. That means we need to
look for some other place.

Can you please apply the patch below and set CONFIG_FUNCTION_TRACER=y.
After boot please do as root:

# mount -t debugfs debugfs /sys/kernel/debug
# echo function >/sys/kernel/debug/tracing/current_tracer
# ech0 1 >/sys/kernel/debug/tracing/options/latency-format
# echo 1 >/sys/kernel/debug/tracing/tracing_enabled

Now wait until that scheduling while atomic bug triggers. This will
stop the tracer. Now

# cat /sys/kernel/debug/tracing/trace | bzip2 >/tmp/trace.bz2

Please upload trace.bz2 file to some place.

Thanks,

	tglx

----
diff --git a/kernel/sched.c b/kernel/sched.c
index 5724508..2e257bf 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4912,6 +4912,7 @@ static noinline void __schedule_bug(struct task_struct *prev)
 {
 	struct pt_regs *regs = get_irq_regs();
 
+	tracing_off();
 	printk(KERN_ERR "BUG: scheduling while atomic: %s/%d/0x%08x\n",
 		prev->comm, prev->pid, preempt_count());
 


