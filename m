Return-Path: <linux-kernel-owner+w=401wt.eu-S1755825AbYFJOnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbYFJOnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 10:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755709AbYFJOmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 10:42:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:12230 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766AbYFJOmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 10:42:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UXA6vMHnwaDgPJeepyqB3KqO/wu/RbvWlV/TzzYpnfg0+2LffSEBgPIlx55obmDlA+
         K4rp7j3jiP5sctL2O8pEPWUSZMM4RuU/TTqHe73+q01cO/g0j4j869xxoIrCRE4z9t6g
         oLZ6gXe2JsNRoX5MbH3w0I+TxCh/acPNtgm/w=
Message-ID: <19f34abd0806100742v176f50e8se463d2e70df44332@mail.gmail.com>
Date: Tue, 10 Jun 2008 16:42:41 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: BUG: NULL pointer dereference at 00000000 -- IP: [<f8e783d5>] :b43:b43_dma_mapping_error+0x16/0x155
Cc: "Miles Lane" <miles.lane@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200806101637.11473.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0806100709rf4602f2x587631852502c0b5@mail.gmail.com>
	 <19f34abd0806100729h7a060012h91e81248c9c7cdca@mail.gmail.com>
	 <200806101634.21576.mb@bu3sch.de> <200806101637.11473.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 4:37 PM, Michael Buesch <mb@bu3sch.de> wrote:
> On Tuesday 10 June 2008 16:34:21 Michael Buesch wrote:
>> On Tuesday 10 June 2008 16:29:17 Vegard Nossum wrote:
>> > On Tue, Jun 10, 2008 at 4:23 PM, Michael Buesch <mb@bu3sch.de> wrote:
>> > > On Tuesday 10 June 2008 16:09:37 Miles Lane wrote:
>> > >> BUG: unable to handle kernel NULL pointer dereference at 00000000
>> > >> IP: [<f8e783d5>] :b43:b43_dma_mapping_error+0x16/0x155
>> > >
>> > >
>> > > It seems to crash at
>> > >  60 extern const struct dma_mapping_ops *dma_ops;
>> > >  61
>> > >  62 static inline int dma_mapping_error(dma_addr_t dma_addr)
>> > >  63 {
>> > >  64         if (dma_ops->mapping_error)
>> > >  65                 return dma_ops->mapping_error(dma_addr);
>> > >  66
>> > >  67         return (dma_addr == bad_dma_address);
>> > >  68 }
>> >
>> > No, this is wrong.
>> >
>> > /* Check if a DMA mapping address is invalid. */
>> > static bool b43_dma_mapping_error(struct b43_dmaring *ring,
>> >                                   dma_addr_t addr,
>> >                                   size_t buffersize, bool dma_to_device)
>> > {
>> >         if (unlikely(dma_mapping_error(ring->dev->dev->dma_dev, addr)))
>> >
>> > It crashes on this line ---^
>>
>> Which calls dma_mapping_error(), correct?
>>

Yes. Sorry, I should have explained. It happened before the call to
dma_mapping_error(), so it has to be during the argument processing.
addr2line -i ftw ;-) (shows inlines)

$ addr2line -e drivers/net/wireless/b43/b43.o -i 24cf9
drivers/net/wireless/b43/dma.c:521

>> But you are right. I see the bug now.
>> ring->dev is assigned after the call.
>> I wonder why it works reliably on all of my machines.
>>
>
> Ehm no wait a second...
> What strange tree are you looking at?
> This is a copy of the code from my local tree.
>
>  516 /* Check if a DMA mapping address is invalid. */
>  517 static bool b43_dma_mapping_error(struct b43_dmaring *ring,
>  518                                   dma_addr_t addr,
>  519                                   size_t buffersize, bool dma_to_device)
>  520 {
>  521         if (unlikely(dma_mapping_error(addr)))
>  522                 return 1;
>
> This code is perfectly fine.
> This must be some merge error in some upstream tree.

I am looking at v2.6.26-rc5-mm2.

This change comes from

commit 353c409463ecba63c3a41a992d3f5fba935eada9
Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date:   Fri May 23 19:02:30 2008 +0000

    dma-mapping-add-the-device-argument-to-dma_mapping_error

    Add per-device dma_mapping_ops support for CONFIG_X86_64 as POWER
    architecture does:

    This enables us to cleanly fix the Calgary IOMMU issue that some devices
    are not behind the IOMMU (http://lkml.org/lkml/2008/5/8/423).

    I think that per-device dma_mapping_ops support would be also helpful for
    KVM people to support PCI passthrough but Andi thinks that this makes it
    difficult to support the PCI passthrough (see the above thread).  So I
    CC'ed this to KVM camp.  Comments are appreciated.

    A pointer to dma_mapping_ops to struct dev_archdata is added.  If the
    pointer is non NULL, DMA operations in asm/dma-mapping.h use it.  If it's
    NULL, the system-wide dma_ops pointer is used as before.

    If it's useful for KVM people, I plan to implement a mechanism to register
    a hook called when a new pci (or dma capable) device is created (it works
    with hot plugging).  It enables IOMMUs to set up an appropriate
    dma_mapping_ops per device.

    The major obstacle is that dma_mapping_error doesn't take a pointer to the
    device unlike other DMA operations.  So x86 can't have dma_mapping_ops per
    device.  Note all the POWER IOMMUs use the same dma_mapping_error function
    so this is not a problem for POWER but x86 IOMMUs use different
    dma_mapping_error functions.

    The first patch adds the device argument to dma_mapping_error.  The patch
    is trivial but large since it touches lots of drivers and dma-mapping.h in
    all the architecture.

(Added to Cc.)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
