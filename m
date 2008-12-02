Return-Path: <linux-kernel-owner+w=401wt.eu-S1753163AbYLBK46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbYLBK46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 05:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbYLBK4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 05:56:36 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:51098 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbYLBK4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 05:56:35 -0500
From: Rodolfo Giometti <giometti@linux.it>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Rodolfo Giometti <giometti@linux.it>
Date: Tue,  2 Dec 2008 11:56:07 +0100
Message-Id: <1228215367-22479-2-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1228215367-22479-1-git-send-email-giometti@linux.it>
References: <20081201103741.f70cb84c.akpm@linux-foundation.org>
 <1228215367-22479-1-git-send-email-giometti@linux.it>
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH] pps ldisc: avoid noisy compilation on 64bits architecture.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix things like these:

drivers/pps/clients/pps-ldisc.c: In function 'pps_tty_dcd_change':
drivers/pps/clients/pps-ldisc.c:32: warning: cast from pointer to integer of different size

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 drivers/pps/clients/pps-ldisc.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/pps/clients/pps-ldisc.c b/drivers/pps/clients/pps-ldisc.c
index 234867b..f16396b 100644
--- a/drivers/pps/clients/pps-ldisc.c
+++ b/drivers/pps/clients/pps-ldisc.c
@@ -29,7 +29,7 @@
 static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int status,
 				struct timespec *ts)
 {
-	int id = (int) tty->disc_data;
+	long id = (long) tty->disc_data;
 	struct timespec __ts;
 	struct pps_ktime pps_ts;
 
@@ -50,7 +50,7 @@ static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int status,
 			NULL);
 
 	pr_debug("PPS %s at %lu on source #%d\n",
-			status ? "assert" : "clear", jiffies, id);
+			status ? "assert" : "clear", jiffies, (int) id);
 }
 
 static int pps_tty_open(struct tty_struct *tty)
@@ -58,7 +58,7 @@ static int pps_tty_open(struct tty_struct *tty)
 	struct pps_source_info info;
 	struct tty_driver *drv = tty->driver;
 	int index = tty->index + drv->name_base;
-	int ret;
+	long ret;
 
 	info.owner = THIS_MODULE;
 	info.dev = NULL;
@@ -79,21 +79,21 @@ static int pps_tty_open(struct tty_struct *tty)
 	/* Should open N_TTY ldisc too */
 	ret = n_tty_open(tty);
 	if (ret < 0)
-		pps_unregister_source((int) tty->disc_data);
+		pps_unregister_source((long) tty->disc_data);
 
-	pr_info("PPS source #%d \"%s\" added\n", ret, info.path);
+	pr_info("PPS source #%d \"%s\" added\n", (int) ret, info.path);
 
 	return 0;
 }
 
 static void pps_tty_close(struct tty_struct *tty)
 {
-	int id = (int) tty->disc_data;
+	long id = (long) tty->disc_data;
 
 	pps_unregister_source(id);
 	n_tty_close(tty);
 
-	pr_info("PPS source #%d removed\n", id);
+	pr_info("PPS source #%d removed\n", (int) id);
 }
 
 struct tty_ldisc_ops pps_ldisc_ops = {
-- 
1.5.3.8

