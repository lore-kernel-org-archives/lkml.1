Return-Path: <linux-kernel-owner+w=401wt.eu-S932478AbXEWOvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478AbXEWOvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 10:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764711AbXEWOvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 10:51:08 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:53323 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764589AbXEWOvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 10:51:07 -0400
Message-ID: <465454CE.2020703@linux.vnet.ibm.com>
Date: Wed, 23 May 2007 20:20:54 +0530
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
Subject: [RFC][PATCH 1/3] Containers: Pagecache accounting and control subsystem
 (v3)
References: <46545459.2090804@linux.vnet.ibm.com>
In-Reply-To: <46545459.2090804@linux.vnet.ibm.com>
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
 mm/rss_container.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

--- linux-2.6.20.orig/mm/rss_container.c
+++ linux-2.6.20/mm/rss_container.c
@@ -16,6 +16,7 @@

 struct rss_container {
 	struct res_counter res;
+	struct res_counter pagecache_res;
 	struct list_head inactive_list;
 	struct list_head active_list;
 	atomic_t rss_reclaimed;
@@ -266,6 +267,7 @@ static int rss_create(struct container_s
 		return -ENOMEM;

 	res_counter_init(&rss->res);
+	res_counter_init(&rss->pagecache_res);
 	INIT_LIST_HEAD(&rss->inactive_list);
 	INIT_LIST_HEAD(&rss->active_list);
 	rss_container_attach(rss, cont);
@@ -308,6 +310,21 @@ static ssize_t rss_read_reclaimed(struct
 			ppos, buf, s - buf);
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

 static struct cftype rss_usage = {
 	.name = "rss_usage",
@@ -333,6 +350,25 @@ static struct cftype rss_reclaimed = {
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
@@ -346,6 +382,12 @@ static int rss_populate(struct container
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
