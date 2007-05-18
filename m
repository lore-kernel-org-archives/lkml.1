Return-Path: <linux-kernel-owner+w=401wt.eu-S1761715AbXERJmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761715AbXERJmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 05:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755669AbXERJmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 05:42:12 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:31381 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437AbXERJmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 05:42:11 -0400
Message-ID: <464D75EE.4040708@sw.ru>
Date: Fri, 18 May 2007 13:46:22 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org
Subject: [PATCH 9/15] Make /proc/modules use seq_list_xxx helpers
References: <464D6E87.7060605@sw.ru>
In-Reply-To: <464D6E87.7060605@sw.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here there is not need even in .show callback altering.
The original code passes list_head in *v.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>

---

diff --git a/kernel/module.c b/kernel/module.c
index 015d60c..7a1a4d3 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2232,26 +2232,13 @@ unsigned long module_kallsyms_lookup_nam
 /* Called by the /proc file system to return a list of modules. */
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
-	struct list_head *i;
-	loff_t n = 0;
-
 	mutex_lock(&module_mutex);
-	list_for_each(i, &modules) {
-		if (n++ == *pos)
-			break;
-	}
-	if (i == &modules)
-		return NULL;
-	return i;
+	return seq_list_start(&modules, *pos);
 }
 
 static void *m_next(struct seq_file *m, void *p, loff_t *pos)
 {
-	struct list_head *i = p;
-	(*pos)++;
-	if (i->next == &modules)
-		return NULL;
-	return i->next;
+	return seq_list_next(p, &modules, pos);
 }
 
 static void m_stop(struct seq_file *m, void *p)

