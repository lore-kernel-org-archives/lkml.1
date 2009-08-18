Return-Path: <linux-kernel-owner+w=401wt.eu-S1752134AbZHRXWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbZHRXWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 19:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbZHRXWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 19:22:37 -0400
Received: from smtp102.sbc.mail.gq1.yahoo.com ([67.195.15.61]:33955 "HELO
	smtp102.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751245AbZHRXWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 19:22:36 -0400
X-Yahoo-SMTP: RrAacJSswBBjW0Obe5dhTHj7mfiuboERhd4hX4HvWHq2RmBoxiTUVqFaT6p3
X-YMail-OSG: Nvc0lV0VM1mYkpGLmrFf6vrCySISTbYjFNPLeGCVlsfCVMFdhLnmLeNdtmx.Yv7S0HhqzERK9y5XwO1tbjJCFClSBkzB7xVPHX1_Y_9SC6R.xB4j8JQUzHyRtpEqfVh8XB7J8x21F.8KaXeOPS8YQqrdj7g2peiLqu.XSf5BBrUr9xUNLohSRi2hqKSF4plu3byDV6xVQWBum3XAOodgDIwZPUbhd9UF67rQ6X9zCmsgJaxvOo2GouJ9q.JYd5qxaTcJl0Ux4cZCG0t93vewqgd4D_7vHHIik_VG.PkS.HWatI2RKrg0c0O1xfJcplPk7zvSfa2BeX3Gp596lMEqTORSdexY0_VBq8ZPDQ.dQg--
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 3/4] [LIO-Target]: Add ALUA Active/NonOptimized state check
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Alasdair G Kergon <agk@redhat.com>,
       Joel Becker <joel.becker@oracle.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Florian Haas <florian.haas@linbit.com>,
       Philipp Reisner <philipp.reisner@linbit.com>
Content-Type: text/plain
Date: Tue, 18 Aug 2009 16:15:55 -0700
Message-Id: <1250637355.27590.68.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

This patch adds a call to target_core_mod symbol core_alua_check_nonop_delay()
in iscsi_handle_scsi_cmd(), which can optionally call msleep_interruptible() for
ALUA target port group members currently in the Active/NonOptimized primary access
state to allow schedule() to be run for real time iSCSI traffic shaping using
SPC-4 ALUA primitives.

The millisecond sleep interval is changed on a per ALUA target port group basis
in target_core_mod configfs at /sys/kernel/config/target/core/$HBA/$DEV/alua/$TG_PT_GP_NAME/nonop_delay_msecs
which will update the timeout for all members of the ALUA target port group using
generic target_core_mod infrastructure.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/lio-core/iscsi_target.c b/drivers/lio-core/iscsi_target.c
index 3b1e3b7..5d00473 100644
--- a/drivers/lio-core/iscsi_target.c
+++ b/drivers/lio-core/iscsi_target.c
@@ -57,6 +57,7 @@
 #include <iscsi_debug_opcodes.h>
 #include <iscsi_target_core.h>
 #include <target/target_core_base.h>
+#include <target/target_core_alua.h>
 #include <iscsi_target_error.h>
 #include <iscsi_target_datain_values.h>
 #include <iscsi_target_discovery.h>
@@ -1571,7 +1572,11 @@ build_list:
 
 attach_cmd:
 	iscsi_attach_cmd_to_queue(conn, cmd);
-
+	/*
+	 * Check if we need to delay processing because of ALUA
+	 * Active/NonOptimized primary access state..
+	 */
+	core_alua_check_nonop_delay(SE_CMD(cmd));
 	/*
 	 * Check the CmdSN against ExpCmdSN/MaxCmdSN here if
 	 * the Immediate Bit is not set, and no Immediate
-- 
1.5.4.1



