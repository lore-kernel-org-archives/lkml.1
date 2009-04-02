Return-Path: <linux-kernel-owner+w=401wt.eu-S1763342AbZDBWhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763342AbZDBWhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 18:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755856AbZDBWgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 18:36:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42483 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbZDBWgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 18:36:50 -0400
Date: Fri, 3 Apr 2009 00:36:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, niv@us.ibm.com, dvhltc@us.ibm.com,
       dhowells@redhat.com, lethal@linux-sh.org, kernel@wantstofly.org,
       matthew@wil.cx
Subject: Re: [PATCH] v3 RCU: the bloatwatch edition
Message-ID: <20090402223605.GB19007@elte.hu>
References: <20090203183426.GA14409@linux.vnet.ibm.com> <20090329203118.GA14005@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090329203118.GA14005@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> This patch is a version of RCU designed for (!SMP && EMBEDDED) 
> provided as a proof of concept of a small-footprint RCU 
> implementation. In particular, the implementation of 
> synchronize_rcu() is extremely lightweight and high performance.  
> It passes rcutorture testing in each of the four relevant 
> configurations (combinations of NO_HZ and PREEMPT) on x86.  This 
> saves about 900 bytes compared to Classic RCU, and a couple 
> kilobytes compared to Hierarchical RCU:
> 
> 	CONFIG_CLASSIC_RCU:
> 
> 	   text	   data	    bss	    dec	    hex	filename
> 	    363	     12	     24	    399	    18f	kernel/rcupdate.o
> 	   1237	     64	    124	   1425	    591	kernel/rcuclassic.o
> 				   1824 Total
> 
> 	CONFIG_TREE_RCU:
> 
> 	   text	   data	    bss	    dec	    hex	filename
> 	    363	     12	     24	    399	    18f	kernel/rcupdate.o
> 	   2344	    240	    184	   2768	    ad0	kernel/rcutree.o
> 				   3167 Total
> 
> 	CONFIG_TINY_RCU:
> 
> 	   text	   data	    bss	    dec	    hex	filename
> 	    294	     12	     24	    330	    14a	kernel/rcupdate.o
> 	    563	     36	      0	    599	    257	kernel/rcutiny.o
> 				    929 Total
> 
> 
> Changes from v2 (http://lkml.org/lkml/2009/2/3/333) include:
> 
> o	Fix whitespace issues.
> 
> o	Change short-circuit "||" operator to instead be "+" in order to
> 	fix performance bug noted by "kraai" on LWN.
> 
> 		(http://lwn.net/Articles/324348/)
> 
> Changes from v1 (http://lkml.org/lkml/2009/1/13/440) include:
> 
> o	This version depends on EMBEDDED as well as !SMP, as suggested
> 	by Ingo.
> 
> o	Updated rcu_needs_cpu() to unconditionally return zero,
> 	permitting the CPU to enter dynticks-idle mode at any time.
> 	This works because callbacks can be invoked upon entry to
> 	dynticks-idle mode.
> 
> o	I am now OK with this being included, based on a poll at the
> 	Kernel Miniconf at linux.conf.au, where about ten people said
> 	that they cared about saving 900 bytes on single-CPU systems.
> 
> o	Applies to both mainline and tip/core/rcu.

Andrew, what do you think?

A worry is yet another RCU variant - we already have 3.

A trick we could use would be to put it into Documentation/rcu/, 
linked in via some clever Makefile magic and only usable if a 
ultra-embedded developer does a build with something like 
CONFIG_RCU_TINY=y. That way there's no real maintenance and testing 
overhead.

It _does_ have documentation value beyond the ~900 bytes: it's the 
simplest and smallest possible still-working UP RCU implementation 
so it would be easy to teach RCU concepts via that, gradually.

	Ingo
