Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbXC3VQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbXC3VQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbXC3VMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:12:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51769 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbXC3VMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:12:33 -0400
Date: Fri, 30 Mar 2007 14:06:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Tejun Heo <htejun@gmail.com>,
       Art Haas <ahaas@airmail.net>, Mark Lord <mlord@pobox.com>,
       Jeff Garzik <jeff@garzik.org>
Subject: [patch 33/37] libata: clear TF before IDENTIFYing
Message-ID: <20070330210655.GJ29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libata-clear-tf-before-identifying.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Tejun Heo <htejun@gmail.com>

libata: clear TF before IDENTIFYing

Some devices chock if Feature is not clear when IDENTIFY is issued.
Set ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE for IDENTIFY such that whole
TF is cleared when reading ID data.

Kudos to Art Haas for testing various futile patches over several
months and Mark Lord for pointing out the fix.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Art Haas <ahaas@airmail.net>
Cc: Mark Lord <mlord@pobox.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-core.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1478,7 +1478,16 @@ int ata_dev_read_id(struct ata_device *d
 	}
 
 	tf.protocol = ATA_PROT_PIO;
-	tf.flags |= ATA_TFLAG_POLLING; /* for polling presence detection */
+
+	/* Some devices choke if TF registers contain garbage.  Make
+	 * sure those are properly initialized.
+	 */
+	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
+
+	/* Device presence detection is unreliable on some
+	 * controllers.  Always poll IDENTIFY if available.
+	 */
+	tf.flags |= ATA_TFLAG_POLLING;
 
 	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_FROM_DEVICE,
 				     id, sizeof(id[0]) * ATA_ID_WORDS);

-- 
