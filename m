Return-Path: <linux-kernel-owner+w=401wt.eu-S1751669AbYJRUDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbYJRUDe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 16:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbYJRUD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 16:03:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:8467 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbYJRUDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 16:03:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=YhdVrmmyvL5cJfaKC+BKNCkwSIJMlO1HBfzkKhDpha7sNVwTPmb8gJyKDJq5FVFFm2
         NIpvrH/YC6cWz+X0GaIsL833Cz8xgK6ZLFJK0NOeqXG/uToydErGRXA9Tc931fgjlt1T
         deDd/xALN1wpB8cYDsxPljmFCJ1u+typ9yahI=
Date: Sun, 19 Oct 2008 00:03:19 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: CFS related question
Message-ID: <20081018200319.GC8188@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Peter,

I just curious, look we have the following

static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
{
	struct sched_entity *se = NULL;

	if (first_fair(cfs_rq)) {
		se = __pick_next_entity(cfs_rq);
		se = pick_next(cfs_rq, se);
		set_next_entity(cfs_rq, se);
	}

	return se;
}

which I presume may return NULL so the following piece
could fail

static struct task_struct *pick_next_task_fair(struct rq *rq)
{
	struct task_struct *p;
	struct cfs_rq *cfs_rq = &rq->cfs;
	struct sched_entity *se;

	if (unlikely(!cfs_rq->nr_running))
		return NULL;

	do {
-->		se = pick_next_entity(cfs_rq);
--> OOPs	cfs_rq = group_cfs_rq(se);
	} while (cfs_rq);

	p = task_of(se);
	hrtick_start_fair(rq, p);

	return p;
}

Did I miss something? Or it comepletely can NOT happen?

		- Cyrill -
