Return-Path: <linux-kernel-owner+w=401wt.eu-S1760082AbYCBXPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082AbYCBXPY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 18:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbYCBXPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 18:15:12 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:38963 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbYCBXPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 18:15:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=sIR7PTSB8p8/wMdnFq7Tyi/WaCwbd4DMPKowQmaOmN1WQQdAvLXmrQjjdFzUXpxgOtMqB2U89wqohZiqobL1Ao6hXEHVDA2JM5OHYWbspDK8hEJbgnLPkjyARhcovYFzFL0cWzC9oCu9oMxINW230uQHhO/SdS1qCQWGVWksaIQ=
Date: Mon, 3 Mar 2008 00:09:18 +0100 (CET)
To: LKML <linux-kernel@vger.kernel.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@elte.hu>, Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH] leak less memory in failure paths of
 alloc_rt_sched_group()
Message-ID: <alpine.LNX.1.00.0803030002520.4939@dragon.funnycrock.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Jesper Juhl <jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In kernel/sched.c b/kernel/sched.c::alloc_rt_sched_group() we currently do 
some paired memory allocations, and if one fails we bail out without 
freeing the previous one.

If we fail inside the loop we should proably roll the whole thing back. 
This patch does not do that, it simply frees the first member of the 
paired alloc if the second fails. This is not perfect, but it's a simple 
change that will, at least, result in us leaking a little less than we 
currently do when an allocation fails.

So, not perfect, but better than what we currently have.
Please consider applying.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 sched.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index f06950c..360857f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7685,8 +7685,10 @@ static int alloc_rt_sched_group(struct task_group *tg)
 	if (!tg->rt_rq)
 		goto err;
 	tg->rt_se = kzalloc(sizeof(rt_se) * NR_CPUS, GFP_KERNEL);
-	if (!tg->rt_se)
+	if (!tg->rt_se) {
+		kfree(tg->rt_rq);
 		goto err;
+	}
 
 	tg->rt_runtime = 0;
 
@@ -7700,8 +7702,10 @@ static int alloc_rt_sched_group(struct task_group *tg)
 
 		rt_se = kmalloc_node(sizeof(struct sched_rt_entity),
 				GFP_KERNEL|__GFP_ZERO, cpu_to_node(i));
-		if (!rt_se)
+		if (!rt_se) {
+			kfree(rt_rq);
 			goto err;
+		}
 
 		init_tg_rt_entry(rq, tg, rt_rq, rt_se, i, 0);
 	}

