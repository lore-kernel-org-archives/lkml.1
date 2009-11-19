Return-Path: <linux-kernel-owner+w=401wt.eu-S1751985AbZKSMFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbZKSMFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 07:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750773AbZKSMFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 07:05:25 -0500
Received: from bamako.nerim.net ([62.4.17.28]:50198 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbZKSMFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 07:05:24 -0500
Date: Thu, 19 Nov 2009 13:05:26 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Leon Woestenberg <leon.woestenberg@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       linux-i2c@vger.kernel.org, rt-users <linux-rt-users@vger.kernel.org>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: yield() in i2c non-happy paths hits BUG under -rt patch
Message-ID: <20091119130526.23a69b85@hyperion.delvare>
In-Reply-To: <alpine.LFD.2.00.0911182127040.24119@localhost.localdomain>
References: <c384c5ea0911071101u7415d37o2611c542e5fae309@mail.gmail.com>
	<20091107210147.3e754278@hyperion.delvare>
	<4AF7148C.9090706@thebigcorporation.com>
	<20091112211255.09cd884a@hyperion.delvare>
	<alpine.LFD.2.00.0911132139560.24119@localhost.localdomain>
	<20091116155606.GC29479@sirena.org.uk>
	<c384c5ea0911171650t1c441dc4v746d31e4154fcb30@mail.gmail.com>
	<20091118010520.4cd397d4@lxorguk.ukuu.org.uk>
	<c384c5ea0911180828x7c857189w3316c93bb78100ab@mail.gmail.com>
	<20091118175202.490989d8@hyperion.delvare>
	<alpine.LFD.2.00.0911182127040.24119@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Nov 2009 21:36:48 +0100 (CET), Thomas Gleixner wrote:
> On Wed, 18 Nov 2009, Jean Delvare wrote:
> 
> > On Wed, 18 Nov 2009 17:28:53 +0100, Leon Woestenberg wrote:
> > > On Wed, Nov 18, 2009 at 2:05 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > > Our timers are very efficient and some day we will need to make jiffies a
> > > > function and stop the timer ticking for best performance. At that point
> > > > timers are probably the most efficient way to do much of this.
> > >
> > > The problem with I2C bitbanged is the stringent timing, we need a way
> > > to have fine-grained sleeping
> > > mixed with real-time tasks in order to make this work.
> > 
> > FWIW, the problem that was initially reported has nothing to do with
> > this. i2c-algo-bit used mdelay() during transactions, not yield().
> > yield() is used only in once place, _between_ transactions attempts.
> > There are no strict timing constraints there.
> 
> That still does not explain why yield() is necessary _between_ the
> transaction attempts.

It is not _necessary_. We are just trying to be fair to other kernel
threads, because bit-banging is expensive and this is the only case
where we know we can tolerate a delay.

Just to clarify things... does (or did) yield() have anything to do
with CONFIG_PREEMPT_VOLUNTARY?

> That code is fully preemptible, otherwise you could not call
> yield().

How does one know what code is preemtible and what code is not? The
rest of the i2c-algo-bit code should definitely _not_ be preemtible, as
it is highly timing sensitive.

> And as I said before nobody even noticed that the yield()
> default implementation was changed to a NOOP by default in the
> scheduler.

Well, I guess only people monitoring system latency would notice, as
this is the only thing yield() was supposed to help with in the first
place.

You say "NOOP by default", does this imply there is a way to change
this?

Was yield() turned into NOOP by design, or was it a bug?

-- 
Jean Delvare
