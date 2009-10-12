Return-Path: <linux-kernel-owner+w=401wt.eu-S932119AbZJLM2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbZJLM2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 08:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbZJLM2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 08:28:10 -0400
Received: from ernst.netinsight.se ([194.16.221.21]:40812 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755053AbZJLM2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 08:28:09 -0400
Date: Mon, 12 Oct 2009 14:27:14 +0200
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       David Woodhouse <dwmw2@infradead.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] panic.c: export panic_on_oops
Message-ID: <20091012142714.56362465@marrow.netinsight.se>
In-Reply-To: <20091012120951.GA16799@elte.hu>
References: <1255241458-11665-1-git-send-email-dedekind1@gmail.com>
	<20091012111545.GB8857@elte.hu>
	<1255346731.9659.31.camel@localhost>
	<20091012113758.GB11035@elte.hu>
	<20091012140149.6789efab@marrow.netinsight.se>
	<20091012120951.GA16799@elte.hu>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 14:09:51 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> > Well, the main reason is to get the write done directly if we know 
> > we're going to crash. The rest of the code around the patch looks like 
> > this:
> > 
> >          if (mtd->panic_write && (in_interrupt() || panic_on_oops))
> >                  /* Interrupt context, we're going to panic so try and log */
> >                  mtdoops_write(cxt, 1);
> >          else
> >                  schedule_work(&cxt->work_write);
> > 
> > so if we're oopsing in interrupt context or are going to panic, we 
> > just write directly. mtdoops_write will then use mtd->panic_write if 
> > it's available to get the write done immediately without sleeping.
> 
> but i'm not sure that code achieves your intention.
> 
> in_interrupt() is a generic test. It will be true whenever you printk in 
> irq context - be that a panic or not a panic.

Well, this particular code is only called when oops_in_progress is set,
so we know we have an oops chasing us. And if we oops in an interrupt,
we're going to panic and the same thing goes if panic_on_oops is set.

So the current code only logs messages which happen when an oops is in
progress.

> Also, the panic_on_oops usage looks wrong as well: it is set on a system 
> that wants a panic on oops - but the flag will be set all the time, even 
> when we are not oopsing.
> 
> I suppose the intention is to add a logic like this:
> 
>  - buffer writes to the MTD async writeout thread for regular printks
> 
>  - if we are in some sort of emergency, write to the MTD device directly 
>    as we cannot buffer anymore.
> 
> Correct?

Almost :-). During an oops, it stores in a memory buffer until we have
either filled the memory buffer, the oops is over, or unblank() is called,
and after that it will write out the buffer to flash.

I believe the other implementation (outlined below) is a bit simpler in
that respect. That will also log all messages (well the last 4-8KB or
so of them), but only write it out when a panic or oops occurs.

> > So with this one, the exported panic_on_oops is no longer needed, and 
> > normal oopses are handled by the scheduled work while panic_on_oopses 
> > are handled by the panic handler.
> 
> Yes, that looks like the better direction - but 'panic' is still the 
> wrong trigger condition i think. We generally just crash and dont panic. 
> Often we'll display a kernel warning and then hang. Etc.

But how can we detect that? The code above will write to the MTD device
either if an oops happens, or if we panic for some reason. If the
kernel just hangs (and is reset by the watchdog, if we have one), how
should we know when to write the log out?


For me personally, the panic case is the important one. Regular oopses
(without panic_on_oops) can go to syslog, but it's important to be able
to catch the cases when the kernel panics as well.

// Simon
