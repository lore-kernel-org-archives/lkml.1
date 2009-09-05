Return-Path: <linux-kernel-owner+w=401wt.eu-S934700AbZIEA3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934700AbZIEA3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934634AbZIEA3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:29:49 -0400
Received: from kroah.org ([198.145.64.141]:42205 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934627AbZIEAVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:21:04 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:53 2009
Message-Id: <20090905001453.388776827@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kashyap Desai <kashyap.desai@lsi.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [patch 39/71] SCSI: mpt2sas: Expander fix oops saying "Already part of another port"
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=scsi-mpt2sas-expander-fix-oops-saying-already-part-of-another-port.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Kashyap, Desai <kashyap.desai@lsi.com>

commit 20f5895d55d9281830bfb7819c5c5b70b05297a6 upstream.

Kernel panic is seen because driver did not tear down the port which should
be dnoe using mpt2sas_transport_port_remove(). without this fix When expander
is added back we would oops inside sas_port_add_phy.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3205,7 +3205,7 @@ _scsih_expander_add(struct MPT2SAS_ADAPT
 	__le64 sas_address;
 	int i;
 	unsigned long flags;
-	struct _sas_port *mpt2sas_port;
+	struct _sas_port *mpt2sas_port = NULL;
 	int rc = 0;
 
 	if (!handle)
@@ -3297,12 +3297,20 @@ _scsih_expander_add(struct MPT2SAS_ADAPT
 		    &expander_pg1, i, handle))) {
 			printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 			    ioc->name, __FILE__, __LINE__, __func__);
-			continue;
+			rc = -1;
+			goto out_fail;
 		}
 		sas_expander->phy[i].handle = handle;
 		sas_expander->phy[i].phy_id = i;
-		mpt2sas_transport_add_expander_phy(ioc, &sas_expander->phy[i],
-		    expander_pg1, sas_expander->parent_dev);
+
+		if ((mpt2sas_transport_add_expander_phy(ioc,
+		    &sas_expander->phy[i], expander_pg1,
+		    sas_expander->parent_dev))) {
+			printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
+			    ioc->name, __FILE__, __LINE__, __func__);
+			rc = -1;
+			goto out_fail;
+		}
 	}
 
 	if (sas_expander->enclosure_handle) {
@@ -3319,8 +3327,9 @@ _scsih_expander_add(struct MPT2SAS_ADAPT
 
  out_fail:
 
-	if (sas_expander)
-		kfree(sas_expander->phy);
+	if (mpt2sas_port)
+		mpt2sas_transport_port_remove(ioc, sas_expander->sas_address,
+		    sas_expander->parent_handle);
 	kfree(sas_expander);
 	return rc;
 }


