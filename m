Return-Path: <linux-kernel-owner+w=401wt.eu-S1761358AbYG3Xih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761358AbYG3Xih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 19:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761286AbYG3XiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 19:38:09 -0400
Received: from ns1.suse.de ([195.135.220.2]:35874 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760896AbYG3XiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 19:38:07 -0400
Date: Wed, 30 Jul 2008 16:27:17 -0700
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
       alan@lxorguk.ukuu.org.uk, Jeff Garzik <jgarzik@redhat.com>,
       Tejun Heo <htejun@gmail.com>, Peer Chen <pchen@nvidia.com>,
       Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
Subject: [patch 16/29] ahci: retry enabling AHCI a few times before
	spitting out WARN_ON()
Message-ID: <20080730232717.GQ30670@suse.de>
References: <20080730231003.655833364@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ahci-retry-enabling-ahci-a-few-times-before-spitting-out-warn_on.patch"
In-Reply-To: <20080730232451.GA30670@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Tejun Heo <htejun@gmail.com>

commit 15fe982e429e0e6b7466719acb6cfd9dbfe47f0c upstream

ahci: retry enabling AHCI a few times before spitting out WARN_ON()

Some chips need AHCI_EN set more than once to actually set it.  Try a
few times before giving up and spitting out WARN_ON().

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Peer Chen <pchen@nvidia.com>
Cc: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/ahci.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -634,16 +634,27 @@ static inline void __iomem *ahci_port_ba
 
 static void ahci_enable_ahci(void __iomem *mmio)
 {
+	int i;
 	u32 tmp;
 
 	/* turn on AHCI_EN */
 	tmp = readl(mmio + HOST_CTL);
-	if (!(tmp & HOST_AHCI_EN)) {
+	if (tmp & HOST_AHCI_EN)
+		return;
+
+	/* Some controllers need AHCI_EN to be written multiple times.
+	 * Try a few times before giving up.
+	 */
+	for (i = 0; i < 5; i++) {
 		tmp |= HOST_AHCI_EN;
 		writel(tmp, mmio + HOST_CTL);
 		tmp = readl(mmio + HOST_CTL);	/* flush && sanity check */
-		WARN_ON(!(tmp & HOST_AHCI_EN));
+		if (tmp & HOST_AHCI_EN)
+			return;
+		msleep(10);
 	}
+
+	WARN_ON(1);
 }
 
 /**

-- 
