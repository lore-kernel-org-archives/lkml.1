Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbXFKTL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbXFKTL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 15:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbXFKTLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 15:11:21 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40841 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752705AbXFKTLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 15:11:20 -0400
Date: Mon, 11 Jun 2007 12:11:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: kernel BUG at mm/slub.c:3689!
In-Reply-To: <1defaf580706111204v35b4dcc9j5dc68e722bd384b1@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706111208580.19316@schroedinger.engr.sgi.com>
References: <20070611161926.2a9f8efd@dhcp-255-175.norway.atmel.com> 
 <Pine.LNX.4.64.0706110918340.15466@schroedinger.engr.sgi.com> 
 <1defaf580706110943q56d83939t9ab6331cc45b4810@mail.gmail.com> 
 <Pine.LNX.4.64.0706110946430.15910@schroedinger.engr.sgi.com> 
 <1defaf580706111011w641b26fbu68d6d34028f6e953@mail.gmail.com> 
 <Pine.LNX.4.64.0706111041160.17264@schroedinger.engr.sgi.com> 
 <1defaf580706111122n78ab46c3sda05cbd4ace97319@mail.gmail.com> 
 <Pine.LNX.4.64.0706111129270.18327@schroedinger.engr.sgi.com>
 <1defaf580706111204v35b4dcc9j5dc68e722bd384b1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1700579579-915512771-1181589079=:19316"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1700579579-915512771-1181589079=:19316
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 11 Jun 2007, H=E5vard Skinnemoen wrote:

> > >
> > > It's not about performance at all, it's about DMA buffers allocated
> > > using kmalloc() getting corrupted. Imagine this:
> >=20
> > Uhhh... How about using a separate slab for the DMA buffers?
>=20
> If there were just a few, known drivers that did this, sure. But as
> long as Documentation/DMA-mapping.txt includes this paragraph:
>=20
>    If you acquired your memory via the page allocator
>    (i.e. __get_free_page*()) or the generic memory allocators
>    (i.e. kmalloc() or kmem_cache_alloc()) then you may DMA to/from
>    that memory using the addresses returned from those routines.
>=20
> I think it's best to ensure that memory returned by kmalloc() actually
> can be used for DMA. I used to work around this problem in the SPI
> controller driver by using a temporary DMA buffer when possible
> misalignment was detected, but David Brownell said it was the wrong
> way to do it and pointed at the above paragraph.

Well there are various ways of doing DMA. Memory returned can be used for=
=20
DMA but it may not be suitable for your DMA device if that device has=20
issues like alignment or physical address size restrictions.

> But, as I mentioned, perhaps ARCH_KMALLOC_MINALIGN isn't the best way
> to solve the problem. I'll look into the flush-caches-from-dma_unmap
> approach. However, it looks like other arches set
> ARCH_KMALLOC_MINALIGN to various values -- I suspect some of them
> might run into the same problem as well?

Could be. That is why I am looking for a general solution.

> > SLABs mininum object size is 32 thus you had no problems. I see. SLAB
> > does not guarantee 32 byte alignment. It just happened to work. If you
> > switch on CONFIG_SLAB_DEBUG you will likely get into trouble.
>=20
> Yeah, that's true. CONFIG_SLAB_DEBUG does indeed cause DMA buffer
> corruption on avr32, and so does CONFIG_SLOB. I've been wanting to fix
> it, but I never understood how. Now that SLUB seems to offer a
> solution that doesn't effectively turn off debugging, I thought I'd
> finally found it...

We should probably make the minimum slab size dependent on=20
ARCH_KMALLOC_MINALIGN. There is no point in having smaller slabs anyways.=
=20
They will all have the same size.

---1700579579-915512771-1181589079=:19316--
