Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbXJHWsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbXJHWsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 18:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbXJHWsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 18:48:37 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:29639 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbXJHWsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 18:48:35 -0400
Date: Mon, 8 Oct 2007 15:48:32 -0700
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alexis Bruemmer <alexisb@us.ibm.com>,
       James Bottomley <james.bottomley@steeleye.com>
Subject: Re: [PATCH] aic94xx: Use request_firmware() to provide SAS address
	if the adapter lacks one
Message-ID: <20071008224832.GB11993@plap3.qlogic.org>
References: <20071008212553.GI16752@tree.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071008212553.GI16752@tree.beaverton.ibm.com>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.15 (2007-04-06)
X-OriginalArrivalTime: 08 Oct 2007 22:47:20.0582 (UTC) FILETIME=[2F595A60:01C809FD]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Oct 2007, Darrick J. Wong wrote:

> If the aic94xx chip doesn't have a SAS address in the chip's flash memory,
> use the request_firmware() interface to get one from userspace.  This
> way, there's no debate as to who or how an address gets generated--it's
> totally up to the administrator to provide it if the card doesn't have one.

So how about factoring that out to a transport-level interface.  How
about something along the lines of the following patch, whereby the
software driver upon detecting no valid WWPN, makes an upcall to each
interface's 'request_wwn()'.  The data passed in from shost_gendev
should be enough for some helper script to cull relevent device bits
and perhaps offer some level of persistence...  Off base?

Darrick, forgive the FC example, I don't do SAS...

--
av

--

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 7a7cfe5..5e0d953 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -35,6 +35,7 @@
 #include <linux/netlink.h>
 #include <net/netlink.h>
 #include <scsi/scsi_netlink_fc.h>
+#include <linux/firmware.h>
 #include "scsi_priv.h"
 #include "scsi_transport_fc_internal.h"
 
@@ -3251,6 +3252,30 @@ fc_vport_sched_delete(struct work_struct *work)
 			vport->channel, stat);
 }
 
+int
+fc_request_wwn(struct Scsi_Host *shost, u64 *wwn)
+{
+	const struct firmware *fw;
+	int stat;
+
+	stat = request_firmware(&fw, "fc_addr", &shost->shost_gendev);
+	if (stat)
+		return stat;
+
+	if (fw->size < 16) {
+		stat = -EINVAL;
+		goto out;
+	}
+
+	stat = fc_parse_wwn(fw->data, wwn);
+	if (stat)
+		return stat;
+
+out:
+	release_firmware(fw);
+	return stat;
+}
+EXPORT_SYMBOL(fc_request_wwn);
 
 /* Original Author:  Martin Hicks */
 MODULE_AUTHOR("James Smart");
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index e466d88..e80c36c 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -734,4 +734,6 @@ void fc_host_post_vendor_event(struct Scsi_Host *shost, u32 event_number,
 	 */
 int fc_vport_terminate(struct fc_vport *vport);
 
+int fc_request_wwn(struct Scsi_Host *, u64 *);
+
 #endif /* SCSI_TRANSPORT_FC_H */
