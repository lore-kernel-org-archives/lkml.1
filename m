Return-Path: <linux-kernel-owner+w=401wt.eu-S1763182AbYGaA1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763182AbYGaA1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763414AbYGaAZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:25:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763273AbYGaAZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:25:00 -0400
Date: Wed, 30 Jul 2008 16:59:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Luotao Fu <l.fu@pengutronix.de>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [patch 55/62] mpc52xx_psc_spi: fix block transfer
Message-ID: <20080730235955.GC12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mpc52xx_psc_spi-fix-block-transfer.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Luotao Fu <l.fu@pengutronix.de>

commit 9a7867e1b34c3575e7e76a05c0c54c6edbdae2a4 upstream

The block transfer routine in the mpc52xx psc spi driver misinterpret
the datasheet.  According to the processor datasheet the chipselect is
held as long as the EOF is not written.

Theoretically blocks of any sizes can be transferred in this way.  The
old routine however writes an EOF after every word, which has the size
of size_of_word.  This makes the transfer slow.

Also fixed some duplicate code.

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/spi/mpc52xx_psc_spi.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

--- a/drivers/spi/mpc52xx_psc_spi.c
+++ b/drivers/spi/mpc52xx_psc_spi.c
@@ -148,7 +148,6 @@ static int mpc52xx_psc_spi_transfer_rxtx
 	unsigned rfalarm;
 	unsigned send_at_once = MPC52xx_PSC_BUFSIZE;
 	unsigned recv_at_once;
-	unsigned bpw = mps->bits_per_word / 8;
 
 	if (!t->tx_buf && !t->rx_buf && t->len)
 		return -EINVAL;
@@ -164,22 +163,15 @@ static int mpc52xx_psc_spi_transfer_rxtx
 		}
 
 		dev_dbg(&spi->dev, "send %d bytes...\n", send_at_once);
-		if (tx_buf) {
-			for (; send_at_once; sb++, send_at_once--) {
-				/* set EOF flag */
-				if (mps->bits_per_word
-						&& (sb + 1) % bpw == 0)
-					out_8(&psc->ircr2, 0x01);
+		for (; send_at_once; sb++, send_at_once--) {
+			/* set EOF flag before the last word is sent */
+			if (send_at_once == 1)
+				out_8(&psc->ircr2, 0x01);
+
+			if (tx_buf)
 				out_8(&psc->mpc52xx_psc_buffer_8, tx_buf[sb]);
-			}
-		} else {
-			for (; send_at_once; sb++, send_at_once--) {
-				/* set EOF flag */
-				if (mps->bits_per_word
-						&& ((sb + 1) % bpw) == 0)
-					out_8(&psc->ircr2, 0x01);
+			else
 				out_8(&psc->mpc52xx_psc_buffer_8, 0);
-			}
 		}
 
 

-- 
