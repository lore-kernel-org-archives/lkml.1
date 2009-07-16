Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbZGPBAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbZGPBAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 21:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756814AbZGPBAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 21:00:22 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37222 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802AbZGPBAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 21:00:20 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [BUG] set_mempolicy(MPOL_INTERLEAV) cause kernel panic
Cc: kosaki.motohiro@jp.fujitsu.com, Miao Xie <miaox@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Paul Menage <menage@google.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Rientjes <rientjes@google.com>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1247679064.4089.26.camel@useless.americas.hpqcorp.net>
References: <20090715182320.39B5.A69D9226@jp.fujitsu.com> <1247679064.4089.26.camel@useless.americas.hpqcorp.net>
Message-Id: <20090716093508.9D05.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 16 Jul 2009 10:00:17 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2009-07-15 at 18:48 +0900, KOSAKI Motohiro wrote:
> > Hi
> > 
> > On 2.6.31-rc3, following test makes kernel panic immediately.
> > 
> >   numactl --interleave=all echo
> > 
> > Panic message is below. I don't think commit 58568d2a8 is correct patch.
> > 
> > old behavior:
> >   do_set_mempolicy
> >     mpol_new
> >       cpuset_update_task_memory_state
> >         guarantee_online_mems
> >           nodes_and(cs->mems_allowed, node_states[N_HIGH_MEMORY]);
> > 
> > but new code doesn't consider N_HIGH_MEMORY. Then, the userland program
> > passing non-online node bit makes crash, I guess.
> > 
> > Miao, What do you think?
> 
> This looks similar to the problem I tried to fix in:
> 
> 	http://marc.info/?l=linux-mm&m=124140637722309&w=4
> 
> Miao pointed out that the patch needs more work to track hot plug of
> nodes.  I've not had time to get back to this.
> 
> Interestingly, on ia64, the top cpuset mems_allowed gets set to all
> possible nodes, while on x86_64, it gets set to on-line nodes [or nodes
> with memory].  Maybe this is a to support hot-plug?

Maybe.

task->mems_allowed of the init process is initialized by node_possible_map.
if the system doesn't have memory hot-plug capability, node_possible_map
is equal to node_online_map.


-------------------------------------------------
@@ -867,6 +866,11 @@ static noinline int init_post(void)
 static int __init kernel_init(void * unused)
 {
        lock_kernel();
+
+       /*
+        * init can allocate pages on any node
+        */
+       set_mems_allowed(node_possible_map);




