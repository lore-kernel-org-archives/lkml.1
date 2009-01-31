Return-Path: <linux-kernel-owner+w=401wt.eu-S1760241AbZAaC5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760241AbZAaC5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 21:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbZAaCrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:09 -0500
Received: from kroah.org ([198.145.64.141]:55070 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752391AbZAaCrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:03 -0500
Date: Fri, 30 Jan 2009 18:40:52 -0800
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
       alan@lxorguk.ukuu.org.uk, Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 30/32] rtl8187: Fix error in setting OFDM power settings
	for RTL8187L
Message-ID: <20090131024052.GE12147@kroah.com>
References: <20090131023411.032399235@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline; filename="rtl8187-fix-error-in-setting-ofdm-power-settings-for-rtl8187l.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090131023906.GA12147@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit eb83bbf57429ab80f49b413e3e44d3b19c3fdc5a upstream.

After reports of poor performance, a review of the latest vendor driver
(rtl8187_linux_26.1025.0328.2007) for RTL8187L devices was undertaken.

A difference was found in the code used to index the OFDM power tables. When
the Linux driver was changed, my unit works at a much greater range than
before. I think this fixes Bugzilla #12380 and has been tested by at least
two other users.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested-by: Martín Ernesto Barreyro <barreyromartin@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rtl8187_rtl8225.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/rtl8187_rtl8225.c
+++ b/drivers/net/wireless/rtl8187_rtl8225.c
@@ -287,7 +287,10 @@ static void rtl8225_rf_set_tx_power(stru
 	ofdm_power = priv->channels[channel - 1].hw_value >> 4;
 
 	cck_power = min(cck_power, (u8)11);
-	ofdm_power = min(ofdm_power, (u8)35);
+	if (ofdm_power > (u8)15)
+		ofdm_power = 25;
+	else
+		ofdm_power += 10;
 
 	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_CCK,
 			 rtl8225_tx_gain_cck_ofdm[cck_power / 6] >> 1);
@@ -540,7 +543,10 @@ static void rtl8225z2_rf_set_tx_power(st
 	cck_power += priv->txpwr_base & 0xF;
 	cck_power = min(cck_power, (u8)35);
 
-	ofdm_power = min(ofdm_power, (u8)15);
+	if (ofdm_power > (u8)15)
+		ofdm_power = 25;
+	else
+		ofdm_power += 10;
 	ofdm_power += priv->txpwr_base >> 4;
 	ofdm_power = min(ofdm_power, (u8)35);
 

