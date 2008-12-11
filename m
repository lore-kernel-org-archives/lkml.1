Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbYLKExX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbYLKExX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 23:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbYLKExN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 23:53:13 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47425 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbYLKExM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 23:53:12 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mike Travis <travis@sgi.com>
Subject: Re: [linux-next][PATCH] cpumask:cpumask_of_node-ia64 fix
Cc: kosaki.motohiro@jp.fujitsu.com, "Luck, Tony" <tony.luck@intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <494093F7.5020000@sgi.com>
References: <20081211105721.4FEE.KOSAKI.MOTOHIRO@jp.fujitsu.com> <494093F7.5020000@sgi.com>
Message-Id: <20081211132146.4FFD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 11 Dec 2008 13:53:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> KOSAKI Motohiro wrote:
> > ===
> > Subject: [PATCH] cpumask:cpumask_of_node-ia64 fix
> > Impact: bug fix
> > 
> > commit 07c636deede53ff3e96d54df0ece2c838e61951f introduce new CPU mask API and change cpu_mask variable type.
> > 
> > -----------------------------------------------
> > -               cpumask_t cpu_mask;
> > +               const struct cpumask *cpu_mask;
> > --------------------------------------------------
> > 
> > 
> > However, its change is incomplete. in build time, compiler output following type mismatch warnings.
> > 
> >   arch/ia64/kernel/iosapic.c:708: warning: passing argument 2 of '__cpu_clear' from incompatible pointer type
> >   arch/ia64/kernel/iosapic.c:711: warning: passing argument 1 of '__cpus_weight' from incompatible pointer type
> >   arch/ia64/kernel/iosapic.c:719: warning: passing argument 1 of '__first_cpu' from incompatible pointer type
> >   arch/ia64/kernel/iosapic.c:720: warning: passing argument 2 of '__next_cpu' from incompatible pointer type
> 
> Good catch, however ...
> > 
> > 
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > CC: "Luck, Tony" <tony.luck@intel.com>
> > CC: Rusty Russell <rusty@rustcorp.com.au>
> > ---
> >  arch/ia64/kernel/iosapic.c |   10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> > 
> > Index: b/arch/ia64/kernel/iosapic.c
> > ===================================================================
> > --- a/arch/ia64/kernel/iosapic.c
> > +++ b/arch/ia64/kernel/iosapic.c
> > @@ -695,7 +695,7 @@ get_target_cpu (unsigned int gsi, int ir
> >  #ifdef CONFIG_NUMA
> >  	{
> >  		int num_cpus, cpu_index, iosapic_index, numa_cpu, i = 0;
> > -		const struct cpumask *cpu_mask;
> > +		struct cpumask *cpu_mask;
> >  
> >  		iosapic_index = find_iosapic(gsi);
> >  		if (iosapic_index < 0 ||
> > @@ -705,10 +705,10 @@ get_target_cpu (unsigned int gsi, int ir
> >  		cpu_mask = cpumask_of_node(iosapic_lists[iosapic_index].node);
> >  		for_each_cpu_and(numa_cpu, cpu_mask, &domain) {
> >  			if (!cpu_online(numa_cpu))
> > -				cpu_clear(numa_cpu, cpu_mask);
> > +				cpu_clear(numa_cpu, *cpu_mask);
> 
> ... you cannot modify the read-only cpumask_of_node map.  Suggested alternative below.

Oh, I see.
I didn't understand original intention.

and my review and test doen't find any problem in your patch.
Very thanks.


The following is the folded patch of your patch and your over-simplified fix.


===
Subject: [PATCH] don't change cpumask_of_node
Impact: bug fix

commit 07c636deede53ff3e96d54df0ece2c838e61951f introduce new CPU mask API and change cpu_mask variable type.
However, its change is incomplete. in build time, compiler output following type mismatch warnings.

  arch/ia64/kernel/iosapic.c:708: warning: passing argument 2 of '__cpu_clear' from incompatible pointer type
  arch/ia64/kernel/iosapic.c:711: warning: passing argument 1 of '__cpus_weight' from incompatible pointer type
  arch/ia64/kernel/iosapic.c:719: warning: passing argument 1 of '__first_cpu' from incompatible pointer type
  arch/ia64/kernel/iosapic.c:720: warning: passing argument 2 of '__next_cpu' from incompatible pointer type


More unfortunately, current code change the return value o cpumask_of_node().
but it is unacceptable operation. it cause to corrupt data structure.


Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: "Luck, Tony" <tony.luck@intel.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/ia64/kernel/iosapic.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: b/arch/ia64/kernel/iosapic.c
===================================================================
--- a/arch/ia64/kernel/iosapic.c
+++ b/arch/ia64/kernel/iosapic.c
@@ -703,23 +703,23 @@ get_target_cpu (unsigned int gsi, int ir
 			goto skip_numa_setup;
 
 		cpu_mask = cpumask_of_node(iosapic_lists[iosapic_index].node);
+		num_cpus = 0;
 		for_each_cpu_and(numa_cpu, cpu_mask, &domain) {
-			if (!cpu_online(numa_cpu))
-				cpu_clear(numa_cpu, cpu_mask);
+			if (cpu_online(numa_cpu))
+				num_cpus++;
 		}
 
-		num_cpus = cpus_weight(cpu_mask);
-
 		if (!num_cpus)
 			goto skip_numa_setup;
 
 		/* Use irq assignment to distribute across cpus in node */
 		cpu_index = irq % num_cpus;
 
-		for (numa_cpu = first_cpu(cpu_mask) ; i < cpu_index ; i++)
-			numa_cpu = next_cpu(numa_cpu, cpu_mask);
+		for_each_cpu_and(numa_cpu, cpu_mask, &domain)
+			if (cpu_online(numa_cpu) && i++ >= cpu_index)
+				break;
 
-		if (numa_cpu != NR_CPUS)
+		if (numa_cpu < nr_cpu_ids)
 			return cpu_physical_id(numa_cpu);
 	}
 skip_numa_setup:
@@ -730,7 +730,7 @@ skip_numa_setup:
 	 * case of NUMA.)
 	 */
 	do {
-		if (++cpu >= NR_CPUS)
+		if (++cpu >= nr_cpu_ids)
 			cpu = 0;
 	} while (!cpu_online(cpu) || !cpu_isset(cpu, domain));
 



