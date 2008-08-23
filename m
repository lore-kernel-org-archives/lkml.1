Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbYHWQQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbYHWQQe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 12:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbYHWQQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 12:16:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40535 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbYHWQQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 12:16:25 -0400
Date: Sat, 23 Aug 2008 18:07:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org,
       akpm@linux-foundation.org, manfred@colorfullife.com,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, schamp@sgi.com,
       niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org
Subject: Re: [PATCH, RFC, tip/core/rcu] scalable classic RCU implementation
Message-ID: <20080823160735.GC27974@elte.hu>
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080822043715.GD15212@elte.hu> <20080822134720.GG6875@linux.vnet.ibm.com> <20080822172221.GA9593@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822172221.GA9593@linux.vnet.ibm.com>
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

> Is this a sufficient improvement?

yeah - looks much better. This was the block that meets the eye for the 
first time in the patch so it stuck out.

just one more small pet peeve of mine: please use vertical alignment too 
to improve readability. Instead of:

> #define MAX_RCU_LEVELS 3
> #define RCU_FANOUT (CONFIG_RCU_FANOUT)
> #define RCU_FANOUT_SQ (RCU_FANOUT * RCU_FANOUT)
> #define RCU_FANOUT_CUBE (RCU_FANOUT_SQ * RCU_FANOUT)

this looks a bit more structured IMO:

> #define MAX_RCU_LEVELS	3
> #define RCU_FANOUT		(CONFIG_RCU_FANOUT)
> #define RCU_FANOUT_SQ		(RCU_FANOUT * RCU_FANOUT)
> #define RCU_FANOUT_CUBE	(RCU_FANOUT_SQ * RCU_FANOUT)

maybe even this:

> #if (NR_CPUS) <= RCU_FANOUT
> #  define NUM_RCU_LVLS	1
> #  define NUM_RCU_LVL_0	1
> #  define NUM_RCU_LVL_1	(NR_CPUS)
> #  define NUM_RCU_LVL_2	0
> #  define NUM_RCU_LVL_3	0
> #elif (NR_CPUS) <= RCU_FANOUT_SQ
> #  define NUM_RCU_LVLS	2
> #  define NUM_RCU_LVL_0	1
> #  define NUM_RCU_LVL_1	(((NR_CPUS) + RCU_FANOUT - 1) / RCU_FANOUT)
> #  define NUM_RCU_LVL_2	(NR_CPUS)
> #  define NUM_RCU_LVL_3	0
> #elif (NR_CPUS) <= RCU_FANOUT_CUBE
> #  define NUM_RCU_LVLS	3
> #  define NUM_RCU_LVL_0	1
> #  define NUM_RCU_LVL_1	(((NR_CPUS) + RCU_FANOUT_SQ - 1) / RCU_FANOUT_SQ)
> #  define NUM_RCU_LVL_2	(((NR_CPUS) + (RCU_FANOUT) - 1) / (RCU_FANOUT))
> #  define NUM_RCU_LVL_3	NR_CPUS
> #else
> # error "CONFIG_RCU_FANOUT insufficient for NR_CPUS"
> #endif /* #if (NR_CPUS) <= RCU_FANOUT */

but no strong feelings on that one. (maybe inserting a space at the 
right places helps too, no need for a full tab)

	Ingo
