Return-Path: <linux-kernel-owner+w=401wt.eu-S1756955AbYB2Cp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955AbYB2Cp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 21:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbYB2Cps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 21:45:48 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:18339 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbYB2Cpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 21:45:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=M0X+5C8ZW/CPw4EG2DAx8yaM8qj7xCiJVkXb0Q97xGgLpyPdgjBow/IcupGRpHmsoz8dNAVZgRfK1gImcdlsJnoYxh1KbF2Z8XOaOI0V85RpcUy8yDefgtT/SXKf/ybEGCVngTCvlN0dCS8yHHNQAmNHewCSBljiVsM/At1G6Is=
Message-ID: <dc1166600802281845t1613beedj7a285399a21cd@mail.gmail.com>
Date: Fri, 29 Feb 2008 13:45:46 +1100
From: "Michael Ellerman" <michael@ellerman.id.au>
To: akepner@sgi.com
Subject: Re: [PATCH 1/3 v3] dma: document dma_{un}map_{single|sg}_attrs() interface
Cc: "Tony Luck" <tony.luck@intel.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>, "Jes Sorensen" <jes@sgi.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Roland Dreier" <rdreier@cisco.com>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "David Miller" <davem@davemloft.net>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Grant Grundler" <grundler@parisc-linux.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080228032448.GS11012@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080228032448.GS11012@sgi.com>
X-Google-Sender-Auth: 9833b227acad9448
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 2:24 PM,  <akepner@sgi.com> wrote:
>
>  Document the new dma_{un}map_{single|sg}_attrs() functions.
>
>  diff --git a/Documentation/DMA-attributes.txt b/Documentation/DMA-attributes.txt
>  index e69de29..36baea5 100644
>  --- a/Documentation/DMA-attributes.txt
>  +++ b/Documentation/DMA-attributes.txt
>  @@ -0,0 +1,29 @@
>  +                       DMA attributes
>  +                       ==============
>  +
>  +This document describes the semantics of the DMA attributes that are
>  +defined in linux/dma-attrs.h.
>  +
>  +
>  +DMA_ATTR_SYNC_ON_WRITE
>  +----------------------
>  +
>  +DMA_ATTR_SYNC_ON_WRITE is used on the IA64_SGI_SN2 architecture.
>  +It provides a mechanism for devices to explicitly order their DMA
>  +writes.
>  +
>  +On IA64_SGI_SN2 machines, DMA may be reordered within the NUMA
>  +interconnect. Allowing reordering improves performance, but in some
>  +situations it may be necessary to ensure that one DMA write is
>  +complete before another is visible. For example, if the device does
>  +a DMA write to indicate that data is available in memory, DMA of the
>  +"completion indication" can race with DMA of data.
>  +
>  +When a memory region is mapped with the DMA_ATTR_SYNC_ON_WRITE attribute,
>  +a write to that region causes all in-flight DMA to be flushed to memory.
>  +Any pending DMA will complete and be visible in memory before the write
>  +to the region with the DMA_ATTR_SYNC_ON_WRITE attribute becomes visible.


I'm not clear how this is all meant to work. Your intial patch says
this is an interface to pass "architecture-specific
attributes" from drivers through to the DMA mapping code, which is
fair enough - we want to do something similar.

But it's not clear that DMA_ATTR_SYNC_ON_WRITE is architecture
specific. If I was a driver writer might assume it works on all
platforms. And in fact in patch 3/3 you define it in
linux/dma-attrs.h, so it's not architecture specific.

What is architecture specific is the semantic. DMA_ATTR_SYNC_ON_WRITE
is defined entirely in terms of what it does on ia64 hardware, and a
particular flavour thereof.

It just seems to me we're going to end up with a gazillion flags,
because DMA_ATTR_SYNC_ON_WRITE isn't quite the same semantic as what
Power can do. So we'll have to add
DMA_ATTR_SYNC_ON_WRITE_WRT_OTHER_SYNC_ON_WRITE_MAPPINGS_ONLY and so
on. Or, we end with subtle driver bugs because the semantics aren't
clear across platforms.

I guess I think the attributes should either be truly arch-specific,
ie. DMA_ATTR_IA64_SYNC_ON_WRITE. Or we need to come up with some well
defined, and architecture neutral semantics for what the flags mean.

cheers
