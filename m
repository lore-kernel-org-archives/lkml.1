Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363Ab0AJOJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab0AJOJp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 09:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171Ab0AJOJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 09:09:44 -0500
Received: from mv-drv-hcb003.ocn.ad.jp ([118.23.109.133]:56509 "EHLO
	mv-drv-hcb003.ocn.ad.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab0AJOJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 09:09:43 -0500
X-Greylist: delayed 169467 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Jan 2010 09:09:43 EST
Date: Sun, 10 Jan 2010 23:09:36 +0900 (JST)
Message-Id: <20100110.230936.193681280.anemo@mba.ocn.ne.jp>
To: arnd@arndb.de
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: compat_ioctl: unknown cmd on serial /dev/console
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <201001081718.23840.arnd@arndb.de>
References: <20100109.000510.193873785.anemo@mba.ocn.ne.jp>
	<201001081718.23840.arnd@arndb.de>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jan 2010 17:18:23 +0100, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 08 January 2010, Atsushi Nemoto wrote:
> > After the commit fb07a5f8 ("compat_ioctl: remove all VT ioctl
> > handling"), I got this error message on 64-bit mips kernel with 32-bit
> > busybox userland:
> > 
> > ioctl32(init:1): Unknown cmd fd(0) cmd(00005600){t:'V';sz:0} arg(7fd76480) on /dev/console
> 
> Just to confirm: The behaviour of the kernel is still correct, it's only
> the message you are worried about, right?

Yes.

> Sorry for this, it will be trivial to fix.
> 
> > The cmd 5600 is VT_OPENQRY.  The busybox's init issues this ioctl to
> > know vt-console or serial-console.  If the console was serial console,
> > VT ioctls are not handled by the serial driver.
> > 
> > How this error should be fixed?  Is this patch OK?
> > 
> > diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
> > index 332dd00..731478f 100644
> > --- a/fs/compat_ioctl.c
> > +++ b/fs/compat_ioctl.c
> > @@ -1005,6 +1005,8 @@ COMPATIBLE_IOCTL(SCSI_IOCTL_SEND_COMMAND)
> >  COMPATIBLE_IOCTL(SCSI_IOCTL_PROBE_HOST)
> >  COMPATIBLE_IOCTL(SCSI_IOCTL_GET_PCI)
> >  #endif
> > +/* Big V (for serial console case) */
> > +COMPATIBLE_IOCTL(VT_OPENQRY)
> >  /* Little p (/dev/rtc, /dev/envctrl, etc.) */
> >  COMPATIBLE_IOCTL(RTC_AIE_ON)
> >  COMPATIBLE_IOCTL(RTC_AIE_OFF)
> 
> I would probably write this as IGNORE_IOCTL() instead of COMPATIBLE_IOCTL
> in order to document the intent, but it's functionally the same.

OK, IGNORE_IOCTL seems better.

> > And by quick search, I found some programs using VT_GETMODE to check
> > vt-console is available or not.  So VT_GETMODE might be an another
> > candidate, but not sure.
> 
> Yes, that sounds reasonable, too.

OK, then I will make a patch to add IGNORE_IOCTL on them.

---
Atsushi Nemoto
