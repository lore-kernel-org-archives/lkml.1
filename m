Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbXFTLgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbXFTLgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 07:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbXFTLgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 07:36:11 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:33880 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbXFTLgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 07:36:08 -0400
Message-ID: <4679110C.6010807@linux.vnet.ibm.com>
Date: Wed, 20 Jun 2007 17:05:40 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>, linux-mm@kvack.org
CC: Balbir Singh <balbir@in.ibm.com>, Pavel Emelianov <xemul@sw.ru>,
       Paul Menage <menage@google.com>, Kirill Korotaev <dev@sw.ru>,
       devel@openvz.org, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, Roy Huang <royhuang9@gmail.com>,
       Aubrey Li <aubreylee@gmail.com>
Subject: [RFC][PATCH 1/4] Pagecache controller setup
References: <46791098.4010801@linux.vnet.ibm.com>
In-Reply-To: <46791098.4010801@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pagecache controller setup
--------------------------

This patch basically adds user interface files in container fs
similar to the rss control files.

pagecache_usage, pagecache_limit and pagecache_failcnt are added
to each container.  All units are 'pages' as in rss controller.

pagecache usage is all file backed pages used by the container
which includes swapcache as well.

Separate res_counter for pagecache has been added.

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---
 mm/rss_container.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

--- linux-2.6.22-rc2-mm1.orig/mm/rss_container.c
+++ linux-2.6.22-rc2-mm1/mm/rss_container.c
@@ -24,6 +24,8 @@ struct rss_container {
 	 * the counter to account for RSS
 	 */
 	struct res_counter res;
+	/* the counter to account for pagecache pages */
+ 	struct res_counter pagecache_res;
 	/*
 	 * the lists of pages within the container.
 	 * actually these lists store the page containers (see below), not
@@ -347,6 +349,7 @@ static int rss_create(struct container_s
 		return -ENOMEM;

 	res_counter_init(&rss->res);
+	res_counter_init(&rss->pagecache_res);
 	INIT_LIST_HEAD(&rss->inactive_list);
 	INIT_LIST_HEAD(&rss->active_list);
 	rss_container_attach(rss, cont);
@@ -359,6 +362,21 @@ static void rss_destroy(struct container
 	kfree(rss_from_cont(cont));
 }

+static ssize_t pagecache_read(struct container *cont, struct cftype *cft,
+		struct file *file, char __user *userbuf,
+		size_t nbytes, loff_t *ppos)
+{
+	return res_counter_read(&rss_from_cont(cont)->pagecache_res,
+			cft->private, userbuf, nbytes, ppos);
+}
+
+static ssize_t pagecache_write(struct container *cont, struct cftype *cft,
+		struct file *file, const char __user *userbuf,
+		size_t nbytes, loff_t *ppos)
+{
+	return res_counter_write(&rss_from_cont(cont)->pagecache_res,
+			cft->private, userbuf, nbytes, ppos);
+}

 static ssize_t rss_read(struct container *cont, struct cftype *cft,
 		struct file *file, char __user *userbuf,
@@ -418,6 +436,25 @@ static struct cftype rss_reclaimed = {
 	.read = rss_read_reclaimed,
 };

+static struct cftype pagecache_usage = {
+	.name = "pagecache_usage",
+	.private = RES_USAGE,
+	.read = pagecache_read,
+};
+
+static struct cftype pagecache_limit = {
+	.name = "pagecache_limit",
+	.private = RES_LIMIT,
+	.read = pagecache_read,
+	.write = pagecache_write,
+};
+
+static struct cftype pagecache_failcnt = {
+	.name = "pagecache_failcnt",
+	.private = RES_FAILCNT,
+	.read = pagecache_read,
+};
+
 static int rss_populate(struct container_subsys *ss,
 		struct container *cont)
 {
@@ -431,6 +468,12 @@ static int rss_populate(struct container
 		return rc;
 	if ((rc = container_add_file(cont, &rss_reclaimed)) < 0)
 		return rc;
+	if ((rc = container_add_file(cont, &pagecache_usage)) < 0)
+		return rc;
+	if ((rc = container_add_file(cont, &pagecache_failcnt)) < 0)
+		return rc;
+	if ((rc = container_add_file(cont, &pagecache_limit)) < 0)
+		return rc;

 	return 0;
 }
