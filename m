Return-Path: <linux-kernel-owner+w=401wt.eu-S1761643AbYA3KfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761643AbYA3KfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 05:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757860AbYA3Kem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 05:34:42 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:56179 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755542AbYA3Kel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 05:34:41 -0500
Date: Wed, 30 Jan 2008 11:34:34 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Remy Bohmer" <linux@bohmer.net>
Cc: michael <trimarchi@gandalf.sssup.it>, fabio@gandalf.sssup.it,
       "Andrew Victor" <linux@maxim.org.za>,
       "Chip Coldwell" <coldwell@redhat.com>,
       "Marc Pignat" <marc.pignat@hevs.ch>,
       "David Brownell" <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -mm v4 6/9] atmel_serial: Split the interrupt handler
Message-ID: <20080130113434.2519f77c@dhcp-252-066.norway.atmel.com>
In-Reply-To: <3efb10970801300221h601261edy33cf89dac5abde78@mail.gmail.com>
References: <20080129224316.GA23155@gandalf.sssup.it>
	<479FB2D7.4020804@gandalf.sssup.it>
	<20080130104113.48ec376f@dhcp-252-066.norway.atmel.com>
	<3efb10970801300221h601261edy33cf89dac5abde78@mail.gmail.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008 11:21:49 +0100
"Remy Bohmer" <linux@bohmer.net> wrote:

> > >  * Drop the lock here since it might end up calling
> > >  * uart_start(), which takes the lock.
> > >    spin_unlock(&port->lock);
> > >  */
> > >     tty_flip_buffer_push(port->info->tty);
> > > /*
> > >     spin_lock(&port->lock);
> > >  */
> > > The same code with this comments out runs  
> 
> I expect the UART generating the problem is the DBGU port. The DBGU
> shares its interrupt line with the timer interrupt with the IRQF_TIMER
> flag set, and thus the DBGU interrupt handler is running in
> IRQF_NODELAY context. Within this context it is forbidden to lock a
> normal spinlock, because a normal spinlock is converted to a mutex on
> Preempt-RT; a mutex can sleep which is forbidden in interrupt context.
> So, to get around this problem, this lock spinlock has to be of the
> raw_spinlock_t type. The raw_spinlock_t is the normal mainline-kernel
> spinlock, and as such it is not converted to a mutex, and will
> therefor never sleep.
> 
> Attached a patch that changes this spinlock type. I used it in my
> patchset, but your updates of December last year do not need this
> patch anymore, so apparantly you changed something that has a
> regression on Preempt-RT...

The code above is from the tasklet, so I don't think that's the problem.
The interrupt handler doesn't take any locks.

Or are spinlocks not allowed in softirq context either?

> I believe I have to look at the latest set of patches, and try to find
> any regressions. Do you have a location somewhere where I can download
> the latest versions? Or do I need to dig through LKML to find the
> latest... ;-)

They are in -mm. You were Cc'ed I think...

Haavard

Haavard
