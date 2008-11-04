Return-Path: <linux-kernel-owner+w=401wt.eu-S1760047AbYKDXvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047AbYKDXvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756445AbYKDXkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:40:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:52173 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757777AbYKDXj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:39:59 -0500
Date: Tue, 4 Nov 2008 15:32:54 -0800
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
Subject: [patch 37/57] DVB: s5h1411: Power down s5h1411 when not in use
Message-ID: <20081104233254.GL659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dvb-s5h1411-power-down-s5h1411-when-not-in-use.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Devin Heitmueller <devin.heitmueller@gmail.com>

cherry picked from commit 11fc9a4a440112b5afc1a99d86ba92d70205a688

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
