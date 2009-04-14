Return-Path: <linux-kernel-owner+w=401wt.eu-S1756402AbZDNRGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbZDNRGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbZDNRGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:06:37 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:36786 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbZDNRGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:06:36 -0400
Date: Tue, 14 Apr 2009 22:36:21 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "mingo@redhat.com" <mingo@redhat.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:sched/urgent] sched: Print sched_group::__cpu_power in
	sched_domain_debug
Message-ID: <20090414170621.GA1733@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20090330045520.2869.24777.stgit@sofia.in.ibm.com> <tip-46e0bb9c12f4bab539736f1714cbf16600f681ec@git.kernel.org> <12c511ca0904131153g39b99ec6n6c6ec2e7de3f7ea6@mail.gmail.com> <20090414000934.GN817@elte.hu> <20090414033936.GA534@in.ibm.com> <57C9024A16AD2D4C97DC78E552063EA39B3CF29A@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA39B3CF29A@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 09:29:53AM -0700, Luck, Tony wrote:
> -               printk(KERN_CONT " %s (__cpu_power = %d)", str,
> -                                               group->__cpu_power);
> +               if (group->__cpu_power != SCHED_LOAD_SCALE)
> +                       printk(KERN_CONT " %s (__cpu_power = %d)", str,
> +                                                       group->__cpu_power);
> 
> Much quieter ... but perhaps a little too quiet?
> Is this what you want?  Now the console output looks like this:
> 
> CPU0 attaching sched-domain:
>  domain 0: span 0-15 level CPU
>   groups:
> CPU1 attaching sched-domain:
>  domain 0: span 0-15 level CPU
>   groups:
> CPU2 attaching sched-domain:
>  domain 0: span 0-15 level CPU
>   groups:
>  ...
> 
> instead of the original:
> 
> CPU0 attaching sched-domain:
>  domain 0: span 0-15 level CPU
>   groups: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
> CPU1 attaching sched-domain:
>  domain 0: span 0-15 level CPU
>   groups: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 0
> CPU2 attaching sched-domain:
>  domain 0: span 0-15 level CPU
>   groups: 2 3 4 5 6 7 8 9 10 11 12 13 14 15 0 1
>  ...
> 
> Either we don't need the empty "groups:" line, or we should
> still list the cpus in the group?  I'm not really sure what
> information you are trying to convey here.

We should be listing the cpus in the group. We should not be listing the
__cpu_power of the group, if the __cpu_power has the default value. In
the patch that I sent this morning, I made a mistake by making dependent
the printing of both cpus as well as __cpu_power, on the if
condition which checks if __cpu_power is default or not.

               if (group->__cpu_power != SCHED_LOAD_SCALE)
                       printk(KERN_CONT " %s (__cpu_power = %d)", str,
                                                       group->__cpu_power);

Unfortunately for me, it's not the first goof up I've been involved in
today. Please find the updated patch below.

---->
sched: Avoid printing sched_group::__cpu_power for default case.

From: Gautham R Shenoy <ego@in.ibm.com>

The following commit produces a messy dmesg output while attempting to print
the sched_group::__cpu_power for each group in the sched_domain hierarchy.

	commit 46e0bb9c12f4bab539736f1714cbf16600f681ec
	Author: Gautham R Shenoy <ego@in.ibm.com>
	Date:   Mon Mar 30 10:25:20 2009 +0530
	sched: Print sched_group::__cpu_power in sched_domain_debug

Fix this by avoid printing the __cpu_power for default cases.
(i.e, __cpu_power == SCHED_LOAD_SCALE).

Reported-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 kernel/sched.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)


diff --git a/kernel/sched.c b/kernel/sched.c
index 681d4ae..db2df70 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7467,7 +7467,9 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 		cpumask_or(groupmask, groupmask, sched_group_cpus(group));
 
 		cpulist_scnprintf(str, sizeof(str), sched_group_cpus(group));
-		printk(KERN_CONT " %s (__cpu_power = %d)", str,
+		printk(KERN_CONT " %s", str);
+		if (group->__cpu_power != SCHED_LOAD_SCALE)
+			printk(KERN_CONT " (__cpu_power = %d)",
 						group->__cpu_power);
 
 		group = group->next;

-- 
Thanks and Regards
gautham
