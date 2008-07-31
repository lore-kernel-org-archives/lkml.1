Return-Path: <linux-kernel-owner+w=401wt.eu-S1757183AbYGaTme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183AbYGaTme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 15:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758365AbYGaTmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 15:42:15 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:41998 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758239AbYGaTmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:42:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F23vuBQm2RTbFTOuGCwnkvjZOgIUGCriieqzkvZFnQyeUQAyGz7LZ9WOmhKrscQnna
         esAOT1z0baK+YCv0iaTeexT5Q42p863NMSXTHSDZCqQGADtJ1ZqzZhr71XVrAf630Sde
         Iz/YeQebe3MbE/m5t9SDEIg7sqix9I8vETUyg=
Date: Thu, 31 Jul 2008 15:42:07 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: linux-next: Tree for July 30
Message-ID: <20080731194207.GA12233@anvil.corenet.prv>
References: <20080730170635.f737ffe9.sfr@canb.auug.org.au> <20080731104437.5e5669bc.akpm@linux-foundation.org> <20080731141302.ZZRA012@mailhub.coreip.homeip.net> <200807312048.57575.rjw@sisk.pl> <20080731145023.ZZRA012@mailhub.coreip.homeip.net> <alpine.LFD.1.10.0807311207000.3277@nehalem.linux-foundation.org> <20080731151625.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080731151625.ZZRA012@mailhub.coreip.homeip.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 03:24:02PM -0400, Dmitry Torokhov wrote:
> On Thu, Jul 31, 2008 at 12:10:40PM -0700, Linus Torvalds wrote:
> > 
> > Sorry, but you're simply wrong.
> > 
> > If somebody has the commit that broke user space, that commit will be 
> > _reverted_ unless it's fixed. It's that simple. The rules are: we don't 
> > knowingly break user space. 
> >
> 
> We have 3 options now:
> 
> 1. Never change KEY_MAX and dont add any new key definitions.
> 2. Introduce a new ioctl and have all wel-behaving programs rewritten
>    to support it.
> 3. Fix userspace driver (patch is available).
> 
> Gioventhe fact that I wanted that change to go when .28 opens and it
> will really hit users in 6+ months I'd still like to have 3.
>  

I guess we could do something like the below, but it is soooo ugly...

Input: paper over a bug in Synaptics X driver

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/evdev.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 2d65411..c78a63b 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -736,8 +736,10 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 			if ((_IOC_NR(cmd) & ~EV_MAX) == _IOC_NR(EVIOCGBIT(0, 0))) {
 
 				unsigned long *bits;
+				unsigned int buf_len = _IOC_SIZE(cmd);
 				int len;
 
+
 				switch (_IOC_NR(cmd) & EV_MAX) {
 
 				case      0: bits = dev->evbit;  len = EV_MAX;  break;
@@ -751,7 +753,17 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 				case EV_SW:  bits = dev->swbit;  len = SW_MAX;  break;
 				default: return -EINVAL;
 				}
-				return bits_to_user(bits, len, _IOC_SIZE(cmd), p, compat_mode);
+
+				if ((_IOC_NR(cmd) & EV_MAX) == EV_KEY && buf_len == 0x1ff) {
+					printk(KERN_WARNING
+						"evdev.c(EVIOCGBIT): Detected suspicious "
+						"buffer size 0x1ff, limiting output to 64 "
+						"bytes. Make sure you are not using "
+						"EVIOCGBIT(EV_KEY, KEY_MAX)\n");
+					buf_len = 64; 
+				}
+
+				return bits_to_user(bits, len, buf_len, p, compat_mode);
 			}
 
 			if (_IOC_NR(cmd) == _IOC_NR(EVIOCGKEY(0)))
