Return-Path: <linux-kernel-owner+w=401wt.eu-S1752474AbYISEVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbYISEVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 00:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750727AbYISEU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 00:20:58 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:49121 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbYISEU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 00:20:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=X5vf6qPsA4aWuxAcX9+WcEbPG2Rr86wlW88hkqAXphIxtlo8mGhqgWaq+mH9L8+9Vv
         z4n8tIExEMhk+oIYQOqcPz9BHidi1HIvjA+D63KEUjaQsYkCIdIdw6k9g5vqjiaHHVeC
         hvodn0A6SayQ/x3c+YxNI+6V8d1lpZ9XZT1V0=
Message-ID: <e9c3a7c20809182120r5e056dd7h170959dc1171af84@mail.gmail.com>
Date: Thu, 18 Sep 2008 21:20:56 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>
Subject: Re: dmaengine.c: question about device_alloc_chan_resources
Cc: "Timur Tabi" <timur@freescale.com>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080918164535.5e9f77a8@hskinnemo-gx745.norway.atmel.com>
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
X-Google-Sender-Auth: 4bd114e1e0a88b44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 7:45 AM, Haavard Skinnemoen
<haavard.skinnemoen@atmel.com> wrote:
> Timur Tabi <timur@freescale.com> wrote:
>> Haavard Skinnemoen wrote:
>>
>> > Wouldn't it be better if the dmaengine layer made sure it didn't pass
>> > the same channel several times to a client?
>>
>> Wouldn't that require it to keep track of which clients have already seen which
>> channels?  It might make more sense, but it's probably easier the current way.
>
> I guess so. What would be even more simple is to simply prevent other
> clients from taking a channel once someone has acked it, which would be
> perfect for my purposes, but perhaps not everyone else's...

Does not seem too bad to have something like a DMA_EXCL flag in
dma_chan to tell the core not to show this channel to any other
clients.

>
> How common is for several clients to use the same channel anyway
> though? Wouldn't you risk stalling the network stack if the md subsystem
> has submitted a large xor operation on the same channel that the
> network stack was about to use?

It's analogous to running the network stack on the same cpu as md.
Yes, they effect each other but the operations are short-lived and can
interleave.  One potential problem could be bouncing the channel lock
across multiple cpu's.  This is mitigated if net_dma is changed to use
async_memcpy(), but it's not a priority.  iop_adma and mv_xor live on
single cpu platforms where net_dma is already turned off due to the
expense of get_user_pages().

--
Dan
