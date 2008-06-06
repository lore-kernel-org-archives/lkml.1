Return-Path: <linux-kernel-owner+w=401wt.eu-S1762213AbYFFDPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762213AbYFFDPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 23:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbYFFDPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 23:15:40 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48607 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbYFFDPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 23:15:38 -0400
Date: Fri, 6 Jun 2008 12:14:16 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, nagar@watson.ibm.com, balbir@in.ibm.com,
       sekharan@us.ibm.com, kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH 0/3 v2] per-task-delay-accounting: add memory reclaim
 delay
Message-Id: <20080606121416.2cb766cf.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <48489E71.2060708@linux.vnet.ibm.com>
References: <20080605162759.a6adf291.kobayashi.kk@ncos.nec.co.jp>
	<48489E71.2060708@linux.vnet.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jun 2008 07:48:25 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Keika Kobayashi wrote:
> > Hi.
> > 
> > This is v2 of accounting memory reclaim patch series.
> > Thanks to Kosaki-san, Kamezawa-san, Andrew for comments and advice!
> > These patches were fixed about the following.
> > 
> > Against: next-20080605
> > 
> > 1) Change Log
> > 
> >  o Add accounting memory reclaim delay from memcgroup.
> >    For accounting both global and cgroup memory reclaim,
> >    accounting point was moved from try_to_free_pages() to do_try_to_free_pages.
> > 
> >  o Drop the patch regarding /proc export for memory reclaim delay.
> >    Because it seems that two separate ways to report are not necessary,
> >    this patch series supports only NETLINK and doesn't add a field to /proc/<pid>/stat.
> > 
> > 
> > 2) Confirm the fix regarding memcgroup.
> > 
> >   o Previous patch can't catch memory reclaim delay from memcgroup.
> > 
> >     $ echo 10M > /cgroups/0/memory.limit_in_bytes
> > 
> >     $ ls -s test.dat
> >     500496 test.dat
> > 
> >     $ time tar cvf test.tar test.dat
> >     real    0m21.957s
> >     user    0m0.032s
> >     sys     0m2.348s
> > 
> >     $ ./delayget -d -p <pid>
> >     CPU             count     real total  virtual total    delay total
> >                      2441     2288143000     2438256954       22371958
> >     IO              count    delay total
> >                      2444    18745251314
> >     SWAP            count    delay total
> >                         0              0
> >     RECLAIM         count    delay total
> >                         0              0
> > 
> >   o Current patch can catch memory reclaim delay from memcgroup.
> > 
> >     $ echo 10M > /cgroups/0/memory.limit_in_bytes
> > 
> >     $ ls -s test.dat
> >     500496 test.dat
> > 
> >     $ time tar cvf test.tar test.dat
> >     real    0m22.563s
> >     user    0m0.028s
> >     sys     0m2.440s
> > 
> >     $ ./delayget -d -p <pid>
> >     CPU             count     real total  virtual total    delay total
> >                      2640     2456153500     2478353004       28366219
> >     IO              count    delay total
> >                      2628    19894214188
> >     SWAP            count    delay total
> >                         0              0
> >     RECLAIM         count    delay total
> >                      6600    10682486085
> > 
> 
> Looks interesting, this data is for the whole system or memcgroup? If it is for
> memcgroup, we should be using cgroupstats.
> 
This patch itself is for per-task-stat. And it seems cgroup_stat doesn't handle
delay accounting now. It just counts # of processes in some status.

Thanks,
-Kame





