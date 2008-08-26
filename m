Return-Path: <linux-kernel-owner+w=401wt.eu-S1759148AbYHZUBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759148AbYHZUBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755717AbYHZUAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:00:49 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:2886 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402AbYHZUAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:00:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Hl4lP0Ibh6gZHP+ts+Yr5bN5BhrrDP9Qk27Gg2073KMYf26jP/np98xu0P4QOWIB/Y
         l9EICpmatuikkZZye3lATam5qtnehP+pbCkIPjta/t6nHRc6s6g1jF9zxejSEXsQphiG
         8GbHDUE6u+pbo6epXC+W1JQeS9C+ogrhhMlUk=
Subject: [PATCH 2/2] rcu: fix sparse shadowed variable warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 26 Aug 2008 13:00:44 -0700
Message-Id: <1219780844.6069.6.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/rcuclassic.c:564:18: warning: symbol 'flags' shadows an earlier one
kernel/rcuclassic.c:527:16: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
It would be safe in this case to just remove the second declaration of flags
and reuse it as it is outside the local_irq_save/restore pair.  I did it this
way in case there are future changes that might mix up the use of flags.

Feel free to just remove the second flags declaration if you'd rather do it
that way.

 kernel/rcuclassic.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index 743cf05..ed15128 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -561,15 +561,15 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp,
 		local_irq_restore(flags);
 
 		if (rcu_batch_after(rdp->batch, rcp->pending)) {
-			unsigned long flags;
+			unsigned long flags2;
 
 			/* and start it/schedule start if it's a new batch */
-			spin_lock_irqsave(&rcp->lock, flags);
+			spin_lock_irqsave(&rcp->lock, flags2);
 			if (rcu_batch_after(rdp->batch, rcp->pending)) {
 				rcp->pending = rdp->batch;
 				rcu_start_batch(rcp);
 			}
-			spin_unlock_irqrestore(&rcp->lock, flags);
+			spin_unlock_irqrestore(&rcp->lock, flags2);
 		}
 	}
 
-- 
1.6.0.340.g84854

