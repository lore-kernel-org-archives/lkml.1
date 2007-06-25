Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbXFYM6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbXFYM6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 08:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755398AbXFYM6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 08:58:17 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:39358 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123AbXFYM6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 08:58:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=csqYGG5lrbZXlFxOKmT1OY/lZKRd1RSyrwj4feV3S/sKDrWK83YGx6+iyQ2omxrVHontPo8su4Ma8PUNp2hyFgXbV8uNE8DsQpIz+c9mkdS76bD0+Q5cwE3Sl7EQmYPeEpOvxbSkfbwL09fh3V0TQ825t5jIYB8ApuqRUMeDs+0=
Message-ID: <68676e00706250558o36ee5a63je3aa0ba36e8a162@mail.gmail.com>
Date: Mon, 25 Jun 2007 14:58:14 +0200
From: Luca <kronos.it@gmail.com>
To: "Jay L. T. Cornwall" <jay@esuna.co.uk>
Subject: Re: Attansic L1 page corruption (was: 2.6.22-rc5: pdflush oops under heavy disk load)
Cc: "Jay Cliburn" <jacliburn@bellsouth.net>, linux-kernel@vger.kernel.org,
       "Chris Snook" <csnook@redhat.com>,
       "huang xiong" <xiong.huang@atheros.com>
In-Reply-To: <467FB237.2030703@esuna.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <467B12CA.5060405@esuna.co.uk> <467BE118.4090308@redhat.com>
	 <467BE4F1.7040308@esuna.co.uk> <467D0EB0.9030100@esuna.co.uk>
	 <20070624125957.2e27820c@osprey.hogchain.net>
	 <467ED4A8.4080500@esuna.co.uk>
	 <20070624164519.04f215b8@osprey.hogchain.net>
	 <467FB237.2030703@esuna.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/25/07, Jay L. T. Cornwall <jay@esuna.co.uk> wrote:
> Jay Cliburn wrote:
>
> > For reasons not yet clear to me, it appears the L1 driver has a bug or
> > the device itself has trouble with DMA in high memory.  This patch,
> > drafted by Luca Tettamanti, is being explored as a workaround.  I'd be
> > interested to know if it fixes your problem.
>
> Yes, it certainly seems to. Now running with this patch and 4GB active,
> I've transferred about 15GB with no problem so far. It usually oopses
> after a GB or two.
>
> I guess it's not an ideal solution, architecturally speaking, but it's a
> good deal better than an unstable driver.

It may cause a "bounce" (i.e. data is copied to another buffer in
lower memory) when a skb is allocated in high memory. Furthermore - at
least on AMD systems - it should be possible to use the IOMMU to remap
the memory to a bus address < 4GB.

Xiong can you comment on this issue? To recap: users are seeing hard
locks when L1 driver does a DMA to/from a high memory area (physical
address > 4GB). Limiting DMA to the lower 4GB with:

pci_set_dma_mask(pdev, DMA_32BIT_MASK);

cures the issue. Does L1 have any know problem decoding 64 addresses?

Luca
