Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbZKDCDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbZKDCDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 21:03:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbZKDCDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 21:03:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56215 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbZKDCDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 21:03:05 -0500
Subject: Re: Ftrace for Microblaze - notrace
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: monstr@monstr.eu
Cc: Steven Rostedt <srostedt@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org,
       John Williams <john.williams@petalogix.com>
In-Reply-To: <4AF0725C.1050106@monstr.eu>
References: <4AF030EE.7050609@monstr.eu>
	 <1257266154.31359.14.camel@localhost.localdomain>
	 <4AF05E0C.5090305@monstr.eu>
	 <1257269575.26028.3355.camel@gandalf.stny.rr.com>
	 <4AF0725C.1050106@monstr.eu>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 03 Nov 2009 21:03:06 -0500
Message-Id: <1257300186.26028.3817.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-03 at 19:11 +0100, Michal Simek wrote:

> > cputable.o, prom_init.o, btext.o and prom.o that are all very sensitive
> > with boot up code. Simply calling mcount here can crash the system. But
> > this prevents boot up. It does not lock up the kernel when we enable
> > function tracing.
> > 
> > ftrace.o - again, this should be obvious.
> > 
> > time.o - this is the same reason we don't trace tsc and rtc in x86.
> 
> ok In general - all timing functions and function which are related with 
> startup code - called only once before turning on irqs - there are a lot 
> of functions. I understand that make no sense to trace that files. And 
> plus all debugging functions.  And function which uses locks.
> Anything else?

Actually, you only need to "notrace" the start up code that can crash
the box if they are traced. The powerpc code was so fragile there that
just calling mcount caused a panic.

> 
> 
> > 
> >> Can I use any special debug features? I mean I look at kernel.h and 
> >> there are some trace_printk function - but they don't work for me. Is it 
> >> possible to use them or not?
> > 
> > Should work. That's not arch dependent. But you need to have some ftrace
> > enabled. Enable CONFIG_CONTEXT_SWITCH_TRACER, and trace_printk should
> > work. That writes to the ring buffer and you can see the output
> > in /debug/tracing/trace.
> 
> It could be nice features but in case that you have command line and you 
> can read that trace debug output. I mean any printk messages - which not 
> contain any trace facility - just pure printk to console. Are that 
> messages written to any place which could be read from debuger? Like log 
> buffer? Is there any place for them?

The are only written to the ring buffer. You may be able to read that
too, but it will take a bit of work.

> 
> The second things is that I haven't implemented save_stack_trace 
> function - it is just while(1) loop. My kernel not jumps to this 
> function that's why I am not interested to implement it. Am I right that 
>   ftrace code don't use it? Or the standard behavior is that ftrace code 
> use this function and really care about. Does your kernel use that function?

We use it for saving stack traces. The ftrace stack tracer also uses it.
But if it is a nop, the other parts of ftrace should still work.

> 
>  From my test I don't understand MCOUNT_INSN_SIZE - and which function 
> doesn't care about. There is this line of pseudocode in your doc
> (unsigned long selfpc = <return address> - MCOUNT_INSN_SIZE;) but what 
> the reason is to do that. If I understand correct selfpc and frompc just 
> give addresses which functions called that mcount and has impact to log.
> I mean that if that address is not proper begin of function is found 
> (not sure if the code do it or not) function name (and function) which 
> contain that address. Or is there any special reason why to substract 
> that MCOUNT_INSN_SIZE - for timing or anything like that?

The passed in address to mcount is really the return address and not the
caller to mcount. We want the actual address to the mcount caller. To
get that we must subtract size of the call to mcount from the address
passed in.


> 
> I simple just not find any reason for it. And I believe that don't have 
> connection with my problem.

The code must account for it. If you have implemented dynamic ftrace,
then you need to do that. Otherwise we are updating the wrong places in
text.

-- Steve


