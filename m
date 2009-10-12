Return-Path: <linux-kernel-owner+w=401wt.eu-S932524AbZJLPCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524AbZJLPCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932155AbZJLPCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:02:32 -0400
Received: from ernst.netinsight.se ([194.16.221.21]:13127 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932133AbZJLPCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:02:31 -0400
Date: Mon, 12 Oct 2009 17:01:39 +0200
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro \(Nokia-D/Helsinki\)" <aaro.koskinen@nokia.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] panic.c: export panic_on_oops
Message-ID: <20091012170139.147fbddc@marrow.netinsight.se>
In-Reply-To: <20091012143017.GC4565@elte.hu>
References: <20091012111545.GB8857@elte.hu>
	<1255346731.9659.31.camel@localhost>
	<20091012113758.GB11035@elte.hu>
	<20091012140149.6789efab@marrow.netinsight.se>
	<20091012120951.GA16799@elte.hu>
	<1255349748.10605.13.camel@macbook.infradead.org>
	<20091012122023.GA19365@elte.hu>
	<20091012150650.51a4b4dc@marrow.netinsight.se>
	<20091012131528.GC25464@elte.hu>
	<20091012153937.0dcd73e5@marrow.netinsight.se>
	<20091012143017.GC4565@elte.hu>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 16:30:17 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> * Simon Kagstrom <simon.kagstrom@netinsight.net> wrote:
> 
> > OK, I don't think we understand each other. Sorry if I'm being slow 
> > here, please tell me if I'm misunderstanding something fundamental 
> > below.
> 
> [ it could easily be me being confused - i dont know the mtdoops code 
>   that well - i just raised an eyebrow at the export request, which 
>   yelled 'layering violation' at me ;-) ]

I sent the same patch (export panic_on_oops) to LKML a week ago, but
got no replies. I now know who to Cc next time ;-)

> > > 2) or add buffered (flash-friendly) writes for all printk output - panic
> > >    and non-panic alike. This would be useful to debug suspend/resume
> > >    bugs for example. This would also optimize the packets of netconsole
> > >    output. (last i checked we sent a packet per line.)
> > 
> > Well, suspend/resume hangs is one of the cases which mtdoops won't 
> > catch. [...]
> 
> ( Sidenote: i see no reason why that wouldnt be possible if it's 
>   implemented properly. )

Provided there is a callback for "really_dump_the_console" which gets
called from interesting places (e.g., suspend/resume) it should be easy
to do with the patched mtdoops without much changes, at least with my
proposed circular buffer patch it will be trivial.

> > [...] But at least on NAND flash, I'd be a bit weary about logging all 
> > printk output for fear of wearing out the flash.
> 
> Clearly should be optional - like the s2ram debug hack to RTC registers 
> is optional on x86.

That would be OK for me at least, and again should not be very difficult
to implement even with todays code.

> > > The workqueue looks wrong in both variants. If we are panic-ing (or 
> > > hanging, or ...) then we are halting the machine - the workqueue has 
> > > no chance to actually execute.
> > 
> > but then we are using mtd->panic_write to write it out directly, not 
> > via the work queue.
> 
> ... i might be confused, but in which case _is_ the workqueue used?
> 
> It clearly shows up in the codepaths i've read, but maybe i've 
> misinterpreted what it does.

With the code in mainline, it basically works like this. 

- When oops_in_progress is not set, mtdoops_console_write will not put
  anything in the buffer. It will call mtdoops_console_sync(), but
  since the buffer will be empty (cxt->writecount is 0), no writes will
  be done.

- When oops_in_progress _is_ set, mtdoops_console_write will start
  putting things in the buffer.

- mtdoops_console_sync is then called either when the buffer has been
  filled, or when ->unblank() is called, or when oops_in_progress is no
  longer true.

  This is the place when the workqueue _can_ be used (in the cases when
  this is not in interrupt context or panic_on_oops is unset).

With my patch it instead works like this:

- mtdoops_console_write continuously writes messages to the buffer, but
  never calls mtdoops_console_sync() itself.

- mtdoops_console_sync (i.e., the ->unblank() callback) will schedule
  work if oops_in_progress is set.

- if we have a panic, it will call mtdoops_write directly (if
  mtd->panic_write is set, otherwise we are out of luck). This is also
  the code path on oopses in interrupt context.

So the workqueue only gets used on unblank() from oopses. I think the
second implementation is simpler, but it also changes the behavior of
mtdoops a bit to include messages before the oops/panic as well.

// Simon
