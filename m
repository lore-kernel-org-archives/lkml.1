Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191AbYBSPkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbYBSPkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 10:40:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbYBSPj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 10:39:59 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:29188 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbYBSPj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 10:39:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=Wqhf6KKg3Hkv/TfpA5JMBmP0VyyAYtoaL6nw5RCX23wLYKsnomjIY4fdPHmtDojKdULGUu1Cts3UA+fGHT8NsfualudRukloCQBWDees/pl2c351rtLIK9liqS20KdQJPyf5pS4IuqzinwhbhVOvI/4Zb0LzRO2indyUkVw02ls=
Date: Tue, 19 Feb 2008 17:37:20 +0200
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Tasklets: Avoid duplicating __tasklet_{,hi_}schedule() code
Message-ID: <20080219153720.GA2967@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Avoid duplicating __tasklet_schedule() and __tasklet_hi_schedule()
code in tasklet_action() and tasklet_hi_action() respectively.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

This also saves a few bytes of image space:

   text	   data	    bss	    dec	    hex	filename
   3632	     12	    324	   3968	    f80	softirq.o.before
   3552	     12	    324	   3888	    f30	softirq.o.after

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 5b3aea5..3068dc3 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -414,11 +414,8 @@ static void tasklet_action(struct softirq_action *a)
 			tasklet_unlock(t);
 		}
 
-		local_irq_disable();
-		t->next = __get_cpu_var(tasklet_vec).list;
-		__get_cpu_var(tasklet_vec).list = t;
-		__raise_softirq_irqoff(TASKLET_SOFTIRQ);
-		local_irq_enable();
+		/* We were not lucky enough to run, reschedule. */
+		__tasklet_schedule(t);
 	}
 }
 
@@ -447,11 +444,8 @@ static void tasklet_hi_action(struct softirq_action *a)
 			tasklet_unlock(t);
 		}
 
-		local_irq_disable();
-		t->next = __get_cpu_var(tasklet_hi_vec).list;
-		__get_cpu_var(tasklet_hi_vec).list = t;
-		__raise_softirq_irqoff(HI_SOFTIRQ);
-		local_irq_enable();
+		/* We were not lucky enough to run, reschedule. */
+		__tasklet_hi_schedule(t);
 	}
 }
 

Regards,

-- 
Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

