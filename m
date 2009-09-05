Return-Path: <linux-kernel-owner+w=401wt.eu-S934672AbZIEA3C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934672AbZIEA3C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:29:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964900AbZIEA26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:28:58 -0400
Received: from kroah.org ([198.145.64.141]:42236 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934634AbZIEAVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:21:09 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:54 2009
Message-Id: <20090905001454.224443797@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kashyap Desai <kashyap.desai@lsi.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [patch 44/71] SCSI: mpt2sas: fix oops because drv data points to NULL on resume from hibernate
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=scsi-mpt2sas-fix-oops-because-drv-data-points-to-null-on-resume-from-hibernate.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Kashyap, Desai <kashyap.desai@lsi.com>

commit fcfe6392d18283df3c561b5ef59c330d485ff8ca upstream.

Fix another ocurring when the system resumes.  This oops was due to driver
setting the pci drvdata to NULL on the prior hibernation.  Becuase it was
set to NULL, upon resmume we assume the pci drvdata is non-zero, and we oops.
To fix the ooops, we don't set pci drvdata to NULL at hibernation time.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1171,7 +1171,6 @@ mpt2sas_base_map_resources(struct MPT2SA
 		}
 	}
 
-	pci_set_drvdata(pdev, ioc->shost);
 	_base_mask_interrupts(ioc);
 	r = _base_enable_msix(ioc);
 	if (r)
@@ -1194,7 +1193,6 @@ mpt2sas_base_map_resources(struct MPT2SA
 	ioc->pci_irq = -1;
 	pci_release_selected_regions(ioc->pdev, ioc->bars);
 	pci_disable_device(pdev);
-	pci_set_drvdata(pdev, NULL);
 	return r;
 }
 
@@ -3253,7 +3251,6 @@ mpt2sas_base_free_resources(struct MPT2S
 	ioc->chip_phys = 0;
 	pci_release_selected_regions(ioc->pdev, ioc->bars);
 	pci_disable_device(pdev);
-	pci_set_drvdata(pdev, NULL);
 	return;
 }
 
@@ -3275,6 +3272,7 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPT
 	if (r)
 		return r;
 
+	pci_set_drvdata(ioc->pdev, ioc->shost);
 	r = _base_make_ioc_ready(ioc, CAN_SLEEP, SOFT_RESET);
 	if (r)
 		goto out_free_resources;
@@ -3357,6 +3355,7 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPT
 	ioc->remove_host = 1;
 	mpt2sas_base_free_resources(ioc);
 	_base_release_memory_pools(ioc);
+	pci_set_drvdata(ioc->pdev, NULL);
 	kfree(ioc->tm_cmds.reply);
 	kfree(ioc->transport_cmds.reply);
 	kfree(ioc->config_cmds.reply);
@@ -3389,6 +3388,7 @@ mpt2sas_base_detach(struct MPT2SAS_ADAPT
 	mpt2sas_base_stop_watchdog(ioc);
 	mpt2sas_base_free_resources(ioc);
 	_base_release_memory_pools(ioc);
+	pci_set_drvdata(ioc->pdev, NULL);
 	kfree(ioc->pfacts);
 	kfree(ioc->ctl_cmds.reply);
 	kfree(ioc->base_cmds.reply);


