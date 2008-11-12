Return-Path: <linux-kernel-owner+w=401wt.eu-S1753259AbYKLDa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbYKLDa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 22:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbYKLDaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 22:30:14 -0500
Received: from ozlabs.org ([203.10.76.45]:34692 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbYKLDaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 22:30:12 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [Bug #11989] Suspend failure on NForce4-based boards due to chanes in stop_machine
Date: Wed, 12 Nov 2008 14:00:03 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; i686; ; )
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera> <19f34abd0811110647y2a00cfbfr2b219a5aa1b3ac9f@mail.gmail.com> <20081111163118.GA18214@redhat.com>
In-Reply-To: <20081111163118.GA18214@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811121400.04278.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 November 2008 03:01:18 Oleg Nesterov wrote:
> On 11/11, Vegard Nossum wrote:
> > I think that the test for stop_machine_data in stop_cpu() should not
> > have been moved from __stop_machine(). Because now cpu_online_map may
> > change in-between calls to stop_cpu() (if the callback tries to
> > online/offline CPUs), and the end result may be different.
>
> I don't think this is possible, the callback must not be called unless
> all threads ack (at least) the STOPMACHINE_PREPARE state.
>
>
> Off-topic question, __stop_machine() does:
>
> 	/* Schedule the stop_cpu work on all cpus: hold this CPU so one
> 	 * doesn't hit this CPU until we're ready. */
> 	get_cpu();
> 	for_each_online_cpu(i) {
> 		sm_work = percpu_ptr(stop_machine_work, i);
> 		INIT_WORK(sm_work, stop_cpu);
> 		queue_work_on(i, stop_machine_wq, sm_work);
> 	}
> 	/* This will release the thread on our CPU. */
> 	put_cpu();
>
> Don't we actually need preempt_disable/preempt_enable instead of
> get/put cpu? (yes, there the same currently). We don't care about
> the CPU we are running on, and it can't go away until we queue all
> works. But we must ensure that stop_cpu() on the same CPU can't
> preempt us, right?

A subtle distinction, but yes.  It used to be true before the recent changes, 
where we manually did "this" cpu.

Cheers,
Rusty.
