Return-Path: <linux-kernel-owner+w=401wt.eu-S1754321AbZKWHQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbZKWHQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 02:16:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbZKWHQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 02:16:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:55177 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225AbZKWHQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 02:16:22 -0500
Date: Mon, 23 Nov 2009 07:15:48 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, a.p.zijlstra@chello.nl,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] ring-buffer benchmark: Run producer/consumer threads at nice +19
Message-ID: <tip-98e4833ba3c314c99dc364012fba6ac894230ad0@git.kernel.org>
Git-Commit-ID: 98e4833ba3c314c99dc364012fba6ac894230ad0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  98e4833ba3c314c99dc364012fba6ac894230ad0
Gitweb:     http://git.kernel.org/tip/98e4833ba3c314c99dc364012fba6ac894230ad0
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 23 Nov 2009 08:03:09 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Nov 2009 08:03:09 +0100

ring-buffer benchmark: Run producer/consumer threads at nice +19

The ring-buffer benchmark threads run on nice 0 by default, using
up a lot of CPU time and slowing down the system:

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
  1024 root      20   0     0    0    0 D 95.3  0.0   4:01.67 rb_producer
  1023 root      20   0     0    0    0 R 93.5  0.0   2:54.33 rb_consumer
 21569 mingo     40   0 14852 1048  772 R  3.6  0.1   0:00.05 top
     1 root      40   0  4080  928  668 S  0.0  0.0   0:23.98 init

Renice them to +19 to make them less intrusive.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/ring_buffer_benchmark.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index 70df73e..3875d49 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -399,6 +399,12 @@ static int __init ring_buffer_benchmark_init(void)
 	if (IS_ERR(producer))
 		goto out_kill;
 
+	/*
+	 * Run them as low-prio background tasks by default:
+	 */
+	set_user_nice(consumer, 19);
+	set_user_nice(producer, 19);
+
 	return 0;
 
  out_kill:
