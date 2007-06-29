Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbXF2XGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbXF2XGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 19:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbXF2XGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 19:06:40 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39191 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752730AbXF2XGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 19:06:39 -0400
Date: Sat, 30 Jun 2007 00:11:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, clameter@sgi.com, hugh@veritas.com,
       James.Bottomley@steeleye.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Containment measures for slab objects on scatter gather
 lists
Message-ID: <20070630001138.6caeb745@the-village.bc.nu>
In-Reply-To: <20070629211434.GA21187@flint.arm.linux.org.uk>
References: <Pine.LNX.4.64.0706282128570.11739@schroedinger.engr.sgi.com>
	<20070628.220606.112621271.davem@davemloft.net>
	<20070628222424.4cbae90c.akpm@linux-foundation.org>
	<20070628.223734.21928089.davem@davemloft.net>
	<20070628224519.1a3319c3.akpm@linux-foundation.org>
	<20070629131657.5ecc3baa@the-village.bc.nu>
	<20070629134529.3e12a131.akpm@linux-foundation.org>
	<20070629211434.GA21187@flint.arm.linux.org.uk>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> DMA to or from memory should be done via the DMA mapping API.  If we're
> DMAing to/from a limited range within a page, either we should be using
> dma_map_single(), or dma_map_page() with an appropriate offset and size.

If those ranges overlap a cache line then the dma mapping API will not
save your backside.

On a system with a 32 byte cache granularity what happens if you get two
dma mapping calls for x and x+16. Right now the thing that avoids this
occurring is that the allocators don't pack stuff in that hard so x+16
always belongs to the same driver and we can hope driver authors are
sensible 

> sizes, but they do happen.  We handle this on ARM by writing back
> the overlapped lines and invalidating the rest before the DMA operation
> commences, and hope that the overlapped lines aren't touched for the
> duration of the DMA.)

The combination of "hope" and "DMA" isn't a good one for stable system
design. In this situation we should be waving large red flags
