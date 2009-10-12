Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbZJLNQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbZJLNQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 09:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbZJLNQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 09:16:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42005 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394AbZJLNQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 09:16:23 -0400
Date: Mon, 12 Oct 2009 15:15:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] panic.c: export panic_on_oops
Message-ID: <20091012131528.GC25464@elte.hu>
References: <1255241458-11665-1-git-send-email-dedekind1@gmail.com> <20091012111545.GB8857@elte.hu> <1255346731.9659.31.camel@localhost> <20091012113758.GB11035@elte.hu> <20091012140149.6789efab@marrow.netinsight.se> <20091012120951.GA16799@elte.hu> <1255349748.10605.13.camel@macbook.infradead.org> <20091012122023.GA19365@elte.hu> <20091012150650.51a4b4dc@marrow.netinsight.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012150650.51a4b4dc@marrow.netinsight.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Simon Kagstrom <simon.kagstrom@netinsight.net> wrote:

> On Mon, 12 Oct 2009 14:20:23 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * David Woodhouse <dwmw2@infradead.org> wrote:
> > 
> > > On Mon, 2009-10-12 at 14:09 +0200, Ingo Molnar wrote:
> > > > Also, would it be possible to just simplify the thing and not do any 
> > > > buffering at all? Extra buffering complexity in a console driver is only 
> > > > asking for trouble. Or is flash storage write cycles optimization that 
> > > > important in this case?
> > > 
> > > That and the fact that on NAND flash you have to write full pages at a 
> > > time -- that's 512 bytes, 2KiB or 4KiB depending on the type of chip. 
> > > So we really do want to buffer it where we can.
> > > 
> > > We don't want to write a 2KiB page for every line of printk output.
> > 
> > Then i think the buffering is at the wrong place: we should instead 
> > buffer in the generic layer and pass it to lowlevel if we know that we 
> > have gone past a 2K boundary.
> >
> > The size of the generic log buffer is always a power of two so 
> > detecting 2K boundaries is very easy. On any emergency the generic 
> > console layer will do faster flushes - this is nothing the console 
> > driver itself should bother with.
> 
> But this is only part of the mtdoops problem (the reason why we don't 
> write all the time). The current code only stores messages printed 
> during an oops, and this behavior will surely change if the console 
> driver gets large buffers of output - or it would have to take in the 
> output unbuffered anyway.
> 
> My patch changes this behavior, and with that I don't think buffered 
> output would be a problem - it would indeed make it more simple as you 
> say - assuming there is something like ->kernel_bug() that would flush 
> the last 4KiB or so of messages to mtdoops when there is an oops or 
> panic.
> 
> > And that would avoid the whole workqueue logic - which is fragile to 
> > be done in a printk to begin with.
> 
> I'm afraid I don't really see this issue. The workqueue is used to 
> write the buffer to the mtd device if we are not in a panic or 
> interrupt context - in which case we do it directly.
> 
> So it's only used when an oops is ongoing.

This fixation on 'panic' is so wrong!

90% of the bugs users care about dont involve any panic. And even if 
there is a panic down the line, most of the interesting messages are in 
the stream leading up to the panic - now tucked away in that async 
workqueue mechanism and not visible.

There's two clean solutions i think:

1) add some new "ok, there's trouble!" callback to struct console and 
   the console driver could via that mechanism send out the _last_ 2KB 
   (or more) of kernel log messages. Basically we can go back in time by 
   looking at the dmesg buffer. The low level console driver does not 
   need to 'follow' the high level console state - it only wants to 
   print in case of trouble anyway.

2) or add buffered (flash-friendly) writes for all printk output - panic
   and non-panic alike. This would be useful to debug suspend/resume
   bugs for example. This would also optimize the packets of netconsole
   output. (last i checked we sent a packet per line.)

The workqueue looks wrong in both variants. If we are panic-ing (or 
hanging, or ...) then we are halting the machine - the workqueue has no 
chance to actually execute.

	Ingo
