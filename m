Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbYIER4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbYIER4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 13:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbYIER4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 13:56:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43742 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751643AbYIER4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 13:56:30 -0400
Date: Fri, 5 Sep 2008 10:49:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, torvalds@linux-foundation.org,
       sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com,
       ink@jurassic.park.msu.ru, jbarnes@virtuousgeek.org,
       netdev@vger.kernel.org, viro@zeniv.linux.org.uk, ebiederm@xmission.com,
       dwmw2@infradead.org, sam@ravnborg.org, johnstul@us.ibm.com
Subject: Re: linux-next: Tree for September 3
Message-Id: <20080905104952.5e9ea394.akpm@linux-foundation.org>
In-Reply-To: <20080905110411.GA26846@elte.hu>
References: <20080904012544.cabed847.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0809040143350.3452@nehalem.linux-foundation.org>
	<20080904015701.5959623a.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0809040203510.3452@nehalem.linux-foundation.org>
	<20080904104554.32ffebea.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0809041058140.3400@nehalem.linux-foundation.org>
	<20080904113408.d47c65f6.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0809050041520.3243@apollo.tec.linutronix.de>
	<20080904161746.dc4800a4.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0809050121440.3243@apollo.tec.linutronix.de>
	<20080905110411.GA26846@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2008 13:04:11 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Thu, 4 Sep 2008, Andrew Morton wrote:
> > > > 
> > > > Cute, NULL pointer in the timer check code. Can you please addr2line
> > > > the exact code line or upload the vmlinux somewhere ?
> > > > 
> > > 
> > > erm, I might have lost that binary, and it only happened the once.  It
> > > happened shortly after the machine had fully booted, during
> > > establishment of the first sshd session.
> > > 
> > > It nuked the machine really well, too.  I had to pull the battery to
> > > get it back.
> > 
> > Known problem on Sonys. :(
> > 
> > > fwiw:
> > >
> > > (gdb) l *0xc0126e7f
> > > 0xc0126e7f is in get_next_timer_interrupt (kernel/timer.c:863).
> > > warning: Source file is more recent than executable.
> > > 858             for (array = 0; array < 4; array++) {
> > > 859                     struct tvec *varp = varray[array];
> > > 860     
> > > 861                     index = slot = timer_jiffies & TVN_MASK;
> > > 862                     do {
> > > 863                             list_for_each_entry(nte, varp->vec + slot, entry) {
> > > 864                                     found = 1;
> > > 865                                     if (time_before(nte->expires, expires))
> > > 866                                             expires = nte->expires;
> > > 867                             }
> > > 
> > > which looks reasonable.
> > 
> > Yeah, as Linus decoded it's that loop. So we look at some corrupted
> > entry here. 
> > 
> > CONFIG_DEBUG_OBJECTS (add debug_objects to the command line as well)
> > should catch it when this is a timer being discarded, freed or
> > reinitialized.
> > 
> > Otherwise, when it is just random corruption it wont help much.
> 
> i guess CONFIG_DEBUG_OBJECTS_TIMERS=y is practical, and 
> CONFIG_DEBUG_LIST=y would be nice as well - it can catch memory 
> corruptions rather early and is relatively light-weight.

I tested rc5-mm1 with all debug options except PAGEALLOC.  No help.

> [ and if there's any reproducability of the corruption and if it happens 
>   at a stable kernel address then a small custom hack in ftrace can 
>   catch it the moment it happens. ]

It was a once-off.
