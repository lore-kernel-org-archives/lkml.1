Return-Path: <linux-kernel-owner+w=401wt.eu-S1758937AbXJaKYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937AbXJaKYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 06:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756632AbXJaKYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 06:24:47 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:35882 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755680AbXJaKYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 06:24:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=wWQAuwwFU3+ChMX0QtixUsgt/y6z6clxHNO9hMbjMzQ+VWRNfI6rENgkVVNNV/FcaGHMprCaYBfgXvlpuYXpKoE4i/DxKShQ+hNqdVFYLoSoS1L/FfLt+FfCK+0TprOokAtP/0woJrBY0oZvXyNODiBWUN7NcOEmnN1OxumKHxE=  ;
X-YMail-OSG: OWyHNnUVM1kvBMmPpf0mZVj5chDclHow4idmVsSLBxrw75VHjxrRNDxOcpw_RQCzkzP8w2ejrw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] Swap delay accounting, include lock_page() delays
Date: Wed, 31 Oct 2007 20:10:33 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20071031075243.22225.53636.sendpatchset@balbir-laptop> <200710311841.53671.nickpiggin@yahoo.com.au>
In-Reply-To: <200710311841.53671.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710312010.33833.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 October 2007 18:41, Nick Piggin wrote:
> On Wednesday 31 October 2007 18:52, Balbir Singh wrote:
> > Reported-by: Nick Piggin <nickpiggin@yahoo.com.au>
> >
> > The delay incurred in lock_page() should also be accounted in swap delay
> > accounting
> >
> > Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
>
> Ah right, I forgot to resend this one, sorry. Thanks for remembering.

Although, I think I had a bit more detail in the changelog which
I think should be kept.

Basically, swap delay accounting seems quite broken as of now,
because what it is counting is the time required to allocate a new
page and submit the IO, but not actually the time to perform the IO
at all (which I'd expect will be significant, although possibly in
some workloads the actual page allocation will dominate).

>
> > ---
> >
> >  mm/memory.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff -puN mm/swapfile.c~fix-delay-accounting-swap-accounting
> > mm/swapfile.c diff -puN mm/memory.c~fix-delay-accounting-swap-accounting
> > mm/memory.c ---
> > linux-2.6-latest/mm/memory.c~fix-delay-accounting-swap-accounting	2007-10
> >-3 1 12:58:05.000000000 +0530 +++
> > linux-2.6-latest-balbir/mm/memory.c	2007-10-31 13:02:50.000000000 +0530
> > @@ -2084,9 +2084,9 @@ static int do_swap_page(struct mm_struct
> >  		count_vm_event(PGMAJFAULT);
> >  	}
> >
> > -	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
> >  	mark_page_accessed(page);
> >  	lock_page(page);
> > +	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
> >
> >  	/*
> >  	 * Back out if somebody else already faulted in this pte.
> > _

