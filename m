Return-Path: <linux-kernel-owner+w=401wt.eu-S1759792AbZBDSp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759792AbZBDSp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758422AbZBDSh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:37:27 -0500
Received: from kroah.org ([198.145.64.141]:51124 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758316AbZBDShT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:37:19 -0500
Date: Wed, 4 Feb 2009 10:34:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
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
       alan@lxorguk.ukuu.org.uk, Larry.Finger@lwfinger.net,
       linville@tuxdriver.com, Christian Lamparter <chunkeey@web.de>
Subject: [patch 22/33] p54: fix p54_read_eeprom to cope with tx_hdr_len
Message-ID: <20090204183459.GW13936@kroah.com>
References: <20090204182823.831027530@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="p54-fix-p54_read_eeprom-to-cope-with-tx_hdr_len.patch"
In-Reply-To: <20090204183403.GA13936@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christian Lamparter <chunkeey@web.de>

commit b92f30d65aeb0502e2ed8beb80c8465578b40002 upstream

This patch fixes a regression in "p54: move eeprom code into common library"
7cb770729ba895f73253dfcd46c3fcba45d896f9

Some of p54usb's devices need a little headroom for the transportation and
this was forgotten in the eeprom change.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/p54/p54common.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -741,17 +741,19 @@ static void p54_assign_address(struct ie
 int p54_read_eeprom(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv = dev->priv;
-	struct p54_control_hdr *hdr = NULL;
+	struct p54_control_hdr *hdr = NULL, *org_hdr;
 	struct p54_eeprom_lm86 *eeprom_hdr;
 	size_t eeprom_size = 0x2020, offset = 0, blocksize;
 	int ret = -ENOMEM;
 	void *eeprom = NULL;
 
-	hdr = (struct p54_control_hdr *)kzalloc(sizeof(*hdr) +
-		sizeof(*eeprom_hdr) + EEPROM_READBACK_LEN, GFP_KERNEL);
-	if (!hdr)
+	org_hdr = kzalloc(priv->tx_hdr_len + sizeof(*hdr) +
+			  sizeof(*eeprom_hdr) + EEPROM_READBACK_LEN,
+			  GFP_KERNEL);
+	if (!org_hdr)
 		goto free;
 
+	hdr = (void *) org_hdr + priv->tx_hdr_len;
 	priv->eeprom = kzalloc(EEPROM_READBACK_LEN, GFP_KERNEL);
 	if (!priv->eeprom)
 		goto free;
@@ -790,7 +792,7 @@ int p54_read_eeprom(struct ieee80211_hw 
 free:
 	kfree(priv->eeprom);
 	priv->eeprom = NULL;
-	kfree(hdr);
+	kfree(org_hdr);
 	kfree(eeprom);
 
 	return ret;

