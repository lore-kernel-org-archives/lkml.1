Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbXERJYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbXERJYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 05:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755817AbXERJYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 05:24:31 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:38663 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754864AbXERJYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 05:24:31 -0400
Message-ID: <464D71A3.7020509@sw.ru>
Date: Fri, 18 May 2007 13:28:03 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chas@cmf.nrl.navy.mil, devel@openvz.org
Subject: [PATCH 3/15] Make ATM driver use seq_list_xxx helpers
References: <464D6E87.7060605@sw.ru>
In-Reply-To: <464D6E87.7060605@sw.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The .show callback receives the list_head pointer now, not
the struct br2684_dev one.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>

---

diff --git a/net/atm/br2684.c b/net/atm/br2684.c
index 0e9f00c..3e26438 100644
--- a/net/atm/br2684.c
+++ b/net/atm/br2684.c
@@ -699,28 +699,13 @@ static struct atm_ioctl br2684_ioctl_ops
 #ifdef CONFIG_PROC_FS
 static void *br2684_seq_start(struct seq_file *seq, loff_t *pos)
 {
-	loff_t offs = 0;
-	struct br2684_dev *brd;
-
 	read_lock(&devs_lock);
-
-	list_for_each_entry(brd, &br2684_devs, br2684_devs) {
-		if (offs == *pos)
-			return brd;
-		++offs;
-	}
-	return NULL;
+	return seq_list_start(&br2684_devs, *pos);
 }
 
 static void *br2684_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	struct br2684_dev *brd = v;
-
-	++*pos;
-
-	brd = list_entry(brd->br2684_devs.next,
-			 struct br2684_dev, br2684_devs);
-	return (&brd->br2684_devs != &br2684_devs) ? brd : NULL;
+	return seq_list_next(v, &br2684_devs, pos);
 }
 
 static void br2684_seq_stop(struct seq_file *seq, void *v)
@@ -730,7 +715,8 @@ static void br2684_seq_stop(struct seq_f
 
 static int br2684_seq_show(struct seq_file *seq, void *v)
 {
-	const struct br2684_dev *brdev = v;
+	const struct br2684_dev *brdev = list_entry(v, struct br2684_dev,
+			br2684_devs);
 	const struct net_device *net_dev = brdev->net_dev;
 	const struct br2684_vcc *brvcc;
 

