Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbZE2KkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbZE2KkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 06:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbZE2Kjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 06:39:52 -0400
Received: from tango.0pointer.de ([85.214.72.216]:39089 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbZE2Kjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 06:39:52 -0400
Date: Fri, 29 May 2009 12:39:25 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] scheduler: introduce SCHED_RESET_ON_FORK scheduling
	policy flag, Second try
Message-ID: <20090529103924.GA32303@tango.0pointer.de>
References: <20090529083840.GA15516@omega> <1243589315.23657.210.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243589315.23657.210.camel@twins>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29.05.09 11:28, Peter Zijlstra (peterz@infradead.org) wrote:

> > This patch introduces a new flag SCHED_RESET_ON_FORK which can be passed
> > to the kernel via sched_setscheduler(), ORed in the policy parameter. If
> > set this will make sure that when the process forks a) the scheduling
> > priority is reset to DEFAULT_PRIO if it was higher and b) the scheduling
> > policy is reset to SCHED_NORMAL if it was either SCHED_FIFO or SCHED_RR.
> 
> Maybe SCHED_OTHER_ON_FORK, or SCHED_DEFAULT_ON_FORK?

Hmm, I think this would be misleading, since it does more than just
reset to SCHED_OTHER. It also resets the nice level.

> > +	if (current->sched_reset_on_fork &&
> > +			(p->policy == SCHED_FIFO || p->policy == SCHED_RR))
> > +		p->policy = SCHED_NORMAL;
> > +
> > +	if (current->sched_reset_on_fork &&
> > +			(current->normal_prio < DEFAULT_PRIO))
> > +		p->prio = DEFAULT_PRIO;
> > +	else
> > +		p->prio = current->normal_prio;
> 
> This bit hurt my brain, what's wrong with:
> 
> 	p->prio = current->normal_prio; /* don't leak boosted prio */
> 	if (current->sched_reset_on_fork) {
> 		p->policy = SCHED_NORMAL;
> 		p->prio = p->normal_prio = p->static_prio = DEFAULT_PRIO;
> 	}

This would do something very different. i.e. with this suggested code
of yours SCHED_IDLE/SCHED_BATCH would be upgraded to SCHED_OTHER on
fork and a process with a positive nice level would be upgraded to to
nice level 0. My original patch would only downgrade, never upgrade.

It is of course a question what makes more sense here: a logic that
makes sure that only "elevated" scheduling gets reset to normal
scheduling, or one that would reset both 'higher' and 'lower'
scheduling settings to normal.

Given that this is supposed to be a security feature it makes more
sense to me to only 'decrease' scheduling settings, not 'increase'
them. Dunno, what do you think?

Lennart

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
