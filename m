Return-Path: <linux-kernel-owner+w=401wt.eu-S1752519AbZICEnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbZICEnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 00:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbZICEnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 00:43:04 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:34202 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbZICEnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 00:43:03 -0400
Date: Thu, 3 Sep 2009 10:12:53 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org, Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [v4 PATCH 1/5]: cpuidle: Cleanup drivers/cpuidle/cpuidle.c
Message-ID: <20090903044253.GA31928@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090901113704.GG7599@linux.vnet.ibm.com> <20090901113840.GH7599@linux.vnet.ibm.com> <1251870144.7547.48.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1251870144.7547.48.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-09-02 07:42:24]:

> On Tue, 2009-09-01 at 17:08 +0530, Arun R Bharadwaj wrote:
> > * Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-09-01 17:07:04]:
> > 
> > Cleanup drivers/cpuidle/cpuidle.c
> > 
> > Cpuidle maintains a pm_idle_old void pointer because, currently in x86
> > there is no clean way of registering and unregistering a idle function.
> 
> Right, and instead of fixing that, they build this cpuidle crap on top,
> instead of replacing the current crap with it.
> 
> > So remove pm_idle_old and leave the responsibility of maintaining the
> > list of registered idle loops to the architecture specific code. If the
> > architecture registers cpuidle_idle_call as its idle loop, only then
> > this loop is called.
> 
> OK, that's a start I guess. Best would be to replace all of pm_idle with
> cpuidle, which is what should have been done from the very start.
> 
> If cpuidle cannot fully replace the pm_idle functionality, then it needs
> to fix that. But having two layers of idle functions is just silly.
> 
> Looking at patch 2 and 3, you're making the same mistake on power, after
> those patches there are multiple ways of registering idle functions, one
> through some native interface and one through cpuidle, this strikes me
> as undesirable.
> 
> If cpuidle is a good idle function manager, then it should be good
> enough to be the sole one, if its not, then why bother with it at all.
> 

Okay, I'm giving this approach a shot now. i.e. trying to make cpuidle
as _the_ sole idle function manager. This would mean doing away with
pm_idle and ppc_md.power_save. And, cpuidle_idle_call() which is the
main idle loop of cpuidle, present in drivers/cpuidle/cpuidle.c will
have to be called from arch specific code of cpu_idle()

Also this would mean enabling cpuidle for all platforms, even if the
platform doesn't have multiple idle states. So suppose a platform doesnt
have multiple states, it wouldn't want the bloated code of cpuidle
governors, and would want just a simple cpuidle loop.

--arun
> 
