Return-Path: <linux-kernel-owner+w=401wt.eu-S1759745AbZANVPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759745AbZANVPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 16:15:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755831AbZANVP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 16:15:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59772 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418AbZANVPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 16:15:25 -0500
Date: Wed, 14 Jan 2009 22:14:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       paulmck@linux.vnet.ibm.com, ghaskins@novell.com, matthew@wil.cx,
       andi@firstfloor.org, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-btrfs@vger.kernel.org, tglx@linutronix.de, npiggin@suse.de,
       pmorreale@novell.com, SDietrich@novell.com, dmitry.adamushko@gmail.com,
       hannes@cmpxchg.org
Subject: Re: [GIT PULL] adaptive spinning mutexes
Message-ID: <20090114211458.GD6519@elte.hu>
References: <1231867314.7141.16.camel@twins> <1231952436.14825.28.camel@laptop> <20090114183319.GA18630@elte.hu> <20090114105300.66bd014d.akpm@linux-foundation.org> <20090114190008.GA13203@elte.hu> <20090114113638.c818fcf8.akpm@linux-foundation.org> <20090114201435.GA6519@elte.hu> <20090114123017.9acf42d7.akpm@linux-foundation.org> <20090114205122.GC6519@elte.hu> <20090114130642.cf2b18b2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114130642.cf2b18b2.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 14 Jan 2009 21:51:22 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > > > Do people enable CONFIG_SCHED_DEBUG?
> > > > 
> > > > If they suspect performance problems and want to analyze them?
> > > 
> > > The vast majority of users do not and usually cannot compile their own 
> > > kernels.
> > 
> > ... which they derive from distro kernels or some old .config they always 
> > used, via 'make oldconfig'. You are arguing against well-established facts 
> > here.
> > 
> > If you dont believe my word for it, here's an analysis of all kernel 
> > configs posted to lkml in the past 8 months:
> > 
> >    $ grep ^CONFIG_SCHED_DEBUG linux-kernel | wc -l
> >    424
> > 
> >    $ grep 'CONFIG_SCHED_DEBUG is not' linux-kernel | wc -l
> >    109
> > 
> > i.e. CONFIG_SCHED_DEBUG=y is set in 80% of the configs. A large majority 
> > of testers has it enabled and /sys/debug/sched_features was always a good 
> > mechanism that we used for runtime toggles.
> 
> You just disproved your own case :(

how so? 80% is not enough? I also checked Fedora and it has SCHED_DEBUG=y 
in its kernel rpms.

note that there's also a performance issue here: we generally _dont want_ 
a debug sysctl overhead in the mutex code or in any fastpath for that 
matter. So making it depend on SCHED_DEBUG is useful.

sched_feat() features get optimized out at build time when SCHED_DEBUG is 
disabled. So it gives us the best of two worlds: the utility of sysctls in 
the SCHED_DEBUG=y, and they get compiled out in the !SCHED_DEBUG case.

	Ingo
