Return-Path: <linux-kernel-owner+w=401wt.eu-S1763402AbXGXRrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763402AbXGXRrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 13:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754999AbXGXRrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 13:47:13 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:25890 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbXGXRrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 13:47:12 -0400
X-IronPort-AV: i="4.16,575,1175486400"; 
   d="scan'208"; a="35581545:sNHT28211183"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: early_printk accessing __log_buf
Date: Tue, 24 Jul 2007 13:50:44 -0400
User-Agent: KMail/1.9.5
Cc: "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
       "Greg Ungerer" <gerg@snapgear.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Paul Mundt" <lethal@linux-sh.org>, "Tim Bird" <tim.bird@am.sony.com>,
       bryan.wu@analog.com
References: <200707181756.44074.rgetz@blackfin.uclinux.org> <200707231815.38124.rgetz@blackfin.uclinux.org> <20070723153437.4fc62253.akpm@linux-foundation.org>
In-Reply-To: <20070723153437.4fc62253.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707241350.45086.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 24 Jul 2007 17:47:04.0404 (UTC) FILETIME=[A579C140:01C7CE1A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 23 Jul 2007 18:34, Andrew Morton pondered:
> On Mon, 23 Jul 2007 18:15:37 -0400
> Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> > 
> > A single function which does the copy as a loop (existing) is going to
> > be much faster than the overhead of 1024 function calls to copy the 
> > last k. 
> 
> I'd expect the overhead of the (fully-cached) instructions to be
> insignificant compared to the time to write to flash?

Maybe - the time to write a single page on NAND is pretty cheap.

SLC is 200us to program a page.
http://www.st.com/stonline/products/families/memories/fl_nand/nand_large.htm
http://www.st.com/stonline/products/families/memories/fl_nand/nand_small.htm

While you are correct - the majority of the time will be spent in the write to 
flash - the overhead of the loop 
 - call (3 cycles)
 - push a few registers on the stack (a cycle for each push),
 - pop same registers off the stack (a cycle for each pop).
 - return (5 cycles)

(Numbers go up and down depending on your arch - this was for 486)

If you assume three registers need to be pushed/popped - for a 1k buffer that 
is 14336 cycles of pure overhead - assuming 500MHz processor (and a perfect 
cache), that is 28us - about 14% of the time in overhead that doesn't need to 
be there.

Can someone increase the size of the capacitors in their power supply to make 
up for this - yes. But larger caps are more money.

> Lots of the kernel is pretty crappy.  One of our main tools for fixing
> that is to ensure that new stuff is non-crappy.

No problem - I wasn't advocating putting something that you thought was crappy 
into your tree (afterall that would be futile). Other than making the 
overhead high - is there a way to make it less crappy?

If the answer is no, and Mike's latest suggestion/patch is OK - that is what I 
will live with - and tell people to spend more on their power supply.

-robin
