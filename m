Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbXIDMsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbXIDMsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 08:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbXIDMsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 08:48:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310AbXIDMsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 08:48:38 -0400
Message-ID: <46DD5423.2040707@redhat.com>
Date: Tue, 04 Sep 2007 08:48:35 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: James Georgas <jgeorgas@rogers.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: HIMEM calculation
References: <491631.7157.qm@web88107.mail.re2.yahoo.com>
In-Reply-To: <491631.7157.qm@web88107.mail.re2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Georgas wrote:
>  > That's the vmalloc address space.  You only get 896 MB in the NORMAL
>  > zone on i386, to leave room for vmalloc.  If you don't like it, go 
> 64-bit.
>  >
>  >       -- Chris
> 
> I like it fine. I just didn't understand it. Thanks for answering.
> 
> So, basically, the vmalloc address space is not backed by physical RAM,
> right? Rather, the virtual address space associated with vmalloc is
> mapped to physical pages by page tables?

Basically, yes, but that's an oversimplification.  We actually use page tables 
everywhere, but the conversion is simply +/- 0xC0000000 for the NORMAL zone, so 
we can skip most of the fancy VM work and just use a trivial macro.  vmalloc can 
allocate large chunks of virtually contiguous memory even when the physical 
memory is heavily fragmented, and since we've set aside address space for it, 
it's visible in all process contexts.

vmalloc is handy sometimes because it can complete even if there's no memory 
free when it's called, since the VM will swap out user pages and then return 
those remapped into the vmalloc address space.  Unfortunately, we can't use 
vmalloc anywhere we want to use DMA because it will be accessed without the MMU. 
  Worse, we also can't use it in any path that could be called while trying to 
free memory, due to recursion issues, which substantially limits its utility in 
the kernel.  Some people *cough*OpenAFS*cough* use it carelessly and get all 
kinds of exciting panics under rare and difficult-to-reproduce load conditions.

	-- Chris
