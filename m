Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbXERJhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbXERJhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 05:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbXERJhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 05:37:13 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:17657 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078AbXERJhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 05:37:12 -0400
Message-ID: <464D74B2.4040609@sw.ru>
Date: Fri, 18 May 2007 13:41:06 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kkeil@suse.de,
       devel@openvz.org
Subject: [PATCH 7/15] Make ISDN CAPI use seq_list_xxx helpers
References: <464D6E87.7060605@sw.ru>
In-Reply-To: <464D6E87.7060605@sw.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The similar code exists here and is called capi_driver_get_idx().
Use generic helpers now and remember to convert list_head to
struct capi_driver in .show callback.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>

---

diff --git a/drivers/isdn/capi/kcapi_proc.c b/drivers/isdn/capi/kcapi_proc.c
index 31f4fd8..845a797 100644
--- a/drivers/isdn/capi/kcapi_proc.c
+++ b/drivers/isdn/capi/kcapi_proc.c
@@ -243,36 +243,15 @@ create_seq_entry(char *name, mode_t mode
 
 // ---------------------------------------------------------------------------
 
-
-static __inline__ struct capi_driver *capi_driver_get_idx(loff_t pos)
-{
-	struct capi_driver *drv = NULL;
-	struct list_head *l;
-	loff_t i;
-
-	i = 0;
-	list_for_each(l, &capi_drivers) {
-		drv = list_entry(l, struct capi_driver, list);
-		if (i++ == pos)
-			return drv;
-	}
-	return NULL;
-}
-
 static void *capi_driver_start(struct seq_file *seq, loff_t *pos)
 {
-	struct capi_driver *drv;
 	read_lock(&capi_drivers_list_lock);
-	drv = capi_driver_get_idx(*pos);
-	return drv;
+	return seq_list_start(&capi_drivers, *pos);
 }
 
 static void *capi_driver_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	struct capi_driver *drv = (struct capi_driver *)v;
-	++*pos;
-	if (drv->list.next == &capi_drivers) return NULL;
-	return list_entry(drv->list.next, struct capi_driver, list);
+	return seq_list_next(v, &capi_drivers, pos);
 }
 
 static void capi_driver_stop(struct seq_file *seq, void *v)
@@ -282,7 +261,8 @@ static void capi_driver_stop(struct seq_
 
 static int capi_driver_show(struct seq_file *seq, void *v)
 {
-	struct capi_driver *drv = (struct capi_driver *)v;
+	struct capi_driver *drv = list_entry(v, struct capi_driver, list);
+
 	seq_printf(seq, "%-32s %s\n", drv->name, drv->revision);
 	return 0;
 }

