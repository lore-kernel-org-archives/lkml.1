Return-Path: <linux-kernel-owner+w=401wt.eu-S933114AbYEITYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114AbYEITYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 15:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbYEITYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 15:24:23 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:58292 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbYEITYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 15:24:22 -0400
Date: Fri, 9 May 2008 21:24:20 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: David Miller <davem@davemloft.net>
cc: linux-kernel@vger.kernel.org, adaplas@pol.net, hpa@zytor.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: 2.6.26-rcX VC console scrolling regression
In-Reply-To: <20080508.232602.193723628.davem@davemloft.net>
Message-ID: <alpine.LNX.1.10.0805092124010.28042@fbirervta.pbzchgretzou.qr>
References: <20080507.214637.193700986.davem@davemloft.net> <alpine.LNX.1.10.0805081236190.16904@fbirervta.pbzchgretzou.qr> <20080508.232602.193723628.davem@davemloft.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-05-09 08:26, David Miller wrote:
>> My guess is that you see the effects of incomplete font table/position
>> switching, something along the lines a `cat /dev/urandom` would cause.
>> Using the very same kernel and boot params (vga=791 or anything to
>> switch it to fbcon), I cannot trigger the problem on opensuse.
>
>Jan, there is code in drivers/video/console/fbcon.c:fbcon_do_set_font()
>which makes changes to vc->vc_video_erase_char, maybe that code needs
>to update the new vc->vc_scrl_erase_char you added?
>
>It would be nice if you could audit the tree to see if any other cases
>have been missed like this as well.
>
Try this patch please.

---
 drivers/video/console/fbcon.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index ca2a543..774f803 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -2508,6 +2508,9 @@ static int fbcon_do_set_font(struct vc_data *vc, int w, int h,
 			c = vc->vc_video_erase_char;
 			vc->vc_video_erase_char =
 			    ((c & 0xfe00) >> 1) | (c & 0xff);
+			c = vc->vc_def_color;
+			vc->vc_scrl_erase_char =
+			    ((c & 0xFE00) >> 1) | (c & 0xFF);
 			vc->vc_attr >>= 1;
 		}
 	} else if (!vc->vc_hi_font_mask && cnt == 512) {
@@ -2538,9 +2541,14 @@ static int fbcon_do_set_font(struct vc_data *vc, int w, int h,
 			if (vc->vc_can_do_color) {
 				vc->vc_video_erase_char =
 				    ((c & 0xff00) << 1) | (c & 0xff);
+				c = vc->vc_def_color;
+				vc->vc_scrl_erase_char =
+				    ((c & 0xFF00) << 1) | (c & 0xFF);
 				vc->vc_attr <<= 1;
-			} else
+			} else {
 				vc->vc_video_erase_char = c & ~0x100;
+				vc->vc_scrl_erase_char = c & ~0x100;
+			}
 		}
 
 	}
-- 
1.5.5.1

