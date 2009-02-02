Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbZBBGC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbZBBGC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 01:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbZBBGCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 01:02:18 -0500
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:23641 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751312AbZBBGCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 01:02:17 -0500
X-YMail-OSG: .GZDh8wVM1mkpiqdZb0rhb1mzUJzC8f7fXZ56CE766nSRZrlRLhg6GI3nndJmzU0Ip6bXeZm9GtXL_l4yrs1ak8HAkWhE_wyATFblr5MynpgoBt2QUdsZlonJGDznF.oGdezEA25B8Hw4s3yUsacdqvbKlRUcTmBKonmN3y5IfjGML6ZfXq0ZuJT6I2jC5nXaukdI8l.c6NCuR2_sKSPYvTjif1r1nMbTF42eBuqySFTxBt92UA-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 2/4] [Target_Core_Mod/PERSISTENT_RESERVATIONS]: Fix
	RELATIVE TARGET PORT IDENTIFIER usage
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Ming Zhang <blackmagic02881@gmail.com>,
       Arne Redlich <agr@powerkom-dd.de>,
       "Ross S. W. Walker" <rswwalker@gmail.com>,
       Rafiu Fakunle <rafiu@openfiler.com>, Hannes Reinecke <hare@suse.de>,
       Mike Christie <michaelc@cs.wisc.edu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Date: Sun, 01 Feb 2009 22:01:09 -0800
Message-Id: <1233554470.12375.42.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1a0caf6fad1dc0067b62639b113b59f0046c6781 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Sun, 1 Feb 2009 21:34:07 -0800
Subject: [PATCH 2/4] [Target_Core_Mod/PERSISTENT_RESERVATIONS]: Fix RELATIVE TARGET PORT IDENTIFIER usage

This patch adds the proper usage of RELATIVE TARGET PORT IDENTIFIER to
PRIN READ_FULL_STATUS and ConfigFS under $HBA/$DEV/pr/res_pr_holder_tg_port.

Here is what PRIN READ_FULL_STATUS looks like from the Linux/iSCSI Initiator side:

initiator:# sg_persist --in --read-full-status -v /dev/sde
    inquiry cdb: 12 00 00 00 24 00
  LIO-ORG  IBLOCK  v3.0
  Peripheral device type: disk
    Persistent Reservation In cmd: 5e 03 00 00 00 00 00 20 00 00
  PR generation=0x5
    Key=0x5678efff
      All target ports bit clear
      Relative port address: 0x1
      << Reservation holder >>
      scope: LU_SCOPE,  type: Write Exclusive
      Transport Id of initiator:
        iSCSI world wide unique port id: iqn.1993-08.org.debian:01:2dadf92d0ef

And from the Target_Core_Mod/ConfigFS with LIO-Target v3.0 side:

target:# cat /sys/kernel/config/target/core/iblock_0/lvm_test0/pr/*
SPC-3 Reservation: iSCSI Initiator: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 Reservation: Single Target Port registration
0x00000005
SPC-3 Reservation: iSCSI Target Node Endpoint: iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd
SPC-3 Reservation: Relative Port Identifer Tag: 1 iSCSI Portal Group Tag: 1 iSCSI Logical Unit: 0
SPC-3 PR Registrations:
iSCSI Node: iqn.1993-08.org.debian:01:2dadf92d0ef Key: 0x000000005678efff PRgen: 0x00000004
SPC-3 Reservation Type: Write Exclusive Access
SPC3_PERSISTENT_RESERVATIONS

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_configfs.c |    8 +++++---
 drivers/lio-core/target_core_pr.c       |    8 ++++----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/lio-core/target_core_configfs.c b/drivers/lio-core/target_core_configfs.c
index 0aa633a..08229dd 100644
--- a/drivers/lio-core/target_core_configfs.c
+++ b/drivers/lio-core/target_core_configfs.c
@@ -950,9 +950,11 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_holder_tg_port (
 	len += sprintf(page+len, "SPC-3 Reservation: %s"
 		" Target Node Endpoint: %s\n", tfo->get_fabric_name(),
 		tfo->tpg_get_wwn(se_tpg));      
-	len += sprintf(page+len, "SPC-3 Reservation: Portal"
-		" Identifer Tag: %hu Logical Unit: %u\n",
-		tfo->tpg_get_tag(se_tpg), lun->unpacked_lun);
+	len += sprintf(page+len, "SPC-3 Reservation: Relative Port"
+		" Identifer Tag: %hu %s Portal Group Tag: %hu"
+		" %s Logical Unit: %u\n", lun->lun_sep->sep_rtpi,
+		tfo->get_fabric_name(), tfo->tpg_get_tag(se_tpg),
+		tfo->get_fabric_name(), lun->unpacked_lun);
 	spin_unlock(&dev->dev_reservation_lock);
 
 	return(len);
diff --git a/drivers/lio-core/target_core_pr.c b/drivers/lio-core/target_core_pr.c
index 3b50ff2..0092a8b 100644
--- a/drivers/lio-core/target_core_pr.c
+++ b/drivers/lio-core/target_core_pr.c
@@ -593,7 +593,7 @@ static int core_scsi3_pro_reserve (
 	if (!(pr_reg->pr_reg_all_tg_pt) &&
 	     (pr_reg->pr_reg_tg_pt_lun != se_lun)) {
 		printk(KERN_ERR "SPC-3 PR: Unable to handle RESERVE because"
-			" ALL_TG_PT=0 and RESERVE was not received on same "
+			" ALL_TG_PT=0 and RESERVE was not received on same"
 			" target port as REGISTER\n");
 		return(PYX_TRANSPORT_RESERVATION_CONFLICT);
 	}
@@ -1249,10 +1249,10 @@ static int core_scsi3_pri_read_full_status (se_cmd_t *cmd)
 		 * IDENTIFIER field are not defined by this standard.
 		 */
 		if (!(pr_reg->pr_reg_all_tg_pt)) {
-			u16 tpgt = TPG_TFO(se_tpg)->tpg_get_tag(se_tpg);
+			se_port_t *port = pr_reg->pr_reg_tg_pt_lun->lun_sep;
 
-			buf[off++] = ((tpgt >> 8) & 0xff);
-			buf[off++] = (tpgt & 0xff);
+			buf[off++] = ((port->sep_rtpi >> 8) & 0xff);
+			buf[off++] = (port->sep_rtpi & 0xff);
 		} else
 			off += 2; /* Skip over RELATIVE TARGET PORT IDENTIFER */
 
-- 
1.5.4.1



