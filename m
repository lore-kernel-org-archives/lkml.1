Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbYGVKXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbYGVKXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 06:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbYGVKXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 06:23:38 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:32814 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbYGVKXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 06:23:37 -0400
Date: Tue, 22 Jul 2008 14:27:17 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] workqueues: do CPU_UP_CANCELED if CPU_UP_PREPARE fails
Message-ID: <20080722102717.GB1068@tv-sign.ru>
References: <200807220826.m6M8Q4I6018588@imap1.linux-foundation.org> <20080722084526.GA165@tv-sign.ru> <20080722085938.GA5857@localhost.localdomain> <20080722091636.GA241@tv-sign.ru> <20080722095539.GA6188@localhost.localdomain> <20080722102354.GA1068@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080722102354.GA1068@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(replaces workqueue-proper-error-unwinding-in-cpu-hotplug-error-path.patch)

The bug was pointed out by Akinobu Mita <akinobu.mita@gmail.com>, and this
patch is based on his original patch.

workqueue_cpu_callback(CPU_UP_PREPARE) expects that if it returns NOTIFY_BAD,
_cpu_up() will send CPU_UP_CANCELED then.

However, this is not true since

	"cpu hotplug: cpu: deliver CPU_UP_CANCELED only to NOTIFY_OKed callbacks with CPU_UP_PREPARE"
	commit: a0d8cdb652d35af9319a9e0fb7134de2a276c636

The callback which has returned NOTIFY_BAD will not receive CPU_UP_CANCELED.
Change the code to fulfil the CPU_UP_CANCELED logic if CPU_UP_PREPARE fails.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/workqueue.c~WQ_CPU_UP_PREPARE	2008-07-12 19:40:57.000000000 +0400
+++ 26-rc2/kernel/workqueue.c	2008-07-22 13:43:47.000000000 +0400
@@ -911,6 +911,7 @@ static int __devinit workqueue_cpu_callb
 	unsigned int cpu = (unsigned long)hcpu;
 	struct cpu_workqueue_struct *cwq;
 	struct workqueue_struct *wq;
+	int ret = NOTIFY_OK;
 
 	action &= ~CPU_TASKS_FROZEN;
 
@@ -918,7 +919,7 @@ static int __devinit workqueue_cpu_callb
 	case CPU_UP_PREPARE:
 		cpu_set(cpu, cpu_populated_map);
 	}
-
+undo:
 	list_for_each_entry(wq, &workqueues, list) {
 		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
 
@@ -928,7 +929,9 @@ static int __devinit workqueue_cpu_callb
 				break;
 			printk(KERN_ERR "workqueue [%s] for %i failed\n",
 				wq->name, cpu);
-			return NOTIFY_BAD;
+			action = CPU_UP_CANCELED;
+			ret = NOTIFY_BAD;
+			goto undo;
 
 		case CPU_ONLINE:
 			start_workqueue_thread(cwq, cpu);
@@ -948,7 +951,7 @@ static int __devinit workqueue_cpu_callb
 		cpu_clear(cpu, cpu_populated_map);
 	}
 
-	return NOTIFY_OK;
+	return ret;
 }
 
 void __init init_workqueues(void)

