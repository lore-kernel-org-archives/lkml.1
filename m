Return-Path: <linux-kernel-owner+w=401wt.eu-S1753036AbYKKQRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbYKKQRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 11:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbYKKQRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 11:17:44 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:42332 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbYKKQRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 11:17:43 -0500
Date: Tue, 11 Nov 2008 08:17:39 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@redhat.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [Bug #11989] Suspend failure on NForce4-based boards due to
	chanes in stop_machine
Message-ID: <20081111161739.GA6736@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera> <20081110120401.GA15518@osiris.boeblingen.de.ibm.com> <200811101547.21325.rjw@sisk.pl> <200811102355.42389.rjw@sisk.pl> <20081111105214.GA15645@elte.hu> <20081111113134.GA5653@osiris.boeblingen.de.ibm.com> <20081111124201.GA9459@osiris.boeblingen.de.ibm.com> <20081111143505.GA6923@linux.vnet.ibm.com> <20081111150132.GB9459@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111150132.GB9459@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 04:01:32PM +0100, Heiko Carstens wrote:
> On Tue, Nov 11, 2008 at 06:35:05AM -0800, Paul E. McKenney wrote:
> > > > A process that would do nothing but onlining/offlining cpus would get
> > > > stuck after a while:
> > > > 
> > > >  0 schedule+842 [0x342522]
> > > >  1 schedule_timeout+200 [0x342ec4]
> > > >  2 wait_for_common+362 [0x341fd6]
> > > >  3 wait_for_completion+54 [0x342146]
> > > >  4 __synchronize_sched+80 [0x81670]
> > > >  5 cpu_down+172 [0x33c030]
> > > >  6 store_online+96 [0x33c488]
> > > >  7 sysdev_store+52 [0x1bda84]
> > > >  8 sysfs_write_file+242 [0x1350ba]
> > > >  9 vfs_write+176 [0xd2028]
> > > > 10 sys_write+82 [0xd21ea]
> > > > 11 sysc_noemu+16 [0x269d8]
> > > > 
> > > > All cpus are in cpu_idle and no other task in state TASK_INTERRUPTIBLE
> > > > or TASK_UNINTERRUPTIBLE. However it would continue to work as soon as
> > > > I login into the system or generate a console interrupt.
> > > > I'm going to look into the dump and see if I can figure out what is
> > > > broken here.
> > > > Dunno if it is the same bug or something else.
> > > 
> > > [Cc:-ed Steven and Paul, since this backtrace seems to be RCU specific]
> > > 
> > > Steven, Paul, any idea what could cause the hang? I think I would
> > > get lost in the RCU code...
> > 
> > Hello, Heiko,
> > 
> > Could you please apply the following debug patch (due to Jiangshan and
> > myself)?  Then you should be able to build with CONFIG_RCU_TRACE,
> > then mount debugfs after boot, for example, on /debug.  This will
> > create a /debug/rcu directory with three files, "rcucb", "rcu_data",
> > and "rcu_bh_data".  Since you are still able to log in, could you
> > please send the contents of these three files?
> 
> Hi Paul,
> 
> could you attach the patch please? :)

Peter Z. beat you to it.  ;-)

See previous email.

> Does the patch also make sense if the system continues to work? That
> is the machine isn't stalled anymore as soon as I log in.
> On the other hand I do have a dump of the system and can look in
> whatever data structures you want. If that helps.

Ah!

I would like to see the value of rcu_ctrlblk.cpumask and also the value
of cpu_online_map.  One guess would be that rcu_ctrlblk.cpumask has a
bit set that is -not- set in cpu_online_map, which would indicate that
RCU was incorrectly waiting on an offline CPU.

On the other hand, if all the bits set in rcu_ctrlblk.cpumask are also
set in cpu_online_map, then could you please dump out the instances of
the rcu_data per-CPU variable that correspond to the bits set in
rcu_ctrlblk.cpumask?

Finally, if no bits are set in rcu_ctrlblk.cpumask, the question would
be "why isn't the synchronize_sched() waking up?"

BTW, I am assuming that you have the same config as Raphael, in other
words, that you are running Classic RCU rather than preemptable RCU.

The point of the patch is that it allows you to see this info by catting
out the /debug/rcu files, at least assuming that the system is healthy
enough to allow you to cat files.  But if you already have a crash dump...

							Thanx, Paul
