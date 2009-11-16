Return-Path: <linux-kernel-owner+w=401wt.eu-S1753297AbZKPNvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbZKPNvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 08:51:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbZKPNvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 08:51:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:4483 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbZKPNvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 08:51:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=teLoXbWgby/1Fe0WsQhkeHue8rgH3Qq5/X4v9faeEZ6/5ysS3GJdQ7FCqyi05UA2Yg
         2LrmrfYMiIzQa/lJNKyvfL8EyYiMZR8tITnvu9f00YIG2MwtRvv/h8ZakLW9aFpmkKYO
         IdpfwAAQcAvCVGjwvSI3HRCdyMD3+4T5Qb4ls=
Date: Mon, 16 Nov 2009 16:51:15 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, alan@lxorguk.ukuu.org.uk,
       mgarski@post.pl
Subject: [PATCH] kbd: (#7063) make CapsLock work as expected even for
 non-ASCII
Message-ID: <20091116135114.GA2719@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steps to reproduce:

	[log into console (not xterm)]
	[load non-trivial keymap]
	[turn on CapsLock]
	[type something]

Symbols won't be capital despite CapsLock and despite Shift+* working
as expected.

Note: patch relies on keymap being consistent wrt SMALL/CAPITAL symbols.
Though extracting SMALL <=> CAPITAL mapping from unicode tables and
putting it into kernel may be more correct.

Fix long-standing http://bugzilla.kernel.org/show_bug.cgi?id=7063

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/char/keyboard.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -1261,8 +1261,14 @@ static void kbd_keycode(unsigned int keycode, int down, int hw_raw)
 		param.value = keysym;
 		if (atomic_notifier_call_chain(&keyboard_notifier_list, KBD_UNICODE, &param) == NOTIFY_STOP)
 			return;
-		if (down && !raw_mode)
+		if (down && !raw_mode) {
+			if (vc_kbd_led(kbd, VC_CAPSLOCK)) {
+				key_map = key_maps[shift_final ^ (1 << KG_SHIFT)];
+				if (key_map)
+					keysym = key_map[keycode];
+			}
 			to_utf8(vc, keysym);
+		}
 		return;
 	}
 
