Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809AbYEQPvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbYEQPvN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 11:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbYEQPvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 11:51:01 -0400
Received: from mail.aknet.ru ([78.158.192.26]:62258 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbYEQPvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 11:51:00 -0400
Message-ID: <482EFED2.1020504@aknet.ru>
Date: Sat, 17 May 2008 19:50:42 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Roberto Oppedisano <roberto.oppedisano@infracom.it>,
       LKML <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org
Subject: [patch] snd-pcsp: silent misleading warning
References: <482737BE.20502@infracom.it>	<4827415A.7060101@aknet.ru>	<482756F0.8020609@infracom.it>	<48275D8D.10500@aknet.ru>	<4827F0A1.9090600@infracom.it>	<48288ACC.1020909@aknet.ru>	<48299F08.2060702@infracom.it>	<4829B6A1.90707@infracom.it>	<s5h7idycfmf.wl%tiwai@suse.de>	<482A7A17.8070706@infracom.it> <s5hwslxb3t8.wl%tiwai@suse.de> <482C9A3E.3000009@infracom.it> <482C9F3E.4050104@aknet.ru> <482EC93E.7080702@infracom.it>
In-Reply-To: <482EC93E.7080702@infracom.it>
X-Enigmail-Version: 0.95.2
Content-Type: multipart/mixed;
 boundary="------------070808040209090602050403"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070808040209090602050403
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello.

Roberto Oppedisano wrote:
> I noticed that when I run
> aplay -D plughw:2,0 /usr/share/sounds/KDE_Logout.wav
>  I get a flood of:
> [  417.338143] PCSP: playback_ptr inconsistent (4642 4661 18645)
It turns out that the buffer size you
get, is not evenly devided by period size.
18645 % 4661 = 1.
That (wrongly) triggers the warning.
This may very well be an alsa bug, or
may not, but the code in the driver is
handling that properly, so there is no
need for such a verbose warning.

The attached patch shuts down the warning.
Takashi, could you please apply?

--------------070808040209090602050403
Content-Type: text/x-patch;
 name="pcsp_fixwarn.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pcsp_fixwarn.diff"

# HG changeset patch
# User Stas Sergeev <stsp@users.sourceforge.net>
# Date 1211038849 -14400
# Node ID 2278b9a6058f5b45081f8227902df585474a81a6
# Parent  49d310de8ac42e5c495cf39440f4fde307b39c75
It appears that alsa allows a sound buffer with size not
evenly devided by the period size. This triggers a warning in
snd-pcsp and floods the log. As a quick fix, the warning should
be disabled.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>

diff -r 49d310de8ac4 -r 2278b9a6058f drivers/pcsp/pcsp_lib.c
--- a/drivers/pcsp/pcsp_lib.c	Sat May 17 02:04:12 2008 +0400
+++ b/drivers/pcsp/pcsp_lib.c	Sat May 17 19:40:49 2008 +0400
@@ -119,9 +119,11 @@ enum hrtimer_restart pcsp_do_timer(struc
 	chip->playback_ptr += PCSP_INDEX_INC() * fmt_size;
 	periods_elapsed = chip->playback_ptr - chip->period_ptr;
 	if (periods_elapsed < 0) {
-		printk(KERN_WARNING "PCSP: playback_ptr inconsistent "
+#if PCSP_DEBUG
+		printk(KERN_INFO "PCSP: buffer_bytes mod period_bytes != 0 ? "
 			"(%zi %zi %zi)\n",
 			chip->playback_ptr, period_bytes, buffer_bytes);
+#endif
 		periods_elapsed += buffer_bytes;
 	}
 	periods_elapsed /= period_bytes;

--------------070808040209090602050403--
