Return-Path: <linux-kernel-owner+w=401wt.eu-S1761703AbYD2R0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761703AbYD2R0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758549AbYD2RVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:21:00 -0400
Received: from mail.suse.de ([195.135.220.2]:52059 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758509AbYD2RU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:20:59 -0400
Date: Tue, 29 Apr 2008 10:18:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [16/37] V4L: tea5761: bugzilla #10462: tea5761 autodetection code
	were broken
Message-ID: <20080429171833.GQ14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-tea5761-bugzilla-10462-tea5761-autodetection-code-were-broken.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Mauro Carvalho Chehab <mchehab@infradead.org>

(cherry picked from commit 867e835f4db4eba6d49072382cc05fc210c4ed1c)

Fix bugzilla #10462: "tea5761 autodetection code were broken"

Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/tea5761.c    |   15 ++++++++++-----
 drivers/media/video/tuner-core.c |    6 +++---
 2 files changed, 13 insertions(+), 8 deletions(-)

--- a/drivers/media/video/tea5761.c
+++ b/drivers/media/video/tea5761.c
@@ -249,14 +249,19 @@ int tea5761_autodetection(struct i2c_ada
 
 	if (16 != (rc = tuner_i2c_xfer_recv(&i2c, buffer, 16))) {
 		printk(KERN_WARNING "it is not a TEA5761. Received %i chars.\n", rc);
-		return EINVAL;
+		return -EINVAL;
 	}
 
-	if (!((buffer[13] != 0x2b) || (buffer[14] != 0x57) || (buffer[15] != 0x061))) {
-		printk(KERN_WARNING "Manufacturer ID= 0x%02x, Chip ID = %02x%02x. It is not a TEA5761\n",buffer[13],buffer[14],buffer[15]);
-		return EINVAL;
+	if ((buffer[13] != 0x2b) || (buffer[14] != 0x57) || (buffer[15] != 0x061)) {
+		printk(KERN_WARNING "Manufacturer ID= 0x%02x, Chip ID = %02x%02x."
+				    " It is not a TEA5761\n",
+				    buffer[13], buffer[14], buffer[15]);
+		return -EINVAL;
 	}
-	printk(KERN_WARNING "TEA5761 detected.\n");
+	printk(KERN_WARNING "tea5761: TEA%02x%02x detected. "
+			    "Manufacturer ID= 0x%02x\n",
+			    buffer[14], buffer[15], buffer[13]);
+
 	return 0;
 }
 
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -1112,8 +1112,8 @@ static int tuner_probe(struct i2c_client
 	if (!no_autodetect) {
 		switch (client->addr) {
 		case 0x10:
-			if (tea5761_autodetection(t->i2c->adapter, t->i2c->addr)
-					!= EINVAL) {
+			if (tea5761_autodetection(t->i2c->adapter,
+						  t->i2c->addr) >= 0) {
 				t->type = TUNER_TEA5761;
 				t->mode_mask = T_RADIO;
 				t->mode = T_STANDBY;
@@ -1125,7 +1125,7 @@ static int tuner_probe(struct i2c_client
 
 				goto register_client;
 			}
-			break;
+			return -ENODEV;
 		case 0x42:
 		case 0x43:
 		case 0x4a:

-- 
