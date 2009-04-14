Return-Path: <linux-kernel-owner+w=401wt.eu-S1755087AbZDNDkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbZDNDkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 23:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbZDNDjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 23:39:51 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:45588 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbZDNDju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 23:39:50 -0400
Date: Tue, 14 Apr 2009 09:09:36 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tony Luck <tony.luck@intel.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched: Print sched_group::__cpu_power in
	sched_domain_debug
Message-ID: <20090414033936.GA534@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20090330045520.2869.24777.stgit@sofia.in.ibm.com> <tip-46e0bb9c12f4bab539736f1714cbf16600f681ec@git.kernel.org> <12c511ca0904131153g39b99ec6n6c6ec2e7de3f7ea6@mail.gmail.com> <20090414000934.GN817@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090414000934.GN817@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 02:09:34AM +0200, Ingo Molnar wrote:
> 
> * Tony Luck <tony.luck@intel.com> wrote:
> 
> > > --- a/kernel/sched.c
> > > +++ b/kernel/sched.c
> > > @@ -6963,7 +6963,8 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
> > >                cpumask_or(groupmask, groupmask, sched_group_cpus(group));
> > >
> > >                cpulist_scnprintf(str, sizeof(str), sched_group_cpus(group));
> > > -               printk(KERN_CONT " %s", str);
> > > +               printk(KERN_CONT " %s (__cpu_power = %d)", str,
> > > +                                               group->__cpu_power);
> > 
> > This has added a lot of clutter to the console log during boot
> > (especially on large systems).
> > 
> > Here is the start of the diff output comparing old and new console
> > messages on a 16 cpu machine:
> > 
> > 77c77
> > <   groups: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
> > ---
> > >   groups: 0 (__cpu_power = 1024) 1 (__cpu_power = 1024) 2 (__cpu_power = 1024) 3 (__cpu_power = 1024) 4 (__cpu_power = 1024) 5 (__cpu_power = 1024) 6 (__cpu_power = 1024) 7 (__cpu_power = 1024) 8 (
> > __cpu_power = 1024) 9 (__cpu_power = 1024) 10 (__cpu_power = 1024) 11
> > (__cpu_power = 1024) 12 (__cpu_power = 1024) 13 (__cpu_power = 1024)
> > 14 (__cpu_power = 1024) 15 (__cpu_power = 1024)
> > 80c80
> 
> indeed ...
> 
> I think we should skip the printout in the default (power==1024) 
> case. Gautham?

Makes sense. Patch appended.
> 
> 	Ingo
-->

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

 kernel/sched.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)


diff --git a/kernel/sched.c b/kernel/sched.c
index 681d4ae..0584e04 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7467,8 +7467,9 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 		cpumask_or(groupmask, groupmask, sched_group_cpus(group));
 
 		cpulist_scnprintf(str, sizeof(str), sched_group_cpus(group));
-		printk(KERN_CONT " %s (__cpu_power = %d)", str,
-						group->__cpu_power);
+		if (group->__cpu_power != SCHED_LOAD_SCALE)
+			printk(KERN_CONT " %s (__cpu_power = %d)", str,
+							group->__cpu_power);
 
 		group = group->next;
 	} while (group != sd->groups);
-- 
Thanks and Regards
gautham
