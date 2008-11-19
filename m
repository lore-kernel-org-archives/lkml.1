Return-Path: <linux-kernel-owner+w=401wt.eu-S1752596AbYKSGWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbYKSGWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 01:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbYKSGWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 01:22:34 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:35008 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbYKSGWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 01:22:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=btc+HQ2Hfh0rHAK2aZQmJHIHP1kWvekxQqsY0yj65gMjnxdxD2l/Lcmw+q9G+fRn1P
         j/w4V9OMxmH3GJxrvU4IMQwojl5VK/tOxwja1LOqsw5aeJBUwnJ8M+qUXuFUK8wdNjQZ
         0AeBIhHorPn2NAluxf3VEU6KMgXM6vZXdTxfg=
Message-ID: <c384c5ea0811182222l7f0e3131tc1cc20ffba5175c@mail.gmail.com>
Date: Wed, 19 Nov 2008 07:22:31 +0100
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: pci_map_sg() does not coalesce adjacent physical memory? x86
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       James.Bottomley@hansenpartnership.com, tj@kernel.org
In-Reply-To: <20081119142016E.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c384c5ea0811171354u5d6f5be6v857f92b1e75769c7@mail.gmail.com>
	 <20081117191532.c1c849f5.akpm@linux-foundation.org>
	 <20081119142016E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Nov 19, 2008 at 6:19 AM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Mon, 17 Nov 2008 19:15:32 -0800
>> > pci_map_sg() does not coalesce the scattergather list for me on x86.
>> [ Marked as Bogus Report ]
>>
>> > Is this expected? Documentation mentions that coalescing is typically
>> > done by pci_map_sg().
>
> Hm, what document did you read? We might need to fix it.
>
http://lxr.linux.no/linux+v2.6.27.6/Documentation/DMA-API.txt

 316        pci_map_sg(struct pci_dev *hwdev, struct scatterlist *sg,
 317                int nents, int direction)
 318
 319Maps a scatter gather list from the block layer.
 320
 321Returns: the number of physical segments mapped (this may be shorter
 322than <nents> passed in if the block layer determines that some
 323elements of the scatter/gather list are physically adjacent and thus
 324may be mapped with a single entry).

Also it is mentioned elsewhere, such a Linux Device Driver 3rd
Edition, page 451.

> pci_map_sg() is not a typical place to coalesce the entries of the sg
> list are physically adjacent. The block layer is the typical place.
>
Hmmm, why not?

In my case I am using the following flow:

virtual user buffer -> scatterlist -> pci_map_sg -> device specific
scatterlist table

Of course, I could write my own (tm) and map my pages into PCI using
pci_map_single, but I thought I was being the good kid by using what
was there.

> The dma operations are free to coalesce the entries that physically
> and virtually adjacent but there are not many that does.
>
> For example, by default, on x86, only AMD GART (x86_64) dma operation
> coalesces such entries.
>

> What's kinda of your driver? If it's a SCSI (or block) driver, you
> don't need this trick.
>
Not a block driver.

A data acquisition driver through PCI Express.

> I don't think that inventing a homegrown function to coalesce sg
> entries in a driver is a good idea. If you really need this, it's
> would be better to have a generic function to coalesce sg entries and
> modify the block layer to use it (and your driver can use it too).
>
+1 for this idea, *iff* it does not belong in pci_map_sg.

However, I think it *does* belong in pci_map_sg, because pci_map_sg
can perform virtual coalescing exploiting IOMMU's if I am not
mistaken.

Regards,
-- 
Leon
