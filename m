Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbZICJko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbZICJko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 05:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519AbZICJkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 05:40:43 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:52666 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500AbZICJkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 05:40:42 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [v4 PATCH 1/5]: cpuidle: Cleanup drivers/cpuidle/cpuidle.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: arun@linux.vnet.ibm.com
Cc: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20090903044253.GA31928@linux.vnet.ibm.com>
References: <20090901113704.GG7599@linux.vnet.ibm.com>
	 <20090901113840.GH7599@linux.vnet.ibm.com> <1251870144.7547.48.camel@twins>
	 <20090903044253.GA31928@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 03 Sep 2009 11:40:38 +0200
Message-Id: <1251970838.7447.23.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-03 at 10:12 +0530, Arun R Bharadwaj wrote:

> > OK, that's a start I guess. Best would be to replace all of pm_idle with
> > cpuidle, which is what should have been done from the very start.
> > 
> > If cpuidle cannot fully replace the pm_idle functionality, then it needs
> > to fix that. But having two layers of idle functions is just silly.
> > 
> > Looking at patch 2 and 3, you're making the same mistake on power, after
> > those patches there are multiple ways of registering idle functions, one
> > through some native interface and one through cpuidle, this strikes me
> > as undesirable.
> > 
> > If cpuidle is a good idle function manager, then it should be good
> > enough to be the sole one, if its not, then why bother with it at all.
> > 
> 
> Okay, I'm giving this approach a shot now. i.e. trying to make cpuidle
> as _the_ sole idle function manager. This would mean doing away with
> pm_idle and ppc_md.power_save. And, cpuidle_idle_call() which is the
> main idle loop of cpuidle, present in drivers/cpuidle/cpuidle.c will
> have to be called from arch specific code of cpu_idle()
> 
> Also this would mean enabling cpuidle for all platforms, even if the
> platform doesn't have multiple idle states. So suppose a platform doesnt
> have multiple states, it wouldn't want the bloated code of cpuidle
> governors, and would want just a simple cpuidle loop.

Do talk to the powerpc maintainers about this. But yes, something like
that should be doable.

AFAICT the whole governor thing is optional and cpuidle provides a
spinning idle loop by default, and platforms can always register a
simple alternative when they set up bits -- the only thing to be careful
about is not creating a chicken-egg problem where the platform setup
runs before cpuidle is able to register a new handler or something.

I'd be delighted to see the end of pm_idle on x86.

