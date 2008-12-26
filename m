Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbYLZIry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbYLZIry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 03:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbYLZIrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 03:47:46 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47124 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbYLZIrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 03:47:45 -0500
Subject: Re: TSC not updating after resume: Bug or Feature?
From: Peter Zijlstra <peterz@infradead.org>
To: Pavel Machek <pavel@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Fabio Comolli <fabio.comolli@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Steven Rostedt <srostedt@redhat.com>,
       dsaxena@plexity.net, LKML <linux-kernel@vger.kernel.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, toralf.foerster@gmx.de
In-Reply-To: <20081224140900.GA1624@ucw.cz>
References: <alpine.LFD.2.00.0812212031220.4548@localhost.localdomain>
	 <b637ec0b0812211443u1ca9c11du5d61c41e3d82bc16@mail.gmail.com>
	 <alpine.LFD.2.00.0812221543550.3723@localhost.localdomain>
	 <20081222150021.GA13839@elte.hu>
	 <alpine.LFD.2.00.0812221921460.3723@localhost.localdomain>
	 <alpine.LFD.2.00.0812222056190.3723@localhost.localdomain>
	 <b637ec0b0812221239p169967aemf14b2e591779f5cd@mail.gmail.com>
	 <alpine.LFD.2.00.0812222212191.3723@localhost.localdomain>
	 <b637ec0b0812221335w54fe11ecwf05e0302bc27b5a3@mail.gmail.com>
	 <alpine.LFD.2.00.0812222238192.3723@localhost.localdomain>
	 <20081224140900.GA1624@ucw.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 26 Dec 2008 09:47:21 +0100
Message-Id: <1230281241.9487.266.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-24 at 15:09 +0100, Pavel Machek wrote:
> Hi!
> > > >
> > > > Can please you revert the last patch and apply the following ? Does
> > > > the WARN_ON trigger ?
> > > >
> > 
> > > Yes, it does:
> >  
> > > [  159.768005]  [<c01389a2>] getnstimeofday+0x21/0xcd
> > > [  159.768005]  [<c0135e26>] ktime_get_ts+0x1d/0x3f
> > > [  159.768005]  [<c0135e57>] ktime_get+0xf/0x2b
> > > [  159.768005]  [<c013736b>] sched_clock_tick+0x46/0x83
> > > [  159.768005]  [<c01373ad>] sched_clock_idle_wakeup_event+0x5/0xa
> > > [  159.768005]  [<c0108670>] set_cyc2ns_scale+0x3f/0x5e
> > > [  159.768005]  [<c01088af>] time_cpufreq_notifier+0xf9/0x103
> > > [  159.768005]  [<c0136782>] notifier_call_chain+0x2a/0x52
> > > [  159.768005]  [<c0136866>] __srcu_notifier_call_chain+0x35/0x4a
> > > [  159.768005]  [<c0136884>] srcu_notifier_call_chain+0x9/0xc
> > > [  159.768005]  [<c031cbca>] cpufreq_resume+0xf3/0x112
> > > [  159.768005]  [<c028c3f3>] __sysdev_resume+0x24/0x34
> > > [  159.768005]  [<c028c421>] sysdev_resume+0x1e/0x50
> > 
> > Thanks for testing. It's exaclty the code path I described :)
> > 
> > So my code analysis holds and your test confirms my suspicion that
> > Shaggy's patch just unearthed some other weirdness in the
> > suspend/resume code.
> > 
> > Can you please apply the following hack^Wpatch and retest ? It
> > restores Shaggys patch, but prevents the sched_clock_tick() call when
> > timekeeping is not resumed. The WARN_ON should not longer trigger
> > except there is some other code path which fiddles with that as well.
> > 
> > If I'm not completely nuts then this should solve your suspend/resume
> > problem really instead of papering over the root cause.
> 
> Should we move timekeeping resume before cpufreq resume, instead of this?

That seems a sensible suggestion (but I've got no clue on how practical
that is). A quick look at the boot code suggests that regular bootups
have that sequence as well, so mirroring that in the resume code seems
like the best all-round solution.
