Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbYLAU72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbYLAU72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 15:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbYLAU7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 15:59:20 -0500
Received: from eta-ori.net ([91.121.142.51]:51769 "EHLO orion.eta-ori.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbYLAU7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 15:59:19 -0500
Message-ID: <49345034.8050208@impulze.org>
Date: Mon, 01 Dec 2008 21:59:32 +0100
From: Daniel Mierswa <impulze@impulze.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081026)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-input@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Fujitsu Amilo PA 1510 key-release events quirk (PATCH
 1/3)
References: <4931BB48.9010706@impulze.org> <20081129233826.be959cae.akpm@linux-foundation.org>
In-Reply-To: <20081129233826.be959cae.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------030706030401000601040400"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030706030401000601040400
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Split patches as requested in "[PATCH] Fujitsu Amilo PA 1510 key-release
events quirk"
Here's the first out of 3.


On 30.11.2008 08:38, Andrew Morton wrote:
> Please don't send more than one patch per email.  I shall comment on
> the two patches in two separate replies.
>   
done, except that they are three now :)


On 30.11.2008 08:38, Andrew Morton wrote:
> Please also cc linux-input@vger.kernel.org on input-related patches.
>
>   
done


On 30.11.2008 08:38, Andrew Morton wrote:
> oh my.  Please, no.  Just write a C function:
>
> void atkbd_gen_release_event(unsigned int *keys, unsigned nr_keys)
> {
> 	...
> }
>
>   
done, I prefer that myself, although I first thought it might be a bad
idea to pass around pointers there, since
other developers might expect ARRAY_SIZE to work in gen_release_events.

-- 
Mierswa, Daniel

If you still don't like it, that's ok: that's why I'm boss. I simply 
know better than you do.
                --- Linus Torvalds, comp.os.linux.advocacy, 1996/07/22



--------------030706030401000601040400
Content-Type: text/plain;
 name="atkbd_gen_release_events.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="atkbd_gen_release_events.patch"

>From f4889ca0b6895abdd1888cb1b56dd411045780be Mon Sep 17 00:00:00 2001
From: Daniel Mierswa <impulze@impulze.org>
Date: Sun, 30 Nov 2008 13:14:00 +0100
Subject: [PATCH] use function for generation of keyrelease events

---
 drivers/input/keyboard/atkbd.c |   27 +++++++++++++++++----------
 1 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index 22016ca..c239745 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -834,6 +834,19 @@ static void atkbd_disconnect(struct serio *serio)
 }
 
 /*
+ * generate release events for the keycodes given in keys[]
+ */
+static void atkbd_gen_release_event(struct atkbd* atkbd, const unsigned int *keys,
+			unsigned int nr_keys)
+{
+	unsigned int i;
+
+	if (atkbd->set == 2)
+		for (i = 0; i < nr_keys; i++)
+			__set_bit(keys[i], atkbd->force_release_mask);
+}
+
+/*
  * Most special keys (Fn+F?) on Dell laptops do not generate release
  * events so we have to do it ourselves.
  */
@@ -842,12 +855,9 @@ static void atkbd_dell_laptop_keymap_fixup(struct atkbd *atkbd)
 	const unsigned int forced_release_keys[] = {
 		0x85, 0x86, 0x87, 0x88, 0x89, 0x8a, 0x8b, 0x8f, 0x93,
 	};
-	int i;
 
-	if (atkbd->set == 2)
-		for (i = 0; i < ARRAY_SIZE(forced_release_keys); i++)
-			__set_bit(forced_release_keys[i],
-				  atkbd->force_release_mask);
+	atkbd_gen_release_event(atkbd, forced_release_keys,
+		ARRAY_SIZE(forced_release_keys));
 }
 
 /*
@@ -859,12 +869,9 @@ static void atkbd_hp_keymap_fixup(struct atkbd *atkbd)
 	const unsigned int forced_release_keys[] = {
 		0x94,
 	};
-	int i;
 
-	if (atkbd->set == 2)
-		for (i = 0; i < ARRAY_SIZE(forced_release_keys); i++)
-			__set_bit(forced_release_keys[i],
-					atkbd->force_release_mask);
+	atkbd_gen_release_event(atkbd, forced_release_keys,
+		ARRAY_SIZE(forced_release_keys));
 }
 
 /*
-- 
1.6.0.4




--------------030706030401000601040400--
