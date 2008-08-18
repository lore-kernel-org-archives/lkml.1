Return-Path: <linux-kernel-owner+w=401wt.eu-S1759140AbYHRTMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759140AbYHRTMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756474AbYHRTHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:07:05 -0400
Received: from ns1.suse.de ([195.135.220.2]:44417 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932784AbYHRTHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:07:03 -0400
Date: Mon, 18 Aug 2008 11:45:35 -0700
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
       alan@lxorguk.ukuu.org.uk, Andrew Vasquez <andrew.vasquez@qlogic.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 55/60] qla2xxx: Set an rports dev_loss_tmo value in a
	consistent manner.
Message-ID: <20080818184535.GD29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="qla2xxx-set-an-rport-s-dev_loss_tmo-value-in-a-consistent-manner.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Andrew Vasquez <andrew.vasquez@qlogic.com>

[ Upstream commit 85821c906cf3563a00a3d98fa380a2581a7a5ff1 ]

As there's no point in adding a fixed-fudge value (originally 5
seconds), honor the user settings only.  We also remove the
driver's dead-callback get_rport_dev_loss_tmo function
(qla2x00_get_rport_loss_tmo()).

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/qla2xxx/qla_attr.c |   20 ++------------------
 drivers/scsi/qla2xxx/qla_os.c   |    2 +-
 2 files changed, 3 insertions(+), 19 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -972,26 +972,12 @@ qla2x00_get_starget_port_id(struct scsi_
 }
 
 static void
-qla2x00_get_rport_loss_tmo(struct fc_rport *rport)
-{
-	struct Scsi_Host *host = rport_to_shost(rport);
-	scsi_qla_host_t *ha = shost_priv(host);
-
-	rport->dev_loss_tmo = ha->port_down_retry_count + 5;
-}
-
-static void
 qla2x00_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout)
 {
-	struct Scsi_Host *host = rport_to_shost(rport);
-	scsi_qla_host_t *ha = shost_priv(host);
-
 	if (timeout)
-		ha->port_down_retry_count = timeout;
+		rport->dev_loss_tmo = timeout;
 	else
-		ha->port_down_retry_count = 1;
-
-	rport->dev_loss_tmo = ha->port_down_retry_count + 5;
+		rport->dev_loss_tmo = 1;
 }
 
 static void
@@ -1275,7 +1261,6 @@ struct fc_function_template qla2xxx_tran
 	.get_starget_port_id  = qla2x00_get_starget_port_id,
 	.show_starget_port_id = 1,
 
-	.get_rport_dev_loss_tmo = qla2x00_get_rport_loss_tmo,
 	.set_rport_dev_loss_tmo = qla2x00_set_rport_loss_tmo,
 	.show_rport_dev_loss_tmo = 1,
 
@@ -1320,7 +1305,6 @@ struct fc_function_template qla2xxx_tran
 	.get_starget_port_id  = qla2x00_get_starget_port_id,
 	.show_starget_port_id = 1,
 
-	.get_rport_dev_loss_tmo = qla2x00_get_rport_loss_tmo,
 	.set_rport_dev_loss_tmo = qla2x00_set_rport_loss_tmo,
 	.show_rport_dev_loss_tmo = 1,
 
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1107,7 +1107,7 @@ qla2xxx_slave_configure(struct scsi_devi
 	else
 		scsi_deactivate_tcq(sdev, ha->max_q_depth);
 
-	rport->dev_loss_tmo = ha->port_down_retry_count + 5;
+	rport->dev_loss_tmo = ha->port_down_retry_count;
 
 	return 0;
 }

-- 
