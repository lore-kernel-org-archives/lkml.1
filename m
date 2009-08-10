Return-Path: <linux-kernel-owner+w=401wt.eu-S932326AbZHJRRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326AbZHJRRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 13:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932207AbZHJRRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 13:17:00 -0400
Received: from n17.bullet.mail.mud.yahoo.com ([68.142.206.144]:36317 "HELO
	n17.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932197AbZHJRQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 13:16:59 -0400
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Aug 2009 13:16:59 EDT
X-Yahoo-Newman-Id: 36017.72155.bm@omp412.mail.mud.yahoo.com
X-YMail-OSG: pyBrh8sVM1nyp.p7YEI83CrsDqbA9Sp.ird14az7kKD1aeJcACb4BGvpxpFCZ5EeVmx3xJhEPH9ANL7YiHLUww5DENuL_mpgzxTwLYd3n8YzsFkNDRdvAUROEof_qNqoqrSexV78MdecPM6AXMOju5oGQO4sLHtXDxz7xCB1aeaYuCrMfpdY41Ue6vJoU7GS7AX5yprbpJP_YUnfu.HzSOU0UYoJwvluILXTxr7g502Dkaz6qm_ttA8j3x_i1YCXxm9nxNvzFVbWE70ALKhf5sjYz5N8QEQF
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 0/2] [Target_Core_Mod]: Add hyrid PR APTPL/ConfigFS support.
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joel Becker <joel.becker@oracle.com>,
       James Smart <James.Smart@Emulex.Com>,
       Philipp Reisner <philipp.reisner@linbit.com>,
       Florian Haas <florian.haas@linbit.com>
Content-Type: text/plain
Date: Mon, 10 Aug 2009 10:06:41 -0700
Message-Id: <1249924001.11105.282.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings folks,

This patch adds complete running support for persistent reservations feature:
Activate Persist across Target Power Loss (APTPL) against all of spc4r17
defined PROUT service actions in lio-core-2.6.git.  This patch has been tested with
PROUT service actions REGISTER, RESERVE, RELEASE, CLEAR, PREEMPT_AND_ABORT and
REGISTER_AND_MOVE (restarting the entire target configfs fabric each step and rebuilding)
from a IBLOCK exported LVM dm block device on v2.6.31-rc5 x86 HVM.

These patches uses a approach that writes out PR metadata in key-value pairs via a pre-allocated
buffer using fabric module dependent code during the various APTPL commit points while running
PROUT service action logic to struct file in /var/target/pr/aptpl_$T10_UNIT_SERIAL.  It then parses
the key=value pairs and makes them comma seperated values in userspace and then into configfs via
/sys/kernel/config/target/core/$HBA/$DEV/pr/res_aptpl_metadata.  From there the PR registrations+reservation
are checked and processed as fabric module LUN ACLs are created with matching PR APTPL metadata as the
configfs fabric is rebuilt upon normal target setup, and put into effect using existing
drivers/target/target_core_pr.c code.

Here is what it looks like with a initial set of REGISTER -> RESERVE ->
PREEMPT_AND_ABORT -> REGISTER_AND_MOVE calls with then /etc/init.d/target restart
using a dm LVM block device exported via TCM+LIO-Target iSCSI ports on v2.6.31-rc5 x86 HVM.
Here is what it looks like after successfully completing the REGISTER_AND_MOVE with APTPL=1

*) Metadata gets parsed with tcm_node.py --praptpl and written to configfs on restart:

<SNIP>

    Target_Core_ConfigFS: Set emulated VPD Unit Serial: a97e4ce21c0711de829b000c2943d57b
    T10 VPD Page Length: 72
    T10 VPD Identifer Length: 16
    T10 VPD Identifier Association: addressed logical unit
    T10 VPD Identifier Type: NAA
    T10 VPD Binary Device Identifier: 36001405a97e4ce21c0711de829b000c2
    T10 VPD Identifer Length: 48
    T10 VPD Identifier Association: addressed logical unit
    T10 VPD Identifier Type: T10 Vendor ID based
    T10 VPD ASCII Device Identifier: LIO-ORG
    SPC-3 PR APTPL Successfully added registration from metadata
    SPC-3 PR APTPL Successfully added registration+reservation from metadata

*) As fabric module initiator LUN ACLs get added (iSCSI Initiator LUN access in LIO-Target's case),
   the PR operations take effect:

<SNIP>

   LIO_Target_ConfigFS: Initialized Initiator LUN ACL: iqn.1993-08.org.debian:01:2dadf92d0ef Mapped LUN: lun_0
   iSCSI_TPG[1]_LUN[0->0] - Added RW ACL for  InitiatorNode: iqn.1993-08.org.debian:01:2dadf92d0ef
   SPC-3 PR [iSCSI] Service Action: REGISTER Initiator Node: iqn.1993-08.org.debian:01:2dadf92d0ef
   SPC-3 PR [iSCSI] for SINGLE TCM Subsystem iblock Object Target Port(s)
   SPC-3 PR [iSCSI] SA Res Key: 0x000000005678ffff PRgeneration: 0x00000000  APTPL: 1
   LIO_Target_ConfigFS: Created Initiator LUN ACL Symlink: iqn.1993-08.org.debian:01:2dadf92d0ef TPG LUN: lun_0 Mapped LUN: lun_0 Write Protect: OFF

<SNIP>

   LIO_Target_ConfigFS: Initialized Initiator LUN ACL: iqn.1996-04.de.suse:01:1661f9ee7b5 Mapped LUN: lun_0
   iSCSI_TPG[1]_LUN[0->0] - Added RW ACL for  InitiatorNode: iqn.1996-04.de.suse:01:1661f9ee7b5
   SPC-3 PR [iSCSI] Service Action: REGISTER Initiator Node: iqn.1996-04.de.suse:01:1661f9ee7b5
   SPC-3 PR [iSCSI] for SINGLE TCM Subsystem iblock Object Target Port(s)
   SPC-3 PR [iSCSI] SA Res Key: 0x000000005678ffff PRgeneration: 0x00000001  APTPL: 1
   SPC-3 PR [iSCSI] Service Action: APTPL RESERVE created new reservation holder TYPE: Write Exclusive Access, Registants Only ALL_TG_PT: 0
   SPC-3 PR [iSCSI] RESERVE Node: iqn.1996-04.de.suse:01:1661f9ee7b5
   LIO_Target_ConfigFS: Created Initiator LUN ACL Symlink: iqn.1996-04.de.suse:01:1661f9ee7b5 TPG LUN: lun_0 Mapped LUN: lun_0 Write Protect: OFF

*) Now check the running 'live' PR metadata, the saved APTPL metadata has been successfully reloaded:

   target# tcm_node --pr iblock_0/lvm_test0
   APTPL Bit Status: Activated
   Ready to process PR APTPL metadata..
   SPC-3 Reservation: iSCSI Initiator: iqn.1996-04.de.suse:01:1661f9ee7b5
   SPC-3 Reservation: Single Target Port registration
   0x00000002
   SPC-3 Reservation: iSCSI Target Node Endpoint: iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0
   SPC-3 Reservation: Relative Port Identifer Tag: 2 iSCSI Portal Group Tag: 1 iSCSI Logical Unit: 0
   SPC-3 PR Registrations:
   iSCSI Node: iqn.1993-08.org.debian:01:2dadf92d0ef Key: 0x000000005678ffff PRgen: 0x00000000
   iSCSI Node: iqn.1996-04.de.suse:01:1661f9ee7b5 Key: 0x000000005678ffff PRgen: 0x00000001
   SPC-3 Reservation Type: Write Exclusive Access, Registrants Only
   SPC3_PERSISTENT_RESERVATIONS

*) And finally from the initiator, check PROUT REPORT_CAPABILITIES for APTPL_C and APTPL_A:

   initiator# sg_persist --in --device /dev/sde --report-capabilities
      LIO-ORG  IBLOCK  3.0
      Peripheral device type: disk
    Report capabilities response:
     Compatible Reservation Handling(CRH): 0
     Specify Initiator Ports Capable(SIP_C): 1
     All Target Ports Capable(ATP_C): 1
     Persist Through Power Loss Capable(PTPL_C): 1
     Type Mask Valid(TMV): 1
     Allow commands: 1
         Persist Through Power Loss Active(PTPL_A): 1
           Support indicated in Type mask:
         Write Exclusive, all registrants: 1
         Exclusive Access, registrants only: 1
         Write Exclusive, registrants only: 1
         Exclusive Access: 1
         Write Exclusive: 1
         Exclusive Access, all registrants: 1


Also, the userspace commits to make it all go can be found at:

http://git.kernel.org/?p=linux/storage/lio/lio-utils.git;a=commitdiff;h=59269840555e04725f2a7b2f4998ba237fb49ccc

Comments..?

--nab



