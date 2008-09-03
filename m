Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbYICRfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbYICRfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679AbYICRfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:35:06 -0400
Received: from ns1.suse.de ([195.135.220.2]:50551 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678AbYICRfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:35:04 -0400
Date: Wed, 3 Sep 2008 10:25:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Clemens Ladisch <clemens@ladisch.de>,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 10/42] ALSA: oxygen: prevent muting of nonexistent AC97
	controls
Message-ID: <20080903172536.GK7731@suse.de>
References: <20080903171927.534216229@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-oxygen-prevent-muting-of-nonexistent-ac97-controls.patch"
In-Reply-To: <20080903172447.GA7731@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 3d839e5b87a70effc629c1cdbf77d837ef141919 upstream

Date: Tue, 26 Aug 2008 11:06:26 +0200
Subject: [patch 10/42] ALSA: oxygen: prevent muting of nonexistent AC97 controls

The Xonar DX does not have CD Capture controls, so we have to check that
a control actually exists before muting it.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/oxygen/oxygen_mixer.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/sound/pci/oxygen/oxygen_mixer.c
+++ b/sound/pci/oxygen/oxygen_mixer.c
@@ -512,9 +512,12 @@ static int ac97_switch_get(struct snd_kc
 
 static void mute_ac97_ctl(struct oxygen *chip, unsigned int control)
 {
-	unsigned int priv_idx = chip->controls[control]->private_value & 0xff;
+	unsigned int priv_idx;
 	u16 value;
 
+	if (!chip->controls[control])
+		return;
+	priv_idx = chip->controls[control]->private_value & 0xff;
 	value = oxygen_read_ac97(chip, 0, priv_idx);
 	if (!(value & 0x8000)) {
 		oxygen_write_ac97(chip, 0, priv_idx, value | 0x8000);

-- 
