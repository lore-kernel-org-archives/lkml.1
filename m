Return-Path: <linux-kernel-owner+w=401wt.eu-S932749AbXFEPwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749AbXFEPwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 11:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932313AbXFEPwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 11:52:21 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4942 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466AbXFEPwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 11:52:15 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 5 Jun 2007 08:52:07 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH/RFC] signal races/bugs, losing TIF_SIGPENDING and other
 woes
In-Reply-To: <1181009413.31677.117.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0706050839350.23304@alien.or.mcafeemobile.com>
References: <1181006711.31677.97.camel@localhost.localdomain> 
 <alpine.LFD.0.98.0706041831400.23741@woody.linux-foundation.org>
 <1181009413.31677.117.camel@localhost.localdomain>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007, Benjamin Herrenschmidt wrote:

> We don't actually call recalc_sigpending_tsk() when sending a signal to
> some other task, we just set the flag... so I need to recheck my theory
> here about recalc_sigpending_tsk being called for somebody else...
> Something is doing it somewhere it seems (we are losing the
> TIF_SIGPENDING bit) but I'll need to cook up a repro case to track
> exactly where.
>> 
>  - I still think there's something wrong with dequeue_signal() being
> potentially called with a task different than current by signalfd, since
> __dequeue_signal() (among others) mucks around with current regardless.
> I'd love to just make signalfd's read() only do anything if current ==
> ctx->tsk and remove the task argument from dequeue_signal... that would
> fix it nicely too no ?

I agree with Ben that recalc_sigpending_tsk() on tsk!=current is a bad 
idea. I think, since dequeue_signal() is called from user context, we 
could just have only recalc_sigpending(), that acts on current, and then 
inside dequeue_signal we have:

	if (tsk == current)
		recalc_sigpending();

What can happen, is that a task may notice TIF_SIGPENDING and not find a 
signal once it calls dequeue_signal(), but this is fine as far as signalfd 
goes. This should be OK in general, no?


- Davide


