Return-Path: <linux-kernel-owner+w=401wt.eu-S1761610AbZATAv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761610AbZATAv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbZATAvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 19:51:19 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:64578 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752210AbZATAvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 19:51:18 -0500
Date: Tue, 20 Jan 2009 09:48:31 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-sh <linux-sh@vger.kernel.org>
Subject: Re: Bug: Latest (rc2 and beyond) kernel fails on Dreamcast
Message-ID: <20090120004830.GA12965@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <lkmladrian@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-sh <linux-sh@vger.kernel.org>
References: <8b67d60901181626l43a8728fh6f2a2ab146b45d90@mail.gmail.com> <8b67d60901191433u51d062bgffa523c7da811cb8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b67d60901191433u51d062bgffa523c7da811cb8@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 10:33:57PM +0000, Adrian McMenamin wrote:
> 2009/1/19 Adrian McMenamin <lkmladrian@gmail.com>:
> > I haven't had time to look at this, but the most up to date kernel
> > (and the one of around a week ago also) fails to boot, seemingly
> > seeking an IP address for the 8139too based NIC.
> 
> > [    4.664236] Sending DHCP requests .<3>eth0: PCI Bus error 2200.
> > [    4.669582] eth0: PCI Bus error 2200.
> 
> And the bisection reveals the following:
> 
> adrian@bossclass:~/linux-2.6$ git bisect bad
> 58c6d3dfe436eb8cfb451981d8fdc9044eaf42da is first bad commit
> commit 58c6d3dfe436eb8cfb451981d8fdc9044eaf42da
> Author: Johannes Weiner <hannes@cmpxchg.org>
> Date:   Tue Jan 6 14:43:10 2009 -0800
> 
>     dma-coherent: catch oversized requests to dma_alloc_from_coherent()
> 
>     Prevent passing an order to bitmap_find_free_region() that is larger than
>     the actual bitmap can represent.
> 
>     These requests can come from device drivers that have no idea how big the
>     dma region is and need to rely on dma_alloc_from_coherent() to sort it out
>     for them.
> 
>     Reported-by: Guennadi Liakhovetski <lg@denx.de>
>     Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>     Cc: Pekka Enberg <penberg@cs.helsinki.fi>
>     Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
>     Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
>     Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> :040000 040000 5c8a694b778f36a3254103d99cb73b561cb84565
> 5efd4e32eb145f32ca4e96aefbea08f4f8f4d27d M	kernel

The dreamcast uses a 32kB coherent area for PCI DMA, which all of the
8139too allocations should fit under just fine. What does
dma_alloc_from_coherent() say the requested size is, vs the per-device
memory size for each allocation?
