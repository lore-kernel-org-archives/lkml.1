Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760854AbYLQANB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760854AbYLQANB (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 19:13:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759323AbYLQAGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 19:06:51 -0500
Received: from kroah.org ([198.145.64.141]:41424 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759761AbYLQAGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 19:06:18 -0500
Date: Tue, 16 Dec 2008 16:04:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
        Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
        Chris Wedgwood <reviews@ml.cw.f00f.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Chuck Ebbert <cebbert@redhat.com>,
        Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
        Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
        Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [patch 21/22] V4L/DVB (9621): Avoid writing outside shadow.bytes[]
	array
Message-ID: <20081217000441.GV4504@kroah.com>
References: <20081216235704.347182084@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-dvb-avoid-writing-outside-shadow.bytes-array.patch"
In-Reply-To: <20081217000306.GA4504@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 494264379d186bf806613d27aafb7d88d42f4212 upstream.

There were no check about the limits of shadow.bytes array. This offers
a risk of writing values outside the limits, overriding other data
areas.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/tvaudio.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

--- a/drivers/media/video/tvaudio.c
+++ b/drivers/media/video/tvaudio.c
@@ -152,7 +152,7 @@ static int chip_write(struct CHIPSTATE *
 {
 	unsigned char buffer[2];
 
-	if (-1 == subaddr) {
+	if (subaddr < 0) {
 		v4l_dbg(1, debug, chip->c, "%s: chip_write: 0x%x\n",
 			chip->c->name, val);
 		chip->shadow.bytes[1] = val;
@@ -163,6 +163,13 @@ static int chip_write(struct CHIPSTATE *
 			return -1;
 		}
 	} else {
+		if (subaddr + 1 >= ARRAY_SIZE(chip->shadow.bytes)) {
+			v4l_info(chip->c,
+				"Tried to access a non-existent register: %d\n",
+				subaddr);
+			return -EINVAL;
+		}
+
 		v4l_dbg(1, debug, chip->c, "%s: chip_write: reg%d=0x%x\n",
 			chip->c->name, subaddr, val);
 		chip->shadow.bytes[subaddr+1] = val;
@@ -177,12 +184,20 @@ static int chip_write(struct CHIPSTATE *
 	return 0;
 }
 
-static int chip_write_masked(struct CHIPSTATE *chip, int subaddr, int val, int mask)
+static int chip_write_masked(struct CHIPSTATE *chip,
+			     int subaddr, int val, int mask)
 {
 	if (mask != 0) {
-		if (-1 == subaddr) {
+		if (subaddr < 0) {
 			val = (chip->shadow.bytes[1] & ~mask) | (val & mask);
 		} else {
+			if (subaddr + 1 >= ARRAY_SIZE(chip->shadow.bytes)) {
+				v4l_info(chip->c,
+					"Tried to access a non-existent register: %d\n",
+					subaddr);
+				return -EINVAL;
+			}
+
 			val = (chip->shadow.bytes[subaddr+1] & ~mask) | (val & mask);
 		}
 	}
@@ -228,6 +243,15 @@ static int chip_cmd(struct CHIPSTATE *ch
 	if (0 == cmd->count)
 		return 0;
 
+	if (cmd->count + cmd->bytes[0] - 1 >= ARRAY_SIZE(chip->shadow.bytes)) {
+		v4l_info(chip->c,
+			 "Tried to access a non-existent register range: %d to %d\n",
+			 cmd->bytes[0] + 1, cmd->bytes[0] + cmd->count - 1);
+		return -EINVAL;
+	}
+
+	/* FIXME: it seems that the shadow bytes are wrong bellow !*/
+
 	/* update our shadow register set; print bytes if (debug > 0) */
 	v4l_dbg(1, debug, chip->c, "%s: chip_cmd(%s): reg=%d, data:",
 		chip->c->name, name,cmd->bytes[0]);

