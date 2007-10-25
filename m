Return-Path: <linux-kernel-owner+w=401wt.eu-S1759013AbXJYCja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759013AbXJYCja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 22:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754734AbXJYCjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 22:39:21 -0400
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:45440 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753954AbXJYCjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 22:39:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jMoOw5Lnjesr8vk/OZzqnZegQgcFrRhnIJKZvsVlFp8NW5EvWWHRcQ39YMCs3PWL443gxMBOLQttVqJmO0ellUZDZ4z1T9UsRjw4kL8+MLSQ0puVNaJ78Kf7mdway44CU73S6nL+IrRTd5jFjwyYU4Vm+k9zD7cAmWK9CEndncE=  ;
X-YMail-OSG: AwqenGEVM1ljFR3wXIqEY3Zvogu_yj6QRAqWz57LHw2F8TNm
From: David Brownell <david-b@pacbell.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 2.6.24-rc1] resource_len() utility function
Date: Wed, 24 Oct 2007 19:39:17 -0700
User-Agent: KMail/1.9.6
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200710241820.52376.david-b@pacbell.net> <20071025024405.3e960e9c@the-village.bc.nu>
In-Reply-To: <20071025024405.3e960e9c@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710241939.17576.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 October 2007, Alan Cox wrote:
> On Wed, 24 Oct 2007 18:20:52 -0700
> David Brownell <david-b@pacbell.net> wrote:
> 
> > Add a new resource_len() function, so drivers can start using this
> > instead of driver-private code for a common idiom.  The call can be
> > useful with at least:
> > 
> >  - request_region(), release_region()
> >  - request_mem_region(), release_mem_region()
> >  - ioremap()
> > 
> > Candidate drivers include those using platform or PNP busses, and
> > maybe some others.  PCI already has a similar function.
> > 
> > This patch also updates a representative set of drivers in two
> > subsystems to use this call (SPI, and USB peripheral/gadget).
> 
> PCI also increasingly is using functions that allow the user to choose to
> map a resource as a resource (eg pci_iomap). So is it better to have
> functions request_mem_resource(res)  free_mem_resource(res) and similar
> instead or as well ?

This was intended to be a minor band-aid.  ;)

We already have request_resource(), which does something
different than the request_*region() calls.  I think calls
with those names would complicate an already-too-strange
interface, adding oddball siblings to request_resource().

I'd hope that when those resource calls were defined they
made sense ... but to me, they don't do so today.  Consider
that the *typical* caller is given a "struct resource", and
then to claim the specified address space it must convert
it into a "start + length" representation before getting
back a *NEW* "struct resource" ... with identical contents,
other than the value of one all-but-undocumented flag bit.
Then, if it's I/O space the address is usable already; but
for memory space, it still needs an ioremap()...

Oh, and PCI has its own resource structs ("BAR") that don't
look or act the same as other resources.


So while I like the notion of starting to abolish that
conversion step, this wasn't an attempt to fix all the
bizarre behaviors of the resource API.

I could imagine a call taking a resource and returning
a "void __iomem *" to use for IO, which implicitly claims
the region (in either memory or i/o space) and does any
ioremap needed for memory space.  With a sibling call to
undo all that.  If that's the answer, someone else should
develop the patch and update drivers...

- Dave
