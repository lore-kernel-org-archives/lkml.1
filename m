Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526AbYGWLYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbYGWLYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 07:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbYGWLYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 07:24:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49653 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbYGWLYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 07:24:09 -0400
Date: Wed, 23 Jul 2008 13:23:09 +0200
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
Message-ID: <20080723112309.GA30519@elte.hu>
References: <20080715211429.454823000@polaris-admin.engr.sgi.com> <200807181530.10044.rusty@rustcorp.com.au> <48809DEB.5060104@sgi.com> <200807202003.31526.rusty@rustcorp.com.au> <20080723112042.GA16420@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723112042.GA16420@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > The simple version is just a static array of [NR_CPUS] cpumask_t's.  
> > Do that, with an override for smarter archs?
> > 
> > I really REALLY prefer that over the fairly tortuous macros.
> 
> a fresh commit in -git has exposed the topology.h mess - see the hack 
> below. We now have diverging versions of topology_core_siblings() 
> semantics - that sure cannot be right. Mike?

also i had to do the net/sunrpc/svc.c fixup below.

	Ingo

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 5a32cb7..835d274 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -310,7 +310,8 @@ svc_pool_map_set_cpumask(struct task_struct *task, unsigned int pidx)
 	switch (m->mode) {
 	case SVC_POOL_PERCPU:
 	{
-		set_cpus_allowed_ptr(task, &cpumask_of_cpu(node));
+		cpumask_of_cpu_ptr(cpumask, node);
+		set_cpus_allowed_ptr(task, cpumask);
 		break;
 	}
 	case SVC_POOL_PERNODE:
