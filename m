Return-Path: <linux-kernel-owner+w=401wt.eu-S1758629AbYICRsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629AbYICRsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbYICRr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:47:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:58098 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbYICRr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:47:56 -0400
Date: Wed, 3 Sep 2008 10:26:54 -0700
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
       alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>, Martin Michlmayr <tbm@cyrius.com>,
       Mark Lord <liml@rtr.ca>, Artem Bokhan <aptem@ngs.ru>
Subject: [patch 42/42] sata_mv: dont issue two DMA commands concurrently
Message-ID: <20080903172654.GQ7731@suse.de>
References: <20080903171927.534216229@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sata_mv-don-t-issue-two-dma-commands-concurrently.patch"
In-Reply-To: <20080903172447.GA7731@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <htejun@gmail.com>

commit 4bdee6c5103696a2729d3db2f235d202191788e4 upstream

sata_mv allowed issuing two DMA commands concurrently which the
hardware allows.  Unfortunately, libata core layer isn't ready for
this yet and spews ugly warning message and malfunctions on this.
Don't allow concurrent DMA commands for now.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Martin Michlmayr <tbm@cyrius.com>
Cc: Mark Lord <liml@rtr.ca>
Cc: Artem Bokhan <aptem@ngs.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/sata_mv.c |   34 ++++++++++------------------------
 1 file changed, 10 insertions(+), 24 deletions(-)

--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -1134,30 +1134,16 @@ static int mv_qc_defer(struct ata_queued
 	if (ap->nr_active_links == 0)
 		return 0;
 
-	if (pp->pp_flags & MV_PP_FLAG_EDMA_EN) {
-		/*
-		 * The port is operating in host queuing mode (EDMA).
-		 * It can accomodate a new qc if the qc protocol
-		 * is compatible with the current host queue mode.
-		 */
-		if (pp->pp_flags & MV_PP_FLAG_NCQ_EN) {
-			/*
-			 * The host queue (EDMA) is in NCQ mode.
-			 * If the new qc is also an NCQ command,
-			 * then allow the new qc.
-			 */
-			if (qc->tf.protocol == ATA_PROT_NCQ)
-				return 0;
-		} else {
-			/*
-			 * The host queue (EDMA) is in non-NCQ, DMA mode.
-			 * If the new qc is also a non-NCQ, DMA command,
-			 * then allow the new qc.
-			 */
-			if (qc->tf.protocol == ATA_PROT_DMA)
-				return 0;
-		}
-	}
+	/*
+	 * The port is operating in host queuing mode (EDMA) with NCQ
+	 * enabled, allow multiple NCQ commands.  EDMA also allows
+	 * queueing multiple DMA commands but libata core currently
+	 * doesn't allow it.
+	 */
+	if ((pp->pp_flags & MV_PP_FLAG_EDMA_EN) &&
+	    (pp->pp_flags & MV_PP_FLAG_NCQ_EN) && ata_is_ncq(qc->tf.protocol))
+		return 0;
+
 	return ATA_DEFER_PORT;
 }
 

-- 
