Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbYHSC2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbYHSC2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 22:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYHSC2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 22:28:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56674 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbYHSC2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 22:28:33 -0400
Date: Mon, 18 Aug 2008 22:28:31 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Scott Wood <scottwood@freescale.com>, Eran Liberty <liberty@extricom.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Steven Rostedt <srostedt@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
In-Reply-To: <1219110814.8062.2.camel@pasglop>
Message-ID: <alpine.DEB.1.10.0808182208110.13401@gandalf.stny.rr.com>
References: <48591941.4070408@extricom.com> <48A92E15.2080709@extricom.com>  <48A9901B.1080900@redhat.com> <20080818154746.GA26835@Krystal>  <48A9AFA7.8080508@freescale.com>  <alpine.DEB.1.10.0808181425090.796@gandalf.stny.rr.com>
 <1219110814.8062.2.camel@pasglop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 19 Aug 2008, Benjamin Herrenschmidt wrote:

> On Mon, 2008-08-18 at 14:27 -0400, Steven Rostedt wrote:
> > 
> > On Mon, 18 Aug 2008, Scott Wood wrote:
> > 
> > > Mathieu Desnoyers wrote:
> > > >         asm volatile (
> > > >                 "1: lwz         %1, 0(%2)\n"
> > > >                 "   cmpw        %1, %5\n"
> > > >                 "   bne         2f\n"
> > > >                 "   stwu        %3, 0(%2)\n"
> > > >                 "2:\n"
> > > >                 ".section .fixup, \"ax\"\n"
> > > >                 "3:     li %0, 1\n"
> > > >                 "       b 2b\n"
> > > >                 ".previous\n"
> > > >                 ".section __ex_table,\"a\"\n"
> > > >                 _ASM_ALIGN "\n"
> > > >                 _ASM_PTR "1b, 3b\n"
> > > >                 ".previous"
> > > >                 : "=r"(faulted), "=r"(replaced)
> > > >                 : "r"(ip), "r"(new),
> > > >                   "0"(faulted), "r"(old)
> > > >                 : "memory");
> > > 
> > > Some (most likely unrelated) nits in the above inline asm:
> 
> 
> Why not use __get_user/__put_user ?

Hmm, this was originally copied from x86, where we did a cmpxchg, but that 
is probably not needed since all of this is done in kstop_machine. Also, 
only the "get" is needed. If we don't fault there, we wont fault on the 
put (unless we have permissions wrong, and that would be a bug).

So are you recommending something like

        int cmd;

	if (__get_user(cmd, ip))
		goto fault;

	if (cmd != old)
		goto not_same;

	WARN_ON_ONCE(__put_user(cmd, ip));

If we did this, we could probably put this into the generic code:


	if (copy_from_user(cmd, ip, ARCH_CALL_SIZE))
		goto fault;

	if (memcmp(cmd, old, ARCH_CALL_SIZE) != 0)
		goto not_same;

	WARN_ON_ONCE(copy_to_user(cmd, ip, ARCH_CALL_SIZE));


-- Steve

