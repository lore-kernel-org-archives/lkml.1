Return-Path: <linux-kernel-owner+w=401wt.eu-S1758229AbZCBAZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbZCBAZf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 19:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbZCBAZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 19:25:26 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44658 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbZCBAZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 19:25:25 -0500
Date: Mon, 2 Mar 2009 09:24:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Bharata B Rao <bharata@in.ibm.com>, Paul Menage <menage@google.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] Memory controller soft limit patches (v3)
Message-Id: <20090302092404.1439d2a6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090301062959.31557.31079.sendpatchset@localhost.localdomain>
References: <20090301062959.31557.31079.sendpatchset@localhost.localdomain>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 01 Mar 2009 11:59:59 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> 
> From: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> Changelog v3...v2
> 1. Implemented several review comments from Kosaki-San and Kamezawa-San
>    Please see individual changelogs for changes
> 
> Changelog v2...v1
> 1. Soft limits now support hierarchies
> 2. Use spinlocks instead of mutexes for synchronization of the RB tree
> 
> Here is v3 of the new soft limit implementation. Soft limits is a new feature
> for the memory resource controller, something similar has existed in the
> group scheduler in the form of shares. The CPU controllers interpretation
> of shares is very different though. 
> 
> Soft limits are the most useful feature to have for environments where
> the administrator wants to overcommit the system, such that only on memory
> contention do the limits become active. The current soft limits implementation
> provides a soft_limit_in_bytes interface for the memory controller and not
> for memory+swap controller. The implementation maintains an RB-Tree of groups
> that exceed their soft limit and starts reclaiming from the group that
> exceeds this limit by the maximum amount.
> 
> If there are no major objections to the patches, I would like to get them
> included in -mm.
> 
> TODOs
> 
> 1. The current implementation maintains the delta from the soft limit
>    and pushes back groups to their soft limits, a ratio of delta/soft_limit
>    might be more useful
> 2. It would be nice to have more targetted reclaim (in terms of pages to
>    recalim) interface. So that groups are pushed back, close to their soft
>    limits.
> 
> Tests
> -----
> 
> I've run two memory intensive workloads with differing soft limits and
> seen that they are pushed back to their soft limit on contention. Their usage
> was their soft limit plus additional memory that they were able to grab
> on the system. Soft limit can take a while before we see the expected
> results.
> 
> Please review, comment.
> 
Please forgive me to say....that the code itself is getting better but far from
what I want. Maybe I have to show my own implementation to show my idea
and the answer is between yours and mine. If now was the last year, I have enough
time until distro's target kernel and may welcome any innovative patches even if
it seems to give me concerns, but I have to be conservative now.

At first, it's said "When cgroup people adds something, the kernel gets slow".
This is my start point of reviewing. Below is comments to this version of patch.

 1. I think it's bad to add more hooks to res_counter. It's enough slow to give up
    adding more fancy things..

 2. please avoid to add hooks to hot-path. In your patch, especially a hook to
    mem_cgroup_uncharge_common() is annoying me.

 3. please avoid to use global spinlock more. 
    no lock is best. mutex is better, maybe.

 4. RB-tree seems broken. Following is example. (please note you do all ops
    in lazy manner (once in HZ/4.)

   i). while running, the tree is constructed as following
 
             R           R=exceed=300M
            / \ 
           A   B      A=exceed=200M  B=exceed=400M
   ii) A process B exits, but and usage goes down.

   iii)      R          R=exceed=300M
            / \
           A   B      A=exceed=200M  B=exceed=10M

   vi) A new node inserted
             R         R=exceed=300M
            / \       
           A   B       A=exceed=200M B=exceed=10M
              / \
             nil C     C=exceed=310M

   v) Time expires and remove "R" and do rotate.

   Hmm ? Is above status is allowed ? I'm sorry if I misunderstand RBtree.

I'll post my own version in this week (more conservative version, maybe).
please discuss and compare trafe-offs.

Thanks,
-Kame

