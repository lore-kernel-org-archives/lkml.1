Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbYIELFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbYIELFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 07:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbYIELFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 07:05:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36442 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbYIELFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 07:05:06 -0400
Date: Fri, 5 Sep 2008 13:04:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com,
       ink@jurassic.park.msu.ru, jbarnes@virtuousgeek.org,
       netdev@vger.kernel.org, viro@zeniv.linux.org.uk, ebiederm@xmission.com,
       dwmw2@infradead.org, sam@ravnborg.org, johnstul@us.ibm.com
Subject: Re: linux-next: Tree for September 3
Message-ID: <20080905110411.GA26846@elte.hu>
References: <20080904012544.cabed847.akpm@linux-foundation.org> <alpine.LFD.1.10.0809040143350.3452@nehalem.linux-foundation.org> <20080904015701.5959623a.akpm@linux-foundation.org> <alpine.LFD.1.10.0809040203510.3452@nehalem.linux-foundation.org> <20080904104554.32ffebea.akpm@linux-foundation.org> <alpine.LFD.1.10.0809041058140.3400@nehalem.linux-foundation.org> <20080904113408.d47c65f6.akpm@linux-foundation.org> <alpine.LFD.1.10.0809050041520.3243@apollo.tec.linutronix.de> <20080904161746.dc4800a4.akpm@linux-foundation.org> <alpine.LFD.1.10.0809050121440.3243@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809050121440.3243@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Thu, 4 Sep 2008, Andrew Morton wrote:
> > > 
> > > Cute, NULL pointer in the timer check code. Can you please addr2line
> > > the exact code line or upload the vmlinux somewhere ?
> > > 
> > 
> > erm, I might have lost that binary, and it only happened the once.  It
> > happened shortly after the machine had fully booted, during
> > establishment of the first sshd session.
> > 
> > It nuked the machine really well, too.  I had to pull the battery to
> > get it back.
> 
> Known problem on Sonys. :(
> 
> > fwiw:
> >
> > (gdb) l *0xc0126e7f
> > 0xc0126e7f is in get_next_timer_interrupt (kernel/timer.c:863).
> > warning: Source file is more recent than executable.
> > 858             for (array = 0; array < 4; array++) {
> > 859                     struct tvec *varp = varray[array];
> > 860     
> > 861                     index = slot = timer_jiffies & TVN_MASK;
> > 862                     do {
> > 863                             list_for_each_entry(nte, varp->vec + slot, entry) {
> > 864                                     found = 1;
> > 865                                     if (time_before(nte->expires, expires))
> > 866                                             expires = nte->expires;
> > 867                             }
> > 
> > which looks reasonable.
> 
> Yeah, as Linus decoded it's that loop. So we look at some corrupted
> entry here. 
> 
> CONFIG_DEBUG_OBJECTS (add debug_objects to the command line as well)
> should catch it when this is a timer being discarded, freed or
> reinitialized.
> 
> Otherwise, when it is just random corruption it wont help much.

i guess CONFIG_DEBUG_OBJECTS_TIMERS=y is practical, and 
CONFIG_DEBUG_LIST=y would be nice as well - it can catch memory 
corruptions rather early and is relatively light-weight.

[ and if there's any reproducability of the corruption and if it happens 
  at a stable kernel address then a small custom hack in ftrace can 
  catch it the moment it happens. ]

	Ingo
