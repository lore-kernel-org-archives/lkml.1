Return-Path: <linux-kernel-owner+w=401wt.eu-S1760299AbZIPWq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760299AbZIPWq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760305AbZIPWjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:39:47 -0400
Received: from kroah.org ([198.145.64.141]:48909 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760276AbZIPWjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:39:42 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:37:13 2009
Message-Id: <20090916223713.797208638@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:36:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kashyap Desai <kashyap.desai@lsi.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [patch 04/45] [SCSI] mpt2sas: setting SDEV into RUNNING state from Interrupt context
References: <20090916223613.597295240@mini.kroah.org>
Content-Disposition: inline; filename=mpt2sas-setting-sdev-into-running-state-from-interrupt-context.patch
In-Reply-To: <20090916223739.GA4789@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Kashyap, Desai <kashyap.desai@lsi.com>

commit 34a03bef2202d0c9983a8da0a8abaee37d285847 upstream.

Changing SDEV Running state from interrupt context. Previously It was
handle in work queue thread. With this change It will not wait for work
queue thread to execute scsih_ublock_io_device to put SDEV into Running
state. This will reduce delay for Device becoming RUNNING.

Modified this patch considering James comment "Not to change SDEV state
using  scsi_device_set_state API, instead use scsi_internal_device_unblock
scsi_internal_device_block API"

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Reviewed-by: Eric Moore <Eric.moore@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/mpt2sas/mpt2sas_base.h  |    2 ++
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |   17 +++++++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -802,5 +802,7 @@ void mpt2sas_transport_update_phy_link_c
    u16 attached_handle, u8 phy_number, u8 link_rate);
 extern struct sas_function_template mpt2sas_transport_functions;
 extern struct scsi_transport_template *mpt2sas_transport_template;
+extern int scsi_internal_device_block(struct scsi_device *sdev);
+extern int scsi_internal_device_unblock(struct scsi_device *sdev);
 
 #endif /* MPT2SAS_BASE_H_INCLUDED */
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2222,7 +2222,7 @@ _scsih_ublock_io_device(struct MPT2SAS_A
 			    MPT2SAS_INFO_FMT "SDEV_RUNNING: "
 			    "handle(0x%04x)\n", ioc->name, handle));
 			sas_device_priv_data->block = 0;
-			scsi_device_set_state(sdev, SDEV_RUNNING);
+			scsi_internal_device_unblock(sdev);
 		}
 	}
 }
@@ -2251,7 +2251,7 @@ _scsih_block_io_device(struct MPT2SAS_AD
 			    MPT2SAS_INFO_FMT "SDEV_BLOCK: "
 			    "handle(0x%04x)\n", ioc->name, handle));
 			sas_device_priv_data->block = 1;
-			scsi_device_set_state(sdev, SDEV_BLOCK);
+			scsi_internal_device_block(sdev);
 		}
 	}
 }
@@ -2327,6 +2327,7 @@ _scsih_block_io_to_children_attached_dir
 	u16 handle;
 	u16 reason_code;
 	u8 phy_number;
+	u8 link_rate;
 
 	for (i = 0; i < event_data->NumEntries; i++) {
 		handle = le16_to_cpu(event_data->PHY[i].AttachedDevHandle);
@@ -2337,6 +2338,11 @@ _scsih_block_io_to_children_attached_dir
 		    MPI2_EVENT_SAS_TOPO_RC_MASK;
 		if (reason_code == MPI2_EVENT_SAS_TOPO_RC_DELAY_NOT_RESPONDING)
 			_scsih_block_io_device(ioc, handle);
+		if (reason_code == MPI2_EVENT_SAS_TOPO_RC_PHY_CHANGED) {
+			link_rate = event_data->PHY[i].LinkRate >> 4;
+			if (link_rate >= MPI2_SAS_NEG_LINK_RATE_1_5)
+				_scsih_ublock_io_device(ioc, handle);
+		}
 	}
 }
 
@@ -3708,6 +3714,9 @@ _scsih_remove_device(struct MPT2SAS_ADAP
 	    le32_to_cpu(mpi_reply.IOCLogInfo)));
 
  out:
+
+	_scsih_ublock_io_device(ioc, handle);
+
 	mpt2sas_transport_port_remove(ioc, sas_device->sas_address,
 	    sas_device->parent_handle);
 
@@ -3887,10 +3896,6 @@ _scsih_sas_topology_change_event(struct 
 						   link_rate_);
 				}
 			}
-			if (reason_code == MPI2_EVENT_SAS_TOPO_RC_PHY_CHANGED) {
-				if (link_rate_ >= MPI2_SAS_NEG_LINK_RATE_1_5)
-					_scsih_ublock_io_device(ioc, handle);
-			}
 			if (reason_code == MPI2_EVENT_SAS_TOPO_RC_TARG_ADDED) {
 				if (link_rate_ < MPI2_SAS_NEG_LINK_RATE_1_5)
 					break;


