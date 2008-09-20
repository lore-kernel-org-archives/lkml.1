Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbYITXAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbYITXAv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 19:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYITXAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 19:00:43 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:23711 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbYITXAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 19:00:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Ew7mSAw+X+e0cCsHDR20tQXwprNF6kdbqMquA9/t6TbZOGiGXbtuiWoiuQz9dRuKrt
         sjvhatAe/u941c9MmPskfXpal5tgL/RMcqEleXWkf40Pwr6RUdNzDGowjFsWscUqglEt
         Js0AomK+Ea3YgFWmGd8hGNNuXaXm/rZodJRBg=
Message-ID: <e9c3a7c20809201600s3862da7qaab4a917220778e9@mail.gmail.com>
Date: Sat, 20 Sep 2008 16:00:40 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Timur Tabi" <timur@freescale.com>
Subject: Re: dmaengine.c: question about device_alloc_chan_resources
Cc: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <48D3B880.3070607@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48D02589.8070601@freescale.com>
	 <e9c3a7c20809171536i189e3816x8572055d932c3c4c@mail.gmail.com>
	 <ed82fe3e0809180713v7e7a6115ya4612aa68879e39d@mail.gmail.com>
	 <20080918162826.3a9d9429@hskinnemo-gx745.norway.atmel.com>
	 <48D2664D.7040204@freescale.com>
	 <20080918164535.5e9f77a8@hskinnemo-gx745.norway.atmel.com>
	 <e9c3a7c20809182120r5e056dd7h170959dc1171af84@mail.gmail.com>
	 <20080919132544.533ab7d0@hskinnemo-gx745.norway.atmel.com>
	 <48D3B880.3070607@freescale.com>
X-Google-Sender-Auth: e05af9ea41b9b75d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 7:34 AM, Timur Tabi <timur@freescale.com> wrote:
> Haavard Skinnemoen wrote:
>
>> Yes, or maybe provide an interface for simply requesting a channel
>> without having to register any callbacks.
>
> I could use this feature.  The sound drivers for our MPC8610 processor use DMA,
> but the drivers need to control the DMA hardware directly, so I can't use
> dmaengine.  I would like to be able to just reserve the channels and program
> them as I see fit.
>

I think its a good idea especially since it would be best not to
needlessly proliferate client implementations with competing channel
allocation schemes.  However it would need to be more descriptive
than:

struct dma_chan *dma_request_channel(dma_cap_mask_t request_mask);

Why:
1/  What if the requester initializes before a dmaengine device has
been registered?  What if a device is never registered?
2/ What about platform specific concerns where dma_cap_mask_t is not
descriptive enough e.g. only one memcpy channel can address a certain
bus?  Currently a client implementation can have some intelligence to
return DMA_DUP for channels that do not have the platform capability.


At the very least clients should be allowed to set an 'exclusive' bit
to prevent the channel from leaking elsewhere.

--
Dan
