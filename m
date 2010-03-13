Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935016Ab0CMBLl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:11:41 -0500
Received: from kroah.org ([198.145.64.141]:46687 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935352Ab0CMAaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:30:52 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:07 2010
Message-Id: <20100313002707.170563901@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:25:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kashyap Desai <kashyap.desai@lsi.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [022/145] [SCSI] mpt2sas: Delete volume before HBA detach.
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Kashyap, Desai <kashyap.desai@lsi.com>

commit d7384b28afb2bf2b7be835ddc8c852bdc5e0ce1c upstream.

The driver hangs when doing `rmmod mpt2sas` if there are any
IR volumes present.The hang is due the scsi midlayer trying to access the
IR volumes after the driver releases controller resources.  Perhaps when
scsi_remove_host is called,the scsi mid layer is sending some request.
This doesn't occur for bare drives becuase the driver is already reporting
those drives deleted prior to calling mpt2sas_base_detach.
To solve this issue, we need to delete the volumes as well.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Reviewed-by: Eric Moore <eric.moore@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -5721,6 +5721,8 @@ _scsih_remove(struct pci_dev *pdev)
 	struct _sas_port *mpt2sas_port;
 	struct _sas_device *sas_device;
 	struct _sas_node *expander_sibling;
+	struct _raid_device *raid_device, *next;
+	struct MPT2SAS_TARGET *sas_target_priv_data;
 	struct workqueue_struct	*wq;
 	unsigned long flags;
 
@@ -5734,6 +5736,21 @@ _scsih_remove(struct pci_dev *pdev)
 	if (wq)
 		destroy_workqueue(wq);
 
+	/* release all the volumes */
+	list_for_each_entry_safe(raid_device, next, &ioc->raid_device_list,
+	    list) {
+		if (raid_device->starget) {
+			sas_target_priv_data =
+			    raid_device->starget->hostdata;
+			sas_target_priv_data->deleted = 1;
+			scsi_remove_target(&raid_device->starget->dev);
+		}
+		printk(MPT2SAS_INFO_FMT "removing handle(0x%04x), wwid"
+		    "(0x%016llx)\n", ioc->name,  raid_device->handle,
+		    (unsigned long long) raid_device->wwid);
+		_scsih_raid_device_remove(ioc, raid_device);
+	}
+
 	/* free ports attached to the sas_host */
  retry_again:
 	list_for_each_entry(mpt2sas_port,


