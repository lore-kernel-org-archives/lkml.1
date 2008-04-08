Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbYDHLXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbYDHLXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbYDHLT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:19:29 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:23292 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993AbYDHLT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:19:26 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 15/29] usb: use non-racy method for proc entries creation
Date: Tue,  8 Apr 2008 15:19:22 +0400
Message-Id: <1207653576-12640-15-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1207653508.7171.18.camel@iris.sw.ru>
References: <1207653508.7171.18.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proc_create()/proc_create_data() to make sure that ->proc_fops and
->data be setup before gluing PDE to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/gadget/at91_udc.c |   11 ++---------
 drivers/usb/gadget/omap_udc.c |    7 ++-----
 drivers/usb/host/sl811-hcd.c  |   10 +---------
 3 files changed, 5 insertions(+), 23 deletions(-)

diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index 6ba0ca5..3fdff1e 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -231,6 +231,7 @@ static int proc_udc_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations proc_ops = {
+	.owner		= THIS_MODULE,
 	.open		= proc_udc_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -239,15 +240,7 @@ static const struct file_operations proc_ops = {
 
 static void create_debug_file(struct at91_udc *udc)
 {
-	struct proc_dir_entry *pde;
-
-	pde = create_proc_entry (debug_filename, 0, NULL);
-	udc->pde = pde;
-	if (pde == NULL)
-		return;
-
-	pde->proc_fops = &proc_ops;
-	pde->data = udc;
+	udc->pde = proc_create_data(debug_filename, 0, NULL, &proc_ops, udc);
 }
 
 static void remove_debug_file(struct at91_udc *udc)
diff --git a/drivers/usb/gadget/omap_udc.c b/drivers/usb/gadget/omap_udc.c
index 49de9d7..ab0d5eb 100644
--- a/drivers/usb/gadget/omap_udc.c
+++ b/drivers/usb/gadget/omap_udc.c
@@ -2504,6 +2504,7 @@ static int proc_udc_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations proc_ops = {
+	.owner		= THIS_MODULE,
 	.open		= proc_udc_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -2512,11 +2513,7 @@ static const struct file_operations proc_ops = {
 
 static void create_proc_file(void)
 {
-	struct proc_dir_entry *pde;
-
-	pde = create_proc_entry (proc_filename, 0, NULL);
-	if (pde)
-		pde->proc_fops = &proc_ops;
+	proc_create(proc_filename, 0, NULL, &proc_ops);
 }
 
 static void remove_proc_file(void)
diff --git a/drivers/usb/host/sl811-hcd.c b/drivers/usb/host/sl811-hcd.c
index ec349d4..7397d37 100644
--- a/drivers/usb/host/sl811-hcd.c
+++ b/drivers/usb/host/sl811-hcd.c
@@ -1505,15 +1505,7 @@ static const char proc_filename[] = "driver/sl811h";
 
 static void create_debug_file(struct sl811 *sl811)
 {
-	struct proc_dir_entry *pde;
-
-	pde = create_proc_entry(proc_filename, 0, NULL);
-	if (pde == NULL)
-		return;
-
-	pde->proc_fops = &proc_ops;
-	pde->data = sl811;
-	sl811->pde = pde;
+	sl811->pde = proc_create_data(proc_filename, 0, NULL, &proc_ops, sl811);
 }
 
 static void remove_debug_file(struct sl811 *sl811)
-- 
1.5.3.rc5

