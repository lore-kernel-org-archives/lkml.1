Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab0AOPEq (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 10:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129Ab0AOPEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 10:04:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34286 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab0AOPEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 10:04:45 -0500
X-Authority-Analysis: v=1.0 c=1 a=1J7b2nWUegwA:10 a=7U3hwN5JcxgA:10 a=8LtHFyZrPCF_3cuuQQoA:9 a=e0qh9Ae585i9OL23KcgW8Ud6RawA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 39/40] debug_core: Turn off tracing while in the
 debugger
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        mingo@elte.hu
In-Reply-To: <4B50759C.30409@windriver.com>
References: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
	 <1263481176-1897-40-git-send-email-jason.wessel@windriver.com>
	 <1263514210.28171.3963.camel@gandalf.stny.rr.com>
	 <4B50759C.30409@windriver.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 15 Jan 2010 10:04:37 -0500
Message-ID: <1263567877.28171.3972.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-15 at 08:03 -0600, Jason Wessel wrote:

> What else do you imagine would turn on tracing, or what might break?
> 
> At the point in time that this is called all the slave CPUs are rounded
> up, and a single CPU remains executing as the "master" cpu inside the
> debug core.  There are two exit points from this context depending on
> the state of how you are resuming system, where we turn tracing back on,
> if it was on prior to entry to the kernel debug context.
> 
> I debated about using an atomic_inc and also allowing the slave_cpu
> entry to turn it off, because that actually happens first, and you can
> actually see that in the function tracer log up to the point that the
> master turns off tracing.
> 
> The approach employed by this patch seemed the most simplistic, and
> definitely stopped the trace log, while the debugger was active.  This
> particular problem with having tracing active while in the kernel debug
> context was not even discovered until kdb ftdump was implemented.  We
> don't really want to do much of anything except keep minimal HW alive
> while in the kernel debugger context.  I am open to suggestions if you
> think we need something more here.  I can also hard code a test if you
> believe there is a condition that requires some investigation.

Ah, if this is done by stopping the box, then it should be pretty safe.
There's two other ways that tracing can be enabled.

One, if someone modifies the kernel and adds "tracing_on()" somewhere.
Which, if happens, is the users fault. You change the kernel, you are
responsible for the consequences.

The other, which can happen from user land, is the "function:traceon"
feature.

# echo 'schedule:traceon' > /sys/kernel/debug/tracing/set_ftrace_filter

This will not add schedule to the ftrace filter, but instead it will
attach a check to schedule that will make the tracer enabled.

If someone attaches a "traceon" command to a function that might be
called by the kernel debugger, then you may have an issue. But this too,
may just be blamed on the user.

-- Steve


