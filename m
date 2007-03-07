Return-Path: <linux-kernel-owner+w=401wt.eu-S1422879AbXCGRRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422879AbXCGRRG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:17:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422822AbXCGRQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:16:45 -0500
Received: from cantor.suse.de ([195.135.220.2]:43954 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422821AbXCGRP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:15:57 -0500
Message-Id: <20070307171420.085896145@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Jeff Garzik <jeff@garzik.org>, <linux-ide@vger.kernel.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Tejun Heo <htejun@gmail.com>
Subject: [patch 055/101] sata_sil: ignore and clear spurious IRQs while executing commands by polling
Content-Disposition: inline; filename=sata_sil-ignore-and-clear-spurious-irqs-while-executing-commands-by-polling.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


sata_sil used to trigger HSM error if IRQ occurs during polling
command.  This didn't matter because polling wasn't used in sata_sil.
However, as of 2.6.20, all IDENTIFYs are performed by polling and
device detection sometimes fails due to spurious IRQ.  This patch
makes sata_sil ignore and clear spurious IRQ while executing commands
by polling.

This fixes bug#7996 and IMHO should also be included in -stable.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/sata_sil.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- linux-2.6.20.1.orig/drivers/ata/sata_sil.c
+++ linux-2.6.20.1/drivers/ata/sata_sil.c
@@ -383,9 +383,15 @@ static void sil_host_intr(struct ata_por
 		goto freeze;
 	}
 
-	if (unlikely(!qc || qc->tf.ctl & ATA_NIEN))
+	if (unlikely(!qc))
 		goto freeze;
 
+	if (unlikely(qc->tf.flags & ATA_TFLAG_POLLING)) {
+		/* this sometimes happens, just clear IRQ */
+		ata_chk_status(ap);
+		return;
+	}
+
 	/* Check whether we are expecting interrupt in this state */
 	switch (ap->hsm_task_state) {
 	case HSM_ST_FIRST:

--
