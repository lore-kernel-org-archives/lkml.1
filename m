Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbXFDW01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbXFDW01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbXFDW0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:26:20 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:56477 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753102AbXFDW0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:26:19 -0400
Date: Mon, 4 Jun 2007 18:26:16 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: Matt Mackall <mpm@selenic.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/9] Conditional Calls - Hash Table
Message-ID: <20070604222616.GC1169@Krystal>
References: <20070530140227.398040643@polymtl.ca> <p731wgxds85.fsf@bingen.suse.de> <20070601160802.GL11166@waste.org> <20070601164623.GB4112@Krystal> <20070601170739.GA11115@waste.org> <20070601174510.GG7217@one.firstfloor.org> <20070601180654.GB7641@Krystal> <20070601193558.GH7217@one.firstfloor.org> <20070601203306.GA14316@Krystal> <20070601204434.GN7217@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070601204434.GN7217@one.firstfloor.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:21:17 up 7 days,  6:59,  3 users,  load average: 0.57, 0.43, 0.38
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> On Fri, Jun 01, 2007 at 04:33:06PM -0400, Mathieu Desnoyers wrote:
> > * Andi Kleen (andi@firstfloor.org) wrote:
> > > > Yes, but as you have probably understood, I want to have everything
> > > > embedded at the cond_call() site rather than polluting the rest of the
> > > > code with declarations.
> > > 
> > > A cond call is essentially a fancy variable. And the Linux kernel
> > > is written in C and in C you declare variables before you use them.
> > > Also it would allow compile time checking against typos and 
> > > allow removing some nasty hash table code. The proposal sounds like a 
> > > clear winner to me. 
> > > 
> > 
> > You could not declare in advance a structure that would contain pointers
> > to every load immediate instruction of the optimized cond_calls. Unless
> 
> To find them you just walk the sections.  Changing cond call is a slow
> path operation. That is similar to how the smp lock switching
> works today.
> 
> > I understand that if we limit ourselves to applications like the two
> > toy examples I proposed (enabling profiling and bug fixups), it could
> > make sense to try to declare a variable somewhere and later use it in
> > the body of functions (except the fact that it cannot work, due to
> > incapacity to declare pointers to each load immediate instruction, as
> > stated above). Even if it would work, the main purpose here is to
> > support the Linux Kernel Markers, where the goal is to provide the
> > ability to declare a marker within the body of a function without
> > requiring more hassle than a printk, but with less performance impact
> > than the latter. Also, we would not want the whole kernel to recompile
> > simply because someone chose to add one or two marker in his own driver
> > to extract some more information and had to add them to some globally
> > included header file.
> 
> Sounds similar to config.h then when Kconfig keeps track of those
> dependencies for the CONFIG_*s and only recompiles what is needed. Perhaps 
> this infrastructure could be reused.
> 

I took time to think about your proposal, and it's all good. the
cond_calls will now depend on a variable address and feed a if()
statement.

If conditional calls CONFIG_* option is disabled, the variable (an
integer) will feed the if().

If enabled, the optimized version will feed the if() with the load
immediate. The generic version will give the integer variable to the if.
(I document that this variable should be declared __read_mostly).

The markers, however, will declare this variable by themselves in their
macro, so it is transparent to the programmer.

All this will be implemented in the next release. Thanks for your
insightful comments!

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
