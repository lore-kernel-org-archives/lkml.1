Return-Path: <linux-kernel-owner+w=401wt.eu-S1758608AbZE1PER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608AbZE1PER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 11:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbZE1PEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 11:04:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64059 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbZE1PEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 11:04:06 -0400
Date: Thu, 28 May 2009 11:04:06 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: annotate emit_log_char() notrace
In-Reply-To: <alpine.LFD.2.00.0905281646380.3397@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0905281057490.905@gandalf.stny.rr.com>
References: <alpine.LFD.2.00.0905271657340.3397@localhost.localdomain> <20090528141648.GA6018@nowhere> <alpine.LFD.2.00.0905281646380.3397@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 28 May 2009, Thomas Gleixner wrote:

> On Thu, 28 May 2009, Frederic Weisbecker wrote:
> > On Wed, May 27, 2009 at 05:00:44PM +0200, Thomas Gleixner wrote:
> > > printk calls emit_log_char() in a loop which is cluttering the trace
> > > buffer. Make it notrace.
> > > 
> > > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > > ---
> > 
> > 
> > Does it produce that much annoying traces?
> > I mean, printk() are usually rare events.
> > 
> > Do you have a particular debugging workflow that makes this
> > function invasive in the trace?
> > 
> > May be it's because you are debugging using ftrace and other
> > debugging options that use a lot of printk()
> > In such case, it would indeed be good to apply this patch.
> 
> I noticed when I chased a boot up problem, half of the trace was full
> of
> 
>    0.540550: emit_log_char <-vprintk
>    0.540550: emit_log_char <-vprintk
>    ...
> 
> though there is another annoyance in the same code path:
> 
>    0.540557: vgacon_set_cursor_size <-vgacon_cursor
>    0.540558: __rcu_read_lock <-__atomic_notifier_call_chain
>    0.540558: __rcu_read_unlock <-__atomic_notifier_call_chain
>    0.540558: __rcu_read_lock <-__atomic_notifier_call_chain
>    ...
> 
> It's actually the same number of times as we have emit_log_char()
> there. __atomic_notifier_call_chain() itself is marked notrace but the
> rcu calls inside are not. :(
> 
> IIRC the same happens with a serial console, but that can be worse as
> you busy wait during the character output.
> 
> It'd be nice if we could inherit the notrace from the caller :)
> 

I'd hate to make rcu_read_*lock be a notrace. I've done some debugging 
with wanting to know where the rcu locks were taken.

I'm sure there's lots of functions that people will want to add notrace 
for. Really, the notrace on a function should only be there to prevent 
crashes (functions used by the tracer or early boot up code for some 
archs).

That said, there are times when you want to avoid tracing things on early 
boot up. Thus, if someone adds to the kernel command line 
"ftrace=function" you have no way to filter out these functions you don't 
care about.

What if I add a "ftrace_notrace=<function list>" kernel command line, that 
has <function list> be a comma separated list of functions you want to go 
into the "set_ftrace_notrace" on boot up? Would that satisfy you. Then you 
can keep adding to the list dynamically every boot. And keep it there in a 
grub file.

This will also keep people from constantly asking for notrace annotations 
just because they are annoyed by the functions that always fill up their 
logs.

-- Steve

