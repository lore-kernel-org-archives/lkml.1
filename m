Return-Path: <linux-kernel-owner+w=401wt.eu-S1758906AbYBESb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbYBESb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755765AbYBESbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:31:47 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:36642 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbYBESbq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:31:46 -0500
Message-Id: <47A863BE.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 05 Feb 2008 11:25:18 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: <dwalker@mvista.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Max Krasnyanskiy" <maxk@qualcomm.com>,
       "LKML" <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: Re: CPU hotplug and IRQ affinity with 2.6.24-rt1
References: <47A7A131.8040800@qualcomm.com>
 <20080205025144.GA31774@dwalker1.mvista.com>
 <47A7A784.BA47.005A.0@novell.com>
 <20080205165936.GA18613@dwalker1.mvista.com>
In-Reply-To: <20080205165936.GA18613@dwalker1.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Tue, Feb 5, 2008 at 11:59 AM, in message
<20080205165936.GA18613@dwalker1.mvista.com>, Daniel Walker
<dwalker@dwalker1.mvista.com> wrote: 

> 
> I looked at the code a bit, and I'm not sure you need this complexity..
> Once you have replace the old_rq, there is no reason it needs to
> protection of the run queue spinlock .. So you could just move the kfree
> down below the spin_unlock_irqrestore() ..

Here is a new version to address your observation:
-----------------------

we cannot kfree while in_atomic()

Signed-off-by: Gregory Haskins <ghaskins@novell.com>

diff --git a/kernel/sched.c b/kernel/sched.c
index e6ad493..0978912 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6226,6 +6226,7 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 {
        unsigned long flags;
        const struct sched_class *class;
+       struct root_domain *reap = NULL;

        spin_lock_irqsave(&rq->lock, flags);

@@ -6241,7 +6242,7 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
                cpu_clear(rq->cpu, old_rd->online);

                if (atomic_dec_and_test(&old_rd->refcount))
-                       kfree(old_rd);
+                       reap = old_rd;
        }

        atomic_inc(&rd->refcount);
@@ -6257,6 +6258,10 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
        }

        spin_unlock_irqrestore(&rq->lock, flags);
+
+       /* Don't try to free the memory while in-atomic() */
+       if (unlikely(reap))
+               kfree(reap);
 }




> 
> Daniel
> -
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


