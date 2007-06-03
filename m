Return-Path: <linux-kernel-owner+w=401wt.eu-S1755063AbXFCOly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063AbXFCOly (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 10:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226AbXFCOkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 10:40:20 -0400
Received: from web50103.mail.re2.yahoo.com ([206.190.38.31]:40198 "HELO
	web50103.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753884AbXFCOkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 10:40:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=v8fhwmMx2KhS7TlHxKkTOfvTrVIIpXJsBuW5EL+beI4wdG+MuZrtZ3+rdzD58o9oIQmVm2hsWiFCoUMAlvxHyRP1htU4VS3dJVyMIuCYhVttbwUwGXwnNoHivoy8aGY28Z/tS+Sqil82TKu7s4V4ubixy7glw9xFryon9G/e5oo=;
X-YMail-OSG: 75HN1VwVM1l59U7ZuuogkPQlvNLLMjPs.MxMJ16E6D_5lxHeUarapGhP1I8Q0nKJp1Zk8Q--
Date: Sun, 3 Jun 2007 07:40:16 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: [PATCH 8/36] drivers edac chaange to mutex operation
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <27653.85350.qm@web50103.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The EDAC core code uses a semaphore as mutex. use the mutex API
instead of the (binary) semaphore. 

Matthaias wrote this, but since I had some patches ahead of it, 
I need to modify it to follow my patches.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
--
 edac_mc.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--
Index: linux-2.6.21.1/drivers/edac/edac_mc.c
===================================================================
--- linux-2.6.21.1.orig/drivers/edac/edac_mc.c
+++ linux-2.6.21.1/drivers/edac/edac_mc.c
@@ -35,7 +35,7 @@
 
 
 /* lock to memory controller's control array */
-static DECLARE_MUTEX(mem_ctls_mutex);
+static DEFINE_MUTEX(mem_ctls_mutex);
 static struct list_head mc_devices = LIST_HEAD_INIT(mc_devices);
 
 #ifdef CONFIG_EDAC_DEBUG
@@ -334,7 +334,7 @@ int edac_mc_add_mc(struct mem_ctl_info *
 		}
 	}
 #endif
-	down(&mem_ctls_mutex);
+	mutex_lock(&mem_ctls_mutex);
 
 	if (add_mc_to_global_list(mci))
 		goto fail0;
@@ -352,14 +352,14 @@ int edac_mc_add_mc(struct mem_ctl_info *
 	edac_mc_printk(mci, KERN_INFO, "Giving out device to %s %s: DEV
%s\n",
 		mci->mod_name, mci->ctl_name, dev_name(mci->dev));
 
-	up(&mem_ctls_mutex);
+	mutex_unlock(&mem_ctls_mutex);
 	return 0;
 
 fail1:
 	del_mc_from_global_list(mci);
 
 fail0:
-	up(&mem_ctls_mutex);
+	mutex_unlock(&mem_ctls_mutex);
 	return 1;
 }
 EXPORT_SYMBOL_GPL(edac_mc_add_mc);
@@ -376,16 +376,16 @@ struct mem_ctl_info * edac_mc_del_mc(str
 	struct mem_ctl_info *mci;
 
 	debugf0("MC: %s()\n", __func__);
-	down(&mem_ctls_mutex);
+	mutex_lock(&mem_ctls_mutex);
 
 	if ((mci = find_mci_by_dev(dev)) == NULL) {
-		up(&mem_ctls_mutex);
+		mutex_unlock(&mem_ctls_mutex);
 		return NULL;
 	}
 
 	edac_remove_sysfs_mci_device(mci);
 	del_mc_from_global_list(mci);
-	up(&mem_ctls_mutex);
+	mutex_unlock(&mem_ctls_mutex);
 	edac_printk(KERN_INFO, EDAC_MC,
 		"Removed device %d for %s %s: DEV %s\n", mci->mc_idx,
 		mci->mod_name, mci->ctl_name, dev_name(mci->dev));
@@ -722,7 +722,7 @@ void edac_check_mc_devices(void)
 	struct mem_ctl_info *mci;
 
 	debugf3("%s()\n", __func__);
-	down(&mem_ctls_mutex);
+	mutex_lock(&mem_ctls_mutex);
 
 	list_for_each(item, &mc_devices) {
 		mci = list_entry(item, struct mem_ctl_info, link);
@@ -731,5 +731,5 @@ void edac_check_mc_devices(void)
 			mci->edac_check(mci);
 	}
 
-	up(&mem_ctls_mutex);
+	mutex_unlock(&mem_ctls_mutex);
 }

