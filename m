Return-Path: <linux-kernel-owner+w=401wt.eu-S1161034AbXDSGs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161034AbXDSGs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 02:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161035AbXDSGs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 02:48:29 -0400
Received: from mx2.go2.pl ([193.17.41.42]:59223 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161034AbXDSGs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 02:48:28 -0400
Date: Thu, 19 Apr 2007 08:54:04 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -mm] workqueue: debug possible endless loop in cancel_rearming_delayed_work
Message-ID: <20070419065404.GB1782@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

IMHO cancel_rearming_delayed_work is dangerous place:

- it assumes a work function always rearms (with no exception),
which probably isn't explained enough now (but anyway should
be checked in such loops);

- probably possible (theoretical) scenario: a few work
functions rearm themselves with very short, equal times;
before flush_workqueue ends, their timers are already
fired, so cancel_delayed_work has nothing to do.

Maybe this patch could check, if I'm not dreaming...

PS: of course the counter value below is a question of taste

Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>

---

diff -Nurp 2.6.21-rc6-mm1-/kernel/workqueue.c 2.6.21-rc6-mm1/kernel/workqueue.c
--- 2.6.21-rc6-mm1-/kernel/workqueue.c	2007-04-18 20:07:45.000000000 +0200
+++ 2.6.21-rc6-mm1/kernel/workqueue.c	2007-04-18 20:15:44.000000000 +0200
@@ -557,9 +557,12 @@ void cancel_rearming_delayed_work(struct
 	/* Was it ever queued ? */
 	if (cwq != NULL) {
 		struct workqueue_struct *wq = cwq->wq;
+		int i = 1000;
 
-		while (!cancel_delayed_work(dwork))
+		while (!cancel_delayed_work(dwork)) {
 			flush_workqueue(wq);
+			BUG_ON(!i--);
+		}
 	}
 }
 EXPORT_SYMBOL(cancel_rearming_delayed_work);
