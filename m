Return-Path: <linux-kernel-owner+w=401wt.eu-S1756420AbYFSJvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbYFSJvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 05:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbYFSJvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 05:51:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32948 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbYFSJvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 05:51:15 -0400
Date: Thu, 19 Jun 2008 11:50:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nathan Lynch <ntl@pobox.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC/PATCH 0/3] sched: allow arch override of cpu power
Message-ID: <20080619095048.GD15228@elte.hu>
References: <1213835374-10868-1-git-send-email-ntl@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213835374-10868-1-git-send-email-ntl@pobox.com>
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


* Nathan Lynch <ntl@pobox.com> wrote:

> There is an "interesting" quality of POWER6 cores, which each have 2 
> hardware threads: assuming one thread on the core is idle, the primary 
> thread is a little "faster" than the secondary thread.  To illustrate:
> 
> for cpumask in 0x1 0x2 ; do
>     taskset $cpumask /usr/bin/time -f "%e elapsed, %U user, %S sys" \
>             /bin/sh -c "i=1000000 ; while (( i-- )) ; do : ; done"
> done
> 
> 17.05 elapsed, 16.83 user, 0.22 sys
> 17.54 elapsed, 17.32 user, 0.22 sys
> 
> (The first result is for a primary thread; the second result for a 
> secondary thread.)
> 
> So it would be nice to have the scheduler slightly prefer primary 
> threads on POWER6 machines.  These patches, which allow the 
> architecture to override the scheduler's CPU "power" calculation, are 
> one possible approach, but I'm open to others.  Please note: these 
> seemed to have the desired effect on 2.6.25-rc kernels (2-3% 
> improvement in a kernbench-like make -j <nr_cores>), but I'm not 
> seeing this improvement with 2.6.26-rc kernels for some reason I am 
> still trying to track down.

ok, i guess that discrepancy has to be tracked down before we can think 
about these patches - but the principle is OK.

One problem is that the whole cpu-power balancing code in sched.c is a 
bit ... unclear and under-documented. So any change to this area should 
begin at documenting the basics: what do the units mean exactly, how are 
they used in balancing and what is the desired effect.

I'd not be surprised if there were a few buglets in this area, SMT is 
not at the forefront of testing at the moment. There's nothing 
spectacularly broken in it (i have a HT machine myself), but the 
concepts have bitrotten a bit. Patches - even if they just add comments 
- are welcome :-)

	Ingo
