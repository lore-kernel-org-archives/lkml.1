Return-Path: <linux-kernel-owner+w=401wt.eu-S1754901AbZENWou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbZENWou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbZENWmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:42:05 -0400
Received: from kroah.org ([198.145.64.141]:51495 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755952AbZENWmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:42:01 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:35:21 2009
Message-Id: <20090514223521.470743601@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:32:43 -0700
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
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [patch 08/51] ALSA: hda - Fix line-in on Mac Mini Core2 Duo
References: <20090514223235.348540705@mini.kroah.org>
Content-Disposition: inline; filename=alsa-hda-fix-line-in-on-mac-mini-core2-duo.patch
In-Reply-To: <20090514223755.GA27019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 5dd17cb992ef4c1ebb1a2d60cbef4b6967974673 upstream.

BIOS on Mac Mini Core2 Duo sets both INPUT and OUTPUT pinctl bits to
the line-in jack, and it confuses the driver as if it's a valid input.
This patch adds the check of OUTPUT bit so that the driver fixes the
invalid pin setup.

Tested-by: Tino Keitel <tino.keitel@gmx.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -4007,7 +4007,12 @@ static int stac92xx_init(struct hda_code
 				pinctl = snd_hda_codec_read(codec, nid, 0,
 					AC_VERB_GET_PIN_WIDGET_CONTROL, 0);
 				/* if PINCTL already set then skip */
-				if (!(pinctl & AC_PINCTL_IN_EN)) {
+				/* Also, if both INPUT and OUTPUT are set,
+				 * it must be a BIOS bug; need to override, too
+				 */
+				if (!(pinctl & AC_PINCTL_IN_EN) ||
+				    (pinctl & AC_PINCTL_OUT_EN)) {
+					pinctl &= ~AC_PINCTL_OUT_EN;
 					pinctl |= AC_PINCTL_IN_EN;
 					stac92xx_auto_set_pinctl(codec, nid,
 								 pinctl);


