Return-Path: <linux-kernel-owner+w=401wt.eu-S1760608AbXERJjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608AbXERJjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 05:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbXERJji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 05:39:38 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:10809 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078AbXERJjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 05:39:37 -0400
Message-ID: <464D7554.8030004@sw.ru>
Date: Fri, 18 May 2007 13:43:48 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org
Subject: [PATCH 8/15] Make /proc/misc use seq_list_xxx helpers
References: <464D6E87.7060605@sw.ru>
In-Reply-To: <464D6E87.7060605@sw.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simple and stupid - just use the helpers.

Sorry for no maintainer in Cc: - I haven't found any.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>

---

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index 4e6fb96..71c8cd7 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -67,25 +67,13 @@ extern int pmu_device_init(void);
 #ifdef CONFIG_PROC_FS
 static void *misc_seq_start(struct seq_file *seq, loff_t *pos)
 {
-	struct miscdevice *p;
-	loff_t off = 0;
-
 	mutex_lock(&misc_mtx);
-	list_for_each_entry(p, &misc_list, list) {
-		if (*pos == off++) 
-			return p;
-	}
-	return NULL;
+	return seq_list_start(&misc_list, *pos);
 }
 
 static void *misc_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	struct list_head *n = ((struct miscdevice *)v)->list.next;
-
-	++*pos;
-
-	return (n != &misc_list) ? list_entry(n, struct miscdevice, list)
-		 : NULL;
+	return seq_list_next(v, &misc_list, pos);
 }
 
 static void misc_seq_stop(struct seq_file *seq, void *v)
@@ -95,7 +83,7 @@ static void misc_seq_stop(struct seq_fil
 
 static int misc_seq_show(struct seq_file *seq, void *v)
 {
-	const struct miscdevice *p = v;
+	const struct miscdevice *p = list_entry(v, struct miscdevice, list);
 
 	seq_printf(seq, "%3i %s\n", p->minor, p->name ? p->name : "");
 	return 0;

