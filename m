Return-Path: <linux-kernel-owner+w=401wt.eu-S1758563AbYGaUcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563AbYGaUcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 16:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbYGaUcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 16:32:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752866AbYGaUcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 16:32:17 -0400
Date: Thu, 31 Jul 2008 13:28:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: linux-next: Tree for July 30
In-Reply-To: <alpine.LFD.1.10.0807311310090.3277@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807311318580.3277@nehalem.linux-foundation.org>
References: <20080730170635.f737ffe9.sfr@canb.auug.org.au> <20080731104437.5e5669bc.akpm@linux-foundation.org> <20080731141302.ZZRA012@mailhub.coreip.homeip.net> <200807312048.57575.rjw@sisk.pl> <20080731145023.ZZRA012@mailhub.coreip.homeip.net>
 <alpine.LFD.1.10.0807311207000.3277@nehalem.linux-foundation.org> <20080731151625.ZZRA012@mailhub.coreip.homeip.net> <alpine.LFD.1.10.0807311235350.3277@nehalem.linux-foundation.org> <20080731155701.ZZRA012@mailhub.coreip.homeip.net>
 <alpine.LFD.1.10.0807311310090.3277@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 31 Jul 2008, Linus Torvalds wrote:
> >     /* Check for ABS_X, ABS_Y, ABS_PRESSURE and BTN_TOOL_FINGER */
> > 
> >     SYSCALL(ret = ioctl(fd, EVIOCGBIT(0, KEY_MAX), evbits));
> > 
> > So we allocate 64 bytes on stack and then as kernel to fill it with
> > 511 bytes worth of data.
> 
> Ok, I can see how it's confused, asking for KEY_MAX _bits_. If this is the 
> main user, why not just change the definition to be in bits?

Or just say that "if the buffer is really much too big, maybe they meant 
bits"?

IOW, something like this?

(And no, I'm not seriously proposing _this_ patch, but you get the idea)

		Linus
---
 drivers/input/evdev.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 2d65411..e45451d 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -734,7 +734,7 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 		if (_IOC_DIR(cmd) == _IOC_READ) {
 
 			if ((_IOC_NR(cmd) & ~EV_MAX) == _IOC_NR(EVIOCGBIT(0, 0))) {
-
+				unsigned int size = _IOC_SIZE(cmd);
 				unsigned long *bits;
 				int len;
 
@@ -751,7 +751,12 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 				case EV_SW:  bits = dev->swbit;  len = SW_MAX;  break;
 				default: return -EINVAL;
 				}
-				return bits_to_user(bits, len, _IOC_SIZE(cmd), p, compat_mode);
+
+				/* Some people get confused about size in bits vs bytes */
+				if (size >= len/8)
+					size = size/8;
+
+				return bits_to_user(bits, len, size, p, compat_mode);
 			}
 
 			if (_IOC_NR(cmd) == _IOC_NR(EVIOCGKEY(0)))
