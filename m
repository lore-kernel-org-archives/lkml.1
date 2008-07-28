Return-Path: <linux-kernel-owner+w=401wt.eu-S1754239AbYG1UmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbYG1UmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbYG1Ull
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:41:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:10814 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbYG1Ulk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:41:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=FC/LBQuOyL2AaIpqjZS00btjYTx/zGQzXqNoaICpRmdxeKfc3rUoR7xr8ZdBGLLPT2
         QljwSZcm0LqgM385FmWDgc6Yekl/cTATosWlt3UoRJ17i0fPLz+PRLl/fmo4lnviCptb
         qTxb2s39SSVN/emb25jSlO3lsMmRbp4Eylg5E=
Subject: [patch, minor]  workqueue: consistently use 'err' in
	__create_workqueue_key()
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 22:41:34 +0200
Message-Id: <1217277694.20627.9.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



I guess error handling is a bit illogical in __create_workqueue_key().
Although, it won't cause any real problems.


---

From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: workqueue: consistently use 'err' in __create_workqueue_key()
    
Fix the logic behind the use of 'err' in the 'for_each_posible_cpu()' loop
of __create_workqueue_key().
    
Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index ec7e4f6..738bf05 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -827,7 +827,8 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 	if (singlethread) {
 		cwq = init_cpu_workqueue(wq, singlethread_cpu);
 		err = create_workqueue_thread(cwq, singlethread_cpu);
-		start_workqueue_thread(cwq, -1);
+		if (!err)
+			start_workqueue_thread(cwq, -1);
 	} else {
 		cpu_maps_update_begin();
 		spin_lock(&workqueue_lock);
@@ -836,9 +837,11 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 
 		for_each_possible_cpu(cpu) {
 			cwq = init_cpu_workqueue(wq, cpu);
-			if (err || !cpu_online(cpu))
+			if (!cpu_online(cpu))
 				continue;
 			err = create_workqueue_thread(cwq, cpu);
+			if (err)
+				break;
 			start_workqueue_thread(cwq, cpu);
 		}
 		cpu_maps_update_done();



