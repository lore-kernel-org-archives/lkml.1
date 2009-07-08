Return-Path: <linux-kernel-owner+w=401wt.eu-S1758751AbZGHUR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751AbZGHUR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 16:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbZGHURu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 16:17:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34402 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753AbZGHURt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 16:17:49 -0400
Date: Wed, 8 Jul 2009 16:17:38 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Beregalov <a.beregalov@gmail.com>, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH] cpufreq: fix UP build
Message-ID: <20090708201738.GA22900@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alexander Beregalov <a.beregalov@gmail.com>,
	linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca
References: <1247075867-11355-1-git-send-email-a.beregalov@gmail.com> <alpine.LFD.2.01.0907081103560.3352@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0907081103560.3352@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 11:08:12AM -0700, Linus Torvalds wrote:
 > 
 > 
 > On Wed, 8 Jul 2009, Alexander Beregalov wrote:
 > >
 > > From: Alexander Beregalov <a.beregalov@gmail.com> 
 > > 
 > > Fix this build error when CONFIG_SMP is not set:
 > > drivers/cpufreq/cpufreq.c:941: 'managed_policy' undeclared
 > 
 > Grr. DaveJ?
 > 
 > That said, I'd much prefer the fix that does _not_ have this crap in it 
 > (not new to your diff - it's pre-existing crap):
 > 
 > 	>  #ifdef CONFIG_SMP
 > 	>       struct cpufreq_policy *managed_policy;
 > 	> +     struct sys_device *cpu_sys_dev;
 > 	>  #endif
 > 
 > and instead those variables should be declared inside the blocks where 
 > they are used, not at the top.
 > 
 > The rule should always be: make the scope of a variable as small as 
 > possible. Don't declare it at the top and try to "save" a declaration when 
 > it can be used inside multiple blocks as multiple different variables.
 > 
 > Also, that whole function could damn well be split into smaller pieces, 
 > which would make it much more readable than that horrible 250+ line piece 
 > of crap monster-function with #ifdef's inside the code.
 > 
 > Please, somebody?

This seems to be a minimal step in the direction of declaring it locally..
Not boot-tested, but should do the right thing.

I'll take a stab at chopping that function up further separately.

	Dave


commit 2381f2a2d3b329313b375bc0bf5df34802b9b4ba
Author: Dave Jones <davej@redhat.com>
Date:   Wed Jul 8 16:14:23 2009 -0400

    [CPUFREQ] Fix compile failure in cpufreq.c
    
    managed_policy is out of scope for the non-smp case.
    Declare it locally where used (twice)
    
    Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index c668ac8..b90eda8 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -776,9 +776,6 @@ static int cpufreq_add_dev(struct sys_device *sys_dev)
 	struct sys_device *cpu_sys_dev;
 	unsigned long flags;
 	unsigned int j;
-#ifdef CONFIG_SMP
-	struct cpufreq_policy *managed_policy;
-#endif
 
 	if (cpu_is_offline(cpu))
 		return 0;
@@ -854,6 +851,8 @@ static int cpufreq_add_dev(struct sys_device *sys_dev)
 #endif
 
 	for_each_cpu(j, policy->cpus) {
+		struct cpufreq_policy *managed_policy;
+
 		if (cpu == j)
 			continue;
 
@@ -932,6 +931,8 @@ static int cpufreq_add_dev(struct sys_device *sys_dev)
 
 	/* symlink affected CPUs */
 	for_each_cpu(j, policy->cpus) {
+		struct cpufreq_policy *managed_policy;
+
 		if (j == cpu)
 			continue;
 		if (!cpu_online(j))

