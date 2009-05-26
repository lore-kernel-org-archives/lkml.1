Return-Path: <linux-kernel-owner+w=401wt.eu-S1755143AbZEZNeC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbZEZNeC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 09:34:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbZEZNdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 09:33:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:45861 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbZEZNdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 09:33:52 -0400
Message-ID: <4A1BEFB6.80205@kernel.org>
Date: Tue, 26 May 2009 22:33:42 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Niel Lambrechts <niel.lambrechts@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux.kernel" <linux-kernel@vger.kernel.org>,
       Theodore Tso <tytso@mit.edu>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
References: <clqON-2Xv-7@gated-at.bofh.it>	<clqON-2Xv-9@gated-at.bofh.it>	<clqON-2Xv-11@gated-at.bofh.it>	<clqON-2Xv-13@gated-at.bofh.it>	<clqON-2Xv-15@gated-at.bofh.it>	<clqON-2Xv-17@gated-at.bofh.it>	<clqON-2Xv-19@gated-at.bofh.it>	<clqON-2Xv-5@gated-at.bofh.it>	<cmknZ-8lW-9@gated-at.bofh.it>	<cmoBl-6Ok-21@gated-at.bofh.it>	<cmp4n-7rb-15@gated-at.bofh.it>	<cmsYg-5BR-27@gated-at.bofh.it>	<cmvW7-1Yj-23@gated-at.bofh.it>	<cnheh-3vO-7@gated-at.bofh.it>	<cnPg1-7Q4-19@gated-at.bofh.it>	<cnTWo-7bV-25@gated-at.bofh.it>	<co1Kd-350-5@gated-at.bofh.it>	<co2Qf-4QQ-27@gated-at.bofh.it>	<co4yj-7Mc-5@gated-at.bofh.it>	<cp71c-4py-29@gated-at.bofh.it>	<cEVyE-re-1@gated-at.bofh.it>	<4A17C39E.2030302@gmail.com>	<4A19F006.3000303@kernel.org> <20090525091534.13ae103c@lxorguk.ukuu.org.uk> <4A1B164B.1010108@gmail.com> <4A1B76EB.9040500@kernel.org> <4A1B8193.1010703@gmail.com> <4A1B8328.80801@kernel.org> <4A1B8873.1040101@gmail.com>
In-Reply-To: <4A1B8873.1040101@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------050901030802060504010700"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 13:33:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050901030802060504010700
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Niel Lambrechts wrote:
> If you send some patches I'll make every effort to test, it beats having
> to re-install, my installation is just too customized. :)

First, let's make sure we aren't balking up the wrong tree.  Can you
please apply the attached patch and report the kernel log?

Thanks.

-- 
tejun

--------------050901030802060504010700
Content-Type: text/x-patch;
 name="noretry-dbg.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="noretry-dbg.patch"

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 0c2c73b..d92f98c 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1223,19 +1223,31 @@ static void scsi_eh_offline_sdevs(struct list_head *work_q,
  */
 int scsi_noretry_cmd(struct scsi_cmnd *scmd)
 {
+	printk("XXX scmd->result=0x%x ff_t=%d ff_dev=%d ff_drv=%d\n",
+	       scmd->result, blk_failfast_transport(scmd->request),
+	       blk_failfast_dev(scmd->request),
+	       blk_failfast_driver(scmd->request));
+
 	switch (host_byte(scmd->result)) {
 	case DID_OK:
+		printk("XXX DID_OK\n");
 		break;
 	case DID_BUS_BUSY:
+		printk("XXX DID_BUS_BUSY, returning ff_t\n");
 		return blk_failfast_transport(scmd->request);
 	case DID_PARITY:
+		printk("XXX DID_PARITY, returning ff_dev\n");
 		return blk_failfast_dev(scmd->request);
 	case DID_ERROR:
+		printk("XXX DID_ERROR\n");
 		if (msg_byte(scmd->result) == COMMAND_COMPLETE &&
-		    status_byte(scmd->result) == RESERVATION_CONFLICT)
+		    status_byte(scmd->result) == RESERVATION_CONFLICT) {
+			printk("XXX RESERVATION_CONFLICT\n");
 			return 0;
+		}
 		/* fall through */
 	case DID_SOFT_ERROR:
+		printk("XXX DID_SOFT_ERROR, returning ff_drv\n");
 		return blk_failfast_driver(scmd->request);
 	}
 
@@ -1245,9 +1257,11 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
 		 * assume caller has checked sense and determinted
 		 * the check condition was retryable.
 		 */
+		printk("XXX CHECK_CONDITION, returning ff_dev\n");
 		return blk_failfast_dev(scmd->request);
 	}
 
+	printk("XXX returning 0\n");
 	return 0;
 }
 

--------------050901030802060504010700--
