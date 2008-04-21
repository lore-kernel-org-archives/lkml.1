Return-Path: <linux-kernel-owner+w=401wt.eu-S1756890AbYDUSZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbYDUSZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 14:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755197AbYDUSZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 14:25:20 -0400
Received: from mail.AKNET.ru ([77.246.241.226]:51982 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755055AbYDUSZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 14:25:19 -0400
Message-ID: <480CD281.6050902@aknet.ru>
Date: Mon, 21 Apr 2008 21:44:33 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Takashi Iwai <tiwai@suse.de>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: 2.6.25-mm1 (snd-pcsp causes driver conflict)
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>	<20080419021343.GA3503@nineveh.local>	<20080418200237.b5a9e805.akpm@linux-foundation.org>	<20080419041429.GA8508@anvil.corenet.prv>	<20080418212934.bbe84ee2.akpm@linux-foundation.org> <s5hwsmrcvow.wl%tiwai@suse.de>
In-Reply-To: <s5hwsmrcvow.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: multipart/mixed;
 boundary="------------070905050306080302080204"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070905050306080302080204
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello.

Takashi Iwai wrote:
> [Added snd-pcsp author to Cc]
Thanks.

> Seems that snd-pcsp registers as "pcspkr", which is identical with
> input pc-speaker driver.  Does the patch below fix the problem?
Actually it does not. The reason is that
then it fails to match the platform device,
which is created in arch/x86/kernel/pcspeaker.c,
with the name of "pcspkr".

But we already had the patch for that in an
alsa tree, it probably got forgotten. Here
it is:
http://hg-mirror.alsa-project.org/alsa-driver/raw-file/90eeee75052f/utils/patches/pcsp-kernel-2.6.22-01.diff

Also attaching it here.
It simply disables the pcspkr driver in
Kconfig. snd-pcsp has the copy of that
driver, so that only one driver would
drive the device.

Does that fix look good? (presumably acked
by Takashi, otherwise the patch wouldn't
be in an alsa tree)

---------------

- Prevent pcspkr driver from being built
together with snd-pcsp. snd-pcsp fully
superceeds pcspkr.
- Update CREDITS file. :)

Signed-off-by: Stas Sergeev <stsp@aknet.ru>
Acked-by: Takashi Iwai <tiwai@suse.de>

--------------070905050306080302080204
Content-Type: text/x-patch;
 name="pcsp-kernel-2.6.24-01.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="pcsp-kernel-2.6.24-01.diff"

diff -urN linux-2.6.24/CREDITS linux-2.6.24-pcsp-kern/CREDITS
--- linux-2.6.24/CREDITS	2008-01-27 16:13:20.000000000 +0300
+++ linux-2.6.24-pcsp-kern/CREDITS	2008-01-27 17:03:31.000000000 +0300
@@ -403,6 +403,8 @@
 N: Erik Inge Bolsø
 E: knan@mo.himolde.no
 D: Misc kernel hacks
+D: Updated PC speaker driver for 2.3
+S: Norway
 
 N: Andreas E. Bombe
 E: andreas.bombe@munich.netsurf.de
@@ -3109,6 +3111,12 @@
 S: Sunnyvale, California 94088-4132
 S: USA
 
+N: Stas Sergeev
+E: stsp@users.sourceforge.net
+D: PCM PC-Speaker driver
+D: misc fixes
+S: Russia
+
 N: Simon Shapiro
 E: shimon@i-Connect.Net
 W: http://www.-i-Connect.Net/~shimon
diff -urN linux-2.6.24/drivers/input/misc/Kconfig linux-2.6.24-pcsp-kern/drivers/input/misc/Kconfig
--- linux-2.6.24/drivers/input/misc/Kconfig	2008-01-27 16:13:43.000000000 +0300
+++ linux-2.6.24-pcsp-kern/drivers/input/misc/Kconfig	2008-01-27 17:03:31.000000000 +0300
@@ -14,7 +14,8 @@
 
 config INPUT_PCSPKR
 	tristate "PC Speaker support"
-	depends on ALPHA || X86 || MIPS || PPC_PREP || PPC_CHRP || PPC_PSERIES
+	depends on (ALPHA || X86 || MIPS || PPC_PREP || PPC_CHRP || \
+		PPC_PSERIES) && SND_PCSP=n
 	help
 	  Say Y here if you want the standard PC Speaker to be used for
 	  bells and whistles.

--------------070905050306080302080204--
