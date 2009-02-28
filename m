Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbZB1WGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbZB1WGO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 17:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754897AbZB1WFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 17:05:47 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:29262 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754711AbZB1WFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 17:05:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=thMLcKzcNcLQz3T97V1VByFBGdcN5VSRlFGCVLe9FB7ElvMelp68HpwjCqJucjLipCPqShct/oHwEnJZzuamF/aSNXK0lfvpcFad0oC+clcHV3YBdWAw9fIh6SQYb0agobV67vaBLccfQm+u+cJGfc7ahA0xgCqUUKYHBUINuYA=  ;
X-YMail-OSG: s9ciiuIVM1mPxDZTd10ZkOMHtjYFBJ7BC0FTWq..nx_jiuGBL33khHnLm_yKZTTeWgpzR1bRfGcdcnWXxaqd1HxugaB9gZbUs0RgDUCnUIpHurQZWQm57IO0K.e.J4yItz3ltOVE4fvWLt.PdnR7Tob1Vx7LOKJYoypy1EOVLL2K.Dqk6V7SgruoBIET_67mnsXOIibhxQP3AWACcEVe9YUMAVmYsQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: lockdep and threaded IRQs (was: ...)
Date: Sat, 28 Feb 2009 14:05:41 -0800
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       a.p.zijlstra@chello.nl
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200902281202.36804.david-b@pacbell.net> <alpine.LFD.2.00.0902282149290.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902282149290.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902281405.42080.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 February 2009, Thomas Gleixner wrote:
> On Sat, 28 Feb 2009, David Brownell wrote:
> > Got a version that applies to mainline GIT?
> 
> http://tglx.de/~tglx/patches.tar.bz2 

Got it, thanks.


> > At a quick glance it looks like these patches don't cover
> > set_irq_chained_handler(), which would be trouble since
> > __setup_irq() doesn't get called in those cases.
> 
> Hmm, I did not think about chained handlers where the demux handler
> needs to run in a thread as well. Usually demux handlers just have a
> fast path kicking the particular real handlers.

That can't work when the demux needs to access state across
I2C in order to see which "real" handlers to kick.  :)


> > They should however handle simpler cases, like I2C devices
> > that only expose one IRQ instead of needing to demux several
> > dozen IRQs going to different drivers and subsystems.
> > 
> > And, not touching lockdep, the original ugliness will still
> > be needed (re-enabling IRQs in threaded handlers).
> 
> Err ? The threaded handlers run with interrupts enabled.

Hmm, I'll have a closer look.  You changed handle_IRQ_event()
which is where the relevant IRQF_DISABLED test kicks in.  In
your updated code, that pokes any quick_check_handler() and
then maybe pokes a per-IRQ thread.

That seems to presume a hardirq-to-taskirq handoff.  But the
problem case is taskirq-to-taskirq chaining, through e.g.
what set_irq_chip_and_handler() provided.  (Details not very
amenable to brief emails, just UTSL.)

Thing is, I'm not sure a per-IRQ thread can work easily with
that chaining.  The chained IRQs can need to be handled before
the top-level IRQ gets re-enabled.  That's why the twl4030-irq
code uses just one taskirq thread for all incoming events.

(Which of course is rarely more than one at a time, so there's
little reason not to share that task between the demuxing code
and the events being demuxed.  Interrupts that need processing
via I2C/SPI/etc are more or less by definition not frequent or
performance-critical.)

- Dave
