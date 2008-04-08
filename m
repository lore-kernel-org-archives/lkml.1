Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbYDHLYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbYDHLYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbYDHLTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:19:31 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:31980 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953AbYDHLT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:19:27 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 25/29] isdn: use non-racy method for proc entries creation
Date: Tue,  8 Apr 2008 15:19:32 +0400
Message-Id: <1207653576-12640-25-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1207653508.7171.18.camel@iris.sw.ru>
References: <1207653508.7171.18.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proc_create()/proc_create_data() to make sure that ->proc_fops and
->data be setup before gluing PDE to main tree.

Add correct ->owner to proc_fops to fix reading/module unloading race.

Signed-off-by: Denis V. Lunev <den@openvz.org>
CC: Karsten Keil <kkeil@suse.de>
CC: isdn4linux@listserv.isdn4linux.de
---
 drivers/isdn/capi/kcapi_proc.c          |   24 ++++++++++--------------
 drivers/isdn/divert/divert_procfs.c     |    5 ++---
 drivers/isdn/hardware/eicon/divasproc.c |    8 ++------
 drivers/isdn/hysdn/hysdn_procconf.c     |    9 ++++-----
 drivers/isdn/hysdn/hysdn_proclog.c      |    8 ++++----
 5 files changed, 22 insertions(+), 32 deletions(-)

diff --git a/drivers/isdn/capi/kcapi_proc.c b/drivers/isdn/capi/kcapi_proc.c
index 845a797..c29208b 100644
--- a/drivers/isdn/capi/kcapi_proc.c
+++ b/drivers/isdn/capi/kcapi_proc.c
@@ -114,6 +114,7 @@ static int seq_contrstats_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations proc_controller_ops = {
+	.owner		= THIS_MODULE,
 	.open		= seq_controller_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -121,6 +122,7 @@ static const struct file_operations proc_controller_ops = {
 };
 
 static const struct file_operations proc_contrstats_ops = {
+	.owner		= THIS_MODULE,
 	.open		= seq_contrstats_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -219,6 +221,7 @@ seq_applstats_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations proc_applications_ops = {
+	.owner		= THIS_MODULE,
 	.open		= seq_applications_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -226,21 +229,13 @@ static const struct file_operations proc_applications_ops = {
 };
 
 static const struct file_operations proc_applstats_ops = {
+	.owner		= THIS_MODULE,
 	.open		= seq_applstats_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= seq_release,
 };
 
-static void
-create_seq_entry(char *name, mode_t mode, const struct file_operations *f)
-{
-	struct proc_dir_entry *entry;
-	entry = create_proc_entry(name, mode, NULL);
-	if (entry)
-		entry->proc_fops = f;
-}
-
 // ---------------------------------------------------------------------------
 
 static void *capi_driver_start(struct seq_file *seq, loff_t *pos)
@@ -283,6 +278,7 @@ seq_capi_driver_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations proc_driver_ops = {
+	.owner		= THIS_MODULE,
 	.open		= seq_capi_driver_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -296,11 +292,11 @@ kcapi_proc_init(void)
 {
 	proc_mkdir("capi",             NULL);
 	proc_mkdir("capi/controllers", NULL);
-	create_seq_entry("capi/controller",   0, &proc_controller_ops);
-	create_seq_entry("capi/contrstats",   0, &proc_contrstats_ops);
-	create_seq_entry("capi/applications", 0, &proc_applications_ops);
-	create_seq_entry("capi/applstats",    0, &proc_applstats_ops);
-	create_seq_entry("capi/driver",       0, &proc_driver_ops);
+	proc_create("capi/controller",   0, NULL, &proc_controller_ops);
+	proc_create("capi/contrstats",   0, NULL, &proc_contrstats_ops);
+	proc_create("capi/applications", 0, NULL, &proc_applications_ops);
+	proc_create("capi/applstats",    0, NULL, &proc_applstats_ops);
+	proc_create("capi/driver",       0, NULL, &proc_driver_ops);
 }
 
 void __exit
diff --git a/drivers/isdn/divert/divert_procfs.c b/drivers/isdn/divert/divert_procfs.c
index 4fd4c46..8b256a6 100644
--- a/drivers/isdn/divert/divert_procfs.c
+++ b/drivers/isdn/divert/divert_procfs.c
@@ -288,13 +288,12 @@ divert_dev_init(void)
 	isdn_proc_entry = proc_mkdir("isdn", init_net.proc_net);
 	if (!isdn_proc_entry)
 		return (-1);
-	isdn_divert_entry = create_proc_entry("divert", S_IFREG | S_IRUGO, isdn_proc_entry);
+	isdn_divert_entry = proc_create("divert", S_IFREG | S_IRUGO,
+					isdn_proc_entry, &isdn_fops);
 	if (!isdn_divert_entry) {
 		remove_proc_entry("isdn", init_net.proc_net);
 		return (-1);
 	}
-	isdn_divert_entry->proc_fops = &isdn_fops; 
-	isdn_divert_entry->owner = THIS_MODULE; 
 #endif	/* CONFIG_PROC_FS */
 
 	return (0);
diff --git a/drivers/isdn/hardware/eicon/divasproc.c b/drivers/isdn/hardware/eicon/divasproc.c
index 0632a26..fae8958 100644
--- a/drivers/isdn/hardware/eicon/divasproc.c
+++ b/drivers/isdn/hardware/eicon/divasproc.c
@@ -125,15 +125,11 @@ static const struct file_operations divas_fops = {
 
 int create_divas_proc(void)
 {
-	divas_proc_entry = create_proc_entry(divas_proc_name,
-					     S_IFREG | S_IRUGO,
-					     proc_net_eicon);
+	proc_create(divas_proc_name, S_IFREG | S_IRUGO, proc_net_eicon,
+		    &divas_fops);
 	if (!divas_proc_entry)
 		return (0);
 
-	divas_proc_entry->proc_fops = &divas_fops;
-	divas_proc_entry->owner = THIS_MODULE;
-
 	return (1);
 }
 
diff --git a/drivers/isdn/hysdn/hysdn_procconf.c b/drivers/isdn/hysdn/hysdn_procconf.c
index 27d890b..877be99 100644
--- a/drivers/isdn/hysdn/hysdn_procconf.c
+++ b/drivers/isdn/hysdn/hysdn_procconf.c
@@ -370,6 +370,7 @@ hysdn_conf_close(struct inode *ino, struct file *filep)
 /******************************************************/
 static const struct file_operations conf_fops =
 {
+	.owner		= THIS_MODULE,
 	.llseek         = no_llseek,
 	.read           = hysdn_conf_read,
 	.write          = hysdn_conf_write,
@@ -402,11 +403,9 @@ hysdn_procconf_init(void)
 	while (card) {
 
 		sprintf(conf_name, "%s%d", PROC_CONF_BASENAME, card->myid);
-		if ((card->procconf = (void *) create_proc_entry(conf_name,
-					     S_IFREG | S_IRUGO | S_IWUSR,
-					    hysdn_proc_entry)) != NULL) {
-			((struct proc_dir_entry *) card->procconf)->proc_fops = &conf_fops;
-			((struct proc_dir_entry *) card->procconf)->owner = THIS_MODULE;
+		if ((card->procconf = (void *) proc_create(conf_name,
+						S_IFREG | S_IRUGO | S_IWUSR,
+						hysdn_proc_entry)) != NULL) {
 			hysdn_proclog_init(card);	/* init the log file entry */
 		}
 		card = card->next;	/* next entry */
diff --git a/drivers/isdn/hysdn/hysdn_proclog.c b/drivers/isdn/hysdn/hysdn_proclog.c
index 27b3991..8991d2c 100644
--- a/drivers/isdn/hysdn/hysdn_proclog.c
+++ b/drivers/isdn/hysdn/hysdn_proclog.c
@@ -380,6 +380,7 @@ hysdn_log_poll(struct file *file, poll_table * wait)
 /**************************************************/
 static const struct file_operations log_fops =
 {
+	.owner		= THIS_MODULE,
 	.llseek         = no_llseek,
 	.read           = hysdn_log_read,
 	.write          = hysdn_log_write,
@@ -402,10 +403,9 @@ hysdn_proclog_init(hysdn_card * card)
 
 	if ((pd = kzalloc(sizeof(struct procdata), GFP_KERNEL)) != NULL) {
 		sprintf(pd->log_name, "%s%d", PROC_LOG_BASENAME, card->myid);
-		if ((pd->log = create_proc_entry(pd->log_name, S_IFREG | S_IRUGO | S_IWUSR, hysdn_proc_entry)) != NULL) {
-		        pd->log->proc_fops = &log_fops; 
-		        pd->log->owner = THIS_MODULE;
-		}
+		pd->log = proc_create(pd->log_name,
+				S_IFREG | S_IRUGO | S_IWUSR, hysdn_proc_entry,
+				&log_fops);
 
 		init_waitqueue_head(&(pd->rd_queue));
 
-- 
1.5.3.rc5

