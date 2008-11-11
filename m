Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbYKKLWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbYKKLWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 06:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755403AbYKKLWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 06:22:46 -0500
Received: from sceest01.correodeempresas.telefonica.es ([212.170.236.202]:50500
	"EHLO sceest01.correodeempresas.telefonica.es" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753026AbYKKLWp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 06:22:45 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Regression: Boot hang sizing transparent PCI-to-PCI bridgesince after 2.6.25-r7.
Date: Tue, 11 Nov 2008 12:21:25 +0100
Message-ID: <D913A682D10DBA4097B5D068D281B09B0266F9B0@S1128EXE.bbva.igrupobbva>
In-Reply-To: <20081110175815.GA7650@us.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Regression: Boot hang sizing transparent PCI-to-PCI bridgesince after 2.6.25-r7.
Thread-Index: AclDXddQq0J7QOfgT+iovA/hlzJLmQAjdU6w
References: <D913A682D10DBA4097B5D068D281B09B0266F65B@S1128EXE.bbva.igrupobbva> <49180973.6080808@gmail.com> <20081110175815.GA7650@us.ibm.com>
From: "GARCIA DE SORIA LUCENA, JUAN JESUS" <juanj.g_soria@grupobbva.com>
To: "Gary Hade" <garyhade@us.ibm.com>, "Jiri Slaby" <jirislaby@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 11 Nov 2008 11:21:26.0850 (UTC) FILETIME=[A30C3220:01C943EF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again. 

> -----Original Message-----
> From: Gary Hade [mailto:garyhade@us.ibm.com] 
> 
> > Doesn't pci=norom help in your case? There was a patch 
> which tried to 
> > resolve this issue in a different manner, but it was reverted too. 
> > This boot parameter was introduced as a replacement IIRC.
> 
> As the unfortunate author of both of the reverted patches and 
> author of the pci=norom patch I can confirm that Jiri is 
> correct.  The issues that the patches addressed (with some 
> unintended side effects caused by the reverted attempts) were 
> PCI resource allocation failures observed during PCI hotplug. 
>  We were not seeing or trying to address boot-time PCI 
> resource allocation failures or hangs.
> 
> Gary

I've tested pci=norom with the Ubuntu 8.10 AMD64 kernel, with no
effects. I'll try to download and test the 32 bit version too, to check
whether it has anything to do with the size of the resource_size_t type
(defined in linux/types.h) being u64. Perhaps it's u32 in a 32 bit
architecture.

A problem with this bridge in my lspci info is that both the I/O and the
prefetchable memory ranges behind bridges have a end address BELOW the
start address.


I/O behind bridge: 0000f000-00000fff
Memory behind bridge: c3000000-c30fffff
Prefetchable memory behind bridge: fff00000-000fffff


I don't know whether these ranges are supposed to encompass the BIOS ROM
or whatever (and thus your pci=norom option). Another explanation for
the hang may lie in the definition of resource_size() (defined in
linux/ioport.h):


static inline resource_size_t resource_size(struct resource *res)
{
     	  return res->end - res->start + 1;
}


As you can see, the subtraction will overflow due to the end address
being BELOW the start address, and the resulting size will be different
when resource_size_t is u64 than it would be if it's u32.

Moreover, I suppose that the intended size-of-size for the IO range
would be u16.

I mean: see this table of calculations:

                 Size, current u64   Size, u16/u32 clamp
I/O              0xFFFFFFFFFFFF2000               0x2000
Prefetchable mem 0xFFFFFFFF00200000             0x200000


Where "clamping" means and'ing with 0xffff for u16 clamp or 0xffffffff
for u32 clamp (at least when the end address is below the start
address).


You can see that, apart from whether there's a rom in the address range
or not, the size calculation (at least by code inspection by simple
arithmetic in resource_size()) seems to be wrong. It produces gigantic
address range sizes, whereas the clamped values (8KB I/O, 2MB
prefetchable mem) seem to be far more sensible.

I tried to do some preliminary tests by putting conditions inside
resource_size() to check for "reversed ranges" and clamp the size by
anding with (res->flags & IORESOURCE_IO) ? 0xffffUL : 0xffffffffUL, but
to no avail yet. It printed the IO mapping in the kernel messages, but
it seems to have choked on the memory range??? I have to investigate
more.


I don't know if what I've written above gives you any clue about my
issue.


Regards, and thanks in advance,

   Juan Jesus.

