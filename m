Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbYAWNg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbYAWNg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 08:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbYAWNgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 08:36:21 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:61398 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751175AbYAWNgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 08:36:20 -0500
Date: Wed, 23 Jan 2008 14:35:03 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Marc Pignat <marc.pignat@hevs.ch>
Cc: Andrew Victor <linux@maxim.org.za>, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org, Remy Bohmer <linux@bohmer.net>,
       Chip Coldwell <coldwell@redhat.com>
Subject: Re: [PATCH 6/6] atmel_serial: Add DMA support
Message-ID: <20080123143503.764bc8cf@dhcp-252-066.norway.atmel.com>
In-Reply-To: <200801231418.38997.marc.pignat@hevs.ch>
References: <1201013444-30370-1-git-send-email-hskinnemoen@atmel.com>
	<200801231330.32777.marc.pignat@hevs.ch>
	<20080123134553.144ca487@dhcp-252-066.norway.atmel.com>
	<200801231418.38997.marc.pignat@hevs.ch>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jan 2008 14:18:38 +0100
Marc Pignat <marc.pignat@hevs.ch> wrote:

> On Wednesday 23 January 2008, Haavard Skinnemoen wrote:
> > Ok, but then any power of two larger than the cache line size should be
> > fine, assuming kmalloc() returns a properly aligned buffer.
> Yes. The memory should be allocated using GFP_KERNEL | GFP_DMA flags, but this
> is probably a nop on at91 and avr32.

GFP_DMA doesn't have anything to do with alignment, AFAIK.

> I prepare a patch using the generic dma api (allocation + dma mapping in one
> call = simpler code).

No, please don't. If you're thinking of dma_alloc_coherent(), it means
that the cache will be bypassed when accessing the buffer (slower), and
that the size will be rounded up to the next multiple of the page size
(larger). If the sole purpose of doing that is to get properly aligned
buffers, we might as well use the page allocator directly.

kmalloc() does return cache-aligned buffers on AVR32, so a patch like
that would have only downsides. I'm not sure about ARM though.

> > Other than that, I can't see any reason why a platform with 64 byte
> > cache lines should need larger buffers than one with 32 byte cache
> > lines.
> If the memory at the end of the cacheline is used by the cpu, it will be
> corrupted while you call dma_sync_single_for_cpu(..., DMA_FROM_DEVICE);

True, but if that happens, the right fix is to provide a suitable
definition of ARCH_KMALLOC_MINALIGN on ARM.

Haavard
