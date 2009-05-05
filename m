Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbZEEK61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbZEEK61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 06:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbZEEK6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 06:58:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:50548 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbZEEK6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 06:58:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: compat ioctl32 for /dev/snapshot?
Date: Tue, 5 May 2009 12:58:04 +0200
User-Agent: KMail/1.9.9
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux-kernel <linux-kernel@vger.kernel.org>
References: <49FEB572.4010909@msgid.tls.msk.ru> <200905041352.18428.arnd@arndb.de> <49FF6B94.2080008@msgid.tls.msk.ru>
In-Reply-To: <49FF6B94.2080008@msgid.tls.msk.ru>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905051258.05102.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+LUeBw3tkZdzr3i6k7/MAp4U1P5g73kMKRu1y
 biUh0y7QEOp/fNdYFFg9SY0en2CrfeoyiFnZgQFuAxDKOMv7AI
 3o3Dt67AG7ITLdRn4vbTQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 May 2009, Michael Tokarev wrote:
> Arnd Bergmann wrote:
> > On Monday 04 May 2009, Michael Tokarev wrote:
> >> Is the following patch ok?  I just pulled all the SNAPSHOT_* stuff from
> >> include/linux/suspend_ioctls.h and added them into fs/compat_ioctl.c.
> []
> 
> > You are however missing support for deprecated ioctls in your
> > code: SNAPSHOT_SET_SWAP_FILE and SNAPSHOT_PMOPS are trivial
> > (COMPATIBLE_IOCTL), but you also need to add support for
> > these
> 
> Well, as comments in that file (kernel/power/user.c) states, those
> ioctls are obsolete and will be removed and are only preserved for
> compatibility etc.  Since no one complained so far (well, no one
> complained about whole /dev/snapshot thing at all ;), maybe there's
> no need to define those and the following ones too?
> 
> > #define SNAPSHOT_ATOMIC_SNAPSHOT32 _IOW(SNAPSHOT_IOC_MAGIC, 3, compat_uptr_t)
> > #define SNAPSHOT_SET_IMAGE_SIZE32 _IOW(SNAPSHOT_IOC_MAGIC, 6, compat_ulong)
> > #define SNAPSHOT_AVAIL_SWAP32 _IOR(SNAPSHOT_IOC_MAGIC, 7, compat_uptr_t)
> > #define SNAPSHOT_GET_SWAP_PAGE32 _IOR(SNAPSHOT_IOC_MAGIC, 8, compat_uptr_t)

The point is that they are meant for compatibility with existing binaries,
which is also the reason for having the compat_ioctl in the first place.
The kernel should behave in identical ways for both 32 and 64 bits, so
either we add all of the ioctl numbers in compat mode, or we remove support
for the obsolete calls in native mode as well.

> > Please try this patch instead:
> 
> Ok.  Your patch was garbled by your MUA (inserting =3D =20 and breaking
> lines), but that's ok.

sorry about that, I'll try to find out how that happened.

> After de-garbling it now complains about 
> undefined compat_uptr_t.  For that, I've added
> 
> #ifdef CONFIG_COMPAT
> #include <linux/compat.h>
> #endif

This one does not need to be enclosed in #ifdef CONFIG_COMPAT,
the file can always be included. The reason for the #ifdef inside
of the switch() statement is that you otherwise get warnings
about duplicate case statements on 32 bit kernels.
 
	Arnd <><
