Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbZKCRcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbZKCRcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 12:32:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbZKCRcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 12:32:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48728 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbZKCRcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 12:32:52 -0500
Subject: Re: Ftrace for Microblaze - notrace
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: monstr@monstr.eu
Cc: Steven Rostedt <srostedt@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org,
       John Williams <john.williams@petalogix.com>
In-Reply-To: <4AF05E0C.5090305@monstr.eu>
References: <4AF030EE.7050609@monstr.eu>
	 <1257266154.31359.14.camel@localhost.localdomain>
	 <4AF05E0C.5090305@monstr.eu>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 03 Nov 2009 12:32:55 -0500
Message-Id: <1257269575.26028.3355.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-03 at 17:45 +0100, Michal Simek wrote:
> Steven Rostedt wrote:

> >>
> >> The next thing is about annotation notrace. I look at all arch. Is there 
> >> any algorithm which function should use it? I think that this could be a 
> >>   reason why I my kernel freeze when enable function tracer.
> >>
> >> I tested to add -pg flag for process.c file and after it kernel freeze 
> >> too. Is it mean that problem could be there?
> > 
> > Probably.
> 
> Is there any manual or instruction which functions are dangerous and 
> especially why?

No there's no manual. It varies from arch to arch. Hmm, maybe I'll
update the current doc to have some of the issues that come with it.
(more info farther down)

> > 
> > And that will keep the process.c from being compiled with it. There may
> > be other files in the arch that should not have it. There's several in
> > x86 and in PowerPC.
> 
> Do you know why they exclude it?

I did the ports for x86 and PowerPC so I guess I'm the best to answer
this ;-)

In arch/x86 we have these removing -pg:

tsc.o, rtc.o - Do not trace clock output. The tracer itself uses it.
Even though it protects against recursion, it is a big overhead to trace
something within the tracer.

paravirt-spinlocks.o - paravirt does crazy things with locks and such,
but overwriting text. Don't add mcount to them and overwrite the text
with the ftrace facility.

ftrace.o - well duh ;-)

early_printk.o - This is mostly used for debugging, don't trace it.

cpu/common.o - This is used in early stages of boot up of secordary
CPUs. As well as used in hot plug. Simply using something like
smp_processor_id() can crash the kernel here. The tracer code uses that,
so don't trace it.

Xen has a bunch that they added, and I think that's also because they do
funny things too.


For powerpc, we have:

cputable.o, prom_init.o, btext.o and prom.o that are all very sensitive
with boot up code. Simply calling mcount here can crash the system. But
this prevents boot up. It does not lock up the kernel when we enable
function tracing.

ftrace.o - again, this should be obvious.

time.o - this is the same reason we don't trace tsc and rtc in x86.

> 
> Can I use any special debug features? I mean I look at kernel.h and 
> there are some trace_printk function - but they don't work for me. Is it 
> possible to use them or not?

Should work. That's not arch dependent. But you need to have some ftrace
enabled. Enable CONFIG_CONTEXT_SWITCH_TRACER, and trace_printk should
work. That writes to the ring buffer and you can see the output
in /debug/tracing/trace.

-- Steve


