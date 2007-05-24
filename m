Return-Path: <linux-kernel-owner+w=401wt.eu-S1760139AbXEXBXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760139AbXEXBXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 21:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756792AbXEXBXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 21:23:38 -0400
Received: from smtp-out.google.com ([216.239.33.17]:24796 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667AbXEXBXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 21:23:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:from:to:cc:subject:message-id:date;
	b=priQCamBNyzJ7JGD/3UsB5KxrUr87EDTa2HFbpKDXKo24CGUT8XdTSsyw5B64CTH1
	M+wdltUzWrCO1K6b/P5VA==
From: Paul Menage <menage@google.com>
To: pj@sgi.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, menage@google.com
Subject: [PATCH] Reduce cpuset.c write_lock_irq() to read_lock()
Message-Id: <20070524012316.98BFB3D65BA@localhost>
Date: Wed, 23 May 2007 18:23:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cpuset.c:update_nodemask() uses a write_lock_irq() on tasklist_lock to
block concurrent forks; a read_lock() suffices and is less intrusive.

Signed-off-by: Paul Menage<menage@google.com>

---
 kernel/cpuset.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: scratch-2.6.22-rc1-mm1/kernel/cpuset.c
===================================================================
--- scratch-2.6.22-rc1-mm1.orig/kernel/cpuset.c
+++ scratch-2.6.22-rc1-mm1/kernel/cpuset.c
@@ -923,10 +923,10 @@ static int update_nodemask(struct cpuset
 		mmarray = kmalloc(ntasks * sizeof(*mmarray), GFP_KERNEL);
 		if (!mmarray)
 			goto done;
-		write_lock_irq(&tasklist_lock);		/* block fork */
+		read_lock(&tasklist_lock);		/* block fork */
 		if (atomic_read(&cs->count) <= ntasks)
 			break;				/* got enough */
-		write_unlock_irq(&tasklist_lock);	/* try again */
+		read_unlock(&tasklist_lock);	/* try again */
 		kfree(mmarray);
 	}
 
@@ -948,7 +948,7 @@ static int update_nodemask(struct cpuset
 			continue;
 		mmarray[n++] = mm;
 	} while_each_thread(g, p);
-	write_unlock_irq(&tasklist_lock);
+	read_unlock(&tasklist_lock);
 
 	/*
 	 * Now that we've dropped the tasklist spinlock, we can

