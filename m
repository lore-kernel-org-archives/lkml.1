Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbXC3VJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbXC3VJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753965AbXC3VJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:09:36 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58200 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966AbXC3VJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:09:34 -0400
Date: Fri, 30 Mar 2007 14:03:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Robert Hancock <hancockr@shaw.ca>,
       Jeff Garzik <jeff@garzik.org>
Subject: [patch 03/37] sata_nv: delay on switching between NCQ and non-NCQ
	commands
Message-ID: <20070330210357.GD29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sata_nv-delay-on-switching-between-ncq-and-non-ncq-commands.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Robert Hancock <hancockr@shaw.ca>

sata_nv: delay on switching between NCQ and non-NCQ commands

This patch appears to solve some problems with commands timing out in
cases where an NCQ command is immediately followed by a non-NCQ command
(or possibly vice versa). This is a rather ugly solution, but until we
know more about why this is needed, this is about all we can do.

[backport to 2.6.20 by Chuck Ebbert <cebbert@redhat.com>]

Signed-off-by: Robert Hancock <hancockr@shaw.ca>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/ata/sata_nv.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -214,6 +214,7 @@ struct nv_adma_port_priv {
 	struct nv_adma_prd	*aprd;
 	dma_addr_t		aprd_dma;
 	u8			flags;
+	int			last_issue_ncq;
 };
 
 #define NV_ADMA_CHECK_INTR(GCTL, PORT) ((GCTL) & ( 1 << (19 + (12 * (PORT)))))
@@ -1151,6 +1152,7 @@ static unsigned int nv_adma_qc_issue(str
 {
 	struct nv_adma_port_priv *pp = qc->ap->private_data;
 	void __iomem *mmio = nv_adma_ctl_block(qc->ap);
+	int curr_ncq = (qc->tf.protocol == ATA_PROT_NCQ);
 
 	VPRINTK("ENTER\n");
 
@@ -1166,6 +1168,14 @@ static unsigned int nv_adma_qc_issue(str
 	/* write append register, command tag in lower 8 bits
 	   and (number of cpbs to append -1) in top 8 bits */
 	wmb();
+
+	if(curr_ncq != pp->last_issue_ncq) {
+	   	/* Seems to need some delay before switching between NCQ and non-NCQ
+		   commands, else we get command timeouts and such. */
+		udelay(20);
+		pp->last_issue_ncq = curr_ncq;
+	}
+
 	writew(qc->tag, mmio + NV_ADMA_APPEND);
 
 	DPRINTK("Issued tag %u\n",qc->tag);

-- 
