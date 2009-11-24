Return-Path: <linux-kernel-owner+w=401wt.eu-S933339AbZKXPIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339AbZKXPIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933295AbZKXPHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:07:54 -0500
Received: from relay2.sgi.com ([192.48.179.30]:45506 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933243AbZKXPHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:07:47 -0500
Message-Id: <20091124150753.925553000@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 24 Nov 2009 09:06:10 -0600
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 13/29] GRU - Add test for gru_copy_gpa
References: <20091124150557.082648000@sgi.com>
Content-Disposition: inline; filename=uv_gru_add_ktest_for_copy_gpa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Improve existing driver self-tests. Add a new debugging test to the SGI GRU driver
for verifying the global GRU copy function.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grukservices.c |   48 +++++++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 9 deletions(-)

Index: linux/drivers/misc/sgi-gru/grukservices.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grukservices.c	2009-11-20 09:32:29.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grukservices.c	2009-11-20 09:32:32.000000000 -0600
@@ -1004,6 +1004,7 @@ static int quicktest2(unsigned long arg)
 	int ret = 0;
 	unsigned long *buf;
 	void *cb0, *cb;
+	struct gru_control_block_status *gen;
 	int i, k, istatus, bytes;
 
 	bytes = numcb * 4 * 8;
@@ -1023,20 +1024,30 @@ static int quicktest2(unsigned long arg)
 				XTYPE_DW, 4, 1, IMA_INTERRUPT);
 
 	ret = 0;
-	for (k = 0; k < numcb; k++) {
+	k = numcb;
+	do {
 		gru_wait_async_cbr(han);
 		for (i = 0; i < numcb; i++) {
 			cb = cb0 + i * GRU_HANDLE_STRIDE;
 			istatus = gru_check_status(cb);
-			if (istatus == CBS_ACTIVE)
-				continue;
-			if (istatus == CBS_EXCEPTION)
-				ret = -EFAULT;
-			else if (buf[i] || buf[i + 1] || buf[i + 2] ||
-					buf[i + 3])
-				ret = -EIO;
+			if (istatus != CBS_ACTIVE && istatus != CBS_CALL_OS)
+				break;
 		}
-	}
+		if (i == numcb)
+			continue;
+		if (istatus != CBS_IDLE) {
+			printk(KERN_DEBUG "GRU:%d quicktest2: cb %d, exception\n", smp_processor_id(), i);
+			ret = -EFAULT;
+		} else if (buf[4 * i] || buf[4 * i + 1] || buf[4 * i + 2] ||
+				buf[4 * i + 3]) {
+			printk(KERN_DEBUG "GRU:%d quicktest2:cb %d,  buf 0x%lx, 0x%lx, 0x%lx, 0x%lx\n",
+			       smp_processor_id(), i, buf[4 * i], buf[4 * i + 1], buf[4 * i + 2], buf[4 * i + 3]);
+			ret = -EIO;
+		}
+		k--;
+		gen = cb;
+		gen->istatus = CBS_CALL_OS; /* don't handle this CBR again */
+	} while (k);
 	BUG_ON(cmp.done);
 
 	gru_unlock_async_resource(han);
@@ -1046,6 +1057,22 @@ done:
 	return ret;
 }
 
+#define BUFSIZE 200
+static int quicktest3(unsigned long arg)
+{
+	char buf1[BUFSIZE], buf2[BUFSIZE];
+	int ret = 0;
+
+	memset(buf2, 0, sizeof(buf2));
+	memset(buf1, get_cycles() & 255, sizeof(buf1));
+	gru_copy_gpa(uv_gpa(buf2), uv_gpa(buf1), BUFSIZE);
+	if (memcmp(buf1, buf2, BUFSIZE)) {
+		printk(KERN_DEBUG "GRU quicktest3 error\n");
+		ret = -EIO;
+	}
+	return ret;
+}
+
 /*
  * Debugging only. User hook for various kernel tests
  * of driver & gru.
@@ -1064,6 +1091,9 @@ int gru_ktest(unsigned long arg)
 	case 2:
 		ret = quicktest2(arg);
 		break;
+	case 3:
+		ret = quicktest3(arg);
+		break;
 	case 99:
 		ret = gru_free_kernel_contexts();
 		break;

