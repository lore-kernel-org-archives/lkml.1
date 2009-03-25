Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbZCYJIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbZCYJIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbZCYJIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:08:01 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60228 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753961AbZCYJIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:08:00 -0400
Message-ID: <49C9F416.1050707@cn.fujitsu.com>
Date: Wed, 25 Mar 2009 17:06:30 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, miaoxie <miaox@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] init,cpuset: fix initialize order
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(After these two fixes applied:
[PATCH 1/2] trace_stat: keep original order
[PATCH 2/2] trace_workqueues: fix empty line's output
)
When I read /debugfs/tracing/trace_stat/workqueues,
and the I got this:

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
---------

Subject: [PATCH] init,cpuset: fix initialize order

Impact: cpuset_wq should be initialized after init_workqueues()

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
---
diff --git a/init/main.c b/init/main.c
index 1ce6931..91d5047 100644
--- a/init/main.c
+++ b/init/main.c
@@ -773,6 +773,7 @@ static void __init do_basic_setup(void)
 {
 	rcu_init_sched(); /* needed by module_init stage. */
 	init_workqueues();
+	cpuset_init_smp();
 	usermodehelper_init();
 	driver_init();
 	init_irq_proc();
@@ -869,8 +870,6 @@ static int __init kernel_init(void * unused)
 	smp_init();
 	sched_init_smp();
 
-	cpuset_init_smp();
-
 	do_basic_setup();
 
 	/*


