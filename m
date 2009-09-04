Return-Path: <linux-kernel-owner+w=401wt.eu-S934232AbZIDUWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934232AbZIDUWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933997AbZIDUWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:22:38 -0400
Received: from kroah.org ([198.145.64.141]:36103 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933956AbZIDUOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:11 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:50 2009
Message-Id: <20090904200850.531838310@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [patch 04/48] sound: pcm_lib: fix unsorted list constraint handling
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=sound-pcm_lib-fix-unsorted-list-constraint-handling.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Clemens Ladisch <clemens@ladisch.de>

commit b1ddaf681e362ed453182ddee1699d7487069a16 upstream.

snd_interval_list() expected a sorted list but did not document this, so
there are drivers that give it an unsorted list.  To fix this, change
the algorithm to work with any list.

This fixes the "Slave PCM not usable" error with USB devices that have
multiple alternate settings with sample rates in decreasing order, such
as the Philips Askey VC010 WebCam.

http://bugzilla.kernel.org/show_bug.cgi?id=14028

Reported-and-tested-by: Andrzej <adkadk@gmail.com>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/core/pcm_lib.c |   39 ++++++++-------------------------------
 1 file changed, 8 insertions(+), 31 deletions(-)

--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -779,47 +779,24 @@ static int snd_interval_ratden(struct sn
 int snd_interval_list(struct snd_interval *i, unsigned int count, unsigned int *list, unsigned int mask)
 {
         unsigned int k;
-	int changed = 0;
+	struct snd_interval list_range;
 
 	if (!count) {
 		i->empty = 1;
 		return -EINVAL;
 	}
+	snd_interval_any(&list_range);
+	list_range.min = UINT_MAX;
+	list_range.max = 0;
         for (k = 0; k < count; k++) {
 		if (mask && !(mask & (1 << k)))
 			continue;
-                if (i->min == list[k] && !i->openmin)
-                        goto _l1;
-                if (i->min < list[k]) {
-                        i->min = list[k];
-			i->openmin = 0;
-			changed = 1;
-                        goto _l1;
-                }
-        }
-        i->empty = 1;
-        return -EINVAL;
- _l1:
-        for (k = count; k-- > 0;) {
-		if (mask && !(mask & (1 << k)))
+		if (!snd_interval_test(i, list[k]))
 			continue;
-                if (i->max == list[k] && !i->openmax)
-                        goto _l2;
-                if (i->max > list[k]) {
-                        i->max = list[k];
-			i->openmax = 0;
-			changed = 1;
-                        goto _l2;
-                }
+		list_range.min = min(list_range.min, list[k]);
+		list_range.max = max(list_range.max, list[k]);
         }
-        i->empty = 1;
-        return -EINVAL;
- _l2:
-	if (snd_interval_checkempty(i)) {
-		i->empty = 1;
-		return -EINVAL;
-	}
-        return changed;
+	return snd_interval_refine(i, &list_range);
 }
 
 EXPORT_SYMBOL(snd_interval_list);


