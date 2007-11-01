Return-Path: <linux-kernel-owner+w=401wt.eu-S1757192AbXKAHZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbXKAHZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 03:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbXKAHZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 03:25:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:15076 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbXKAHZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 03:25:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=bW6mrq0nWo9yD5wLrgBhvFPqP0kmZnTybGVTNG7E65P+mb8mv9cZhQCJlzyol4/jXjIQK19YyHecxYeRDhwTI83Dlte57R1PkuozpO+RZuY9BMWdHfby6znOeZ9VG1heXpHduujLlLOEoLYNj6GM1KcoBX0CRaTisvSNvNFn7bQ=
Message-ID: <47297F43.8050201@gmail.com>
Date: Thu, 01 Nov 2007 16:24:51 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Jens Axboe <jens.axboe@oracle.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Drake <dsd@gentoo.org>,
       linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
References: <47274A5F.6070409@gentoo.org> <20071030153417.59b9182c@the-village.bc.nu> <47276DCA.1000808@gentoo.org> <20071030190153.373c9347@the-village.bc.nu> <47278439.4030801@gentoo.org> <20071031114958.210bd7cc@the-village.bc.nu> <20071031115754.GK5059@kernel.dk> <472872F6.70802@garzik.org> <4729209A.50809@gmail.com>
In-Reply-To: <4729209A.50809@gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello, Jeff.
> 
> Jeff Garzik wrote:
>> That's easy for the PIO case.  But CD writing is normally DMA, which
>> means you will get a DMA engine exception if the device wants to give
>> you more data than the scatter/gather entries permit.
> 
> For sense data and mode pages, the standard-sanctioned way to know the
> transfer size is to issue command with short buffer size just enough to
> contain the fixed size header part, determine actual transfer size from
> it and issue the command again with the correct buffer size.  This
> doesn't happen for READ/WRITE commands.  Transfer sizes are
> pre-determined for those commands and WRITE's to optical devices often
> can't be retried w/o side effect.
> 
> I've just went through the ATA spec and this basically means we can't
> use DMA for these variable-transfer-length commands.  Some DMA engines
> have "throw away what's left over bit" in its command structure or SG
> entry but not all do and none of drivers we currently has such feature
> enabled.
> 
> Hmmm.... reading ide-cd.c::cdrom_pc_intr().  OIC, ide-cd is dealing with
> this problem by draining PIO after BMDMA engine is done.  This is
> possible for BMDMA engines as they simply step out when the SG entries
> are exhausted; then, the interrupt handler kicks in and drains the
> left-over using PIO.  This just isn't possible with more modern DMA engines.
> 
> This really makes me think libata should do these commands via PIO
> unless we're gonna enable leftover draining for each DMA engine
> implementation or blacklist the ones which can't drain individually.
> Then again, nobody really knows how well those features would work as
> probably none has actually used them.

Eeek, please ignore this.  I somehow completely forgot about Allocation
Length fields in CDBs.

Thanks.

-- 
tejun
