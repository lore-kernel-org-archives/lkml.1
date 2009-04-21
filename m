Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZDUOni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZDUOni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 10:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbZDUOn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 10:43:29 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46751 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbZDUOn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 10:43:28 -0400
Message-ID: <49EDDB8E.5020200@canonical.com>
Date: Tue, 21 Apr 2009 16:43:26 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Uwe Geuder <ubuntuLp-ugeuder@sneakemail.com>
Subject: [PATCH] vgacon: Return the upper half of 512 character fonts
Content-Type: multipart/mixed;
 boundary="------------040508070000040108020402"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040508070000040108020402
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Not sure who would be considered maintainer for vgacon, so spreading slightly. 
There is a bug in returning the font data for 512 character fonts which seems 
to have evaded all detection. Unlikely to be important enough for stable as it 
won't cause any mayhem.

Regards,
Stefan



--------------040508070000040108020402
Content-Type: text/x-diff;
 name="0001-vgacon-Return-the-upper-half-of-512-character-fonts.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-vgacon-Return-the-upper-half-of-512-character-fonts.pat";
 filename*1="ch"

>From e7aa277f2e8d76c4d93991b345a80ef80f461f89 Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Fri, 17 Apr 2009 23:21:05 +0200
Subject: [PATCH] vgacon: Return the upper half of 512 character fonts

Bug: #355057

Uwe Geuder noted that he gets random bitmaps on a text console if he tried
to type extended characters (like the e acute). For him everything above
unicode 0xa0 was corrupted.

After some digging there seems to be a little culprit in vgacon since the
beginning of ages (well git). The function vgacon_font_get will store the
number of characters correctly in font->charcount but then calls to
vgacon_do_font_op(..., 0, 0). Which means only the lower 256 characters are
actually stored to the fontdata. The rest is left untouched. So the next time
that saved data is used, the garbled font appears. This happens on every
switch between text consoles.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Tested-by: Uwe Geuder <ubuntuLp-ugeuder@sneakemail.com>
---
 drivers/video/console/vgacon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index d012edd..38e86b8 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -1282,7 +1282,7 @@ static int vgacon_font_get(struct vc_data *c, struct console_font *font)
 	font->charcount = vga_512_chars ? 512 : 256;
 	if (!font->data)
 		return 0;
-	return vgacon_do_font_op(&state, font->data, 0, 0);
+	return vgacon_do_font_op(&state, font->data, 0, vga_512_chars);
 }
 
 #else
-- 
1.5.4.3


--------------040508070000040108020402--
