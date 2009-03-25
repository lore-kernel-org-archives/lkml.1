Return-Path: <linux-kernel-owner+w=401wt.eu-S1763546AbZCYRg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763546AbZCYRg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763582AbZCYRfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:35:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:54408 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763573AbZCYRfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:35:45 -0400
Date: Wed, 25 Mar 2009 17:33:53 GMT
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, menage@google.com, fweisbec@gmail.com,
       akpm@linux-foundation.org, srostedt@redhat.com, tglx@linutronix.de,
       miaox@cn.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, menage@google.com, fweisbec@gmail.com,
       akpm@linux-foundation.org, srostedt@redhat.com, tglx@linutronix.de,
       miaox@cn.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <49C9F416.1050707@cn.fujitsu.com>
References: <49C9F416.1050707@cn.fujitsu.com>
Subject: [tip:tracing/ftrace] init,cpuset: fix initialize order
Message-ID: <tip-759ee0915dd713361e72facb78b66600b5712d65@git.kernel.org>
Git-Commit-ID: 759ee0915dd713361e72facb78b66600b5712d65
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 17:33:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  759ee0915dd713361e72facb78b66600b5712d65
Gitweb:     http://git.kernel.org/tip/759ee0915dd713361e72facb78b66600b5712d65
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Wed, 25 Mar 2009 17:06:30 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 18:32:35 +0100

init,cpuset: fix initialize order

Impact: cpuset_wq should be initialized after init_workqueues()

When I read /debugfs/tracing/trace_stat/workqueues,
I got this:

 # CPU  INSERTED  EXECUTED   NAME
 # |      |         |          |

   0      0          0       cpuset
   0    285        285       events/0
   0      2          2       work_on_cpu/0
   0   1115       1115       khelper
   0    325        325       kblockd/0
   0      0          0       kacpid
   0      0          0       kacpi_notify
   0      0          0       ata/0
   0      0          0       ata_aux
   0      0          0       ksuspend_usbd
   0      0          0       aio/0
   0      0          0       nfsiod
   0      0          0       kpsmoused
   0      0          0       kstriped
   0      0          0       kondemand/0
   0      1          1       hid_compat
   0      0          0       rpciod/0

   1     64         64       events/1
   1      2          2       work_on_cpu/1
   1      5          5       kblockd/1
   1      0          0       ata/1
   1      0          0       aio/1
   1      0          0       kondemand/1
   1      0          0       rpciod/1

I found "cpuset" is at the earliest.

I found a create_singlethread_workqueue() is earlier than
init_workqueues():

kernel_init()
->cpuset_init_smp()
  ->create_singlethread_workqueue()
->do_basic_setup()
  ->init_workqueues()

I think it's better that create_singlethread_workqueue() is called
after workqueue subsystem has been initialized.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Steven Rostedt <srostedt@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Menage <menage@google.com>
Cc: miaoxie <miaox@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <49C9F416.1050707@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 init/main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index 20d784a..b0097d2 100644
--- a/init/main.c
+++ b/init/main.c
@@ -772,6 +772,7 @@ static void __init do_basic_setup(void)
 {
 	rcu_init_sched(); /* needed by module_init stage. */
 	init_workqueues();
+	cpuset_init_smp();
 	usermodehelper_init();
 	driver_init();
 	init_irq_proc();
@@ -865,8 +866,6 @@ static int __init kernel_init(void * unused)
 	smp_init();
 	sched_init_smp();
 
-	cpuset_init_smp();
-
 	do_basic_setup();
 
 	/*
