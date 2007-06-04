Return-Path: <linux-kernel-owner+w=401wt.eu-S1760696AbXFDUA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760696AbXFDUA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 16:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759261AbXFDUAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 16:00:19 -0400
Received: from waste.org ([66.93.16.53]:58859 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759009AbXFDUAR (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 16:00:17 -0400
Date: Mon, 4 Jun 2007 14:59:51 -0500
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       Linux-kernel@vger.kernel.org
Subject: Re: Interesting interaction between lguest and CFS
Message-ID: <20070604195951.GJ11115@waste.org>
References: <20070604173710.GR11166@waste.org> <20070604181151.GA1745@elte.hu> <20070604184224.GH11115@waste.org> <20070604191229.GA12444@elte.hu> <20070604192755.GI11115@waste.org> <20070604194038.GA15782@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604194038.GA15782@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 09:40:38PM +0200, Ingo Molnar wrote:
> 
> * Matt Mackall <mpm@selenic.com> wrote:
> 
> > > ah, so both the shell and the 'competing' CPU hog was running within 
> > > the same lguest instance?
> > 
> > No.
> > 
> > The CPU hog is running in the host. A single instance of lguest using 
> > busybox is started in another shell. When it reaches a shell prompt, 
> > -that- shell is occassionally unresponsive for long stretches.
> 
> so the shell within lguest is affected by the CPU hog outside? Could you 
> send me the sched-debug stats of the CPU hog and of the lguest host 
> process as well? (or were those amongst the ones you already sent?)

I sent you the stats for:

- both lguest processes
- the bash which started lguest (which I suspect you don't actually
  want)
- the gnome-terminal that lguest was running inside of
  (keystrokes to the shell in lguest go through that terminal)

The last is probably not very interesting either, as gnome-terminal is
a single process with multiple windows and none of the other windows
were affected.

So I sent you everything but the stats for the CPU hog.

I suggest you try this yourself - lguest is incredibly easy to get up
and running. It's also quite useful: I can test-boot kernels with it
in less than a second, or about 10x faster than basic qemu, and 100x
faster than a real boot. And as it uses a pty as console, you can do
things like pipe it through grep.

You'll need the following tab-damaged patch for rc3-mm1:

--- mm.orig/arch/i386/kernel/sched-clock.c      2007-06-04 12:15:51.000000000 -0500
+++ mm/arch/i386/kernel/sched-clock.c   2007-06-04 12:15:57.000000000
-0500
@@ -133,7 +133,7 @@ static void resync_freq(void *arg)
        struct sc_data *sc = &__get_cpu_var(sc_data);
 
        sc->sync_base = jiffies;
-       if (!cpu_has_tsc) {
+       if (!cpu_has_tsc || tsc_disable) {
                sc->unstable = 1;
                return;
        }

-- 
Mathematics is the supreme nostalgia of our time.
