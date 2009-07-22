Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbZGVVVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbZGVVVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 17:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbZGVVVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 17:21:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52671 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbZGVVVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 17:21:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Pekka Paalanen <pq@iki.fi>
Subject: Re: Do cpu-endian MMIO accessors exist?
Date: Wed, 22 Jul 2009 23:19:12 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-3-generic; KDE/4.2.96; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20090721234243.1928d9e2@daedalus.pq.iki.fi> <200907220001.59388.arnd@arndb.de> <20090722201148.19f47119@daedalus.pq.iki.fi>
In-Reply-To: <20090722201148.19f47119@daedalus.pq.iki.fi>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?iso-8859-1?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60?=
 =?iso-8859-1?q?Y=2Ea=5E3zb?=)
 =?iso-8859-1?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5C?=
 =?iso-8859-1?q?wg=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Message-Id: <200907222319.12859.arnd@arndb.de>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX192sfMwb8kMiJ3MzIT8SdLOt0pHtLahJ5NxyGw
 mGviJProlDCnnXxj1ePfjUeCDrvKACI3jA1E/aMOmmEBxim0UL
 uZLoVE/qbNLBbK7wjWmMQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 July 2009, Pekka Paalanen wrote:
> > The powerpc in_le32 style functions are a completely different
> > story, they are basically defined to operate only on on-chip
> > components, while ioread32 and readl do work on PCI devices.
> 
> So what should I use on BE arches when the card is in BE mode?
> Not out_be32() but iowrite32be()?
> I never even noticed that io*be() functions exist, thanks for the hint.

If it's a PCI/AGP/PCIe device, use iowrite32be(), otherwise it
may not work correctly on a pseries, celleb or qs20 machine.

If it's connected over a different bus (IOIF on PS3), out_be32
would be more appropriate, but AFAICT, iowrite32be should work
just as well.

> On LE arches I'll stick to {read,write}[bwl], which in my
> understanding always handle the hardware as LE. Right?

Right. For consistency you could decide to switch to iowrite32()
to go along with iowrite32be(), that should be equivalent on
MMIO based devices to writel.

> > It would of course be easy to just define an API extension
> > to ioread along the lines of
> > 
> > #ifdef __BIG_ENDIAN
> > #define ioread16_native ioread16be
> > #define ioread32_native ioread32be
> > #define iowrite16_native iowrite16be
> > #define iowrite32_native iowrite32be
> > #else
> > #define ioread16_native ioread16
> > #define ioread32_native ioread32
> > #define iowrite16_native iowrite16
> > #define iowrite32_native iowrite32
> > #endif
> > 
> > but I'm not yet convinced that there is a potential user that
> > should not just be fixed in a different way.
> 
> This is how it currently is.

Well, I meant we could add it to asm-generic/iomap.h. If we
decide that this is the right approach after all, it should
be part of the common linux API, not private to a single driver.

	Arnd <><

