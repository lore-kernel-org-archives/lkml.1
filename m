Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbYKGX1C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbYKGX1C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:27:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbYKGXXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:23:06 -0500
Received: from kroah.org ([198.145.64.141]:59280 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752865AbYKGXXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:23:03 -0500
Date: Fri, 7 Nov 2008 15:15:45 -0800
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
       Steven Toth <stoth@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [patch 11/23] DVB: s5h1411: bugfix: Setting serial or parallel
	mode could destroy bits
Message-ID: <20081107231545.GL1108@kroah.com>
References: <20081107224818.593212310@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dvb-s5h1411-bugfix-setting-serial-or-parallel-mode-could-destroy-bits.patch"
In-Reply-To: <20081107231457.GA1108@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steven Toth <stoth@linuxtv.org>

commit 1af46b450fa49c57d73764d66f267335ccd807e2 upstream.

DVB: s5h1411: bugfix: Setting serial or parallel mode could destroy bits

Adding a serialmode function to read/and/or/write the register for safety.

Signed-off-by: Steven Toth <stoth@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/frontends/s5h1411.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/media/dvb/frontends/s5h1411.c
+++ b/drivers/media/dvb/frontends/s5h1411.c
@@ -472,6 +472,20 @@ static int s5h1411_set_spectralinversion
 	return s5h1411_writereg(state, S5H1411_I2C_TOP_ADDR, 0x24, val);
 }
 
+static int s5h1411_set_serialmode(struct dvb_frontend *fe, int serial)
+{
+	struct s5h1411_state *state = fe->demodulator_priv;
+	u16 val;
+
+	dprintk("%s(%d)\n", __func__, serial);
+	val = s5h1411_readreg(state, S5H1411_I2C_TOP_ADDR, 0xbd) & ~0x100;
+
+	if (serial == 1)
+		val |= 0x100;
+
+	return s5h1411_writereg(state, S5H1411_I2C_TOP_ADDR, 0xbd, val);
+}
+
 static int s5h1411_enable_modulation(struct dvb_frontend *fe,
 				     fe_modulation_t m)
 {
@@ -612,10 +626,10 @@ static int s5h1411_init(struct dvb_front
 
 	if (state->config->output_mode == S5H1411_SERIAL_OUTPUT)
 		/* Serial */
-		s5h1411_writereg(state, S5H1411_I2C_TOP_ADDR, 0xbd, 0x1101);
+		s5h1411_set_serialmode(fe, 1);
 	else
 		/* Parallel */
-		s5h1411_writereg(state, S5H1411_I2C_TOP_ADDR, 0xbd, 0x1001);
+		s5h1411_set_serialmode(fe, 0);
 
 	s5h1411_set_spectralinversion(fe, state->config->inversion);
 	s5h1411_set_if_freq(fe, state->config->vsb_if);

-- 
