Return-Path: <linux-kernel-owner+w=401wt.eu-S1762150AbXLMHNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762150AbXLMHNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762621AbXLMG5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:57:49 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55528 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762616AbXLMG5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:57:47 -0500
Date: Wed, 12 Dec 2007 22:53:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, bunk@kernel.org,
       davem@davemloft.net
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       chas williams <chas@cmf.nrl.navy.mil>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 41/60] ATM: initialize lock and tasklet earlier
Message-ID: <20071213065303.GQ6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="atm-initialize-lock-and-tasklet-earlier.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: chas williams <chas@cmf.nrl.navy.mil>

[ATM]: [he] initialize lock and tasklet earlier

[ Upstream commit: 8a8037ac9dbe4eb20ce50aa20244faf77444f4a3 ]

if you are lucky (unlucky?) enough to have shared interrupts, the
interrupt handler can be called before the tasklet and lock are ready
for use.

Signed-off-by: chas williams <chas@cmf.nrl.navy.mil>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/atm/he.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/atm/he.c
+++ b/drivers/atm/he.c
@@ -394,6 +394,11 @@ he_init_one(struct pci_dev *pci_dev, con
 	he_dev->atm_dev->dev_data = he_dev;
 	atm_dev->dev_data = he_dev;
 	he_dev->number = atm_dev->number;
+#ifdef USE_TASKLET
+	tasklet_init(&he_dev->tasklet, he_tasklet, (unsigned long) he_dev);
+#endif
+	spin_lock_init(&he_dev->global_lock);
+
 	if (he_start(atm_dev)) {
 		he_stop(he_dev);
 		err = -ENODEV;
@@ -1173,11 +1178,6 @@ he_start(struct atm_dev *dev)
 	if ((err = he_init_irq(he_dev)) != 0)
 		return err;
 
-#ifdef USE_TASKLET
-	tasklet_init(&he_dev->tasklet, he_tasklet, (unsigned long) he_dev);
-#endif
-	spin_lock_init(&he_dev->global_lock);
-
 	/* 4.11 enable pci bus controller state machines */
 	host_cntl |= (OUTFF_ENB | CMDFF_ENB |
 				QUICK_RD_RETRY | QUICK_WR_RETRY | PERR_INT_ENB);

-- 
