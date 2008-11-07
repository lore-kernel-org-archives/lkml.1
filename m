Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbYKGQnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbYKGQnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 11:43:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbYKGQmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 11:42:55 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:38636 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbYKGQmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 11:42:54 -0500
From: Joachim Fenkes <fenkes@de.ibm.com>
To: LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       OF-General <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, OF-EWG <ewg@lists.openfabrics.org>
Subject: [PATCH] IB/ehca: Fix suppression of port activation events
User-Agent: KMail/1.9.1
Cc: Stefan Roscher <stefan.roscher@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Alexander Schmidt <alexschm@de.ibm.com>
References: <200806061835.43802.fenkes@de.ibm.com> <48499C11.7030504@gmail.com>
In-Reply-To: <48499C11.7030504@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2361
Date: Fri, 7 Nov 2008 17:42:51 +0100
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200811071742.51867.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A previous fix introduced a regression where port activation events were
dropped unconditionally if port autodetection was not enabled. Fixed.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---

Roland -- this patch is made against your for-linus branch. Please review
and apply if you think it's okay. Hope it's not too late for the next kernel.

Joachim

 drivers/infiniband/hw/ehca/ehca_irq.c |   45 +++++++++++++++++++-------------
 1 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index 9e43459..757035e 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -359,34 +359,43 @@ static void notify_port_conf_change(struct ehca_shca *shca, int port_num)
 	*old_attr = new_attr;
 }
 
+/* replay modify_qp for sqps -- return 0 if all is well, 1 if AQP1 destroyed */
+static int replay_modify_qp(struct ehca_sport *sport)
+{
+	int aqp1_destroyed;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sport->mod_sqp_lock, flags);
+
+	aqp1_destroyed = !sport->ibqp_sqp[IB_QPT_GSI];
+
+	if (sport->ibqp_sqp[IB_QPT_SMI])
+		ehca_recover_sqp(sport->ibqp_sqp[IB_QPT_SMI]);
+	if (!aqp1_destroyed)
+		ehca_recover_sqp(sport->ibqp_sqp[IB_QPT_GSI]);
+
+	spin_unlock_irqrestore(&sport->mod_sqp_lock, flags);
+
+	return aqp1_destroyed;
+}
+
 static void parse_ec(struct ehca_shca *shca, u64 eqe)
 {
 	u8 ec   = EHCA_BMASK_GET(NEQE_EVENT_CODE, eqe);
 	u8 port = EHCA_BMASK_GET(NEQE_PORT_NUMBER, eqe);
 	u8 spec_event;
 	struct ehca_sport *sport = &shca->sport[port - 1];
-	unsigned long flags;
 
 	switch (ec) {
 	case 0x30: /* port availability change */
 		if (EHCA_BMASK_GET(NEQE_PORT_AVAILABILITY, eqe)) {
-			/* only for autodetect mode important */
-			if (ehca_nr_ports >= 0)
-				break;
-
-			int suppress_event;
-			/* replay modify_qp for sqps */
-			spin_lock_irqsave(&sport->mod_sqp_lock, flags);
-			suppress_event = !sport->ibqp_sqp[IB_QPT_GSI];
-			if (sport->ibqp_sqp[IB_QPT_SMI])
-				ehca_recover_sqp(sport->ibqp_sqp[IB_QPT_SMI]);
-			if (!suppress_event)
-				ehca_recover_sqp(sport->ibqp_sqp[IB_QPT_GSI]);
-			spin_unlock_irqrestore(&sport->mod_sqp_lock, flags);
-
-			/* AQP1 was destroyed, ignore this event */
-			if (suppress_event)
-				break;
+			/* only replay modify_qp calls in autodetect mode;
+			 * if AQP1 was destroyed, the port is already down
+			 * again and we can drop the event.
+			 */
+			if (ehca_nr_ports < 0)
+				if (replay_modify_qp(sport))
+					break;
 
 			sport->port_state = IB_PORT_ACTIVE;
 			dispatch_port_event(shca, port, IB_EVENT_PORT_ACTIVE,
-- 
1.5.5




