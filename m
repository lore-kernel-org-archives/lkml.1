Return-Path: <linux-kernel-owner+w=401wt.eu-S1762030AbYDSSA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762030AbYDSSA7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 14:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbYDSSAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 14:00:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48870 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929AbYDSSAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 14:00:49 -0400
Date: Sat, 19 Apr 2008 11:00:34 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080419110034.34b70bd5@laptopd505.fenrus.org>
In-Reply-To: <20080419145948.GA4528@lintop>
References: <200804181737.m3IHbabI010051@hera.kernel.org>
	<20080418142934.38ce6bf4.akpm@linux-foundation.org>
	<20080419142329.GA5339@elte.hu>
	<20080419145948.GA4528@lintop>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Apr 2008 09:59:48 -0500
Shawn Bohrer <shawn.bohrer@gmail.com> wrote:

> On Sat, Apr 19, 2008 at 04:23:29PM +0200, Ingo Molnar wrote:
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > >  config 4KSTACKS
> > > >  	bool "Use 4Kb for kernel stacks instead of 8Kb"
> > > > -	depends on DEBUG_KERNEL
> > > >  	depends on X86_32
> > > > +	default y
> > > 
> > > This patch will cause kernels to crash.
> > 
> > what mainline kernels crash and how will they crash? Fedora and
> > other distros have had 4K stacks enabled for years:
> 
> If by other distros you mean RHEL then yes.  However, openSUSE,
> Ubuntu, and Mandriva all still have 8K stacks.  I know of no other
> distributions that default to 4K.

centos, oracle and redflag tend to follow the RHEL/fedora settings.

To be honest, at this point we're at a situation where
* Several very popular distributions have this enabled for 5+ years,
  apparently without any real issues (otherwise the enterprise releases
  would have turned this off)
* The early "hot known issues" have been resolved afaik, things like
  block device stacking, and symlink recursion lookups are either no longer
  recursive, or a lot less recursive than they used to be.

There are clear benefits to 4K stacks (no need to reiterate the flamewar,
but worth mentioning)
* Less memory consumption in the lowmem zone (critical for enterprise use,
  also good for general performance)
* Kernel stacks at 8K are one of the most prominent order-1 allocations in the
  kernel; again with big-memory systems the fragmentation of the lowmem zone
  is a problem (and the distros that ship 4K stacks went there because of customer
  complaints)

On the flipside the arguments tend to be
1) certain stackings of components still runs the risk of overflowing
2) I want to run ndiswrapper
3) general, unspecified uneasyness.

For 1), we need to know which they are, and then solve them, because even on x86-64 with 8k stacks
they can be a problem (just because the stack frames are bigger, although not quite double, there).
I've not seen any recent reports, I'll try to extend the kerneloops.org client to collect the
"stack is getting low" warning to be able to see how much this really happens.

for 2), the real answer there is "ndiswrapper needs 12kb not 8kb"

for 3), this is hard to deal with but also generally unfounded... you can use this argument against any change in the kernel.

