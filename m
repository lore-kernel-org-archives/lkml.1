Return-Path: <linux-kernel-owner+w=401wt.eu-S1751070AbXBUBpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751070AbXBUBpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 20:45:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112AbXBUBpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 20:45:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:34627 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbXBUBjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 20:39:25 -0500
Date: Tue, 20 Feb 2007 17:38:03 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Buesch <mb@bu3sch.de>, Larry Finger <Larry.Finger@lwfinger.net>
Subject: [patch 13/21] bcm43xx: Fix for oops on ampdu status
Message-ID: <20070221013803.GN30227@kroah.com>
References: <20070221012758.925122216@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="bcm43xx-fix-for-oops-on-ampdu-status.patch"
In-Reply-To: <20070221013619.GA30227@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Buesch <mb@bu3sch.de>

If bcm43xx were to process an afterburner (ampdu) status response, Linux would oops. The
ampdu and intermediate status bits are properly named.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/bcm43xx/bcm43xx_main.c |    8 +++-----
 drivers/net/wireless/bcm43xx/bcm43xx_xmit.h |   10 ++--------
 2 files changed, 5 insertions(+), 13 deletions(-)

--- linux-2.6.19.4.orig/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ linux-2.6.19.4/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -1449,12 +1449,10 @@ static void handle_irq_transmit_status(s
 
 		bcm43xx_debugfs_log_txstat(bcm, &stat);
 
-		if (stat.flags & BCM43xx_TXSTAT_FLAG_IGNORE)
+		if (stat.flags & BCM43xx_TXSTAT_FLAG_AMPDU)
+			continue;
+		if (stat.flags & BCM43xx_TXSTAT_FLAG_INTER)
 			continue;
-		if (!(stat.flags & BCM43xx_TXSTAT_FLAG_ACK)) {
-			//TODO: packet was not acked (was lost)
-		}
-		//TODO: There are more (unknown) flags to test. see bcm43xx_main.h
 
 		if (bcm43xx_using_pio(bcm))
 			bcm43xx_pio_handle_xmitstatus(bcm, &stat);
--- linux-2.6.19.4.orig/drivers/net/wireless/bcm43xx/bcm43xx_xmit.h
+++ linux-2.6.19.4/drivers/net/wireless/bcm43xx/bcm43xx_xmit.h
@@ -137,14 +137,8 @@ struct bcm43xx_xmitstatus {
 	u16 unknown; //FIXME
 };
 
-#define BCM43xx_TXSTAT_FLAG_ACK		0x01
-//TODO #define BCM43xx_TXSTAT_FLAG_???	0x02
-//TODO #define BCM43xx_TXSTAT_FLAG_???	0x04
-//TODO #define BCM43xx_TXSTAT_FLAG_???	0x08
-//TODO #define BCM43xx_TXSTAT_FLAG_???	0x10
-#define BCM43xx_TXSTAT_FLAG_IGNORE	0x20
-//TODO #define BCM43xx_TXSTAT_FLAG_???	0x40
-//TODO #define BCM43xx_TXSTAT_FLAG_???	0x80
+#define BCM43xx_TXSTAT_FLAG_AMPDU	0x10
+#define BCM43xx_TXSTAT_FLAG_INTER	0x20
 
 u8 bcm43xx_plcp_get_ratecode_cck(const u8 bitrate);
 u8 bcm43xx_plcp_get_ratecode_ofdm(const u8 bitrate);

--
