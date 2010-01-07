Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049Ab0AVXXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab0AVXXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 18:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568Ab0AVXW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 18:22:28 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:46001 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab0AVXW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 18:22:26 -0500
Message-Id: <47fe27053f07474cb77dc0a53c8f3417d5ea2a7e.1264201406.git.jan.kiszka@web.de>
In-Reply-To: <cover.1264201406.git.jan.kiszka@web.de>
References: <cover.1264201406.git.jan.kiszka@web.de>
From: Jan Kiszka <jan.kiszka@web.de>
To: David Miller <davem@davemloft.net>, Karsten Keil <isdn@linux-pingi.de>
Cc: linux-kernel@vger.kernel.org, i4ldeveloper@listserv.isdn4linux.de,
       isdn4linux@listserv.isdn4linux.de, netdev@vger.kernel.org
Date: Thu, 7 Jan 2010 19:16:09 +0100
Subject: [PATCH 13/31] CAPI: Convert capidev_list_lock into a mutex
X-Provags-ID: V01U2FsdGVkX185/e1sI6EM7NsSpqNPx5uOkGrynTaty81qTB7q
	3MSysQXYvkNoO0zcJQPsnuskWlkyJCAWbfXel5IBG32tNApCM/
	nzDm3zgl8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need for anything "harder" here (specifically no need for
irqsave...). Also, make the list removal the first operation of
capidev_free to avoid dumping half-released devices via /proc.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
---
 drivers/isdn/capi/capi.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index fa18971..2af6c05 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -145,7 +145,7 @@ struct capidev {
 
 /* -------- global variables ---------------------------------------- */
 
-static DEFINE_RWLOCK(capidev_list_lock);
+static DEFINE_MUTEX(capidev_list_lock);
 static LIST_HEAD(capidev_list);
 
 #ifdef CONFIG_ISDN_CAPI_MIDDLEWARE
@@ -405,7 +405,6 @@ static struct capincci *capincci_find(struct capidev *cdev, u32 ncci)
 static struct capidev *capidev_alloc(void)
 {
 	struct capidev *cdev;
-	unsigned long flags;
 
 	cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
 	if (!cdev)
@@ -414,15 +413,19 @@ static struct capidev *capidev_alloc(void)
 	mutex_init(&cdev->ncci_list_mtx);
 	skb_queue_head_init(&cdev->recvqueue);
 	init_waitqueue_head(&cdev->recvwait);
-	write_lock_irqsave(&capidev_list_lock, flags);
+
+	mutex_lock(&capidev_list_lock);
 	list_add_tail(&cdev->list, &capidev_list);
-	write_unlock_irqrestore(&capidev_list_lock, flags);
+	mutex_unlock(&capidev_list_lock);
+
         return cdev;
 }
 
 static void capidev_free(struct capidev *cdev)
 {
-	unsigned long flags;
+	mutex_lock(&capidev_list_lock);
+	list_del(&cdev->list);
+	mutex_unlock(&capidev_list_lock);
 
 	if (cdev->ap.applid) {
 		capi20_release(&cdev->ap);
@@ -434,9 +437,6 @@ static void capidev_free(struct capidev *cdev)
 	capincci_free(cdev, 0xffffffff);
 	mutex_unlock(&cdev->ncci_list_mtx);
 
-	write_lock_irqsave(&capidev_list_lock, flags);
-	list_del(&cdev->list);
-	write_unlock_irqrestore(&capidev_list_lock, flags);
 	kfree(cdev);
 }
 
@@ -1432,7 +1432,7 @@ static int proc_capidev_read_proc(char *page, char **start, off_t off,
 	struct list_head *l;
 	int len = 0;
 
-	read_lock(&capidev_list_lock);
+	mutex_lock(&capidev_list_lock);
 	list_for_each(l, &capidev_list) {
 		cdev = list_entry(l, struct capidev, list);
 		len += sprintf(page+len, "0 %d %lu %lu %lu %lun",
@@ -1451,7 +1451,7 @@ static int proc_capidev_read_proc(char *page, char **start, off_t off,
 	}
 
 endloop:
-	read_unlock(&capidev_list_lock);
+	mutex_unlock(&capidev_list_lock);
 	if (len < count)
 		*eof = 1;
 	if (len > count) len = count;
@@ -1471,7 +1471,7 @@ static int proc_capincci_read_proc(char *page, char **start, off_t off,
 	struct list_head *l;
 	int len = 0;
 
-	read_lock(&capidev_list_lock);
+	mutex_lock(&capidev_list_lock);
 	list_for_each(l, &capidev_list) {
 		cdev = list_entry(l, struct capidev, list);
 		for (np=cdev->nccis; np; np = np->next) {
@@ -1488,7 +1488,7 @@ static int proc_capincci_read_proc(char *page, char **start, off_t off,
 		}
 	}
 endloop:
-	read_unlock(&capidev_list_lock);
+	mutex_unlock(&capidev_list_lock);
 	*start = page+off;
 	if (len < count)
 		*eof = 1;
-- 
1.6.0.2

