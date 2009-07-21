Return-Path: <linux-kernel-owner+w=401wt.eu-S1756338AbZGUWCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338AbZGUWCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 18:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756207AbZGUWCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 18:02:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:65236 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbZGUWCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 18:02:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: Do cpu-endian MMIO accessors exist?
Date: Wed, 22 Jul 2009 00:01:59 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-3-generic; KDE/4.2.96; x86_64; ; )
Cc: Jiri Slaby <jirislaby@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linux-kernel@vger.kernel.org
References: <20090721234243.1928d9e2@daedalus.pq.iki.fi> <200907212315.50225.arnd@arndb.de> <20090721213333.GA27202@infradead.org>
In-Reply-To: <20090721213333.GA27202@infradead.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907220001.59388.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/nUMCcNa55Adype+qws8blnute/VcaZBPZ2sF
 4YT9x4xPY2LK/eCcgLb/POf1OgvYVMLrSbFGU/T0mL2fqMoe+x
 P4n18KC4BeP3NmIRiSYLw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 July 2009, Christoph Hellwig wrote:
> Why would you want to do that?  That just means a useless byteswap.
> We really should have a generic native-endian MMIO-access API as there
> is quite a bit of hardware with features like that, and currently we
> have a miriad of hacks using __raw_* and manual barriers, the ppc
> specific accessors and god knows what.

The byte swap on powerpc I/O instructions is practically free
on all the interesting CPUs, and on the others it is still
swamped by the overhead of the synchronization. If you care
about the latency of MMIO instructions, going to explicit
synchronization would help much more, saving hundreds of
cycles per I/O rather than one cycle for a saved byte swap.

The powerpc in_le32 style functions are a completely different
story, they are basically defined to operate only on on-chip
components, while ioread32 and readl do work on PCI devices.

No portable code should ever use the __raw_* functions and
architecture specific barriers.

It would of course be easy to just define an API extension
to ioread along the lines of

#ifdef __BIG_ENDIAN
#define ioread16_native ioread16be
#define ioread32_native ioread32be
#define iowrite16_native iowrite16be
#define iowrite32_native iowrite32be
#else
#define ioread16_native ioread16
#define ioread32_native ioread32
#define iowrite16_native iowrite16
#define iowrite32_native iowrite32
#endif

but I'm not yet convinced that there is a potential user that
should not just be fixed in a different way.

	Arnd <><
