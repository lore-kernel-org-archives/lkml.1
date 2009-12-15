Return-Path: <linux-kernel-owner+w=401wt.eu-S1751149AbZLOFTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751149AbZLOFTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 00:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbZLOFTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 00:19:53 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41775 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbZLOFTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 00:19:53 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [BUGFIX][PATCH] oom-kill: fix NUMA consraint check with nodemask v4.2
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0912142046070.436@chino.kir.corp.google.com>
References: <20091215133546.6872fc4f.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0912142046070.436@chino.kir.corp.google.com>
Message-Id: <20091215135902.CDD6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 15 Dec 2009 14:19:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 15 Dec 2009, KAMEZAWA Hiroyuki wrote:
> 
> > > I would agree only if the oom killer used total_vm as a the default, it is 
> > > long-standing and allows for the aforementioned capability that you lose 
> > > with rss.  I have no problem with the added sysctl to use rss as the 
> > > baseline when enabled.
> > > 
> > I'll prepare a patch for adds
> > 
> >   sysctl_oom_kill_based_on_rss (default=0)
> > 
> > ok ?
> > 
> 
> I have no strong feelings either for or against that, I guess users who 
> want to always kill the biggest memory hogger even when single page 
> __GFP_WAIT allocations fail could use it.  I'm not sure it would get much 
> use, though.
> 
> I think we should methodically work out an oom killer badness rewrite that 
> won't compound the problem by adding more and more userspace knobs.  In 
> other words, we should slow down, construct a list of goals that we want 
> to achieve, and then see what type of solution we can create.
> 
> A few requirements that I have:

Um, good analysis! really.

>
>  - we must be able to define when a task is a memory hogger; this is
>    currently done by /proc/pid/oom_adj relying on the overall total_vm
>    size of the task as a baseline.  Most users should have a good sense
>    of when their task is using more memory than expected and killing a
>    memory leaker should always be the optimal oom killer result.  A better 
>    set of units other than a shift on total_vm would be helpful, though.

nit: What's mean "Most users"? desktop user(one of most majority users)
don't have any expection of memory usage.

but, if admin have memory expection, they should be able to tune
optimal oom result.

I think you pointed right thing.


>  - we must prefer tasks that run on a cpuset or mempolicy's nodes if the 
>    oom condition is constrained by that cpuset or mempolicy and its not a
>    system-wide issue.

agreed. (who disagree it?)


>  - we must be able to polarize the badness heuristic to always select a
>    particular task is if its very low priority or disable oom killing for
>    a task if its must-run.

Probably I haven't catch your point. What's mean "polarize"? Can you
please describe more?


> The proposal may be to remove /proc/pid/oom_adj completely since I know 
> both you and KOSAKI-san dislike it, but we'd need an alternative which 
> keeps the above functionality intact.

Yes, To provide alternative way is must.



