Return-Path: <linux-kernel-owner+w=401wt.eu-S1760127AbZEKW6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127AbZEKW6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758711AbZEKW6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:58:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:60050 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530AbZEKW6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:58:30 -0400
Message-Id: <200905112258.27662.arnd@arndb.de>
References: <20090511222702.352192505@arndb.de>>
User-Agent: quilt/0.46-1
Date: Mon, 11 May 2009 22:58:27 +0000
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
Subject: [PATCH] input: use PIT_TICK_RATE in vt beep ioctl
Content-Disposition: inline
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19qC4wb13u6iS8h2eFHNg1ERxTFqS9UZT+OS7+
 G81trkuT3t6YWqT6rLp3PJhOACXoIUKL4UDqtXCx2iM0HVd3Vx
 gQLFMOo4V6HR550MhizZg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The KIOCSOUND and KDMKTONE ioctls are based on the
CLOCK_TICK_RATE, which is architecture and sometimes
configuration specific.

In practice, most user applications assume that it
is actually defined as the i8253 PIT base clock of
1193182 Hz, which is true on some architectures
but not on others.

This patch makes the vt code use the PIT frequency
on all architectures, which is much more well-defined.
It will change the behavior of user applications
sending the beep ioctl on all architectures that
define CLOCK_TICK_RATE different from PIT_TICK_RATE.

Hopefully, this change will make the frequency correct
in more cases than it will make it incorrect.

This patch depends on "move PIT_TICK_RATE to linux/timex.h"
in order to build on architectures that previously did not
define PIT_TICK_RATE.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/vt_ioctl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index e6ce632..00f96b6 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -404,7 +404,7 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 		   supported and somehow separate the historic advertised
 		   tick rate from any real one */
 		if (arg)
-			arg = CLOCK_TICK_RATE / arg;
+			arg = PIT_TICK_RATE / arg;
 		kd_mksound(arg, 0);
 		break;
 
@@ -424,7 +424,7 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 		   supported and somehow separate the historic advertised
 		   tick rate from any real one */
 		if (count)
-			count = CLOCK_TICK_RATE / count;
+			count = PIT_TICK_RATE / count;
 		kd_mksound(count, ticks);
 		break;
 	}
-- 
1.6.0.4

-- 


