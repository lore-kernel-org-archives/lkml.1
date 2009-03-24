Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbZCXVgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbZCXVgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbZCXVg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:36:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:17275 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308AbZCXVg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:36:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=U9AwjhgcZTFjW6JgBbsAcOX0K53XmbpfHrp9IOcdlehr4Td8DpiFZvE1rbTw7p1h8t
         l17OItNuUv9OjWoMSY/MTwX2NEbUZn43nb+Et/AHsL6+JpfzgUAXuOYy4KPliue+it1l
         RS1i2p5I92iRbfo130KPqR9YcgLVLcKCuP0Kk=
Date: Tue, 24 Mar 2009 22:36:19 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: Anyone working on ftrace function graph support on ARM?
Message-ID: <20090324213618.GC5975@nowhere>
References: <49C936CA.8070800@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C936CA.8070800@am.sony.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 12:38:50PM -0700, Tim Bird wrote:
> ARM and FTRACE people,
> 
> Is anyone working on function graph support for ARM?


Aah, it was on my plans!
But well, if you are about to do it, so don't hesitate.

I don't have any arm board for now, though I have a pending
one which I will probably get in few weeks, but for now
I can't work on it, so knock yourself out.


> I haven't done much ARM assembly, but the Intel mechanism
> for the return hook looks fairly straightforward,
> and I thought I'd take a shot at implementing it on ARM.


Yes, ie:

_Before jumping to the function entry hook, you must save
the arguments for the traced function on the stack.
On x86, its eax, edx and ecx.
On arm, it will be r0-r3.
Then you have to transmit the address of the traced function
(it's on r14) and it's parent (must rely on fp for that).
Then you call the entry hook and restore the old scratch/arg
registers.


_ On return hook it's pretty the same, (saving the scratch
registers, especially the return value which should be on r0
and r1 if I'm not wrong).
But you'll have to get the original return address from the
return handler and then put it on pc.

Well it's a very naive listing, there are sometimes some problems.
For example on x86-64, I had to save even some non-scratch registers
before calling the return hook, I still don't know why.


> But if someone else is already doing it, I'd rather work
> with them.
> 
> BTW - I turned on -finstrument-functions on ARM, and it seems
> to work OK (with the exception being that I don't see evenly matched
> calls and returns).  For this latter reason, I'm going to
> start with an implementation that copies the return hook
> used by x86, with a fallback to using __cyg_profile_... instead
> of mcount, if the hook approach proves too hard for me on ARM.


Be care, -finstrument-functions will add one more handler and then
increase the size of the kernel, may be a lot.

Moreover it will not be compatible with dynamic tracing which is
designed to patch the mcount call sites. It doesn't support patching
of __cyg_profile. And patching __cyg_profile call sites would mean
running twice the time to patch the kernel code.

Function tracing (hooks only on function entries) and dynamic tracing
are already implemented on Arm. Using the mcount way shoudn't really be
a problem because all is already set for that with the function tracer.


Anyway if you need some help, don't hesitate!


> My ultimate goal is to add function duration filtering, which
> is one of the nicer features of KFT (an older tracer I used
> to maintain out-of-mainline).  With all the ftrace and ringbuffer
> support already in mainline, this shouldn't be too hard, but
> I need to start with basic graph support on ARM first.


Yeah, seems a nice idea.

Thanks,
Frederic.


> Any comments or feedback on the approach, or on current plans
> to extend ftrace support on ARM, before I get too far along,
> are welcome.
> 
> Thanks,
>  -- Tim
> 
> =============================
> Tim Bird
> Architecture Group Chair, CE Linux Forum
> Senior Staff Engineer, Sony Corporation of America
> =============================
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

