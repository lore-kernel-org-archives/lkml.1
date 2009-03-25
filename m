Return-Path: <linux-kernel-owner+w=401wt.eu-S1761413AbZCYMKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761413AbZCYMKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761385AbZCYMKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:10:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58124 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761377AbZCYMJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:09:59 -0400
Date: Wed, 25 Mar 2009 13:09:44 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: Anyone working on ftrace function graph support on ARM?
Message-ID: <20090325120944.GA30873@pengutronix.de>
References: <49C936CA.8070800@am.sony.com> <20090324213618.GC5975@nowhere> <49C95EAF.7030901@gmail.com> <20090324224857.GE5975@nowhere> <20090325084248.GF4697@n2100.arm.linux.org.uk> <20090325085418.GA2341@elte.hu> <20090325095751.GA31464@n2100.arm.linux.org.uk> <20090325104505.GA27803@pengutronix.de> <20090325112115.GB31464@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090325112115.GB31464@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

> > > Hmm, and it looks like the ftrace code is rather crap:
> > > 
> > > ENTRY(mcount)
> > >         stmdb sp!, {r0-r3, lr}
> > >         ldr r0, =ftrace_trace_function
> > >         ldr r2, [r0]
> > >         adr r0, ftrace_stub
> > >         cmp r0, r2
> > >         bne trace
> > >         ldr lr, [fp, #-4]                       @ restore lr
> > >         ldmia sp!, {r0-r3, pc}
> > > 
> > > trace:
> > >         ldr r1, [fp, #-4]                       @ lr of instrumented routine
> > >         mov r0, lr
> > >         sub r0, r0, #MCOUNT_INSN_SIZE
> > >         mov lr, pc
> > >         mov pc, r2
> > >  XXX calling a C function results in r0-r3,ip,lr being clobbered XXX
> > > 
> > >         mov lr, r1                              @ restore lr
> > >  XXX not necessarily, r1 might be some other random value
> > > 
> > >         ldmia sp!, {r0-r3, pc}
> > > 
> > > In fact, to me the above code looks totally crap, because it's checking
> > > whether the caller is 'ftrace_stub'.  It can never be 'ftrace_stub'
> > > because that is an assembly function:
> > > 
> > >         .globl ftrace_stub
> > > ftrace_stub:
> > >         mov pc, lr
> > > 
> > > and therefore gcc has no hand in adding a mcount call to it.
> > Hhhm.  Isn't the equivalent C-Code ~ as follows:
> > 
> > 	if (ftrace_trace_function != ftrace_stub)
> > 		trace(some, args);
> > 	return;
> > ?  ftrace_trace_function is initialised to ftrace_stub at compile time
> > and is changed when a tracerfunction is registered.
> 
> Correct.  But my point is that there's no way for ftrace_stub to ever call
> mcount.  So the check there is pointless.
Which check?  ftrace_trace_function isn't the caller of mcount but a
function pointer defined in kernel/trace/ftrace.c.  And if this pointer
changes, the if-condition becomes true.

> Ok - it would be nice if there was a comment to explain that.
Some comments would be nice, that's right.

> Is someone going to fix the existing ftrace before trying to build stuff
> on top of it?
Mmh, I think you misunderstood the code, so I don't see something to fix
here (at least for non-dynamic ftrace).  If the next few mails show,
that it's me who didn't understand the code, I will fix the problems, of
course.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
