Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbZGVRL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbZGVRL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 13:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbZGVRL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 13:11:56 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:57535 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbZGVRLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 13:11:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=sKrJ0B3dTOLysiLnsGffsFIiQe9cl5SW3s4LGhmBO36yVE4eg0R8PsrcqJyxXjfdUu
         URMtgPRYaaeFaDDuB9ZgMW+CmrL9Lp1p+ajSLcq82qy88JH4bc2i/3aJgQ/+tVymNScP
         GCplg6Uws8xw7VEQheUZRyb1GgjLBr5YAqbLM=
Date: Wed, 22 Jul 2009 20:11:48 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Do cpu-endian MMIO accessors exist?
Message-ID: <20090722201148.19f47119@daedalus.pq.iki.fi>
In-Reply-To: <200907220001.59388.arnd@arndb.de>
References: <20090721234243.1928d9e2@daedalus.pq.iki.fi>
	<200907212315.50225.arnd@arndb.de>
	<20090721213333.GA27202@infradead.org>
	<200907220001.59388.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009 00:01:59 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Tuesday 21 July 2009, Christoph Hellwig wrote:
> > Why would you want to do that?  That just means a useless byteswap.
> > We really should have a generic native-endian MMIO-access API as there
> > is quite a bit of hardware with features like that, and currently we
> > have a miriad of hacks using __raw_* and manual barriers, the ppc
> > specific accessors and god knows what.

My motivation is to clean up nouveau code, and I was first thinking the
same as Christoph.

Arnd is right, there is an easy way to switch the card's endianess,
in theory. I hear there are few cases where it doesn't work yet.

> The byte swap on powerpc I/O instructions is practically free
> on all the interesting CPUs, and on the others it is still
> swamped by the overhead of the synchronization. If you care
> about the latency of MMIO instructions, going to explicit
> synchronization would help much more, saving hundreds of
> cycles per I/O rather than one cycle for a saved byte swap.

I figured something like that while reading the ppc implementation.
Therefore having the card always LE is not much different from setting
it to cpu endianness. I'll let the Nouveau developers decide which
way to do it, and keep it as is for now.

> The powerpc in_le32 style functions are a completely different
> story, they are basically defined to operate only on on-chip
> components, while ioread32 and readl do work on PCI devices.

So what should I use on BE arches when the card is in BE mode?
Not out_be32() but iowrite32be()?
I never even noticed that io*be() functions exist, thanks for the hint.

On LE arches I'll stick to {read,write}[bwl], which in my
understanding always handle the hardware as LE. Right?

> No portable code should ever use the __raw_* functions and
> architecture specific barriers.

Yeah, it felt like that, hence I asked here.

> It would of course be easy to just define an API extension
> to ioread along the lines of
> 
> #ifdef __BIG_ENDIAN
> #define ioread16_native ioread16be
> #define ioread32_native ioread32be
> #define iowrite16_native iowrite16be
> #define iowrite32_native iowrite32be
> #else
> #define ioread16_native ioread16
> #define ioread32_native ioread32
> #define iowrite16_native iowrite16
> #define iowrite32_native iowrite32
> #endif
> 
> but I'm not yet convinced that there is a potential user that
> should not just be fixed in a different way.

This is how it currently is.


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
