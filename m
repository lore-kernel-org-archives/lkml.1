Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbXKEIlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbXKEIlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 03:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbXKEIlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 03:41:09 -0500
Received: from flatline.sindominio.net ([82.144.4.26]:45314 "EHLO
	flatline.sindominio.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbXKEIlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 03:41:07 -0500
Date: Mon, 5 Nov 2007 09:41:01 +0100
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: mcgrof@gmail.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Prism54: Convert mgmt_sem to the mutex API
Message-ID: <20071105084101.GB18236@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Michael Buesch <mb@bu3sch.de>, mcgrof@gmail.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20071101071902.GH6092@traven> <200711050036.13654.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711050036.13654.mb@bu3sch.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Mon, Nov 05, 2007 at 12:36:13AM +0100 Michael Buesch ha dit:

> On Thursday 01 November 2007 08:19:02 Matthias Kaehlcke wrote:
> > Prism54: Convert mgmt_sem to the mutex API
> > 
> > Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
> > 
> 
> Uhm, so this mutex is not used? Why not remove it then?

i apologize, the patch i submitted is incorrect, a file is
missing. here is the correct version

--

Prism54: Convert mgmt_sem to the mutex API
 
Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/net/wireless/prism54/islpci_dev.c b/drivers/net/wireless/prism54/islpci_dev.c
index 219dd65..dbb538c 100644
--- a/drivers/net/wireless/prism54/islpci_dev.c
+++ b/drivers/net/wireless/prism54/islpci_dev.c
@@ -861,7 +861,7 @@ islpci_setup(struct pci_dev *pdev)
 	init_waitqueue_head(&priv->reset_done);
 
 	/* init the queue read locks, process wait counter */
-	sema_init(&priv->mgmt_sem, 1);
+	mutex_init(&priv->mgmt_lock);
 	priv->mgmt_received = NULL;
 	init_waitqueue_head(&priv->mgmt_wqueue);
 	sema_init(&priv->stats_sem, 1);
diff --git a/drivers/net/wireless/prism54/islpci_dev.h b/drivers/net/wireless/prism54/islpci_dev.h
index 736666d..4e0182c 100644
--- a/drivers/net/wireless/prism54/islpci_dev.h
+++ b/drivers/net/wireless/prism54/islpci_dev.h
@@ -26,6 +26,7 @@
 #include <linux/wireless.h>
 #include <net/iw_handler.h>
 #include <linux/list.h>
+#include <linux/mutex.h>
 
 #include "isl_38xx.h"
 #include "isl_oid.h"
@@ -164,7 +165,7 @@ typedef struct {
 	wait_queue_head_t reset_done;
 
 	/* used by islpci_mgt_transaction */
-	struct semaphore mgmt_sem; /* serialize access to mailbox and wqueue */
+	struct mutex mgmt_lock; /* serialize access to mailbox and wqueue */
 	struct islpci_mgmtframe *mgmt_received;	  /* mbox for incoming frame */
 	wait_queue_head_t mgmt_wqueue;            /* waitqueue for mbox */
 
diff --git a/drivers/net/wireless/prism54/islpci_mgt.c b/drivers/net/wireless/prism54/islpci_mgt.c
index 2246f79..f7c677e 100644
--- a/drivers/net/wireless/prism54/islpci_mgt.c
+++ b/drivers/net/wireless/prism54/islpci_mgt.c
@@ -460,7 +460,7 @@ islpci_mgt_transaction(struct net_device *ndev,
 
 	*recvframe = NULL;
 
-	if (down_interruptible(&priv->mgmt_sem))
+	if (mutex_lock_interruptible(&priv->mgmt_lock))
 		return -ERESTARTSYS;
 
 	prepare_to_wait(&priv->mgmt_wqueue, &wait, TASK_UNINTERRUPTIBLE);
@@ -504,7 +504,7 @@ islpci_mgt_transaction(struct net_device *ndev,
 	/* TODO: we should reset the device here */
  out:
 	finish_wait(&priv->mgmt_wqueue, &wait);
-	up(&priv->mgmt_sem);
+	mutex_unlock(&priv->mgmt_lock);
 	return err;
 }
 
-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

     La guerra es un acto abominable en el que se matan personas que no
      se conocen, dirigidas por personas que se conocen y no se matan
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
