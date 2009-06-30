Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874AbZF3UMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbZF3UMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 16:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbZF3UMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 16:12:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754531AbZF3UMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 16:12:36 -0400
Date: Tue, 30 Jun 2009 13:10:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Mikael Pettersson <mikpe@it.uu.se>, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [BUG 2.6.31-rc1] HIGHMEM64G causes hang in PCI init on 32-bit
 x86
In-Reply-To: <4A4A25B1.5010102@zytor.com>
Message-ID: <alpine.LFD.2.01.0906301308180.3605@localhost.localdomain>
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se> <19013.29264.623540.275538@pilspetsen.it.uu.se> <4A45A5C1.5080701@zytor.com> <19013.59956.144640.331854@pilspetsen.it.uu.se> <20090629022911.GC20297@lackof.org> <4A484A8A.9020704@zytor.com>
 <19016.41349.636663.515540@pilspetsen.it.uu.se> <20090629112155.GJ5480@parisc-linux.org> <19016.44061.600652.676183@pilspetsen.it.uu.se> <4A490804.3040609@zytor.com> <4A494478.7020304@kernel.org> <4A494E3C.70304@kernel.org> <4A495C0D.2020807@zytor.com>
 <4A4966EF.6010809@kernel.org> <alpine.LFD.2.01.0906291820060.3605@localhost.localdomain> <4A496D4B.3040608@kernel.org> <19017.53428.834539.389495@pilspetsen.it.uu.se> <4A4A25B1.5010102@zytor.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Jun 2009, H. Peter Anvin wrote:
> 
> By process of elimination, the culprit must be round_up(), which reveals
> that the macro definition of round_up() has a *very* sublte behavior
> with mixed types:
> 
> #define round_up(x, y) (((x) + (y) - 1) & ~((y) - 1))
> 
> ram_alignment() returns unsigned long, which becomes (y).  This means
> that the mask word on the right hand of the & gets truncated to 32 bits
> *before* the masking happens -- since ((y) - 1) is still unsigned long,
> inverting it will not set bits [63..32] to on.

Good catch.

Also, this shows another bug in the #define: it evaluates 'y' twice, which 
is a no-no for something that _looks_ like a function.

> I think this macro is actively dangerous.  Better would be:
> 
> ({ __typeof__(x) __mask = (y)-1;  ((x)+__mask) & ~__mask; })

Yes. Please make it so.

> The deep irony in this is that in our particular case is perhaps that
> align_up(x,y)-1 is the same thing as x | (y-1) which would have avoided
> the problem...

I don't know how deep that irony is, but I do agree that maybe we should 
do that simplification too. In addition to fixing round_up() to not bite 
future generations in the ass.

		Linus
