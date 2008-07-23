Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbYGWLV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbYGWLV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 07:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYGWLVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 07:21:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48450 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270AbYGWLVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 07:21:46 -0400
Date: Wed, 23 Jul 2008 13:20:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>, Dave Jones <davej@codemonkey.org.uk>,
       Paul Jackson <pj@sgi.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Robert Richter <robert.richter@amd.com>, Greg Banks <gnb@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Adrian Bunk <bunk@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andreas Schwab <schwab@suse.de>, Johannes Weiner <hannes@saeurebad.de>
Subject: Re: [PATCH 1/8] cpumask: Replace cpumask_of_cpu with
	cpumask_of_cpu_ptr
Message-ID: <20080723112042.GA16420@elte.hu>
References: <20080715211429.454823000@polaris-admin.engr.sgi.com> <200807181530.10044.rusty@rustcorp.com.au> <48809DEB.5060104@sgi.com> <200807202003.31526.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200807202003.31526.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> > I wouldn't mind it at all, and since it's almost always calling a 
> > function that requires a cpumask_t pointer (like the cpu_* ops or 
> > set_cpus_allowed_ptr) then there shouldn't be too many "pointer 
> > dereference" penalties.  I'm just always a bit hesitant to make too 
> > many generic changes since I have only x86 and ia64 machines to test 
> > with.
> 
> The simple version is just a static array of [NR_CPUS] cpumask_t's.  
> Do that, with an override for smarter archs?
> 
> I really REALLY prefer that over the fairly tortuous macros.

a fresh commit in -git has exposed the topology.h mess - see the hack 
below. We now have diverging versions of topology_core_siblings() 
semantics - that sure cannot be right. Mike?

	Ingo

------->
commit 695a6b456307455a10059512208e8ed0d376ecd3
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Jul 23 13:19:44 2008 +0200

    topology: work around topology_core_siblings() breakage
    
    work around:
    
    drivers/net/sfc/efx.c: In function ‘efx_probe_interrupts':
    drivers/net/sfc/efx.c:845: error: lvalue required as unary ‘&' operand
    
    the topology API is a mess right now ...
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/net/sfc/efx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/sfc/efx.c b/drivers/net/sfc/efx.c
index 45c72ee..1ababfa 100644
--- a/drivers/net/sfc/efx.c
+++ b/drivers/net/sfc/efx.c
@@ -842,8 +842,10 @@ static void efx_probe_interrupts(struct efx_nic *efx)
 			for_each_online_cpu(cpu) {
 				if (!cpu_isset(cpu, core_mask)) {
 					++efx->rss_queues;
+#if 0
 					cpus_or(core_mask, core_mask,
 						topology_core_siblings(cpu));
+#endif
 				}
 			}
 		} else {

