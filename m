Return-Path: <linux-kernel-owner+w=401wt.eu-S1759704AbYB1KrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759704AbYB1KrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 05:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbYB1KrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 05:47:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34959 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756150AbYB1KrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 05:47:13 -0500
Date: Thu, 28 Feb 2008 11:46:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Jackson <pj@sgi.com>
Cc: a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, maxk@qualcomm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
Message-ID: <20080228104637.GA9129@elte.hu>
References: <20080227222103.673194000@chello.nl> <20080228075010.GA28781@elte.hu> <20080228020808.3fd22f77.pj@sgi.com> <20080228090847.GA1133@elte.hu> <20080228031710.3405e405.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228031710.3405e405.pj@sgi.com>
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


* Paul Jackson <pj@sgi.com> wrote:

> But your words sound alot like what we at SGI call a 'boot' cpuset.
> 
> Our big honkin NUMA customers, who are managing most of the system 
> either for a few dedicated, very-important jobs, and/or under a batch 
> scheduler, need to leave a few nodes to run the classic Unix load such 
> as init, cron, assorted daemons and the admins login shell.
> 
> So we provide them some init script mechanisms that make it easy to 
> set this up, which includes moving every task (not many at the low 
> numbered init script time this runs) that isn't pinned (doesn't have a 
> restricted Cpus_allowed) into the boot cpuset, conventionally named 
> /dev/cpuset/boot.

yes. Ideally Peter's patchset should turn into something equivalent and 
i very much agree with Peter's arguments. There was never any design 
level problem with cpusets, and the parallel cpu_isolated_map approach 
was misdirected IMO.

There was indeed a problem with the _manageability_ of cpusets in 
certain (rather new) usecases like real-time or virtualization, and how 
they are connected to other system resources like IRQs and how easy it 
is to manage these resources. IRQs should probably be tied to specific 
cpusets and should migrate together with them, were the span of that 
cpuset be changed. (by default they'd be tied to the boot cpuset)

IMO Peter's patchset is a good first step in that it removes the 
cpu_isolated_map API hack, and i think we should try to go the whole way 
and just offer a /dev/cpuset/boot/ default set that can then be 
restricted to isolate the default workloads away from other CPUs.

( an initscripts approach, while i'm sure it works, would always be a
  bit fragile in that it requires precise knowledge about which task is
  what. I think we should make this a turn-key in-kernel solution that
  both the big-honking NUMA-box guys and the real-time guys would be
  happy with. )

	Ingo
