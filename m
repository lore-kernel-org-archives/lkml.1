Return-Path: <linux-kernel-owner+w=401wt.eu-S1760712AbXERKBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760712AbXERKBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 06:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbXERKA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 06:00:58 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:33139 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529AbXERKA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 06:00:57 -0400
Message-ID: <464D7A47.7000204@sw.ru>
Date: Fri, 18 May 2007 14:04:55 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trond.myklebust@fys.uio.no, devel@openvz.org
Subject: [PATCH 12/15] Make NFS client use seq_list_xxx helpers
References: <464D6E87.7060605@sw.ru>
In-Reply-To: <464D6E87.7060605@sw.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This includes /proc/fs/nfsfs/servers and /proc/fs/nfsfs/volumes
entries.

Both need to show the header and use the list_head.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>

---

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 50c6821..10355ec 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -1232,23 +1232,9 @@ static int nfs_server_list_open(struct i
  */
 static void *nfs_server_list_start(struct seq_file *m, loff_t *_pos)
 {
-	struct list_head *_p;
-	loff_t pos = *_pos;
-
 	/* lock the list against modification */
 	spin_lock(&nfs_client_lock);
-
-	/* allow for the header line */
-	if (!pos)
-		return SEQ_START_TOKEN;
-	pos--;
-
-	/* find the n'th element in the list */
-	list_for_each(_p, &nfs_client_list)
-		if (!pos--)
-			break;
-
-	return _p != &nfs_client_list ? _p : NULL;
+	return seq_list_start_head(&nfs_client_list, *_pos);
 }
 
 /*
@@ -1256,14 +1242,7 @@ static void *nfs_server_list_start(struc
  */
 static void *nfs_server_list_next(struct seq_file *p, void *v, loff_t *pos)
 {
-	struct list_head *_p;
-
-	(*pos)++;
-
-	_p = v;
-	_p = (v == SEQ_START_TOKEN) ? nfs_client_list.next : _p->next;
-
-	return _p != &nfs_client_list ? _p : NULL;
+	return seq_list_next(v, &nfs_client_list, pos);
 }
 
 /*
@@ -1282,7 +1261,7 @@ static int nfs_server_list_show(struct s
 	struct nfs_client *clp;
 
 	/* display header on line 1 */
-	if (v == SEQ_START_TOKEN) {
+	if (v == &nfs_client_list) {
 		seq_puts(m, "NV SERVER   PORT USE HOSTNAME\n");
 		return 0;
 	}
@@ -1323,23 +1302,9 @@ static int nfs_volume_list_open(struct i
  */
 static void *nfs_volume_list_start(struct seq_file *m, loff_t *_pos)
 {
-	struct list_head *_p;
-	loff_t pos = *_pos;
-
 	/* lock the list against modification */
 	spin_lock(&nfs_client_lock);
-
-	/* allow for the header line */
-	if (!pos)
-		return SEQ_START_TOKEN;
-	pos--;
-
-	/* find the n'th element in the list */
-	list_for_each(_p, &nfs_volume_list)
-		if (!pos--)
-			break;
-
-	return _p != &nfs_volume_list ? _p : NULL;
+	return seq_list_start_head(&nfs_volume_list, *_pos);
 }
 
 /*
@@ -1347,14 +1312,7 @@ static void *nfs_volume_list_start(struc
  */
 static void *nfs_volume_list_next(struct seq_file *p, void *v, loff_t *pos)
 {
-	struct list_head *_p;
-
-	(*pos)++;
-
-	_p = v;
-	_p = (v == SEQ_START_TOKEN) ? nfs_volume_list.next : _p->next;
-
-	return _p != &nfs_volume_list ? _p : NULL;
+	return seq_list_next(v, &nfs_volume_list, pos);
 }
 
 /*
@@ -1375,7 +1333,7 @@ static int nfs_volume_list_show(struct s
 	char dev[8], fsid[17];
 
 	/* display header on line 1 */
-	if (v == SEQ_START_TOKEN) {
+	if (v == &nfs_volume_list) {
 		seq_puts(m, "NV SERVER   PORT DEV     FSID\n");
 		return 0;
 	}

