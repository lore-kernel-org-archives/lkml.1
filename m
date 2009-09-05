Return-Path: <linux-kernel-owner+w=401wt.eu-S934674AbZIEA3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934674AbZIEA3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934559AbZIEA3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:29:45 -0400
Received: from kroah.org ([198.145.64.141]:42223 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934516AbZIEAVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:21:06 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:53 2009
Message-Id: <20090905001453.693568507@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kashyap Desai <kashyap.desai@lsi.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [patch 41/71] SCSI: mpt2sas: Excessive log info causes sas iounit page time out
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=scsi-mpt2sas-excessive-log-info-causes-sas-iounit-page-time-out.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Kashyap, Desai <kashyap.desai@lsi.com>

commit be9e8cd75ce8d94ae4aab721fdcc337fa78a9090 upstream.

Inhibit 0x3117 loginfos - during cable pull, there are too many printks going
to the syslog, this is have impact on how fast the interrupt routine can handle
keeping up with command completions; this was the root cause to the config
pages timeouts.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/mpt2sas/mpt2sas_base.c  |    4 ++++
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    4 ++++
 2 files changed, 8 insertions(+)

--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -440,6 +440,10 @@ _base_sas_log_info(struct MPT2SAS_ADAPTE
 	if (sas_loginfo.dw.bus_type != 3 /*SAS*/)
 		return;
 
+	/* each nexus loss loginfo */
+	if (log_info == 0x31170000)
+		return;
+
 	/* eat the loginfos associated with task aborts */
 	if (ioc->ignore_loginfos && (log_info == 30050000 || log_info ==
 	    0x31140000 || log_info == 0x31130000))
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2560,6 +2560,10 @@ _scsih_scsi_ioc_info(struct MPT2SAS_ADAP
 	char *desc_ioc_state = NULL;
 	char *desc_scsi_status = NULL;
 	char *desc_scsi_state = ioc->tmp_string;
+	u32 log_info = le32_to_cpu(mpi_reply->IOCLogInfo);
+
+	if (log_info == 0x31170000)
+		return;
 
 	switch (ioc_status) {
 	case MPI2_IOCSTATUS_SUCCESS:


