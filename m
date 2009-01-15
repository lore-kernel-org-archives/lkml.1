Return-Path: <linux-kernel-owner+w=401wt.eu-S934381AbZAOUzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934381AbZAOUzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932361AbZAOUDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:03:16 -0500
Received: from kroah.org ([198.145.64.141]:49866 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765878AbZAOUDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:03:07 -0500
Date: Thu, 15 Jan 2009 12:00:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Brian King <brking@linux.vnet.ibm.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 90/94] [SCSI] ibmvfc: Delay NPIV login retry and add retries
Message-ID: <20090115200042.GL14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ibmvfc-delay-npiv-login-retry-and-add-retries.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Brian King <brking@linux.vnet.ibm.com>

commit 1c41fa8288277e76785acb50f52bb2f39509f903 upstream.

Adds a delay prior to retrying a failed NPIV login. This fixes
a scenario if the backing fibre channel adapter is getting reset
due to an EEH event, NPIV login will fail. Currently, ibmvfc
retries three times very quickly, resets the CRQ and tries one
more time. If the adapter is getting reset due to EEH, this isn't
enough time. This adds a delay prior to retrying a failed NPIV
login and also increments the number of retries.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/ibmvscsi/ibmvfc.c |   17 ++++++++++++-----
 drivers/scsi/ibmvscsi/ibmvfc.h |    4 +++-
 2 files changed, 15 insertions(+), 6 deletions(-)

--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -566,7 +566,7 @@ static void ibmvfc_init_host(struct ibmv
 	struct ibmvfc_target *tgt;
 
 	if (vhost->action == IBMVFC_HOST_ACTION_INIT_WAIT) {
-		if (++vhost->init_retries > IBMVFC_MAX_INIT_RETRIES) {
+		if (++vhost->init_retries > IBMVFC_MAX_HOST_INIT_RETRIES) {
 			dev_err(vhost->dev,
 				"Host initialization retries exceeded. Taking adapter offline\n");
 			ibmvfc_link_down(vhost, IBMVFC_HOST_OFFLINE);
@@ -847,11 +847,12 @@ static void ibmvfc_reset_host(struct ibm
 static void ibmvfc_retry_host_init(struct ibmvfc_host *vhost)
 {
 	if (vhost->action == IBMVFC_HOST_ACTION_INIT_WAIT) {
-		if (++vhost->init_retries > IBMVFC_MAX_INIT_RETRIES) {
+		vhost->delay_init = 1;
+		if (++vhost->init_retries > IBMVFC_MAX_HOST_INIT_RETRIES) {
 			dev_err(vhost->dev,
 				"Host initialization retries exceeded. Taking adapter offline\n");
 			ibmvfc_link_down(vhost, IBMVFC_HOST_OFFLINE);
-		} else if (vhost->init_retries == IBMVFC_MAX_INIT_RETRIES)
+		} else if (vhost->init_retries == IBMVFC_MAX_HOST_INIT_RETRIES)
 			__ibmvfc_reset_host(vhost);
 		else
 			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_INIT);
@@ -2669,7 +2670,7 @@ static void ibmvfc_init_tgt(struct ibmvf
 static void ibmvfc_retry_tgt_init(struct ibmvfc_target *tgt,
 				  void (*job_step) (struct ibmvfc_target *))
 {
-	if (++tgt->init_retries > IBMVFC_MAX_INIT_RETRIES) {
+	if (++tgt->init_retries > IBMVFC_MAX_TGT_INIT_RETRIES) {
 		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
 		wake_up(&tgt->vhost->work_wait_q);
 	} else
@@ -3519,7 +3520,13 @@ static void ibmvfc_do_work(struct ibmvfc
 		break;
 	case IBMVFC_HOST_ACTION_INIT:
 		BUG_ON(vhost->state != IBMVFC_INITIALIZING);
-		vhost->job_step(vhost);
+		if (vhost->delay_init) {
+			vhost->delay_init = 0;
+			spin_unlock_irqrestore(vhost->host->host_lock, flags);
+			ssleep(5);
+			return;
+		} else
+			vhost->job_step(vhost);
 		break;
 	case IBMVFC_HOST_ACTION_QUERY:
 		list_for_each_entry(tgt, &vhost->targets, queue)
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -43,7 +43,8 @@
 #define IBMVFC_MAX_DISC_THREADS	4
 #define IBMVFC_TGT_MEMPOOL_SZ		64
 #define IBMVFC_MAX_CMDS_PER_LUN	64
-#define IBMVFC_MAX_INIT_RETRIES	3
+#define IBMVFC_MAX_HOST_INIT_RETRIES	6
+#define IBMVFC_MAX_TGT_INIT_RETRIES		3
 #define IBMVFC_DEV_LOSS_TMO		(5 * 60)
 #define IBMVFC_DEFAULT_LOG_LEVEL	2
 #define IBMVFC_MAX_CDB_LEN		16
@@ -671,6 +672,7 @@ struct ibmvfc_host {
 	int discovery_threads;
 	int client_migrated;
 	int reinit;
+	int delay_init;
 	int events_to_log;
 #define IBMVFC_AE_LINKUP	0x0001
 #define IBMVFC_AE_LINKDOWN	0x0002

