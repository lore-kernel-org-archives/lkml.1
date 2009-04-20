Return-Path: <linux-kernel-owner+w=401wt.eu-S1752933AbZDTA42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbZDTA42 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 20:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbZDTA4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 20:56:18 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:59945 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbZDTA4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 20:56:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=WC1HiVAOuVzPAAzIgYW03TtbDvhfOpG5+ZrmiN+h3yytNA7KVa6VBeFc2L0HsC7SkZ
         7LzvVD7R/2/3xSio2Y3Dua8E2juSpZ230DdxVH0+HUav03rUN5xGHQE8ux8/ws1Pp+1b
         QZLsGsn+y6pwAq93XiHSjY5vTuLhdVwxX/FZo=
MIME-Version: 1.0
Date: Mon, 20 Apr 2009 02:56:15 +0200
X-Google-Sender-Auth: 840bf7c399d0a122
Message-ID: <ed038eb20904191756y5a5bcf8fn53473405b3929de6@mail.gmail.com>
Subject: CFQ: Preemption/timeout logic reversed?
From: Carl Henrik Lunde <chlunde@ping.uio.no>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

It seems the preemption "bonus" logic in CFQ is reversed, a preempted
process is given an additional delay in start time instead of a bonus.
 This seems unfair.  I'm not sure if it's a good idea to let
slice_resid grow without limit as shown below, but isn't this more
like the way it was intended to work?  Or did I misunderstand
something?

PS! The comment above cfq_preempt_queue seems outdated too.

Code not tested, just showing what I mean:

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 664ebfd..ea18d45 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -292,7 +292,8 @@ cfq_prio_to_slice(struct cfq_data *cfqd, struct
cfq_queue *cfqq)
 static inline void
 cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
-       cfqq->slice_end = cfq_prio_to_slice(cfqd, cfqq) + jiffies;
+       cfqq->slice_end = cfq_prio_to_slice(cfqd, cfqq) +
cfqq->slice_resid + jiffies;
+       cfqq->slice_resid = 0;
        cfq_log_cfqq(cfqd, cfqq, "set_slice=%lu", cfqq->slice_end - jiffies);
 }

@@ -489,8 +490,6 @@ static void cfq_service_tree_add(struct cfq_data *cfqd,
                        rb_key += jiffies;
        } else if (!add_front) {
                rb_key = cfq_slice_offset(cfqd, cfqq) + jiffies;
-               rb_key += cfqq->slice_resid;
-               cfqq->slice_resid = 0;
        } else
                rb_key = 0;

@@ -1851,8 +1850,7 @@ cfq_should_preempt(struct cfq_data *cfqd, struct
cfq_queue *new_cfqq,
 }

 /*
- * cfqq preempts the active queue. if we allowed preempt with no slice left,
- * let it have half of its nominal slice.
+ * cfqq preempts the active queue.  start a new time slice.
  */
 static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {


-- 
mvh
Carl Henrik
