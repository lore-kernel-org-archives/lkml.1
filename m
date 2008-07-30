Return-Path: <linux-kernel-owner+w=401wt.eu-S1763148AbYGaAYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763148AbYGaAYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763498AbYGaAWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:22:34 -0400
Received: from ns2.suse.de ([195.135.220.15]:37528 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763494AbYGaAWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:22:33 -0400
Date: Wed, 30 Jul 2008 16:59:41 -0700
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
Subject: [patch 49/62] DVB: cx23885: Reallocated the sram to avoid
	concurrent VIDB/C issues
Message-ID: <20080730235941.GW12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dvb-cx23885-reallocated-the-sram-to-avoid-concurrent-vidb-c-issues.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Steven Toth <stoth@hauppauge.com>

(cherry picked from commit d8d12b4367e2e759f65c5f9dcb94d21ec237bbc5)

DVB: cx23885: Reallocated the sram to avoid concurrent VIDB/C issues

This may be cx23885 chip specific and may not work on the cx23887.
Analog and mpeg encoder streaming are still to be tested.

Signed-off-by: Steven Toth <stoth@hauppauge.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/cx23885/cx23885-core.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -80,8 +80,8 @@ static struct sram_channel cx23887_sram_
 	[SRAM_CH01] = {
 		.name		= "VID A",
 		.cmds_start	= 0x10000,
-		.ctrl_start	= 0x105b0,
-		.cdt		= 0x107b0,
+		.ctrl_start	= 0x10380,
+		.cdt		= 0x104c0,
 		.fifo_start	= 0x40,
 		.fifo_size	= 0x2800,
 		.ptr1_reg	= DMA1_PTR1,
@@ -104,8 +104,8 @@ static struct sram_channel cx23887_sram_
 	[SRAM_CH03] = {
 		.name		= "TS1 B",
 		.cmds_start	= 0x100A0,
-		.ctrl_start	= 0x10670,
-		.cdt		= 0x10810,
+		.ctrl_start	= 0x10400,
+		.cdt		= 0x10580,
 		.fifo_start	= 0x5000,
 		.fifo_size	= 0x1000,
 		.ptr1_reg	= DMA3_PTR1,
@@ -140,8 +140,8 @@ static struct sram_channel cx23887_sram_
 	[SRAM_CH06] = {
 		.name		= "TS2 C",
 		.cmds_start	= 0x10140,
-		.ctrl_start	= 0x10680,
-		.cdt		= 0x108d0,
+		.ctrl_start	= 0x10440,
+		.cdt		= 0x105e0,
 		.fifo_start	= 0x6000,
 		.fifo_size	= 0x1000,
 		.ptr1_reg	= DMA5_PTR1,
@@ -1043,6 +1043,9 @@ static int cx23885_start_dma(struct cx23
 	dprintk(1, "%s() w: %d, h: %d, f: %d\n", __func__,
 		buf->vb.width, buf->vb.height, buf->vb.field);
 
+	/* Stop the fifo and risc engine for this port */
+	cx_clear(port->reg_dma_ctl, port->dma_ctl_val);
+
 	/* setup fifo + format */
 	cx23885_sram_channel_setup(dev,
 				   &dev->sram_channels[ port->sram_chno ],

-- 
