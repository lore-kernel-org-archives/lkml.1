Return-Path: <linux-kernel-owner+w=401wt.eu-S1756498AbXLLRrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbXLLRrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 12:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbXLLRrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 12:47:12 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:48900 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751892AbXLLRrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 12:47:11 -0500
Date: Wed, 12 Dec 2007 18:47:11 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] let elv_register() return void
Message-ID: <20071212174711.GC10069@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

elv_register() always returns 0, and there isn't anything it does where 
it should return an error (the only error condition is so grave that 
it's handled with a BUG_ON).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 block/as-iosched.c       |    4 +++-
 block/cfq-iosched.c      |    8 ++------
 block/deadline-iosched.c |    4 +++-
 block/elevator.c         |    3 +--
 block/noop-iosched.c     |    4 +++-
 include/linux/elevator.h |    2 +-
 6 files changed, 13 insertions(+), 12 deletions(-)

9db70d828b748473c55e2b8f61f993feebd7144e 
diff --git a/block/as-iosched.c b/block/as-iosched.c
index dc715a5..46f56ce 100644
--- a/block/as-iosched.c
+++ b/block/as-iosched.c
@@ -1463,7 +1463,9 @@ static struct elevator_type iosched_as = {
 
 static int __init as_init(void)
 {
-	return elv_register(&iosched_as);
+	elv_register(&iosched_as);
+
+	return 0;
 }
 
 static void __exit as_exit(void)
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 0b4a479..13553e0 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2279,8 +2279,6 @@ static struct elevator_type iosched_cfq = {
 
 static int __init cfq_init(void)
 {
-	int ret;
-
 	/*
 	 * could be 0 on HZ < 1000 setups
 	 */
@@ -2292,11 +2290,9 @@ static int __init cfq_init(void)
 	if (cfq_slab_setup())
 		return -ENOMEM;
 
-	ret = elv_register(&iosched_cfq);
-	if (ret)
-		cfq_slab_kill();
+	elv_register(&iosched_cfq);
 
-	return ret;
+	return 0;
 }
 
 static void __exit cfq_exit(void)
diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index a054eef..342448c 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -467,7 +467,9 @@ static struct elevator_type iosched_deadline = {
 
 static int __init deadline_init(void)
 {
-	return elv_register(&iosched_deadline);
+	elv_register(&iosched_deadline);
+
+	return 0;
 }
 
 static void __exit deadline_exit(void)
diff --git a/block/elevator.c b/block/elevator.c
index 446aea2..e452deb 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -960,7 +960,7 @@ void elv_unregister_queue(struct request_queue *q)
 		__elv_unregister_queue(q->elevator);
 }
 
-int elv_register(struct elevator_type *e)
+void elv_register(struct elevator_type *e)
 {
 	char *def = "";
 
@@ -975,7 +975,6 @@ int elv_register(struct elevator_type *e)
 				def = " (default)";
 
 	printk(KERN_INFO "io scheduler %s registered%s\n", e->elevator_name, def);
-	return 0;
 }
 EXPORT_SYMBOL_GPL(elv_register);
 
diff --git a/block/noop-iosched.c b/block/noop-iosched.c
index 7563d8a..c23e029 100644
--- a/block/noop-iosched.c
+++ b/block/noop-iosched.c
@@ -101,7 +101,9 @@ static struct elevator_type elevator_noop = {
 
 static int __init noop_init(void)
 {
-	return elv_register(&elevator_noop);
+	elv_register(&elevator_noop);
+
+	return 0;
 }
 
 static void __exit noop_exit(void)
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index e8f4213..639624b 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -119,7 +119,7 @@ extern void elv_put_request(struct request_queue *, struct request *);
 /*
  * io scheduler registration
  */
-extern int elv_register(struct elevator_type *);
+extern void elv_register(struct elevator_type *);
 extern void elv_unregister(struct elevator_type *);
 
 /*

