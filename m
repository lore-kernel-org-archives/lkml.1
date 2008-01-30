Return-Path: <linux-kernel-owner+w=401wt.eu-S1760594AbYA3MhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760594AbYA3MhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 07:37:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756912AbYA3MhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 07:37:04 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:56163 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756806AbYA3MhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 07:37:02 -0500
Date: Wed, 30 Jan 2008 13:36:59 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: michael <trimarchi@gandalf.sssup.it>
Cc: Remy Bohmer <linux@bohmer.net>, fabio@gandalf.sssup.it,
       Andrew Victor <linux@maxim.org.za>, Chip Coldwell <coldwell@redhat.com>,
       Marc Pignat <marc.pignat@hevs.ch>, David Brownell <david-b@pacbell.net>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -mm v4 6/9] atmel_serial: Split the interrupt handler
Message-ID: <20080130133659.55ebd828@dhcp-252-066.norway.atmel.com>
In-Reply-To: <47A051A7.7030004@gandalf.sssup.it>
References: <20080129224316.GA23155@gandalf.sssup.it>
	<479FB2D7.4020804@gandalf.sssup.it>
	<20080130104113.48ec376f@dhcp-252-066.norway.atmel.com>
	<47A051A7.7030004@gandalf.sssup.it>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008 11:29:59 +0100
michael <trimarchi@gandalf.sssup.it> wrote:
> > Now, _that_ is strange. I can't see anything that needs protection
> > across that call; in fact, I think we can lock a lot less than what we
> > currently do.
> >
> >   
> I explain it bad:
> - with spin_lock the system seems, there is no problem with Valuntary 
> Preeption and
> Preemptible Kernel
> - with full preemption  it runs but the serial line can't be used for 
> receiving at
> high bit rate (using lrz)

...but if you drop the spinlock across the call to
tty_flip_buffer_push, you get an Oops?

Could you post the Oops?

> >> Complete Preemption (Real-Time) ok but the serials is just unusable due
> >> to too many overruns (just using lrz)
> >>     
> >
> > Is it worse than before? IIRC Remy mentioned something about
> > IRQF_NODELAY being the reason for moving all this code to softirq
> > context in the first place; does the interrupt handler run in hardirq
> > context?
> >
> >   
> In the complete preemption yes.

Which question did you answer "yes" to? That it's worse than before or
that the interrupt handler runs in hardirq context (i.e. IRQF_NODELAY)?

> > I think you're right. Can you change it and see if it helps?
> >
> >   
> I just change it because I have corruption on receiving buffer. All
> my test are done with this fix

Ok.

> > I guess I didn't test it thoroughly enough with DMA
> > disabled...slub_debug ought to catch such things, but not until we
> > receive enough data to actually overflow the buffer.
> >
> >   
> I just test it I don't have
> buffer overflow.

No, I'd expect your allocation fix to take care of that. Or did you by
any chance test without the fix and with slub_debug enabled?

> I protect with a spinlock the access to the register when we sending
> from the tasklet. It is correct?

I have no idea. Could you post some more specifics about what you
modified, for example a diff?

Most of the tasklet is already protected by the spinlock, so you must
be careful to avoid any lock recursion.

Haavard
