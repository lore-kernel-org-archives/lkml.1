Return-Path: <linux-kernel-owner+w=401wt.eu-S1763161AbZE1TYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763161AbZE1TYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 15:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbZE1TYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 15:24:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61297 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbZE1TYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 15:24:00 -0400
Date: Thu, 28 May 2009 15:23:59 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] tracing: annotate emit_log_char() notrace
In-Reply-To: <alpine.LFD.2.00.0905281732010.3397@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0905281512210.11238@gandalf.stny.rr.com>
References: <alpine.LFD.2.00.0905271657340.3397@localhost.localdomain> <20090528141648.GA6018@nowhere> <alpine.LFD.2.00.0905281646380.3397@localhost.localdomain> <alpine.DEB.2.00.0905281057490.905@gandalf.stny.rr.com>
 <alpine.LFD.2.00.0905281732010.3397@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 28 May 2009, Thomas Gleixner wrote:

> On Thu, 28 May 2009, Steven Rostedt wrote:
> > > IIRC the same happens with a serial console, but that can be worse as
> > > you busy wait during the character output.
> > > 
> > > It'd be nice if we could inherit the notrace from the caller :)
> > > 
> > 
> > I'd hate to make rcu_read_*lock be a notrace. I've done some debugging 
> > with wanting to know where the rcu locks were taken.
> 
> Sure.
>  
> > I'm sure there's lots of functions that people will want to add notrace 
> > for. Really, the notrace on a function should only be there to prevent 
> > crashes (functions used by the tracer or early boot up code for some 
> > archs).
> 
> Well, lets look at the atomic notifier then. Why is it notrace ? And
> if there is a reason why does it trace the calls which are done inside
> of it. We should really think about inheriting the notrace down the
> call chain at least for those calls which must be annotated to avoid
> wreckage. That could then be made optional (via commandline) for all
> notrace calls.

Every function marked with __kprobes becomes notrace, which atomic 
notifier is.

We probably can even remove that now. Ingo added it when we had the issue 
with the NMI causing lockups. See 36dcd67ae994fece615b7c700958d215e884b9ae
But we have since fixed the NMI issues.

Also, there's no real way to inherit notrace automatically. Well we could 
write some really nasty scripts to try it at compile time. notrace is 
simply an attribute in gcc to prevent it from calling mcount.

> 
> > That said, there are times when you want to avoid tracing things on early 
> > boot up. Thus, if someone adds to the kernel command line 
> > "ftrace=function" you have no way to filter out these functions you don't 
> > care about.
> > 
> > What if I add a "ftrace_notrace=<function list>" kernel command line, that 
> > has <function list> be a comma separated list of functions you want to go 
> > into the "set_ftrace_notrace" on boot up? Would that satisfy you. Then you 
> > can keep adding to the list dynamically every boot. And keep it there in a 
> > grub file.
> 
> That list might grow fast beyond the command line lenght limit :)
> 
> But yeah, I can see your point. At least it would be better than
> cursing and adding ad hoc notrace patches all over the place.
> 

Well, the boot options still allow for simple wild cards. So hopefully the 
list will not grow too much. You can also just add a list of functions 
that you want to trace (filter as suppose to notrace).

If you are tracing after boot up, then you can add the list to a start up 
script and just echo into the set_ftrace_notrace file.

-- Steve

