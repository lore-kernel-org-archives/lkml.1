Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbYKKNRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbYKKNRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 08:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755398AbYKKNRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 08:17:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55880 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207AbYKKNRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 08:17:03 -0500
Date: Tue, 11 Nov 2008 14:13:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@redhat.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #11989] Suspend failure on NForce4-based boards due to
	chanes in stop_machine
Message-ID: <20081111131319.GF14989@elte.hu>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera> <20081110120401.GA15518@osiris.boeblingen.de.ibm.com> <200811101547.21325.rjw@sisk.pl> <200811102355.42389.rjw@sisk.pl> <20081111105214.GA15645@elte.hu> <20081111113134.GA5653@osiris.boeblingen.de.ibm.com> <20081111124201.GA9459@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111124201.GA9459@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Tue, Nov 11, 2008 at 12:31:34PM +0100, Heiko Carstens wrote:
> > On Tue, Nov 11, 2008 at 11:52:14AM +0100, Ingo Molnar wrote:
> > > 
> > > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > 
> > > > However, it is reproducible by doing
> > > > 
> > > > # echo core > /sys/power/pm_test
> > > > 
> > > > and repeating
> > > > 
> > > > # echo disk > /sys/power/state
> > > > 
> > > > for a couple of times, in which case the last two lines printed to the console
> > > > before a (solid) hang are:
> > > > 
> > > > SMP alternatives: switching to SMP code
> > > > Booting processor 1 APIC 0x1 ip 0x6000
> > > > 
> > > > So, it evidently fails while re-enabling the non-boot CPU and not 
> > > > during disabling it as I thought before.
> > > > 
> > > > With commit c9583e55fa2b08a230c549bd1e3c0bde6c50d9cc reverted the 
> > > > issue is not reproducible any more.
> > > 
> > > [ Cc:-ed workqueue/locking/suspend-race-condition experts. ]
> > > 
> > > Seems like the new kernel/stop_machine.c logic has a race for the test 
> > > sequence above. (Below is the bisected commit again, maybe the race is 
> > > visible via email review as well.)
> > 
> > FWIW, I tried to reproduce this on s390 and got the following:
> > 
> > A process that would do nothing but onlining/offlining cpus would get
> > stuck after a while:
> > 
> >  0 schedule+842 [0x342522]
> >  1 schedule_timeout+200 [0x342ec4]
> >  2 wait_for_common+362 [0x341fd6]
> >  3 wait_for_completion+54 [0x342146]
> >  4 __synchronize_sched+80 [0x81670]
> >  5 cpu_down+172 [0x33c030]
> >  6 store_online+96 [0x33c488]
> >  7 sysdev_store+52 [0x1bda84]
> >  8 sysfs_write_file+242 [0x1350ba]
> >  9 vfs_write+176 [0xd2028]
> > 10 sys_write+82 [0xd21ea]
> > 11 sysc_noemu+16 [0x269d8]
> > 
> > All cpus are in cpu_idle and no other task in state TASK_INTERRUPTIBLE
> > or TASK_UNINTERRUPTIBLE. However it would continue to work as soon as
> > I login into the system or generate a console interrupt.
> > I'm going to look into the dump and see if I can figure out what is
> > broken here.
> > Dunno if it is the same bug or something else.
> 
> [Cc:-ed Steven and Paul, since this backtrace seems to be RCU specific]
> 
> Steven, Paul, any idea what could cause the hang? I think I would
> get lost in the RCU code...

Cc:-ed Thomas - sometimes "RCU hangs" happen due to nohz confusion: 
because no timer IRQ happens so there's nothing to drive the RCU 
machinery.

	Ingo
