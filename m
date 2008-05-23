Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbYEWNFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbYEWNFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbYEWNF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:05:28 -0400
Received: from mail.gmx.net ([213.165.64.20]:58687 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752476AbYEWNF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:05:27 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/HBi8WuBfHsp/EqGWYgyISUKTkfeL6dtjpNaIDLj
	4wiRpvLeSqj/rm
Subject: Re: PostgreSQL pgbench performance regression in 2.6.23+
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg Smith <gsmith@gregsmith.com>, Peter Zijlstra <peterz@infradead.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <20080523101000.GA13964@elte.hu>
References: <1211440207.5733.8.camel@marge.simson.net>
	 <20080522082814.GA4499@linux.vnet.ibm.com>
	 <1211447105.4823.7.camel@marge.simson.net>
	 <1211452465.7606.8.camel@marge.simson.net>
	 <1211455553.4381.9.camel@marge.simson.net>
	 <1211456659.29104.20.camel@twins>
	 <1211458176.5693.6.camel@marge.simson.net>
	 <1211459081.29104.40.camel@twins>
	 <Pine.GSO.4.64.0805230232190.28654@westnet.com>
	 <1211536814.5851.18.camel@marge.simson.net>
	 <20080523101000.GA13964@elte.hu>
Content-Type: text/plain
Date: Fri, 23 May 2008 15:05:23 +0200
Message-Id: <1211547923.5521.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-23 at 12:10 +0200, Ingo Molnar wrote:

> if it's other tweaks as well then could you perhaps try to make 
> SCHED_BATCH batch more agressively?

Running SCHED_BATCH with only the below put a large dent in the problem.

You can have tl <= current->se.load.weight.  Nothing good happens in
either case, at least with this load.

--- kernel/sched_fair.c.org	2008-05-23 14:59:39.000000000 +0200
+++ kernel/sched_fair.c	2008-05-23 14:49:05.000000000 +0200
@@ -1081,7 +1081,7 @@ wake_affine(struct rq *rq, struct sched_
 	 * effect of the currently running task from the load
 	 * of the current CPU:
 	 */
-	if (sync)
+	if (sync && tl > current->se.load.weight)
 		tl -= current->se.load.weight;
 
 	if ((tl <= load && tl + target_load(prev_cpu, idx) <= tl_per_task) ||
 


2.6.26-smp x86_64
1 9209.503213
2 15792.406916
3 23369.199181
4 23140.108032
5 24556.515470
6 24926.457776
8 26896.607558
10 27350.988396
15 29005.426298
20 28558.267290
30 27002.328374
40 25809.202374
50 24589.478654

