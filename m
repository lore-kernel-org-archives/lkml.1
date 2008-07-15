Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbYGOIMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbYGOIMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 04:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbYGOIMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 04:12:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:44121 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbYGOIMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 04:12:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=KxAthOUjag+Crsx3tLrtct3YfSr00AbbzcqsKpmMWYiwwo52TDnFQJIiiav065b5Ga
         p1Zx6DbRWm2a+cCHgraOFtnPTkOMxZi0MOUwMxzzw6HwRaCg6kalFr8mz5y9RT0Ehm2T
         i6vBEUotTgX1g6kUTOvHH3wRg4KRIDKCUJDxw=
Date: Tue, 15 Jul 2008 17:12:10 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] workqueue: proper error unwinding in cpu hotplug error path
Message-ID: <20080715081210.GC22068@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add proper error unwinding in error path in CPU_UP_PREPARE notifier.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 kernel/workqueue.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: 2.6-mmotm/kernel/workqueue.c
===================================================================
--- 2.6-mmotm.orig/kernel/workqueue.c
+++ 2.6-mmotm/kernel/workqueue.c
@@ -928,6 +928,15 @@ static int __devinit workqueue_cpu_callb
 				break;
 			printk(KERN_ERR "workqueue [%s] for %i failed\n",
 				wq->name, cpu);
+
+			list_for_each_entry_continue_reverse(wq, &workqueues,
+							list) {
+				cwq = per_cpu_ptr(wq->cpu_wq, cpu);
+				start_workqueue_thread(cwq, -1);
+				cleanup_workqueue_thread(cwq);
+			}
+			cpu_clear(cpu, cpu_populated_map);
+
 			return NOTIFY_BAD;
 
 		case CPU_ONLINE:
