Return-Path: <linux-kernel-owner+w=401wt.eu-S1758399AbZDHH2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758399AbZDHH2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762955AbZDHH1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:27:32 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:14819 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762965AbZDHH1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:27:31 -0400
Date: Wed, 8 Apr 2009 09:27:16 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Doug Thompson <dougthompson@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] emac: Fix dangerous struct assumption
Message-ID: <20090408092716.392c3005@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The emac-core driver includes code which assumes that the work_struct
which is included in every delayed_work is the first member of that
structure. This is currently the case but might change in the future,
so use to_delayed_work() instead, which doesn't make such an
assumption.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
---
 drivers/edac/edac_device.c |    2 +-
 drivers/edac/edac_mc.c     |    2 +-
 drivers/edac/edac_pci.c    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.30-rc0.orig/drivers/edac/edac_device.c	2009-03-24 13:43:33.000000000 +0100
+++ linux-2.6.30-rc0/drivers/edac/edac_device.c	2009-04-06 14:40:48.000000000 +0200
@@ -389,7 +389,7 @@ static void del_edac_device_from_global_
  */
 static void edac_device_workq_function(struct work_struct *work_req)
 {
-	struct delayed_work *d_work = (struct delayed_work *)work_req;
+	struct delayed_work *d_work = to_delayed_work(work_req);
 	struct edac_device_ctl_info *edac_dev = to_edac_device_ctl_work(d_work);
 
 	mutex_lock(&device_ctls_mutex);
--- linux-2.6.30-rc0.orig/drivers/edac/edac_mc.c	2009-03-24 13:43:33.000000000 +0100
+++ linux-2.6.30-rc0/drivers/edac/edac_mc.c	2009-04-06 14:40:14.000000000 +0200
@@ -260,7 +260,7 @@ static int edac_mc_assert_error_check_an
  */
 static void edac_mc_workq_function(struct work_struct *work_req)
 {
-	struct delayed_work *d_work = (struct delayed_work *)work_req;
+	struct delayed_work *d_work = to_delayed_work(work_req);
 	struct mem_ctl_info *mci = to_edac_mem_ctl_work(d_work);
 
 	mutex_lock(&mem_ctls_mutex);
--- linux-2.6.30-rc0.orig/drivers/edac/edac_pci.c	2009-04-06 11:17:57.000000000 +0200
+++ linux-2.6.30-rc0/drivers/edac/edac_pci.c	2009-04-06 14:40:04.000000000 +0200
@@ -233,7 +233,7 @@ EXPORT_SYMBOL_GPL(edac_pci_find);
  */
 static void edac_pci_workq_function(struct work_struct *work_req)
 {
-	struct delayed_work *d_work = (struct delayed_work *)work_req;
+	struct delayed_work *d_work = to_delayed_work(work_req);
 	struct edac_pci_ctl_info *pci = to_edac_pci_ctl_work(d_work);
 	int msec;
 	unsigned long delay;


-- 
Jean Delvare
