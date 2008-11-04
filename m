Return-Path: <linux-kernel-owner+w=401wt.eu-S1759965AbYKDXvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965AbYKDXvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:51:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756283AbYKDXj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:39:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:52158 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757737AbYKDXjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:39:55 -0500
Date: Tue, 4 Nov 2008 15:32:51 -0800
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
Subject: [patch 36/57] DVB: s5h1411: Perform s5h1411 soft reset after tuning
Message-ID: <20081104233251.GK659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dvb-s5h1411-perform-s5h1411-soft-reset-after-tuning.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Devin Heitmueller <devin.heitmueller@gmail.com>

cherry picked from commit f0d041e50bc6c8a677922d72b010f80af9b23b18

DVB: s5h1411: Perform s5h1411 soft reset after tuning

If you instruct the tuner to change frequencies, it can take up to 2500ms to
get a demod lock.  By performing a soft reset after the tuning call (which
is consistent with how the Pinnacle 801e Windows driver behaves), you get
a demod lock inside of 300ms

Signed-off-by: Devin Heitmueller <devin.heitmueller@gmail.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Acked-by: Steven Toth <stoth@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/frontends/s5h1411.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/media/dvb/frontends/s5h1411.c
+++ b/drivers/media/dvb/frontends/s5h1411.c
@@ -588,9 +588,6 @@ static int s5h1411_set_frontend(struct d
 
 	s5h1411_enable_modulation(fe, p->u.vsb.modulation);
 
-	/* Allow the demod to settle */
-	msleep(100);
-
 	if (fe->ops.tuner_ops.set_params) {
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 1);
@@ -601,6 +598,10 @@ static int s5h1411_set_frontend(struct d
 			fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
+	/* Issue a reset to the demod so it knows to resync against the
+	   newly tuned frequency */
+	s5h1411_softreset(fe);
+
 	return 0;
 }
 

-- 
