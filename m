Return-Path: <linux-kernel-owner+w=401wt.eu-S1757403AbZGGPbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbZGGPbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755752AbZGGPbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:31:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51859 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452AbZGGPbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:31:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH][RFC] asm-generic:remove calling flush_write_buffers() in dma_sync_*_for_cpu
Date: Tue, 7 Jul 2009 17:30:45 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.30-9-generic; KDE/4.2.95; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Joerg Roedel <joerg.roedel@amd.com>, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "linux-arm-kernel" <linux-arm-kernel@lists.arm.linux.org.uk>
References: <1246199959-6548-1-git-send-email-tom.leiming@gmail.com> <200907071606.48933.arnd@arndb.de> <d82e647a0907070755m150b8aa0x3ae8faf1c47587f9@mail.gmail.com>
In-Reply-To: <d82e647a0907070755m150b8aa0x3ae8faf1c47587f9@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907071730.45661.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/4XOiItlPnVntLhAjs4jdsCvvnAI+DAvSMDuV
 AyNX63+4q3g6uageUH/CYexsQM8qQxBl2Rm3QfEe88fpGGodLx
 pFKcbf4wqeyiYkWcgEO8Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 July 2009, Ming Lei wrote:
> > Note that actually you need to do writeback+invalidate in DMA_TO_DEVICE
> 
> IMHO,  writeback in dma map is enough for DMA_TO_DEVICE transfer.

Right. writeback+invalidate would only be needed for bidirectional
transfers but not for DMA_TO_DEVICE.

> > and at least an invalidate in DMA_FROM_DEVICE during dma_map_*.
> > For the unmap, I don't think you ever need to invalidate the cache.
> 
> No,  as Russell said that CPU speculative fetches can make cache "dirty" after
> dma map but before dma is over, then CPU may read inconsistent data
> after DMA_FROM_DEVICE transfer is finished if does not invalidate
> cache in
> dma unmap.

Hmm, I don't think any of the other architectures currently
try to prevent this. Is ARM special in this regard, or does that
mean that the others are broken? What kind of code would cause
a speculative read on a data section that the kernel (by convention)
must not access? Would it be enough to have an rmb() in dma_unmap_*
and dma_sync_*_for_cpu to prevent speculative accesses?

> > If you invalidate only at unmap time for DMA_FROM_DEVICE, a dirty
> > cache line might be accidentally flushed to the buffer after
> > the device has written to it.
> 
> It seems you are reasonable, and we do need to invalidate cache in both dma
> map and dma unmap for DMA_FROM_DEVICE, don't we?

Is it guaranteed that a cache line from a speculative fetch will
never be written back? Otherwise it would still be broken.

	Arnd <><
