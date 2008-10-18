Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbYJRTXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbYJRTXg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbYJRTGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:06:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795AbYJRTGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:06:34 -0400
Date: Sat, 18 Oct 2008 11:57:38 -0700
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
       alan@lxorguk.ukuu.org.uk, Jean Delvare <khali@linux-fr.org>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [patch 11/14] V4L: bttv: Prevent NULL pointer dereference in
	radio_open
Message-ID: <20081018185738.GL17196@suse.de>
References: <20081018185031.236868964@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-bttv-prevent-null-pointer-dereference-in-radio_open.patch"
In-Reply-To: <20081018185658.GA17196@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Jean Delvare <khali@linux-fr.org>

cherry picked from commit c37396c19403e249f12626187d51e92c915f2bc9

Fix the following crash in the bttv driver:

BUG: unable to handle kernel NULL pointer dereference at 000000000000036c
IP: [<ffffffffa037860a>] radio_open+0x3a/0x170 [bttv]

This happens because radio_open assumes that all present bttv devices
have a radio function. If a bttv device without radio and one with
radio are installed on the same system, and the one without radio is
registered first, then radio_open checks for the radio device number
of a bttv device that has no radio function, and this breaks. All we
have to do to fix it is to skip bttv devices without a radio function.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/bt8xx/bttv-driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -3422,7 +3422,7 @@ static int radio_open(struct inode *inod
 	dprintk("bttv: open minor=%d\n",minor);
 
 	for (i = 0; i < bttv_num; i++) {
-		if (bttvs[i].radio_dev->minor == minor) {
+		if (bttvs[i].radio_dev && bttvs[i].radio_dev->minor == minor) {
 			btv = &bttvs[i];
 			break;
 		}

-- 
