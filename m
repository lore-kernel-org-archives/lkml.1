Return-Path: <linux-kernel-owner+w=401wt.eu-S964975AbZIEA3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964975AbZIEA3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934649AbZIEA3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:29:01 -0400
Received: from kroah.org ([198.145.64.141]:42205 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934586AbZIEAVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:21:07 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:54 2009
Message-Id: <20090905001453.850141328@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kashyap Desai <kashyap.desai@lsi.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [patch 42/71] SCSI: mpt2sas: fix infinite loop inside config request
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=scsi-mpt2sas-fix-infinite-loop-inside-config-request.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Kashyap, Desai <kashyap.desai@lsi.com>

commit 6bd4e1e4d6023f4da069fd68729c502cc4e6dfd0 upstream.

This restriction is introduced just to avoid loop of
config_request. Retry must be limited so we have restricted
config request to maximum 2 times.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/drivers/scsi/mpt2sas/mpt2sas_config.c b/drivers/scsi/mpt2sas/mpt2sas_config.c
index 58cfb97..1c6658c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_config.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_config.c
@@ -247,6 +247,12 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	retry_count = 0;
 
  retry_config:
+	if (retry_count) {
+		if (retry_count > 2) /* attempt only 2 retries */
+			return -EFAULT;
+		printk(MPT2SAS_INFO_FMT "%s: attempting retry (%d)\n",
+		    ioc->name, __func__, retry_count);
+	}
 	wait_state_count = 0;
 	ioc_state = mpt2sas_base_get_iocstate(ioc, 1);
 	while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {


