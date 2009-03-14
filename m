Return-Path: <linux-kernel-owner+w=401wt.eu-S1762047AbZCNApT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762047AbZCNApT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbZCNATu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:19:50 -0400
Received: from kroah.org ([198.145.64.141]:34963 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750857AbZCNATh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:37 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:50 2009
Message-Id: <20090314000750.623373636@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:06:24 -0700
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
       alan@lxorguk.ukuu.org.uk, Devin Heitmueller <dheitmueller@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [patch 76/96] DVB: s5h1409: Perform s5h1409 soft reset after tuning
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=0001-DVB-s5h1409-Perform-s5h1409-soft-reset-after-tunin.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Devin Heitmueller <dheitmueller@linuxtv.org>

(cherry picked from commit 67e70baf043cfdcdaf5972bc94be82632071536b)

Just like with the s5h1411, the s5h1409 needs a soft-reset in order for it
to know that the tuner has been told to change frequencies.  This change
changes the behavior from "random tuning times between 500ms to complete
tuning lock failures" to "tuning lock consistently within 700ms".

Thanks to Robert Krakora <rob.krakora@messagenetsystems.com> for doing
initial testing of the patch on the KWorld 330U.

Thanks to Andy Walls <awalls@radix.net> for doing testing of the patch on
the HVR-1600.

Thanks to Michael Krufky <mkrufky@linuxtv.org> for doing additional testing.

Signed-off-by: Devin Heitmueller <dheitmueller@linuxtv.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/frontends/s5h1409.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/media/dvb/frontends/s5h1409.c
+++ b/drivers/media/dvb/frontends/s5h1409.c
@@ -542,9 +542,6 @@ static int s5h1409_set_frontend (struct 
 
 	s5h1409_enable_modulation(fe, p->u.vsb.modulation);
 
-	/* Allow the demod to settle */
-	msleep(100);
-
 	if (fe->ops.tuner_ops.set_params) {
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 1);
 		fe->ops.tuner_ops.set_params(fe, p);
@@ -557,6 +554,10 @@ static int s5h1409_set_frontend (struct 
 		s5h1409_set_qam_interleave_mode(fe);
 	}
 
+	/* Issue a reset to the demod so it knows to resync against the
+	   newly tuned frequency */
+	s5h1409_softreset(fe);
+
 	return 0;
 }
 


