Return-Path: <linux-kernel-owner+w=401wt.eu-S1759806AbZDWHwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759806AbZDWHwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756018AbZDWHdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:33:47 -0400
Received: from sous-sol.org ([216.99.217.87]:50979 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757329AbZDWHdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:33:46 -0400
Message-Id: <20090423072809.974244009@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:28 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [patch 068/100] ALSA: hda - Fix the cmd cache keys for amp verbs
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=alsa-hda-fix-the-cmd-cache-keys-for-amp-verbs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Takashi Iwai <tiwai@suse.de>

upstream commit: fcad94a4c71c36a05f4d5c6dcb174534b4e0b136

Fix the key value generation for get/set amp verbs.  The upper bits of
the parameter have to be combined with the verb value to be unique for
each direction/index of amp access.

This fixes the resume problem on some hardwares like Macbook after
the channel mode is changed.

Tested-by: Johannes Berg <johannes@sipsolutions.net>
Cc: <stable@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 sound/pci/hda/hda_codec.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2003,7 +2003,11 @@ int snd_hda_codec_write_cache(struct hda
 	err = bus->ops.command(bus, res);
 	if (!err) {
 		struct hda_cache_head *c;
-		u32 key = build_cmd_cache_key(nid, verb);
+		u32 key;
+		/* parm may contain the verb stuff for get/set amp */
+		verb = verb | (parm >> 8);
+		parm &= 0xff;
+		key = build_cmd_cache_key(nid, verb);
 		c = get_alloc_hash(&codec->cmd_cache, key);
 		if (c)
 			c->val = parm;

