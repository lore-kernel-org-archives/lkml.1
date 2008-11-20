Return-Path: <linux-kernel-owner+w=401wt.eu-S1756833AbYKTVsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbYKTVsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 16:48:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbYKTVrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 16:47:52 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:22576 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755501AbYKTVrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 16:47:52 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=c9nLIXe7Zr0AtteHhCJmDp5MfhzeHoi69rM/XuddvHIlD3Y7egXv896xry8auS9NBvCHBx/b674DzcTzhEwPH0Dl4qR4+LGkgLhJYGQUDSFQNLraYWKJdPKS7L1QJHUKW20cMpijDTOz01Yyyd9xDSVsafPcr8/xcCy5QCR1arA=  ;
X-YMail-OSG: XOsIiCcVM1lwJB5ewORP57AN6LKarZ6qGA8SpCmNDhgAMWO0UuW1xs._awW3uZKcf0y6m0XHSb1acr.H4nhBYoSi7TVT2mCuoJTEMe4dRR._a6sRVHrxn71vGParH9DYWbs-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH 01/16] Blackfin SPI Driver: ensure cache coherency before doing DMA
Date: Thu, 20 Nov 2008 13:47:45 -0800
User-Agent: KMail/1.9.10
Cc: "Bryan Wu" <cooloney@kernel.org>, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, "Vitja Makarov" <vitja.makarov@gmail.com>
References: <1226994760-4301-1-git-send-email-cooloney@kernel.org> <200811201224.15493.david-b@pacbell.net> <8bd0f97a0811201258j14dfcf46vce1655632bb12e2@mail.gmail.com>
In-Reply-To: <8bd0f97a0811201258j14dfcf46vce1655632bb12e2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811201347.46355.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 November 2008, Mike Frysinger wrote:
> On Thu, Nov 20, 2008 at 15:24, David Brownell wrote:
> > On Monday 17 November 2008, Bryan Wu wrote:
> >>                         /* set transfer mode, and enable SPI */
> >>                         dev_dbg(&drv_data->pdev->dev, "doing DMA in.\n");
> >>
> >> +                       /* invalidate caches, if needed */
> >> +                       if (bfin_addr_dcachable((unsigned long) drv_data->rx))
> >> +                               invalidate_dcache_range((unsigned long) drv_data->rx,
> >> +                                                       (unsigned long) (drv_data->rx +
> >> +                                                       drv_data->len));
> >
> > Could you explain why you're not using dma_map_*() calls
> > or the rx_dma (and tx_dma) addresses the caller may pass?
> 
> i'm not familiar with said API.  i worked with what was there already.

I see.


> > As a rule, you should use the standard kernel interfaces
> > for such stuff instead of platform-specific calls like
> > those two.  There are a LOT more developers who can find
> > and fix bugs that way.
> 
> could you elaborate on the common calls that would replace these ?

See Documentation/DMA-(mapping,API}.txt ... the "mapping"
document's section on what memory may be used for DMA is
not otherwise replicated in the description of the "generic"
versions of those API calls.

Basically, dma_map_single(), dma_unmap_single() ... and
remember that the caller may have done the mappings for
you already.


> > Also, this patch affects the "not full duplex" branch of
> > this routine.  DMA here seems unusually convoluted ... but
> > if you didn't invalidate the cache (RX path) before
> > flushing it (TX path) and instead did it the other way
> > aroound, would you actually *need* separate branches?
> 
> it's convoluted because the hardware sucks.  it cant do full duplex
> with DMA.  full duplex only works in the non-DMA case.

Ah, ok.  Sucky hardware -- been there, done that, still doing.  ;)

It'd be nice if one of patches snuck in a comment on that
point:  "Full duplex only works for non-DMA transfers."
Same rationale:  you may know this hardware inside out,
but the next person won't.

- Dave



> -mike
> 
> 


