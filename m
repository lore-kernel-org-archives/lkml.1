Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbYKGX1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbYKGX1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:27:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbYKGXXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:23:09 -0500
Received: from kroah.org ([198.145.64.141]:59299 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753288AbYKGXXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:23:05 -0500
Date: Fri, 7 Nov 2008 15:15:49 -0800
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
       Devin Heitmueller <devin.heitmueller@gmail.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [patch 13/23] DVB: s5h1411: Power down s5h1411 when not in use
Message-ID: <20081107231549.GN1108@kroah.com>
References: <20081107224818.593212310@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dvb-s5h1411-power-down-s5h1411-when-not-in-use.patch"
In-Reply-To: <20081107231457.GA1108@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Devin Heitmueller <devin.heitmueller@gmail.com>

commit 11fc9a4a440112b5afc1a99d86ba92d70205a688 upstream.

DVB: s5h1411: Power down s5h1411 when not in use

Power down the s5h1411 demodulator when not in use
(on the Pinnacle 801e, this brings idle power from
123ma down to 84ma).

Signed-off-by: Devin Heitmueller <devin.heitmueller@gmail.com>
Acked-by: Steven Toth <stoth@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/frontends/s5h1411.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/media/dvb/frontends/s5h1411.c
+++ b/drivers/media/dvb/frontends/s5h1411.c
@@ -549,7 +549,7 @@ static int s5h1411_set_gpio(struct dvb_f
 		return s5h1411_writereg(state, S5H1411_I2C_TOP_ADDR, 0xe0, val);
 }
 
-static int s5h1411_sleep(struct dvb_frontend *fe, int enable)
+static int s5h1411_set_powerstate(struct dvb_frontend *fe, int enable)
 {
 	struct s5h1411_state *state = fe->demodulator_priv;
 
@@ -565,6 +565,11 @@ static int s5h1411_sleep(struct dvb_fron
 	return 0;
 }
 
+static int s5h1411_sleep(struct dvb_frontend *fe)
+{
+	return s5h1411_set_powerstate(fe, 1);
+}
+
 static int s5h1411_register_reset(struct dvb_frontend *fe)
 {
 	struct s5h1411_state *state = fe->demodulator_priv;
@@ -614,7 +619,7 @@ static int s5h1411_init(struct dvb_front
 
 	dprintk("%s()\n", __func__);
 
-	s5h1411_sleep(fe, 0);
+	s5h1411_set_powerstate(fe, 0);
 	s5h1411_register_reset(fe);
 
 	for (i = 0; i < ARRAY_SIZE(init_tab); i++)
@@ -878,6 +883,7 @@ static struct dvb_frontend_ops s5h1411_o
 	},
 
 	.init                 = s5h1411_init,
+	.sleep                = s5h1411_sleep,
 	.i2c_gate_ctrl        = s5h1411_i2c_gate_ctrl,
 	.set_frontend         = s5h1411_set_frontend,
 	.get_frontend         = s5h1411_get_frontend,

-- 
