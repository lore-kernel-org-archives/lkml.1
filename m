Return-Path: <linux-kernel-owner+w=401wt.eu-S1760051AbXEYIff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760051AbXEYIff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbXEYIf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:35:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48601 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbXEYIf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:35:27 -0400
Date: Fri, 25 May 2007 10:29:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Guillaume Chazarain <guichaz@yahoo.fr>,
       Nick Piggin <nickpiggin@yahoo.com.au>, efault@gmx.de,
       kernel@kolivas.org, containers@lists.osdl.org,
       ckrm-tech@lists.sourceforge.net, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, pwil3058@bigpond.net.au, tingy@cs.umass.edu,
       tong.n.li@intel.com, wli@holomorphy.com, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [RFC] [PATCH 0/3] Add group fairness to CFS
Message-ID: <20070525082951.GA25280@elte.hu>
References: <20070523164859.GA6595@in.ibm.com> <3d8471ca0705231112rfac9cfbt9145ac2da8ec1c85@mail.gmail.com> <20070523183824.GA7388@elte.hu> <4654BF88.3030404@yahoo.fr> <20070525074500.GD6157@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525074500.GD6157@in.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:

> Can you repeat your tests with this patch pls? With the patch applied, 
> I am now getting the same split between nice 0 and nice 10 task as 
> CFS-v13 provides (90:10 as reported by top )
> 
>  5418 guest     20   0  2464  304  236 R   90  0.0   5:41.40 3 hog
>  5419 guest     30  10  2460  304  236 R   10  0.0   0:43.62 3 nice10hog

btw., what are you thoughts about SMP?

it's a natural extension of your current code. I think the best approach 
would be to add a level of 'virtual CPU' objects above struct user. (how 
to set the attributes of those objects is open - possibly combine it 
with cpusets?)

That way the scheduler would first pick a "virtual CPU" to schedule, and 
then pick a user from that virtual CPU, and then a task from the user. 

To make group accounting scalable, the accounting object attached to the 
user struct should/must be per-cpu (per-vcpu) too. That way we'd have a 
clean hierarchy like:

  CPU #0 => VCPU A [ 40% ] + VCPU B [ 60% ]
  CPU #1 => VCPU C [ 30% ] + VCPU D [ 70% ]

  VCPU A => USER X [ 10% ] + USER Y [ 90% ]
  VCPU B => USER X [ 10% ] + USER Y [ 90% ]
  VCPU C => USER X [ 10% ] + USER Y [ 90% ]
  VCPU D => USER X [ 10% ] + USER Y [ 90% ]

the scheduler first picks a vcpu, then a user from a vcpu. (the actual 
external structure of the hierarchy should be opaque to the scheduler 
core, naturally, so that we can use other hierarchies too)

whenever the scheduler does accounting, it knows where in the hierarchy 
it is and updates all higher level entries too. This means that the 
accounting object for USER X is replicated for each VCPU it participates 
in.

SMP balancing is straightforward: it would fundamentally iterate through 
the same hierarchy and would attempt to keep all levels balanced - i 
abstracted away its iterators already.

Hm? 

	Ingo
