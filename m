Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbZAIMQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbZAIMQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 07:16:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbZAIMQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 07:16:41 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:48396 "EHLO mail.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752675AbZAIMQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 07:16:40 -0500
X-Greylist: delayed 3403 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jan 2009 07:16:39 EST
Date: Fri, 9 Jan 2009 11:19:36 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       linux-arch@vger.kernel.org
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, dan.j.williams@intel.com,
       linux-kernel@vger.kernel.org, maciej.sosnowski@intel.com
Subject: Re: [PATCH] dmatest: flush and invalidate destination buffer
	before DMA
Message-ID: <20090109111936.GB17948@linux-mips.org>
References: <20081227111037.3bd13adc@hskinnemoen-d830> <20081229.025352.01917409.anemo@mba.ocn.ne.jp> <e9c3a7c20901051031y528d0d31r18d44c5096c59e0@mail.gmail.com> <20090108.134336.127659765.nemoto@toshiba-tops.co.jp> <20090108093603.691c1200@hskinnemoen-d830>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090108093603.691c1200@hskinnemoen-d830>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 09:36:03AM +0100, Haavard Skinnemoen wrote:

> In the general case, however, I think MIPS has a bug: I've seen drivers
> DMA to/from tiny buffers stored inside another struct. This is legal
> because the driver can guarantee that the other fields in the struct
> aren't accessed in the mean time, but any fields sharing a cacheline
> with the buffer must be written back before the lines are invalidated.

Depending on the implementation details, the use of such a struct might be
relying on implementation-specific behaviour.  This is what
Documentation/DMA-API.txt has to say:

[...]
int
dma_get_cache_alignment(void)

Returns the processor cache alignment.  This is the absolute minimum
alignment *and* width that you must observe when either mapping
memory or doing partial flushes.

Notes: This API may return a number *larger* than the actual cache
line, but it will guarantee that one or more cache lines fit exactly
into the width returned by this call.  It will also always be a power
of two for easy alignment.
[...]

Since dma_get_cache_alignment() is a function not a constant its result
can't be used in the definition of a struct unless possibly excessive
padding is used.

The debate has shown that we problably need BUG_ON() assertions in the
DMA API implementations to catch this sort of dangerous use.

  Ralf
