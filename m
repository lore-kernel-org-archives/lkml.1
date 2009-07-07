Return-Path: <linux-kernel-owner+w=401wt.eu-S1757244AbZGGOHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbZGGOHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755231AbZGGOHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:07:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57341 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085AbZGGOHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:07:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH][RFC] asm-generic:remove calling flush_write_buffers() in dma_sync_*_for_cpu
Date: Tue, 7 Jul 2009 16:06:48 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.30-9-generic; KDE/4.2.95; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Joerg Roedel <joerg.roedel@amd.com>, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "linux-arm-kernel" <linux-arm-kernel@lists.arm.linux.org.uk>
References: <1246199959-6548-1-git-send-email-tom.leiming@gmail.com> <20090707074821.GB6995@n2100.arm.linux.org.uk> <d82e647a0907070643i198b9188q80203ab0408b4df8@mail.gmail.com>
In-Reply-To: <d82e647a0907070643i198b9188q80203ab0408b4df8@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907071606.48933.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/1Jzyw1JsPx8b54eWMbNC+GiCySV8kZ1eBmij
 lEiaswa9PGvBG/5yr+EY90PT8buCjsvfCsjYlvMK98xgYu+HDx
 g3yb90bcypLIyWC/maxWQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 July 2009, Ming Lei wrote:
> > ARM has two (normal, and dma bounce), and in the long run we need to do
> 
> OK, Can we use dma-mapping-common.h on ARM?

It should work in principle. It may be a good idea to also move to
the generic swiotlb instead of the traditional dma bounce at the
same time.

Note that dma-mapping-common.h is only needed if you want to support
two or more different DMA implementations in a single kernel, which
I'm not sure is needed for ARM.

> > cache handling on unmap as well as map due to CPU speculative fetches.
> 
> IMHO, it seems we can fix this problem now.
> 
> For DMA_TO_DEVICE transfer, clean cache in dma map, but does nothing in
> dma unmap;
> 
> For  DMA_FROM_DEVICE, we may do nothing in dma map, but invaliate cache
> in dma unmap.

A number of other architectures do this already. You also need to
have dma_sync_*_for_cpu and dma_sync_*_for_device, where the *_for_device
operation needs to do the same flushing as dma_map_* and *_for_cpu
does the same as dma_unmap_*.

Note that actually you need to do writeback+invalidate in DMA_TO_DEVICE
and at least an invalidate in DMA_FROM_DEVICE during dma_map_*.
For the unmap, I don't think you ever need to invalidate the cache.
If you invalidate only at unmap time for DMA_FROM_DEVICE, a dirty
cache line might be accidentally flushed to the buffer after
the device has written to it.

	Arnd <><
