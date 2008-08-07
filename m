Return-Path: <linux-kernel-owner+w=401wt.eu-S1754951AbYHGREZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbYHGREZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 13:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbYHGRER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 13:04:17 -0400
Received: from outbound-mail-35.bluehost.com ([69.89.18.155]:41892 "HELO
	outbound-mail-35.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752682AbYHGREQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 13:04:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=E/Yzgd1DsEUCZr/iCFd/iYGYVNkWQV9iOtsUK5Xz9XuOap0pQo9nyiVxSuyX1gKu0sl2U8nGrarqBh0ETrY/mCzfS3oqKKOCzzF+fTZV2hGxu5mcYKy0LBODuTEbOVSe;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
Date: Thu, 7 Aug 2008 10:03:43 -0700
User-Agent: KMail/1.9.9
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, joro@8bytes.org,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
References: <200807281523.35469.jbarnes@virtuousgeek.org> <20080806223550K.tomof@acm.org> <4899B611.4070408@redhat.com>
In-Reply-To: <4899B611.4070408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808071003.47326.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 6, 2008 7:32 am Prarit Bhargava wrote:
> > You can't kmalloc pci_dev or setup some trivial values. You need to
> > use a proper value. The pci code does for us.
>
> Oops -- I meant struct device, not struct pci_dev.
>
> Anwyay, Jesse -- is this true?  I can no longer do something like:
>
>
> static struct device junk_dev = {
>         .bus_id = "junk device",
>         .coherent_dma_mask = 0xffffffff,
>         .dma_mask = &junk_dev.coherent_dma_mask,
> };
>
> And then use that as the device target for dma_alloc_coherent?  AFAIK,
> that has always worked for me.

It gets dangerous since platforms are in control of some pci_dev and dev 
fields, and if they don't get initialized you can get into trouble.

> > Calgary IOMMU has the same code. New AMD IOMMU has the same code too.
>
> Then they don't handle the above problem and are broken when
> dma_get_seg_boundary() returns 0xffffffff and will require patches.
>
> /me hasn't tried out Calgary of AMD IOMMU.

Would be good to find someone to do some testing on one of those platforms...

> >> Maybe I'm missing something -- what implies  size has to be a power of
> >> two?
> >
> > Yes, see iommu_area_alloc().
>
> /me looks and still doesn't see where the size passed into
> gart_map_simple() must be a power of two.  ... and if that was the case,
> shouldn't we be failing all the time?  I mean, I've seen values passed
> into pci_alloc_consistent like 0x3820 -- clearly not a multiple of 2.
>
> iommu_area_alloc() deals with pages, not actual sizes as
> gart_map_simple() does.
>
> If anything, I would make this simple fix:
>
> dma_addr_t map = dma_map_area(dev, paddr, size, dir, size - 1);
>
> should be
>
> dma_addr_t map = dma_map_area(dev, paddr, size, dir, size);
>
> because after my patch we round up the mask argument to get the correct
> alignment to # of pages anyway.

Feel like respinning with a full changelog against my for-linus branch?  Maybe 
you can convince Tomonori-san this time. :)

Jesse
