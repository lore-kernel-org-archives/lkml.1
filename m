Return-Path: <linux-kernel-owner+w=401wt.eu-S1760642AbYALTP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642AbYALTP5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 14:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756871AbYALTPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 14:15:49 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34131 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756223AbYALTPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 14:15:47 -0500
Date: Sat, 12 Jan 2008 11:15:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Jens Axboe <jens.axboe@oracle.com>, Paul Mundt <lethal@linux-sh.org>,
       linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SH/Dreamcast - add support for GD-Rom CDROM drive on
 SEGA Dreamcast
Message-Id: <20080112111520.abf625ce.akpm@linux-foundation.org>
In-Reply-To: <1200147241.6207.17.camel@localhost.localdomain>
References: <1200007549.6349.16.camel@localhost.localdomain>
	<1200088609.6213.3.camel@localhost.localdomain>
	<20080112053630.0ccb290e.akpm@linux-foundation.org>
	<1200147241.6207.17.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jan 2008 14:14:01 +0000 Adrian McMenamin <adrian@newgolddream.dyndns.info> wrote:

> 
> > > +	spin_command->cmd[0] = 0x70;
> > > +	spin_command->cmd[2] = 0x1f;
> > > +	spin_command->buflen = 0;
> > > +	gd.pending = 1;
> > > +	gdrom_packetcommand(gd.cd_info, spin_command);
> > > +	/* 60 second timeout */
> > > +	wait_event_interruptible_timeout(command_queue, gd.pending == 0, HZ * 60);
> > > +	gd.pending = 0;
> > > +	kfree(spin_command);
> > > +	if (gd.status & 0x01) {
> > > +		/* log an error */
> > > +		gdrom_getsense(NULL);
> > > +		return -EIO;
> > > +	}
> > > +	return 0;
> > > +}
> > 
> > If the wait_event_interruptible_timeout() indeed times out, we go ahead and
> > free spin_command.  But someone else could potentially be using it. 
> > 
> > Suppose gdrom_packetcommand() got stuck for a minute due to bad hardware,
> > or some SCHED_FIFO task preempting us here and running for 61 seconds without
> > yielding or something similarly weird.
> > 
> 
> 
> Maybe I am being stupid here, but I don't follow this. They'll get a
> non-fatal error, that's all. Who else would be using spin_command? It's
> just a series of bytes to plug into the GD Rom registers, that's all.
> 

After programming the registers we need to wait for the interrupt to clear
gd.pending, don't we?

<looks>

oh, I see.  gd is a global singleton and we only support one command at a
time and one device.  hrm.

> > > +
> > > +static int __devinit gdrom_set_interrupt_handlers(void)
> > > +{
> > > +	int err;
> > > +	init_waitqueue_head(&command_queue);
> > > +	err = request_irq(HW_EVENT_GDROM_CMD, gdrom_command_interrupt, IRQF_DISABLED, "gdrom_command", &gd);
> > > +	if (err)
> > > +		return err;
> > > +	init_waitqueue_head(&request_queue);
> > 
> > You can initialise command_queue and request_queue at compile-time with
> > DECLARE_WAIT_QUEUE_HEAD().
> > 
> 
> Are you saying that is better?

Yup.  Less source code, less object code, no startup-ordering issues.


