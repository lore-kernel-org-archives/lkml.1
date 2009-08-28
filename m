Return-Path: <linux-kernel-owner+w=401wt.eu-S1752036AbZH1HDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbZH1HDN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 03:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbZH1HDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 03:03:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:47513 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbZH1HDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 03:03:12 -0400
Subject: Re: [PATCH 2/4]: CPUIDLE: Introduce architecture independent
 cpuidle_pm_idle in drivers/cpuidle/cpuidle.c
From: Peter Zijlstra <peterz@infradead.org>
To: arun@linux.vnet.ibm.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Joel Schopp <jschopp@austin.ibm.com>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <1251442085.18584.120.camel@twins>
References: <20090827114908.GA24986@linux.vnet.ibm.com>
	 <20090827115354.GC24986@linux.vnet.ibm.com>
	 <1251377607.18584.96.camel@twins>
	 <20090828061434.GA11863@linux.vnet.ibm.com>
	 <1251442085.18584.120.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 28 Aug 2009 09:01:12 +0200
Message-Id: <1251442872.18584.125.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-28 at 08:48 +0200, Peter Zijlstra wrote:
> 
> > void cpuidle_install_idle_handler(void)
> > {
> >       .........
> >       .........
> >       cpuidle_pm_idle = cpuidle_idle_call;
> > }
> 
> All I'm seeing here is a frigging mess.
> 
> How on earths can something called: cpuidle_install_idle_handler() have
> a void argument, _WHAT_ handler is it going to install?

Argh, now I see, it installs itself as the platform idle handler.

so cpuidle_install_idle_handler() pokes at the unmanaged pm_idle pointer
to make cpuidle take control.

On module load it does:

 pm_idle_old = pm_idle;

then in the actual idle loop it does:

        if (!dev || !dev->enabled) {
                if (pm_idle_old)
                        pm_idle_old();

who is to say that the pointer stored at module init time is still
around at that time?

So cpuidle recognised the pm_idle stuff was a flaky, but instead of
fixing it, they build a whole new layer on top of it. Brilliant.

/me goes mark this whole thread read, I've got enough things to do.
