Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbZKDCTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbZKDCTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 21:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbZKDCTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 21:19:36 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44488 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbZKDCTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 21:19:36 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 4 Nov 2009 11:17:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: vedran.furac@gmail.com, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, minchan.kim@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory overcommit
Message-Id: <20091104111703.b46ae72b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0911031752180.1187@chino.kir.corp.google.com>
References: <hav57c$rso$1@ger.gmane.org>
	<4AE792B8.5020806@gmail.com>
	<alpine.DEB.2.00.0910272047430.8988@chino.kir.corp.google.com>
	<20091028135519.805c4789.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0910272205200.7507@chino.kir.corp.google.com>
	<20091028150536.674abe68.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0910272311001.15462@chino.kir.corp.google.com>
	<20091028152015.3d383cd6.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0910290136000.11476@chino.kir.corp.google.com>
	<4AE97861.1070902@gmail.com>
	<alpine.DEB.2.00.0910291248480.2276@chino.kir.corp.google.com>
	<20091030084836.5428e085.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0910300200170.18076@chino.kir.corp.google.com>
	<20091030183638.1125c987.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0911031240470.29695@chino.kir.corp.google.com>
	<20091104095021.5532e913.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0911031752180.1187@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Nov 2009 17:58:04 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Wed, 4 Nov 2009, KAMEZAWA Hiroyuki wrote:
> 
> > > That's a different point.  Today, we can influence the badness score of 
> > > any user thread to prioritize oom killing from userspace and that can be 
> > > done regardless of whether there's a memory leaker, a fork bomber, etc.  
> > > The priority based oom killing is important to production scenarios and 
> > > cannot be replaced by a heuristic that works everytime if it cannot be 
> > > influenced by userspace.
> > > 
> > I don't removed oom_adj...
> > 
> 
> Right, but we must ensure that we have the same ability to influence a 
> priority based oom killing scheme from userspace as we currently do with a 
> relatively static total_vm.  total_vm may not be the optimal baseline, but 
> it does allow users to tune oom_adj specifically to identify tasks that 
> are using more memory than expected and to be static enough to not depend 
> on rss, for example, that is really hard to predict at the time of oom.
> 
> That's actually my main goal in this discussion: to avoid losing any 
> ability of userspace to influence to priority of tasks being oom killed 
> (if you haven't noticed :).
> 
> > > Tweaking on the heuristic will probably make it more convoluted and 
> > > overall worse, I agree.  But it's a more stable baseline than rss from 
> > > which we can set oom killing priorities from userspace.
> > 
> > - "rss < total_vm_size" always.
> 
> But rss is much more dynamic than total_vm, that's my point.
> 
My point and your point are differnt.

  1. All my concern is "baseline for heuristics"
  2. All your concern is "baseline for knob, as oom_adj"

ok ? For selecting victim by the kernel, dynamic value is much more useful.
Current behavior of "Random kill" and "Kill multiple processes" are too bad.
Considering oom-killer is for what, I think "1" is more important.

But I know what you want, so, I offers new knob which is not affected by RSS
as I wrote in previous mail.

Off-topic:
As memcg is growing better, using OOM-Killer for resource control should be
ended, I think. Maybe Fake-NUMA+cpuset is working well for google system, 
but plz consider to use memcg. 



> > - oom_adj culculation is quite strong.
> > - total_vm of processes which maps hugetlb is very big ....but killing them
> >   is no help for usual oom.
> > 
> > I recommend you to add "stable baseline" knob for user space, as I wrote.
> > My patch 6 adds stable baseline bonus as 50% of vm size if run_time is enough
> > large.
> > 
> 
> There's no clear relationship between VM size and runtime.  The forkbomb 
> heuristic itself could easily return a badness of ULONG_MAX if one is 
> detected using runtime and number of children, as I earlier proposed, but 
> that doesn't seem helpful to factor into the scoring. 
> 

Old processes are important, younger are not. But as I wrote, I'll drop
most of patch "6". So, plz forget about this part.

I'm interested in fork-bomb killer rather than crazy badness calculation, now.

Thanks,
-Kame



