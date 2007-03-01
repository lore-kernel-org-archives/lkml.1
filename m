Return-Path: <linux-kernel-owner+w=401wt.eu-S932825AbXCAAUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825AbXCAAUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 19:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932830AbXCAAUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 19:20:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58128
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932825AbXCAAUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 19:20:18 -0500
Date: Wed, 28 Feb 2007 16:20:16 -0800 (PST)
Message-Id: <20070228.162016.74750990.davem@davemloft.net>
To: adaplas@pol.net
CC: linux-kernel@vger.kernel.org
Subject: [PATCH]: Fix radeon blanking return value.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


If you'll recall, over a year ago, I pointed out that the current
Radeon driver erroneously returns -EINVAL for valid blanking codes,
here is a link to that thread:

	http://lkml.org/lkml/2006/1/28/6

No other driver does this, and it confuses the X server into thinking
that the device does not support blanking properly.

As a result I have to switch to a console VC and back to the X server
to unblank the screen, which is rediculious.

I've had to do this for more than 3 years and I'm really tired of this
problem still being around :-)

I looked again and there is simply no reason for the Radeon driver to
return -EINVAL for FB_BLANK_NORMAL.  It claims it wants to do this in
order to convince fbcon to blank in software, right here:

			if (fb_blank(info, blank))
				fbcon_generic_blank(vc, info, blank);

to software blank the screen.  But it only causes that to happen
in the FB_BLANK_NORMAL case.

That makes no sense because the Radeon code does this:

		val |= CRTC_DISPLAY_DIS;

in the FB_BLANK_NORMAL case so should be blanking the hardware, and
there is therefore no reason to SW blank by returning -EINVAL.

Therefore I propose we finally apply the following patch.  No other
fbdev driver does this madness, and as I've shown above there is no
justification for the behavior at all :-)

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
index c32b714..af7eb07 100644
--- a/drivers/video/aty/radeon_base.c
+++ b/drivers/video/aty/radeon_base.c
@@ -1032,8 +1032,7 @@ int radeon_screen_blank(struct radeonfb_info *rinfo, int blank, int mode_switch)
 		break;
 	}
 
-	/* let fbcon do a soft blank for us */
-	return (blank == FB_BLANK_NORMAL) ? -EINVAL : 0;
+	return 0;
 }
 
 static int radeonfb_blank (int blank, struct fb_info *info)
