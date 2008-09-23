Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbYIWBUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbYIWBUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 21:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbYIWBUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 21:20:42 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:45564 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753696AbYIWBUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 21:20:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEEAHvf10hMQWq+/2dsb2JhbACBXbULgWY
Date: Mon, 22 Sep 2008 21:20:39 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] [RFC] tracehook: Hook in syscall tracing markers.
Message-ID: <20080923012039.GA24937@Krystal>
References: <20080921021630.GA6443@linux-sh.org> <20080922010408.F53D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080922010408.F53D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:19:33 up 110 days,  5:59,  7 users,  load average: 0.48, 0.36,
	0.27
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
> Hi Paul,
> 
> > At kernel summit, the idea that syscall tracing was generally desirable
> > for tracing was mentioned several times, as was the argument that kernel
> > developers aren't placing markers in meaningful locations. This is a
> > simple patch to try and do that for the syscall case.
> > 
> > Presently LTTng attempts to litter these trace markers all over the
> > architecture code, primarily to get around the fact that there was no
> > generic way to get at this information before. Now that platforms are
> > starting to do their syscall entry/exit notifiers through tracehook and
> > we have the asm/syscall.h interface, all of this information can be
> > generically abstracted.
> > 
> > Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> > 
> 
> I think marriage between tracehook and generic marker is very good idea. 
> at least, instruction pointer and return value are definitly useful.
> 
> but...
> Have you seen Mathieu's tracepoint patch?
> I recommend to use tracepoint insted use marker directly.
> 

Yep, tracepoints would be better suited for this. They can be found in
-tip or in -lttng trees.

Does tracehook have any infrastructure that would give us the system
calls parameters (with correct typing ?) :-) Or could they evolve into
this ?

Mathieu

> 
> > ---
> > 
> >  include/linux/tracehook.h |    7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
> > index 6186a78..481ff45 100644
> > --- a/include/linux/tracehook.h
> > +++ b/include/linux/tracehook.h
> > @@ -49,6 +49,9 @@
> >  #include <linux/sched.h>
> >  #include <linux/ptrace.h>
> >  #include <linux/security.h>
> > +#include <linux/marker.h>
> > +#include <asm/syscall.h>
> > +
> >  struct linux_binprm;
> >  
> >  /**
> > @@ -112,6 +115,8 @@ static inline __must_check int tracehook_report_syscall_entry(
> >  	struct pt_regs *regs)
> >  {
> >  	ptrace_report_syscall(regs);
> > +	trace_mark(kernel_arch_syscall_entry, "syscall_id %ld ip #p%ld",
> > +		   syscall_get_nr(NULL, regs), instruction_pointer(regs));
> >  	return 0;
> >  }
> >  
> > @@ -135,6 +140,8 @@ static inline __must_check int tracehook_report_syscall_entry(
> >  static inline void tracehook_report_syscall_exit(struct pt_regs *regs, int step)
> >  {
> >  	ptrace_report_syscall(regs);
> > +	trace_mark(kernel_arch_syscall_exit, "ret %ld",
> > +		   syscall_get_return_value(NULL, regs));
> >  }
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
