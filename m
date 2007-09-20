Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbXITVK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbXITVK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 17:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbXITVKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 17:10:12 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57594 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbXITVKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 17:10:10 -0400
Date: Thu, 20 Sep 2007 14:10:15 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: linux-scsi <linux-scsi@vger.kernel.org>, mpt_linux_developer@lsi.com,
       Eric.Moore@lsi.com, support@lsi.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mptbase: Reset ioc initiator during PCI resume
Message-ID: <20070920211014.GA24047@tree.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It appears that the LSI SAS 1064E chip needs to be reset after a
suspend/resume cycle before the driver attempts further communications with
the chip.  Without this patch, resuming the chip results in this error
message being printed repeatedly and no more disk I/O.

mptbase: ioc0: ERROR - Invalid IOC facts reply, msgLength=0 offsetof=6!

So far it seems to fix suspend/resume on all the MPT Fusion cards I have
(SAS and U320 SCSI) but since I don't know the internals of that chip I
can't say for sure if this is a proper fix.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/message/fusion/mptbase.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 414c109..97895bd 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1772,6 +1772,12 @@ mpt_resume(struct pci_dev *pdev)
 		(mpt_GetIocState(ioc, 1) >> MPI_IOC_STATE_SHIFT),
 		CHIPREG_READ32(&ioc->chip->Doorbell));
 
+	/* put ioc into READY_STATE */
+	if(SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, CAN_SLEEP)) {
+		printk(MYIOC_s_ERR_FMT
+		"pci-resume:  IOC msg unit reset failed!\n", ioc->name);
+	}
+
 	/* bring ioc to operational state */
 	if ((recovery_state = mpt_do_ioc_recovery(ioc,
 	    MPT_HOSTEVENT_IOC_RECOVER, CAN_SLEEP)) != 0) {
