Return-Path: <linux-kernel-owner+w=401wt.eu-S1752595AbXDWQtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbXDWQtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 12:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbXDWQtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 12:49:45 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:49078 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752595AbXDWQto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 12:49:44 -0400
Subject: Re: [PATCH] dma_declare_coherent_memory wrong allocation
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, jayalk@intworks.biz,
       akpm@linux-foundation.org
In-Reply-To: <Pine.LNX.4.60.0704222202050.4127@poirot.grange>
References: <Pine.LNX.4.60.0704132000030.5919@poirot.grange>
	 <1177260725.4268.9.camel@mulgrave.il.steeleye.com>
	 <Pine.LNX.4.60.0704222202050.4127@poirot.grange>
Content-Type: text/plain
Date: Mon, 23 Apr 2007 11:58:25 -0400
Message-Id: <1177343905.6284.22.camel@mulgrave>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-23 at 00:45 +0200, Guennadi Liakhovetski wrote:
> Right, thinko. How about using his:
> 
> +	int pages = DIV_ROUND_UP(size, PAGE_SIZE);

Actually, no ... this has to be size >> PAGE_SHIFT.  The reason being
that the  allocator is designed to allocate pages out of a device memory
buffer.  If the size isn't a multiple of page size, we have to round
down (we can't allocate the last page if the memory we have is only part
of a page).

I suppose if you want to catch the unlikely nutcase where size <
PAGE_SIZE you could

if (unlikely(pages == 0))
	goto out;

> +	int bitmap_size = BITS_TO_LONGS(pages) * BYTES_PER_LONG;

This is fine, except the BYTES_PER_LONG.  Traditionally, we do this with
sizeof(long).  The only reason to have a #define for it is if it has to
be used in a macro (the compiler does sizeof() not the preprocessor).

How about just a simple

int bitmap_size = BITS_TO_LONGS(pages) * sizeof(long);

?

Then you don't need the first patch defining BYTES_PER_LONG.

> to also allow for size not an integer number of pages as Andrew noticed? 
> This could be done in 2 patches:

James


