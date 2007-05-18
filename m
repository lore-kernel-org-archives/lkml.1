Return-Path: <linux-kernel-owner+w=401wt.eu-S1759362AbXERKDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362AbXERKDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 06:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbXERKDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 06:03:31 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:32225 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529AbXERKDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 06:03:31 -0400
Message-ID: <464D7AE4.1080103@sw.ru>
Date: Fri, 18 May 2007 14:07:32 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org
Subject: [PATCH 13/15] Make /proc/tty/drivers use seq_list_xxx helpers
References: <464D6E87.7060605@sw.ru>
In-Reply-To: <464D6E87.7060605@sw.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simple and stupid like some previous ones. Just use new API.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>

---

diff --git a/fs/proc/proc_tty.c b/fs/proc/proc_tty.c
index b3a473b..2284622 100644
--- a/fs/proc/proc_tty.c
+++ b/fs/proc/proc_tty.c
@@ -69,7 +69,7 @@ static void show_tty_range(struct seq_fi
 
 static int show_tty_driver(struct seq_file *m, void *v)
 {
-	struct tty_driver *p = v;
+	struct tty_driver *p = list_entry(v, struct tty_driver, tty_drivers);
 	dev_t from = MKDEV(p->major, p->minor_start);
 	dev_t to = from + p->num;
 
@@ -106,22 +106,13 @@ static int show_tty_driver(struct seq_fi
 /* iterator */
 static void *t_start(struct seq_file *m, loff_t *pos)
 {
-	struct list_head *p;
-	loff_t l = *pos;
-
 	mutex_lock(&tty_mutex);
-	list_for_each(p, &tty_drivers)
-		if (!l--)
-			return list_entry(p, struct tty_driver, tty_drivers);
-	return NULL;
+	return seq_list_start(&tty_drivers, *pos);
 }
 
 static void *t_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct list_head *p = ((struct tty_driver *)v)->tty_drivers.next;
-	(*pos)++;
-	return p==&tty_drivers ? NULL :
-			list_entry(p, struct tty_driver, tty_drivers);
+	return seq_list_next(v, &tty_drivers, pos);
 }
 
 static void t_stop(struct seq_file *m, void *v)

