Return-Path: <linux-kernel-owner+w=401wt.eu-S1762171AbYGaAYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762171AbYGaAYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762787AbYGaAWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:22:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37493 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760471AbYGaAWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:22:08 -0400
Date: Wed, 30 Jul 2008 16:59:39 -0700
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
       alan@lxorguk.ukuu.org.uk,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Steven Toth <stoth@hauppauge.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 48/62] DVB: cx23885: DVB Transport cards using DVB port
	VIDB/TS1 did not stream
Message-ID: <20080730235939.GV12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dvb-cx23885-dvb-transport-cards-using-dvb-port-vidb-ts1-did-not-stream.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Steven Toth <stoth@hauppauge.com>

(cherry picked from commit 52ce27bfc4d302a3e28267a5820a8b031ceccee9)

DVB: cx23885: DVB Transport cards using DVB port VIDB/TS1 did not stream

Certain DVB cards that have demodulators on TS1/VIDB were not
streaming packets.

This ensure the pin directions on PAD_CTRL are set correctly,
solving the issue.

Signed-off-by: Steven Toth <stoth@hauppauge.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/cx23885/cx23885-core.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -1084,7 +1084,21 @@ static int cx23885_start_dma(struct cx23
 	cx_write(port->reg_gpcnt_ctl, 3);
 	q->count = 1;
 
-	if (cx23885_boards[dev->board].portb & CX23885_MPEG_ENCODER) {
+	/* Set VIDB pins to input */
+	if (cx23885_boards[dev->board].portb == CX23885_MPEG_DVB) {
+		reg = cx_read(PAD_CTRL);
+		reg &= ~0x3; /* Clear TS1_OE & TS1_SOP_OE */
+		cx_write(PAD_CTRL, reg);
+	}
+
+	/* Set VIDC pins to input */
+	if (cx23885_boards[dev->board].portc == CX23885_MPEG_DVB) {
+		reg = cx_read(PAD_CTRL);
+		reg &= ~0x4; /* Clear TS2_SOP_OE */
+		cx_write(PAD_CTRL, reg);
+	}
+
+	if (cx23885_boards[dev->board].portb == CX23885_MPEG_ENCODER) {
 
 		reg = cx_read(PAD_CTRL);
 		reg = reg & ~0x1;    /* Clear TS1_OE */
@@ -1134,7 +1148,7 @@ static int cx23885_stop_dma(struct cx238
 	cx_clear(port->reg_ts_int_msk, port->ts_int_msk_val);
 	cx_clear(port->reg_dma_ctl, port->dma_ctl_val);
 
-	if (cx23885_boards[dev->board].portb & CX23885_MPEG_ENCODER) {
+	if (cx23885_boards[dev->board].portb == CX23885_MPEG_ENCODER) {
 
 		reg = cx_read(PAD_CTRL);
 

-- 
