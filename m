Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbYKGXds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbYKGXds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:33:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbYKGX0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:26:51 -0500
Received: from kroah.org ([198.145.64.141]:47559 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754097AbYKGX0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:26:50 -0500
Date: Fri, 7 Nov 2008 15:26:12 -0800
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
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@perex.cz>, Chris Wedgwood <cw@f00f.org>
Subject: [patch 07/16] ALSA: use correct lock in snd_ctl_dev_disconnect()
Message-ID: <20081107232612.GH4282@kroah.com>
References: <20081107231848.995297975@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-use-correct-lock-in-snd_ctl_dev_disconnect.patch"
In-Reply-To: <20081107232544.GA4282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit d8009882e9f5e1a76986c741f071edd2ad760c97 upstream

The lock used in snd_ctl_dev_disconnect() should be card->ctl_files_rwlock
for protection of card->ctl_files entries, instead of card->controls_rwsem.

Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Cc: Chris Wedgwood <cw@f00f.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/core/control.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -1426,12 +1426,12 @@ static int snd_ctl_dev_disconnect(struct
 	cardnum = card->number;
 	snd_assert(cardnum >= 0 && cardnum < SNDRV_CARDS, return -ENXIO);
 
-	down_read(&card->controls_rwsem);
+	read_lock(&card->ctl_files_rwlock);
 	list_for_each_entry(ctl, &card->ctl_files, list) {
 		wake_up(&ctl->change_sleep);
 		kill_fasync(&ctl->fasync, SIGIO, POLL_ERR);
 	}
-	up_read(&card->controls_rwsem);
+	read_unlock(&card->ctl_files_rwlock);
 
 	if ((err = snd_unregister_device(SNDRV_DEVICE_TYPE_CONTROL,
 					 card, -1)) < 0)

-- 
