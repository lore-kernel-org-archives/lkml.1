Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbYHAQx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbYHAQx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 12:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbYHAQxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 12:53:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58088 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbYHAQxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 12:53:19 -0400
Date: Fri, 1 Aug 2008 12:53:17 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH v2 2/2] ftrace: printk formatting infrastructure
In-Reply-To: <20080801094331.626195c8.randy.dunlap@oracle.com>
Message-ID: <alpine.DEB.1.10.0808011248080.31922@gandalf.stny.rr.com>
References: <20080801162639.175407419@goodmis.org> <20080801163737.420519487@goodmis.org> <20080801094331.626195c8.randy.dunlap@oracle.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 1 Aug 2008, Randy Dunlap wrote:

> On Fri, 01 Aug 2008 12:26:41 -0400 Steven Rostedt wrote:
> 
> > +/**
> > + * ftrace_printk - printf formatting in the ftrace buffer
> > + * @fmt - the printf format for printing.
> 
>     * @fmt: the printf format for printing
>     * @ip: <description>
> 
> > + *
> > + * Note: __ftrace_printk is an internal function for ftrace_printk and
> > + *       the @ip is passed in via the ftrace_printk macro.

The above note actually explains this ;-)

Should I move the description to the ftrace_printk macro?

In include/linux/ftrace.h you see:

#ifdef CONFIG_TRACING
[...]
# define ftrace_printk(x...) __ftrace_printk(_THIS_IP_, x)
extern int
__ftrace_printk(unsigned long ip, const char *fmt, ...)
        __attribute__ ((format (printf, 2, 3)));
#else
[...]
static inline int
ftrace_printk(const char *fmt, ...) __attribute__ ((format (printf, 1, 
0)))
{
        return 0;
}
#endif

The true API is ftrace_printk(const char *fmt) and the __ftrace_printk
version should not be used.

Do you still think I should document the @ip?

I could also just remove the passing of _THIS_IP_ and use _RET_IP_ 
inside of ftrace_printk but the _THIS_IP_ seems to be more accurate 
especially when we have stack unwinding returns.

-- Steve



> > + *
> > + * This function allows a kernel developer to debug fast path sections
> > + * that printk is not appropriate for. By scattering in various
> > + * printk like tracing in the code, a developer can quickly see
> > + * where problems are occurring.
> > + *
> > + * This is intended as a debugging tool for the developer only.
> > + * Please reframe from leaving ftrace_printks scattered around in
> > + * your code.
> > + */
> > +int __ftrace_printk(unsigned long ip, const char *fmt, ...)
> > +{
> 
> 
> ---
> ~Randy
> Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
> http://linuxplumbersconf.org/
> 
