Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404AbYEIGvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbYEIGvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 02:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbYEIGuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 02:50:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39156 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbYEIGuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 02:50:54 -0400
Date: Fri, 9 May 2008 08:50:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] speed up / fix the new generic semaphore code (fix
	AIM7 40% regression with 2.6.26-rc1)
Message-ID: <20080509065032.GB15754@elte.hu>
References: <20080508120130.GA2860@elte.hu> <20080508122802.GA4880@elte.hu> <alpine.LFD.1.10.0805080859140.3024@woody.linux-foundation.org> <alpine.LFD.1.10.0805081128550.3024@woody.linux-foundation.org> <20080508201956.GA2547@elte.hu> <alpine.LFD.1.10.0805081326130.2940@woody.linux-foundation.org> <20080508214557.GA13311@elte.hu> <alpine.LFD.1.10.0805081535130.2940@woody.linux-foundation.org> <20080509001647.244393bc@core> <alpine.LFD.1.10.0805081631440.2940@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805081631440.2940@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > I don't think fixing n_tty is now a big job if someone wants to take 
> > a swing at it. The driver write/throttle/etc routines below the 
> > n_tty ldisc layer are now BKL clean so it should just be the 
> > internal locking of the buffers, window and the like to tackle.
> 
> Well, it turns out that Ingo's fixed statistics actually put the real 
> cost in fcntl/ioctl/open/release:
> 
>     310  down <= lock_kernel <= sys_fcntl <= system_call_after_swapgs <
>     332  down <= lock_kernel <= vfs_ioctl <= do_vfs_ioctl <
>     380  down <= lock_kernel <= tty_release <= __fput <
>     422  down <= lock_kernel <= chrdev_open <= __dentry_open <
> 
> rather than the write routines. But it may be that Ingo was just 
> profiling two different sections, and it's really all of them.

the first trace had general desktop load mixed into it as well - so 
while it's not interesting to AIM7 the BKL does matter in those 
situations and i'd not be surprised if it was responsible for certain 
categories of desktop lag.

The second trace was the correct 'pure' AIM7 workload which produces 
very little tty output. It is a quite stable workload and the trace i 
uploaded is representative of the totality of that workload. AIM7 runs 
for several minutes so there's no significant rampup/rampdown 
interaction either.

	Ingo
