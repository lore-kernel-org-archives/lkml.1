Return-Path: <linux-kernel-owner+w=401wt.eu-S1756418AbYK2K5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbYK2K5s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 05:57:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbYK2K5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 05:57:40 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:26988 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbYK2K5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 05:57:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=suZa1m0welyqvnoGN9clRdB2j738Oqr6RCllGVgGem1kCdqgb5eb/5W4HAXEhcQ+ZN
         KlgVUXRr2EMZUk+senqAAE0NkQnqaHb3sYqc8N8FzcG+qrtlj5bxyv/5Fp8sldJhdcwb
         LbqJ+aMKLs/xBax6poNUgi9oMjXCEkpaQkoug=
Message-ID: <4931201D.7060701@gmail.com>
Date: Sat, 29 Nov 2008 05:57:33 -0500
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: powerpc: hv{cs,si}_close() both unsigned hp->count and hvcsd->open_count
 cannot be negative
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unsigned hp->count and hvcsd->open_count cannot be negative

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Both members of respectively struct hvcs_struct, see
vi drivers/char/hvcs.c +262

and struct hvcs_struct, see
vi drivers/char/hvsi.c +70

diff --git a/drivers/char/hvcs.c b/drivers/char/hvcs.c
index 473d9b1..b228b84 100644
--- a/drivers/char/hvcs.c
+++ b/drivers/char/hvcs.c
@@ -1222,7 +1222,8 @@ static void hvcs_close(struct tty_struct *tty, struct file *filp)
 	hvcsd = tty->driver_data;
 
 	spin_lock_irqsave(&hvcsd->lock, flags);
-	if (--hvcsd->open_count == 0) {
+	if (hvcsd->open_count == 1) {
+		hvcsd->open_count--;
 
 		vio_disable_interrupts(hvcsd->vdev);
 
@@ -1248,7 +1249,9 @@ static void hvcs_close(struct tty_struct *tty, struct file *filp)
 		free_irq(irq, hvcsd);
 		kref_put(&hvcsd->kref, destroy_hvcs_struct);
 		return;
-	} else if (hvcsd->open_count < 0) {
+	} else if (hvcsd->open_count > 1) {
+		hvcsd->open_count--;
+	} else {
 		printk(KERN_ERR "HVCS: vty-server@%X open_count: %d"
 				" is missmanaged.\n",
 		hvcsd->vdev->unit_address, hvcsd->open_count);
diff --git a/drivers/char/hvsi.c b/drivers/char/hvsi.c
index 59c6f9a..d46bccd 100644
--- a/drivers/char/hvsi.c
+++ b/drivers/char/hvsi.c
@@ -875,7 +875,8 @@ static void hvsi_close(struct tty_struct *tty, struct file *filp)
 
 	spin_lock_irqsave(&hp->lock, flags);
 
-	if (--hp->count == 0) {
+	if (hp->count == 1) {
+		hp->count--;
 		hp->tty = NULL;
 		hp->inbuf_end = hp->inbuf; /* discard remaining partial packets */
 
@@ -908,7 +909,9 @@ static void hvsi_close(struct tty_struct *tty, struct file *filp)
 
 			spin_lock_irqsave(&hp->lock, flags);
 		}
-	} else if (hp->count < 0)
+	} else if (hp->count > 1)
+		hp->count--;
+	else
 		printk(KERN_ERR "hvsi_close %lu: oops, count is %d\n",
 		       hp - hvsi_ports, hp->count);
 
