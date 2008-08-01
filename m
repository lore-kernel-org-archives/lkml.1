Return-Path: <linux-kernel-owner+w=401wt.eu-S1760700AbYHAWXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760700AbYHAWXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 18:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756536AbYHAWXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 18:23:07 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:54174 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937AbYHAWXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 18:23:05 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Mayer <ajm@sgi.com>
Cc: Cliff Wickman <cpw@sgi.com>, jeremy@goop.org, rusty@rustcorp.com.au,
       suresh.b.siddha@intel.com, mingo@elte.hu, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Dean Nelson <dcn@sgi.com>
In-Reply-To: <4893856D.6060909@sgi.com> (Alan Mayer's message of "Fri, 01 Aug
	2008 16:51:41 -0500")
References: <48922D16.1080704@sgi.com> <m13alp1z8w.fsf@frodo.ebiederm.org>
	<20080801155120.GA21706@sgi.com> <m18wvgv4bj.fsf@frodo.ebiederm.org>
	<4893856D.6060909@sgi.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
Date: Fri, 01 Aug 2008 15:14:42 -0700
Message-ID: <m11w18tmb1.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alan Mayer <ajm@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.2 SARE_LWSHORTT BODY: SARE_LWSHORTT
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] x86_64:  Dynamically allocate arch specific system vectors
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Mayer <ajm@sgi.com> writes:

> Okay, I think we have it now.  assign_irq_vector *almost* does what we need.
> One minor thing is that assign_irq_vector ANDs against cpu_online_map.  We would
> need cpu_possible_map, so we get the vector on offline cpus that may come
> online.  The other thing is that assign_irq_vector doesn't allow the
> specification of interrupt priorities.  It would need to be modified to handle
> returning either a high priority vector or a low priority vector.  Would
> modifying the api for assign_irq_vector be the proper approach?

I don't know if it makes sense to modify assign_irq_vector or to 
have a companion function that uses the same data structures.

I think I would work on the companion function and if the code
can be made sufficiently similar merge the two functions.

> The interrupts don't necessarily fire on all cpus, it's just that they *can*
> fire on any cpu.  For example, the GRU triggers an interrupt (it is very
> IPI'ish) to a particular cpu in the event of a GRU TLB fault. That cpu handles
> the fault and returns.  But the fault can happen on any cpu, so all cpus need to
> be registered for the same vector and irq. This is probably splitting hairs; it
> is certainly no different in principal from timer interrupts or processor TLB
> faults.

Reasonable.  As long as you don't need to read a status register to figure
out what to do that sounds reasonable.  This does sound very much like
splitting hairs on a very platform specific capability.

If we can generalize the mechanism to things like per cpu timer
interrupts and such so that we reduced the total amount of code we
have to maintain I would find it a very compelling mechanism.

> As far as kernel_stat is concerned.  I see you're point.  NR_CPUS on our
> machines is going to be big (4K? 8K? something like that).  NR_IRQS is also
> going to big because of that.  It's unfortunate since the actual number of
> interrupt sources is going to be an order of magnitude smaller, at least.

The number of interrupts sources is going to be smaller only because
SGI machines have or at least appear to have poor I/O compared to most
of the rest of machines in existence.  NR_CPUS*16 is a fairly
reasonable estimate on most machines in existence.  In the short term
it is going to get worse in the presence of MSI-X.  I was talking to a
developer at Intel last week about 256 irqs for one card.  I keep
having dreams about finding a way to just keep stats for a few cpus
but alas I don't think that is going to happen.  Silly us.

Eric
