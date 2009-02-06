Return-Path: <linux-kernel-owner+w=401wt.eu-S1756258AbZBFSuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258AbZBFSuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 13:50:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbZBFSuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 13:50:10 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:33935 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbZBFSuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 13:50:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=obDjugSPt/Mr5nj9CdQoGiyLgq2BjAO3g+ja36x6OE59zuZHMFKhvrB1B7+BB0uy00
         NNf7jBaKTi5RBR0mbXP2p/xVHyg5bV7MvKKLUeCjHWb03SHgwKpbWImtlmZVzMXnnpSq
         9VqnFFkv6NWt6fhSn4B2u/lil9+P5b3G+ay58=
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: linux-kernel@vger.kernel.org, Bert Wesarg <bert.wesarg@googlemail.com>
Subject: [urcu PATCH] test_urcu.c: use gettid()
Date: Fri,  6 Feb 2009 19:49:57 +0100
Message-Id: <1233946197-32046-1-git-send-email-bert.wesarg@googlemail.com>
X-Mailer: git-send-email 1.6.1.rc4
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's probably better to print the tid for each thread, not the pid.

Signed-off-by: Bert Wesarg <bert.wesarg@googlemail.com>

---
 test_urcu.c |   28 ++++++++++++++++++++++++----
 1 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/test_urcu.c b/test_urcu.c
index db0b68c..ea5a784 100644
--- a/test_urcu.c
+++ b/test_urcu.c
@@ -17,6 +17,23 @@
 #include <unistd.h>
 #include <stdio.h>
 #include <assert.h>
+#include <sys/syscall.h>
+
+#if defined(_syscall0)
+_syscall0(pid_t, gettid)
+#elif defined(__NR_gettid)
+static inline pid_t gettid(void)
+{
+	return syscall(__NR_gettid);
+}
+#else
+#warning "use pid as tid"
+static inline pid_t gettid(void)
+{
+	return getpid();
+}
+#endif
+
 #include "urcu.h"
 
 struct test_array {
@@ -36,8 +53,8 @@ void *thr_reader(void *arg)
 	int qparity, i, j;
 	struct test_array *local_ptr;
 
-	printf("thread %s, thread id : %lu, pid %lu\n",
-			"reader", pthread_self(), (unsigned long)getpid());
+	printf("thread %s, thread id : %lx, tid %lu\n",
+			"reader", pthread_self(), (unsigned long)gettid());
 	sleep(2);
 
 	urcu_register_thread();
@@ -66,8 +83,8 @@ void *thr_writer(void *arg)
 	int i;
 	struct test_array *new, *old;
 
-	printf("thread %s, thread id : %lu, pid %lu\n",
-			"writer", pthread_self(), (unsigned long)getpid());
+	printf("thread %s, thread id : %lx, tid %lu\n",
+			"writer", pthread_self(), (unsigned long)gettid());
 	sleep(2);
 
 	for (i = 0; i < 10000000; i++) {
@@ -104,6 +121,9 @@ int main()
 	void *tret;
 	int i;
 
+	printf("thread %-6s, thread id : %lx, tid %lu\n",
+			"main", pthread_self(), (unsigned long)gettid());
+
 	for (i = 0; i < NR_READ; i++) {
 		err = pthread_create(&tid_reader[i], NULL, thr_reader, NULL);
 		if (err != 0)
-- 
tg: (24316d1..) bw/use-gettid (depends on: master)
