Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbZHZFuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbZHZFuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 01:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756669AbZHZFuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 01:50:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34390 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394AbZHZFuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 01:50:04 -0400
Subject: Re: PROBLEM: oops
From: Peter Zijlstra <peterz@infradead.org>
To: Pawel Golaszewski <blues@gda.pl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Dhaval Giani <dhaval.giani@gmail.com>
In-Reply-To: <alpine.LNX.2.00.0908252317080.17744@fgnss.gnfx.tqn.cy>
References: <alpine.LNX.2.00.0908251515380.16876@fgnss.gnfx.tqn.cy>
	 <1251209206.7538.1159.camel@twins>
	 <alpine.LNX.2.00.0908251608280.16876@fgnss.gnfx.tqn.cy>
	 <1251209734.7538.1160.camel@twins>
	 <alpine.LNX.2.00.0908251625580.16876@fgnss.gnfx.tqn.cy>
	 <1251211483.7538.1162.camel@twins>
	 <alpine.LNX.2.00.0908251701020.16876@fgnss.gnfx.tqn.cy>
	 <1251212859.7538.1166.camel@twins>
	 <alpine.LNX.2.00.0908252317080.17744@fgnss.gnfx.tqn.cy>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 26 Aug 2009 07:49:02 +0200
Message-Id: <1251265742.7538.1192.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 23:23 +0200, Pawel Golaszewski wrote:
> On Tue, 25 Aug 2009, Peter Zijlstra wrote:
> > > > could you try to reproduce without that?
> > > > 
> > > > CONFIG_GROUP_SCHED=n
> > > I'll try. 
> 
> It seems that problem still exists - system has crashed too. From 
> netconsole:

> Any ideas?
> 
> Last kernel I was using is 2.6.27.13 - works fine. None between 13 and 31 
> tested...

# git log --format=oneline v2.6.27.13..v2.6.27.31 kernel/sched*
2b46f3769896dc04e1e49144d282e4655677105a wait: prevent exclusive waiter starvation

Nothing changed anywhere near the code that is falling apart..

Also:

[20621.263297] BUG: unable to handle kernel paging request at ffffffd8
[20621.263396] IP: [<c081cc50>] hrtick_start_fair+0x0/0x30


#ifndef CONFIG_FAIR_GROUP_SCHED

static inline struct cfs_rq *cfs_rq_of(struct sched_entity *se)
{
        struct task_struct *p = task_of(se);
        struct rq *rq = task_rq(p);

        return &rq->cfs;
}

#endif

SCHED_FEAT(HRTICK, 0)

static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
{
        struct sched_entity *se = &p->se;
        struct cfs_rq *cfs_rq = cfs_rq_of(se);

        WARN_ON(task_rq(p) != rq);

        if (hrtick_enabled(rq) && cfs_rq->nr_running > 1) {

		/* won't get here since HRTICK is disabled by default */

        }
}

Suggests something went terribly wrong and corrupted a fundamental data
structure.

Maybe turning on each and every debug feature related to memory
debugging might help.
