Return-Path: <linux-kernel-owner+w=401wt.eu-S1754225AbYKHIcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbYKHIcl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 03:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbYKHIcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 03:32:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52431 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbYKHIcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 03:32:22 -0500
Date: Sat, 8 Nov 2008 09:32:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, suresh.b.siddha@intel.com
Subject: Re: [PATCH] sched: fix a bug in sched domain degenerate
Message-ID: <20081108083206.GA16667@elte.hu>
References: <49124C2C.9080300@cn.fujitsu.com> <491537C6.3050800@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491537C6.3050800@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> Hi Ingo,
> 
> I just read the modified changelog in the git-log, and it is
> wrong (or maybe my fix is wrong?), I should have explained
> the bug clearer. :(
> 
> I'm writing this mail to confirm if my thought and fix is
> right or not.
> 
> > commit f29c9b1ccb52904ee442a933cf3dee628f9f4e62
> > Author: Li Zefan <lizf@cn.fujitsu.com>
> > Date:   Thu Nov 6 09:45:16 2008 +0800
> > 
> >     sched: fix a bug in sched domain degenerate
> >     
> >     Impact: re-add incorrectly eliminated sched domain layers
> >     
> 
> This statement is wrong..

that's OK, because the patch is correct :-)

> >     (1) on i386 with SCHED_SMT and SCHED_MC enabled
> >     	# mount -t cgroup -o cpuset xxx /mnt
> >     	# echo 0 > /mnt/cpuset.sched_load_balance
> >     	# mkdir /mnt/0
> >     	# echo 0 > /mnt/0/cpuset.cpus
> >     	# dmesg
> >     	CPU0 attaching sched-domain:
> >     	 domain 0: span 0 level CPU
> >     	  groups: 0
> >     
> 
> I think this behavior is wrong.
> 
> >     (2) on i386 with SCHED_MC enabled but SCHED_SMT disabled
> >     	# same with (1)
> >     	# dmesg
> >     	CPU0 attaching NULL sched-domain.
> >     
> 
> And this is right. CPU domain has only 1 cpu so it does not contribute
> to scheduling, so it can be removed.
> 
> >     The bug is that some sched domains may be skipped unintentionally when
> >     degenerating (optimizing) sched domains.
> >     
> 
> The bug is, some sched domains won't be checked in the for loop due
> to the bug, so they have no chance to be removed.
> 
> In the for loop, we check if the parents domains can be removed:
> 
> cur_ptr
>  |
>  v
> SMT--->MC--->CPU--->NULL
> 
> (parent MC is checked and can be removed)
> 
> =>
> 
>        cur_ptr
>         |
>         v
> SMT--->CPU--->NULL
> 
> (break out of the for loop, because cur_ptr->parent == NULL)
> 
> so CPU domain won't be checked. When we delete MC domain, the pointer
> should not move forwards, so the fix is:
> 
> cur_ptr
>  |
>  v
> SMT--->CPU--->NULL

ah, ok - i misunderstood the direction of the fix. So it strengthens 
degeneration - which is a valid fix too. And the commit message 
remains there to shame my reading skills forever ;-)

	Ingo
