Return-Path: <linux-kernel-owner+w=401wt.eu-S1761751AbXHEOAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761751AbXHEOAt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 10:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756646AbXHEOAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 10:00:40 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:48481 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757565AbXHEOAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 10:00:39 -0400
Date: Sun, 5 Aug 2007 17:00:37 +0300 (EEST)
From: Timo Jantunen <jeti@welho.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ayaz Abdulla <aabdulla@nvidia.com>
Subject: Re: 2.6.22.1: hang with forcedeth driver?
In-Reply-To: <20070803122241.4d242978.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708051629170.6058@limbo>
References: <Pine.LNX.4.64.0708021044260.6069@limbo>
 <20070803122241.4d242978.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2007, Andrew Morton wrote:

> On Thu, 2 Aug 2007 11:57:21 +0300 (EEST)
> Timo Jantunen <jeti@welho.com> wrote:
> 
> > Heip!
> > 
> > I have had few total hangs with 2.6.22.1 kernel. Everything suddenly 
> > freezes and nothing works (SysRq keys, pinging the machine from the 
> > network.) Neither syslog nor netconsole have any relevant messages. I'm 99% 
> > sure this didn't happen in 2.6.21.x kernels.
> 
> Try enabling the NMI watchdog?  (boot with nmi_watchdog=1 on the kernel
> command line) (or maybe nmi_watchdog=2).

nmi_watchdog=1 got me (in dmesg)
Testing NMI watchdog ... CPU#0: NMI appears to be stuck (0->0)!
CPU#1: NMI appears to be stuck (0->0)!

nmi_watchdog=2 got me
Testing NMI watchdog ... OK.

In both cases, when the machine hanged, nothing happened and nothing more 
was written to console, syslog or netconsole (with console Loglevel set to 
9.)


> otoh, I think NMI watchdog is always enabled on x86_64.  But the counts
> aren't going up.  I forget what the story is there, apart from
> lets-be-as-different-from-i386-as-we-can :(

Like I said later I'm using i386 kernel.


> > All hangs happened with relatively high network traffic (twice with mplayer 
> > using remote display, once with high network fs activity). I copied 
> > gigabytes of files over nfs but couldn't dupicatate the problem that way, 
> > but OTOH I have also watched hours of video without problems so the problem 
> > doesn't occur often. (In the mplayer case, the file I play is usually on 
> > remote nfs disk, too.)
> > 
> > I started using mplayer from a text console and today I finally managed to 
> > catch first bit of information. The machine hanged like before (even SysRq 
> > keys don't print anything) but there was one console message:
> > 
> > eth0: too many iterations (6) in nv_nic_irq.
> > 
> > Looking at the sources, it seems when too much works happens in a single 
> > interrupt, the driver tries to disable device interrupts (and prints above 
> > message). It doesn't seem to be expecting the machine to hang afterwards.
> > 
> > I guess the quick fix for me is to increase max_interrupt_work value so it 
> > doesn't get hit as easily.
> 
> Well.  A Key piece of information would be: did that help?

I added forcedeth.max_interrupt_work=16 to the command line, and haven't 
seen the problem after that. But I did hit the problem about once a week so 
I can't say if it is gone for good yet.


For the tests with NMI I used forcedeth.max_interrupt_work=2 and managed to 
reproduce the problem in few minutes by copying from /dev/zero to nfs disk. 
I also did it without any binary drivers loaded.


As I see it there is two separate problems: that "too many iterations" 
message and the fact the machine hangs after it. Since the same test was in 
the previous kernel but I don't remember ever seeing it it is possible that 
2.6.22 changed timings or something like that which made hitting the 
default max_interrupt_work limit more likely.

I can try to get 2.6.21.x hang with forcedeth.max_interrupt_work=2 if you 
think that information is useful.


> > I have nForce3 board and Athlon 64 X2 CPU (but using 32-bit kernel). I'm 
> > using the built in ethernet with forcedeth driver. I also have ATI/AMD 
> > binary drivers loaded, and at least in some of the cases, VMware host 
> > drivers, too.

//T

