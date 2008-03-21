Return-Path: <linux-kernel-owner+w=401wt.eu-S933160AbYCUXRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160AbYCUXRn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932300AbYCUXD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 19:03:27 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55357 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932289AbYCUXDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 19:03:25 -0400
Message-Id: <20080321224356.773615847@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:19 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 29/76] SCSI aic94xx: fix REQ_TASK_ABORT and REQ_DEVICE_RESET
Content-Disposition: inline; filename=scsi-aic94xx-fix-req_task_abort-and-req_device_reset.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: James Bottomley <James.Bottomley@HansenPartnership.com>

This driver has been failing under heavy load with

aic94xx: escb_tasklet_complete: REQ_TASK_ABORT, reason=0x6
aic94xx: escb_tasklet_complete: Can't find task (tc=4) to abort!

The second message is because the driver fails to identify the task
it's being asked to abort.  On closer inpection, there's a thinko in
the for each task loop over pending tasks in both the REQ_TASK_ABORT
and REQ_DEVICE_RESET cases where it doesn't look at the task on the
pending list but at the one on the ESCB (which is always NULL).

Fix by looking at the right task.  Also add a print for the case where
the pending SCB doesn't have a task attached.

Not sure if this will fix all the problems, but it's a definite first
step.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/scsi/aic94xx/aic94xx_scb.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/scsi/aic94xx/aic94xx_scb.c
+++ b/drivers/scsi/aic94xx/aic94xx_scb.c
@@ -458,13 +458,19 @@ static void escb_tasklet_complete(struct
 		tc_abort = le16_to_cpu(tc_abort);
 
 		list_for_each_entry_safe(a, b, &asd_ha->seq.pend_q, list) {
-			struct sas_task *task = ascb->uldd_task;
+			struct sas_task *task = a->uldd_task;
+
+			if (a->tc_index != tc_abort)
+				continue;
 
-			if (task && a->tc_index == tc_abort) {
+			if (task) {
 				failed_dev = task->dev;
 				sas_task_abort(task);
-				break;
+			} else {
+				ASD_DPRINTK("R_T_A for non TASK scb 0x%x\n",
+					    a->scb->header.opcode);
 			}
+			break;
 		}
 
 		if (!failed_dev) {
@@ -478,7 +484,7 @@ static void escb_tasklet_complete(struct
 		 * that the EH will wake up and do something.
 		 */
 		list_for_each_entry_safe(a, b, &asd_ha->seq.pend_q, list) {
-			struct sas_task *task = ascb->uldd_task;
+			struct sas_task *task = a->uldd_task;
 
 			if (task &&
 			    task->dev == failed_dev &&

-- 
