Return-Path: <linux-kernel-owner+w=401wt.eu-S1752212AbZJ2JTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbZJ2JTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 05:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbZJ2JTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 05:19:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45418 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbZJ2JTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 05:19:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 29 Oct 2009 18:16:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrea Arcangeli <aarcange@redhat.com>, vedran.furac@gmail.com,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] oom_kill: use rss value instead of vm size for badness
Message-Id: <20091029181650.979bf95c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0910290156560.16347@chino.kir.corp.google.com>
References: <20091028175846.49a1d29c.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0910280206430.7122@chino.kir.corp.google.com>
	<abbed627532b26d8d96990e2f95c02fc.squirrel@webmail-b.css.fujitsu.com>
	<20091029100042.973328d3.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0910290125390.11476@chino.kir.corp.google.com>
	<20091029174632.8110976c.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0910290156560.16347@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Oct 2009 02:01:49 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:
> > yes, then I wrote "as start point". There are many environments.
> 
> And this environment has a particularly bad result.
> yes, then I wrote "as start point". There are many environments.

In my understanding, 2nd, 3rd candidates are not important. If both of
total_vm and RSS catches the same process as 1st candidate, it's ok.
(i.e. If killed, oom situation will go away.)


> > ya, I'm now considering to drop file_rss from calculation.
> > 
> > some reasons.
> > 
> >   - file caches remaining in memory at OOM tend to have some trouble to remove it.
> >   - file caches tend to be shared.
> >   - if file caches are from shmem, we never be able to drop them if no swap/swapfull.
> > 
> > Maybe we'll have better result.
> > 
> 
> That sounds more appropriate.
> 
> I'm surprised you still don't see a value in using the peak VM and RSS 
> sizes, though, as part of your formula as it would indicate the proportion 
> of memory resident in RAM at the time of oom.
> 
I'll use swap_usage instead of peak VM size as bonus.

  anon_rss + swap_usage/2 ? or some.

My first purpose is not to kill not-guilty process at random.
If memory eater is killed, it's reasnoable.

In my consideration

  - "Killing a process because of OOM" is something bad, but not avoidable.

  - We don't need to do compliated/too-wise calculation for killing a process.
    "The worst one is memory-eater!" is easy to understand to users and admins.

  - We have oom_adj, now. User can customize it if he run _important_ memory eater.

  - But fork-bomb doesn't seem memory eater if we see each process.
    We need some cares.

  Then,
  - I'd like to drop file_rss.
  - I'd like to take swap_usage into acccount.
  - I'd like to remove cpu_time bonus. runtime bonus is much more important.
  - I'd like to remove penalty from children. To do that, fork-bomb detector
    is necessary.
  - nice bonus is bad. (We have oom_adj instead of this.) It should be
    if (task_nice(p) < 0)
	points /= 2;
    But we have "root user" bonus already. We can remove this line.

After above, much more simple selection, easy-to-understand,  will be done.

Thanks,
-Kame

