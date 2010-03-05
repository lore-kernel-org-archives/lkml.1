Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311Ab0CENIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 08:08:44 -0500
Received: from f0.cmpxchg.org ([85.214.51.133]:50066 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab0CENIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 08:08:43 -0500
Date: Fri, 5 Mar 2010 14:08:34 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, Greg Thelen <gthelen@google.com>,
       linux-mm@kvack.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm boot panic bootmem-avoid-dma32-zone-by-default.patch
Message-ID: <20100305130834.GB13726@cmpxchg.org>
References: <49b004811003041321g2567bac8yb73235be32a27e7c@mail.gmail.com> <20100305032106.GA12065@cmpxchg.org> <4B90C921.6060908@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B90C921.6060908@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 01:04:33AM -0800, Yinghai Lu wrote:
> On 03/04/2010 07:21 PM, Johannes Weiner wrote:
> > Hello Greg,
> > 
> > On Thu, Mar 04, 2010 at 01:21:41PM -0800, Greg Thelen wrote:
> >> On several systems I am seeing a boot panic if I use mmotm
> >> (stamp-2010-03-02-18-38).  If I remove
> >> bootmem-avoid-dma32-zone-by-default.patch then no panic is seen.  I
> >> find that:
> >> * 2.6.33 boots fine.
> >> * 2.6.33 + mmotm w/o bootmem-avoid-dma32-zone-by-default.patch: boots fine.
> >> * 2.6.33 + mmotm (including
> >> bootmem-avoid-dma32-zone-by-default.patch): panics.
> >> Note: I had to enable earlyprintk to see the panic.  Without
> >> earlyprintk no console output was seen.  The system appeared to hang
> >> after the loader.
> > 
> > where sparse_index_init(), in the SPARSEMEM_EXTREME case, will allocate
> > the mem_section descriptor with bootmem.  If this would fail, the box
> > would panic immediately earlier, but NO_BOOTMEM does not seem to get it
> > right.
> > 
> > Greg, could you retry _with_ my bootmem patch applied, but with setting
> > CONFIG_NO_BOOTMEM=n up front?
> > 
> > I think NO_BOOTMEM has several problems.  Yinghai, can you verify them?
> ...
> > 
> > 1. It does not seem to handle goal appropriately: bootmem would try
> > without the goal if it does not make sense.  And in this case, the
> > goal is 4G (above DMA32) and the amount of memory is 256M.
> > 
> > And if I did not miss something, this is the difference with my patch:
> > without it, the default goal is 16M, which is no problem as it is well
> > within your available memory.  But the change of the default goal moved
> > it outside it which the bootmem replacement can not handle.
> > 
> > 2. The early reservation stuff seems to return NULL but callsites assume
> > that the bootmem interface never does that.  Okay, the result is the same,
> > we crash.  But it still moves error reporting to a possibly much later
> > point where somebody actually dereferences the returned pointer.
> 
> under CONFIG_NO_BOOTMEM
> for alloc_bootmem_node it will honor goal, if someone input big goal it will not
> fallback to get a small one below that goal.

Yes, that's the problem.

> return NULL, could make caller have more choice and more control.

Most callers do not need it as there is no real way to handle allocation
failures at this point of time in the boot process.

For everything else, there is the _nopanic API.
