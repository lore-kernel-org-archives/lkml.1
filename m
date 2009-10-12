Return-Path: <linux-kernel-owner+w=401wt.eu-S1756432AbZJLLjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432AbZJLLjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 07:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756264AbZJLLjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 07:39:12 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:54740 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848AbZJLLjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 07:39:12 -0400
Date: Mon, 12 Oct 2009 17:08:29 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Ying Han <yinghan@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 0/2] memcg: improving scalability by reducing lock
 contention at charge/uncharge
Message-ID: <20091012113829.GD3007@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20091002135531.3b5abf5c.kamezawa.hiroyu@jp.fujitsu.com>
 <604427e00910091737s52e11ce9p256c95d533dc2837@mail.gmail.com>
 <f82dee90d0ab51d5bd33a6c01a9feb17.squirrel@webmail-b.css.fujitsu.com>
 <604427e00910111134o6f22f0ddg2b87124dd334ec02@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <604427e00910111134o6f22f0ddg2b87124dd334ec02@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ying Han <yinghan@google.com> [2009-10-11 11:34:39]:

> 2009/10/10 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> > Ying Han wrote:
> > > Hi KAMEZAWA-san: I tested your patch set based on 2.6.32-rc3 but I don't
> > > see
> > > much improvement on the page-faults rate.
> > > Here is the number I got:
> > >
> > > [Before]
> > >  Performance counter stats for './runpause.sh 10' (5 runs):
> > >
> > >   226272.271246  task-clock-msecs         #      3.768 CPUs    ( +-
> > > 0.193%
> > > )
> > >            4424  context-switches         #      0.000 M/sec   ( +-
> > > 14.418%
> > > )
> > >              25  CPU-migrations           #      0.000 M/sec   ( +-
> > > 23.077%
> > > )
> > >        80499059  page-faults              #      0.356 M/sec   ( +-
> > > 2.586%
> > > )
> > >    499246232482  cycles                   #   2206.396 M/sec   ( +-
> > > 0.055%
> > > )
> > >    193036122022  instructions             #      0.387 IPC     ( +-
> > > 0.281%
> > > )
> > >     76548856038  cache-references         #    338.304 M/sec   ( +-
> > > 0.832%
> > > )
> > >       480196860  cache-misses             #      2.122 M/sec   ( +-
> > > 2.741%
> > > )
> > >
> > >    60.051646892  seconds time elapsed   ( +-   0.010% )
> > >
> > > [After]
> > >  Performance counter stats for './runpause.sh 10' (5 runs):
> > >
> > >   226491.338475  task-clock-msecs         #      3.772 CPUs    ( +-
> > > 0.176%
> > > )
> > >            3377  context-switches         #      0.000 M/sec   ( +-
> > > 14.713%
> > > )
> > >              12  CPU-migrations           #      0.000 M/sec   ( +-
> > > 23.077%
> > > )
> > >        81867014  page-faults              #      0.361 M/sec   ( +-
> > > 3.201%
> > > )
> > >    499835798750  cycles                   #   2206.865 M/sec   ( +-
> > > 0.036%
> > > )
> > >    196685031865  instructions             #      0.393 IPC     ( +-
> > > 0.286%
> > > )
> > >     81143829910  cache-references         #    358.265 M/sec   ( +-
> > > 0.428%
> > > )
> > >       119362559  cache-misses             #      0.527 M/sec   ( +-
> > > 5.291%
> > > )
> > >
> > >    60.048917062  seconds time elapsed   ( +-   0.010% )
> > >
> > > I ran it on an 4 core machine with 16G of RAM. And I modified
> > > the runpause.sh to fork 4 pagefault process instead of 8. I mounted
> > cgroup
> > > with only memory subsystem and start running the test on the root cgroup.
> > >
> > > I believe that we might have different running environment including the
> > > cgroup configuration.  Any suggestions?
> > >
> >
> > This patch series is only for "child" cgroup. Sorry, I had to write it
> > clearer. No effects to root.
> >
> 
> Ok, Thanks for making it clearer. :) So Do you mind post the cgroup+memcg
> configuration
> while you are running on your host?
> 
> Thanks
>

Yes, root was fixed by another patchset now in mainline. Another check
is to see if resource_counter lock shows up in /proc/lock_stats.
 
-- 
	Balbir
