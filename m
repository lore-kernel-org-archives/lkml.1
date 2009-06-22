Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbZFVLxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbZFVLxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbZFVLx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:53:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43097 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbZFVLx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:53:27 -0400
Date: Mon, 22 Jun 2009 13:53:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: I.6 - Group scheduling
Message-ID: <20090622115310.GG24366@elte.hu>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 6/ Group scheduling
>
> Looking at the existing code, it seems to me there is a risk of
> starvation for groups, i.e., groups never scheduled on the PMU.
>
> My understanding of the scheduling algorithm is:
>
> - first try to �schedule pinned groups. If a pinned group
>   fails, put it in error mode. read() will fail until the
>   group gets another chance at being scheduled.
>
> - then try to schedule the remaining groups. If a group fails
>   just skip it.
>
> If the group list does not change, then certain groups may always
> fail. However, the ordering of the list changes because at every
> tick, it is rotated. The head becomes the tail. Therefore, each
> group eventually gets the first position and therefore gets the
> full PMU to assign its events.
>
> This works as long as there is a guarantee the list will ALWAYS
> rotate. If a thread does not run long enough for a tick, it may
> never rotate.

You need to ensure the task never runs during the tick, this is a
statistical propery that is bound to untrue for any 'normal'
application.

This is similar to the old cputime hiding tricks. We don't think
this will be a problem, you really need to actively avoid the tick
to aggregate a significantly lower tick rate.

In any case this can also be excluded via a natural extension
mentioned above: scheduling based not on the scheduler tick but
based on one of the counters.
