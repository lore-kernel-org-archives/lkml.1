Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286AbZGYCf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbZGYCf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 22:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbZGYCf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 22:35:59 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38130 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbZGYCf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 22:35:58 -0400
Message-ID: <5bb65c0e4c6828b1331d33745f34d9ee.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <337c5d83954b38b14a17f0adf4d357d8.squirrel@webmail-b.css.fujitsu.com>
References: <20090715182320.39B5.A69D9226@jp.fujitsu.com>
    <1247679064.4089.26.camel@useless.americas.hpqcorp.net>
    <alpine.DEB.2.00.0907161257190.31844@chino.kir.corp.google.com>
    <alpine.DEB.2.00.0907241551070.8573@chino.kir.corp.google.com>
    <20090724160936.a3b8ad29.akpm@linux-foundation.org>
    <337c5d83954b38b14a17f0adf4d357d8.squirrel@webmail-b.css.fujitsu.com>
Date: Sat, 25 Jul 2009 11:35:54 +0900 (JST)
Subject: Re: [BUG] set_mempolicy(MPOL_INTERLEAV) cause kernel panic
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "David Rientjes" <rientjes@google.com>, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com, miaox@cn.fujitsu.com, mingo@elte.hu,
       a.p.zijlstra@chello.nl, cl@linux-foundation.org, menage@google.com,
       nickpiggin@yahoo.com.au, y-goto@jp.fujitsu.com, penberg@cs.helsinki.fi,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> Andrew Morton wrote:
>> On Fri, 24 Jul 2009 15:51:51 -0700 (PDT)
>> David Rientjes <rientjes@google.com> wrote:
>
>> afaik we don't have a final patch for this.  I asked Motohiro-san about
>> this and he's proposing that we revert the offending change (which one
>> was it?) if nothing gets fixed soon - the original author is on a
>> lengthy vacation.
>>
>>
>> If we _do_ have a patch then can we start again?  Someone send out the
>> patch
>> and let's take a look at it.
> Hmm, like this ? (cleaned up David's one because we shouldn't have
> extra nodemask_t on stack.)
>
> Problems are
>   - rebind() is maybe broken but no good idea.
>    (but it seems to be broken in old kernels
>   - Who can test this is only a user who has possible node on SRAT.
>

> +		/* should we call is_valid_nodemask() here ?*/
>  		if (pol->flags & MPOL_F_RELATIVE_NODES)
>  			mpol_relative_nodemask(&cpuset_context_nmask, nodes,
> -					       &cpuset_current_mems_allowed);
> +					       &cpuset_context_nmask);
Sorry this part is buggy.

But to fix this, we use extra nodemask here and this patch will
allocate 3 nodemasks on stack!
Then, here is a much easier fix. for trusting cpuset more.

==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

task->mems_allowed is guaranteed to be only includes valid nodes when
it is set under cpuset. but, at init, all possible nodes are included.
fix it.

And at cpuset-rebind, caluculated result can be a invaild one.
In that case, trust cpuset's one

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 init/main.c    |    4 ++--
 mm/mempolicy.c |    7 ++++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

Index: mmotm-2.6.31-Jul16/init/main.c
===================================================================
--- mmotm-2.6.31-Jul16.orig/init/main.c
+++ mmotm-2.6.31-Jul16/init/main.c
@@ -855,9 +855,9 @@ static int __init kernel_init(void * unu
 	lock_kernel();

 	/*
-	 * init can allocate pages on any node
+	 * init can allocate pages on any online node
 	 */
-	set_mems_allowed(node_possible_map);
+	set_mems_allowed(node_state[N_HIGH_MEMORY]);
 	/*
 	 * init can run on any cpu.
 	 */
Index: mmotm-2.6.31-Jul16/mm/mempolicy.c
===================================================================
--- mmotm-2.6.31-Jul16.orig/mm/mempolicy.c
+++ mmotm-2.6.31-Jul16/mm/mempolicy.c
@@ -290,7 +290,12 @@ static void mpol_rebind_nodemask(struct
 			    *nodes);
 		pol->w.cpuset_mems_allowed = *nodes;
 	}
-
+	/*
+	 * tmp can be invalid ...just use cpuset's one in that case.
+	 */
+	if (nodes_empty(tmp) ||
+	    ((pol->mode == MPOL_BIND) && !is_valid_nodemask(&tmp)))
+		tmp = *nodes;
 	pol->v.nodes = tmp;
 	if (!node_isset(current->il_next, tmp)) {
 		current->il_next = next_node(current->il_next, tmp);





