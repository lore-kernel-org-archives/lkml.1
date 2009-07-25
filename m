Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbZGYDPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbZGYDPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 23:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbZGYDPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 23:15:14 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38476 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbZGYDPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 23:15:12 -0400
Message-ID: <9443f91bd4648e6214b32acff4512b97.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <5bb65c0e4c6828b1331d33745f34d9ee.squirrel@webmail-b.css.fujitsu.com>
References: <20090715182320.39B5.A69D9226@jp.fujitsu.com>
    <1247679064.4089.26.camel@useless.americas.hpqcorp.net>
    <alpine.DEB.2.00.0907161257190.31844@chino.kir.corp.google.com>
    <alpine.DEB.2.00.0907241551070.8573@chino.kir.corp.google.com>
    <20090724160936.a3b8ad29.akpm@linux-foundation.org>
    <337c5d83954b38b14a17f0adf4d357d8.squirrel@webmail-b.css.fujitsu.com>
    <5bb65c0e4c6828b1331d33745f34d9ee.squirrel@webmail-b.css.fujitsu.com>
Date: Sat, 25 Jul 2009 12:15:10 +0900 (JST)
Subject: Re: [BUG] set_mempolicy(MPOL_INTERLEAV) cause kernel panic
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
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
> KAMEZAWA Hiroyuki wrote:
> Then, here is a much easier fix. for trusting cpuset more.
>
just a memo about memory hotplug

_Direct_ use of task->mems_allowed is only in cpuset and mempolicy.
If no policy is used, it's not checked.
(See alloc_pages_current())

memory hotplug's notifier just updates top_cpuset's mems_allowed.
But it doesn't update each task's ones.
Then, task's bahavior is

 - tasks which don't use mempolicy will use all nodes, N_HIGH_MEMORY.
 - tasks under cpuset will be controlled under their own cpuset.
 - tasks under mempolicy will use their own policy.
   but no new policy is re-calculated and, then, no new mask.

Now, even if all memory on nodes a removed, pgdat just remains.
Then, cpuset/mempolicy will never access NODE_DATA(nid) which is NULL.

Thanks,
-Kame

