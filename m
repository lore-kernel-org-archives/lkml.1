Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbXERLKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbXERLKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 07:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755866AbXERLKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 07:10:16 -0400
Received: from ns1.suse.de ([195.135.220.2]:48214 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649AbXERLKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 07:10:14 -0400
Date: Fri, 18 May 2007 13:10:07 +0200
From: Karsten Keil <kkeil@suse.de>
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org,
       Pavel Emelianov <xemul@sw.ru>
Subject: Re: [PATCH 7/15] Make ISDN CAPI use seq_list_xxx helpers
Message-ID: <20070518111007.GA16940@pingi.kke.suse.de>
Mail-Followup-To: Andrew Morton <akpm@osdl.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	devel@openvz.org, Pavel Emelianov <xemul@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.27-0.6-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The similar code exists here and is called capi_driver_get_idx().
Use generic helpers now and remember to convert list_head to
struct capi_driver in .show callback.

Acked-by: Karsten Keil <kkeil@suse.de>
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

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
