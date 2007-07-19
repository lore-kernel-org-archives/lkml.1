Return-Path: <linux-kernel-owner+w=401wt.eu-S938337AbXGSOzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938337AbXGSOzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757870AbXGSOzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 10:55:45 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:44280 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755058AbXGSOzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 10:55:44 -0400
Message-ID: <469F7B4C.5050502@openvz.org>
Date: Thu, 19 Jul 2007 18:55:08 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: devel@openvz.org
Subject: [PATCH] Cleanup elevator_ops->trim function
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The elevator_ops's member "trim" is declared and called not like
all the other ones. Was this deliberate?

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

 block/as-iosched.c       |    2 +-
 block/cfq-iosched.c      |    2 +-
 block/elevator.c         |    4 ++--
 include/linux/elevator.h |    3 ++-
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/block/as-iosched.c b/block/as-iosched.c
index 3e316dd..add524c 100644
--- a/block/as-iosched.c
+++ b/block/as-iosched.c
@@ -1451,7 +1451,7 @@ static struct elevator_type iosched_as =
 		.elevator_may_queue_fn =	as_may_queue,
 		.elevator_init_fn =		as_init_queue,
 		.elevator_exit_fn =		as_exit_queue,
-		.trim =				as_trim,
+		.elevator_trim_fn =		as_trim,
 	},
 
 	.elevator_attrs = as_attrs,
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 9755a3c..5ee8c39 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2237,7 +2237,7 @@ static struct elevator_type iosched_cfq 
 		.elevator_may_queue_fn =	cfq_may_queue,
 		.elevator_init_fn =		cfq_init_queue,
 		.elevator_exit_fn =		cfq_exit_queue,
-		.trim =				cfq_free_io_context,
+		.elevator_trim_fn =		cfq_free_io_context,
 	},
 	.elevator_attrs =	cfq_attrs,
 	.elevator_name =	"cfq",
diff --git a/block/elevator.c b/block/elevator.c
index d265963..ae7601f 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -983,12 +983,12 @@ void elv_unregister(struct elevator_type
 	/*
 	 * Iterate every thread in the process to remove the io contexts.
 	 */
-	if (e->ops.trim) {
+	if (e->ops.elevator_trim_fn) {
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
 			task_lock(p);
 			if (p->io_context)
-				e->ops.trim(p->io_context);
+				e->ops.elevator_trim_fn(p->io_context);
 			task_unlock(p);
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index e88fcbc..896831a 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -29,6 +29,7 @@ typedef void (elevator_deactivate_req_fn
 
 typedef void *(elevator_init_fn) (request_queue_t *);
 typedef void (elevator_exit_fn) (elevator_t *);
+typedef void (elevator_trim_fn) (struct io_context *);
 
 struct elevator_ops
 {
@@ -55,7 +56,7 @@ struct elevator_ops
 
 	elevator_init_fn *elevator_init_fn;
 	elevator_exit_fn *elevator_exit_fn;
-	void (*trim)(struct io_context *);
+	elevator_trim_fn *elevator_trim_fn;
 };
 
 #define ELV_NAME_MAX	(16)
