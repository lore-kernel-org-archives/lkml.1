Return-Path: <linux-kernel-owner+w=401wt.eu-S2993195AbXDSIGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993195AbXDSIGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 04:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993189AbXDSIFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 04:05:25 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45818 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993168AbXDSIEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 04:04:41 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       David Howells <dhowells@redhat.com>
Subject: [PATCH] synchro_test: Convert to the kthread API.
Date: Thu, 19 Apr 2007 01:59:06 -0600
Message-Id: <11769696422937-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.5.1.1.g2de0
In-Reply-To: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/synchro-test.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/kernel/synchro-test.c b/kernel/synchro-test.c
index a4747a6..b1d7fd6 100644
--- a/kernel/synchro-test.c
+++ b/kernel/synchro-test.c
@@ -30,6 +30,7 @@
 #include <linux/timer.h>
 #include <linux/completion.h>
 #include <linux/mutex.h>
+#include <linux/kthread.h>
 
 #define MAX_THREADS 64
 
@@ -224,7 +225,6 @@ static int mutexer(void *arg)
 {
 	unsigned int N = (unsigned long) arg;
 
-	daemonize("Mutex%u", N);
 	set_user_nice(current, 19);
 
 	while (atomic_read(&do_stuff)) {
@@ -246,7 +246,6 @@ static int semaphorer(void *arg)
 {
 	unsigned int N = (unsigned long) arg;
 
-	daemonize("Sem%u", N);
 	set_user_nice(current, 19);
 
 	while (atomic_read(&do_stuff)) {
@@ -268,7 +267,6 @@ static int reader(void *arg)
 {
 	unsigned int N = (unsigned long) arg;
 
-	daemonize("Read%u", N);
 	set_user_nice(current, 19);
 
 	while (atomic_read(&do_stuff)) {
@@ -292,7 +290,6 @@ static int writer(void *arg)
 {
 	unsigned int N = (unsigned long) arg;
 
-	daemonize("Write%u", N);
 	set_user_nice(current, 19);
 
 	while (atomic_read(&do_stuff)) {
@@ -316,7 +313,6 @@ static int downgrader(void *arg)
 {
 	unsigned int N = (unsigned long) arg;
 
-	daemonize("Down%u", N);
 	set_user_nice(current, 19);
 
 	while (atomic_read(&do_stuff)) {
@@ -433,27 +429,27 @@ static int __init do_tests(void)
 	for (loop = 0; loop < MAX_THREADS; loop++) {
 		if (loop < nummx) {
 			init_completion(&mx_comp[loop]);
-			kernel_thread(mutexer, (void *) loop, 0);
+			kthread_run(mutexer, (void *) loop, "Mutex%u", loop);
 		}
 
 		if (loop < numsm) {
 			init_completion(&sm_comp[loop]);
-			kernel_thread(semaphorer, (void *) loop, 0);
+			kthread_run(semaphorer, (void *) loop, "Sem%u", loop);
 		}
 
 		if (loop < numrd) {
 			init_completion(&rd_comp[loop]);
-			kernel_thread(reader, (void *) loop, 0);
+			kthread_run(reader, (void *) loop, "Read%u", loop);
 		}
 
 		if (loop < numwr) {
 			init_completion(&wr_comp[loop]);
-			kernel_thread(writer, (void *) loop, 0);
+			kthread_run(writer, (void *) loop, "Write%u", loop);
 		}
 
 		if (loop < numdg) {
 			init_completion(&dg_comp[loop]);
-			kernel_thread(downgrader, (void *) loop, 0);
+			kthread_run(downgrader, (void *) loop, "Down%u", loop);
 		}
 	}
 
-- 
1.5.0.g53756

