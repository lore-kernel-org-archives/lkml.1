Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbYFFCUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbYFFCUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 22:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbYFFCT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 22:19:59 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:54898 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbYFFCT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 22:19:59 -0400
Message-ID: <48489E71.2060708@linux.vnet.ibm.com>
Date: Fri, 06 Jun 2008 07:48:25 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, nagar@watson.ibm.com, balbir@in.ibm.com,
       sekharan@us.ibm.com, kosaki.motohiro@jp.fujitsu.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 0/3 v2] per-task-delay-accounting: add memory reclaim
 delay
References: <20080605162759.a6adf291.kobayashi.kk@ncos.nec.co.jp>
In-Reply-To: <20080605162759.a6adf291.kobayashi.kk@ncos.nec.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keika Kobayashi wrote:
> Hi.
> 
> This is v2 of accounting memory reclaim patch series.
> Thanks to Kosaki-san, Kamezawa-san, Andrew for comments and advice!
> These patches were fixed about the following.
> 
> Against: next-20080605
> 
> 1) Change Log
> 
>  o Add accounting memory reclaim delay from memcgroup.
>    For accounting both global and cgroup memory reclaim,
>    accounting point was moved from try_to_free_pages() to do_try_to_free_pages.
> 
>  o Drop the patch regarding /proc export for memory reclaim delay.
>    Because it seems that two separate ways to report are not necessary,
>    this patch series supports only NETLINK and doesn't add a field to /proc/<pid>/stat.
> 
> 
> 2) Confirm the fix regarding memcgroup.
> 
>   o Previous patch can't catch memory reclaim delay from memcgroup.
> 
>     $ echo 10M > /cgroups/0/memory.limit_in_bytes
> 
>     $ ls -s test.dat
>     500496 test.dat
> 
>     $ time tar cvf test.tar test.dat
>     real    0m21.957s
>     user    0m0.032s
>     sys     0m2.348s
> 
>     $ ./delayget -d -p <pid>
>     CPU             count     real total  virtual total    delay total
>                      2441     2288143000     2438256954       22371958
>     IO              count    delay total
>                      2444    18745251314
>     SWAP            count    delay total
>                         0              0
>     RECLAIM         count    delay total
>                         0              0
> 
>   o Current patch can catch memory reclaim delay from memcgroup.
> 
>     $ echo 10M > /cgroups/0/memory.limit_in_bytes
> 
>     $ ls -s test.dat
>     500496 test.dat
> 
>     $ time tar cvf test.tar test.dat
>     real    0m22.563s
>     user    0m0.028s
>     sys     0m2.440s
> 
>     $ ./delayget -d -p <pid>
>     CPU             count     real total  virtual total    delay total
>                      2640     2456153500     2478353004       28366219
>     IO              count    delay total
>                      2628    19894214188
>     SWAP            count    delay total
>                         0              0
>     RECLAIM         count    delay total
>                      6600    10682486085
> 

Looks interesting, this data is for the whole system or memcgroup? If it is for
memcgroup, we should be using cgroupstats.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
