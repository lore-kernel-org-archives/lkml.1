Return-Path: <linux-kernel-owner+w=401wt.eu-S1751839AbXEXRnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbXEXRnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbXEXRnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:43:08 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:34773
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbXEXRnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:43:07 -0400
From: Rob Landley <rob@landley.net>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Status of CONFIG_FORCED_INLINING?
Date: Thu, 24 May 2007 13:40:54 -0400
User-Agent: KMail/1.9.1
Cc: Adrian Bunk <bunk@stusta.de>, Arjan van de Ven <arjan@linux.intel.com>,
       linux-kernel@vger.kernel.org
References: <200705231510.52932.rob@landley.net> <20070523212237.GH2098@stusta.de> <Pine.LNX.4.61.0705241829000.31549@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705241829000.31549@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705241340.54796.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 May 2007 12:29 pm, Jan Engelhardt wrote:
> 
> On May 23 2007 23:22, Adrian Bunk wrote:
> >
> >And we need only two different inline levels (__always_inline and
> >"let the compiler decide"), not three (__always_inline, inline and
> >"let the compiler decide").
> 
> "inline" is "let the compiler decide".

The compiler decides anyway.  That's why we need a noinline to tell it _not_ 
to spontaneously inline things it shouldn't.

> If it is not, then it is "let the 
> compiler decide, based on my bias that I think it should be inlined".

Things like unlikely() actually produce different code (and are, technically 
speaking, workarounds for the high branch misprediction penalty in modern 
processor designs).

Things like "register" are a hint to the compiler that it's free to ignore.  
How often do we use the "register" keyword in Linux?  Register allocation is 
totally different on different processors, and deprived of context the hint 
is almomst meaningless.  If it doesn't guarantee anything and has far less of 
a performance impact than the difference between -O2 and -Os (or between gcc 
3.4 and 4.1), then it's probably an unnecessary complication.

Inlining is even worse because whether or not it's a performance win depends 
on the L1 cache size, cache line size and alignment, L2 cache, DRAM fetch 
latency, and so on.  This varies all over the map within a given processor 
line, let alone between processors.

If we actually need something inlined, we can tell it to do so reliably with 
__always_inline (and change __always_inline to be MORE explicit each time gcc 
breaks the previous way of saying "yes really inline it dammit").  If we can 
live with it not being inlined, why not leave it to the compiler whether or 
not to inline it?

Rob
