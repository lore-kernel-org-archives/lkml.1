Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbZIVATu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbZIVATu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 20:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbZIVATt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 20:19:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:45751 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668AbZIVATs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 20:19:48 -0400
Subject: Re: [LTP] mmapstress03 weirdness? (fwd)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux Test Project <Ltp-list@lists.sourceforge.net>
In-Reply-To: <alpine.LRH.2.00.0909211539520.16077@vixen.sonytel.be>
References: <alpine.LRH.2.00.0909211539520.16077@vixen.sonytel.be>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Sep 2009 10:19:41 +1000
Message-Id: <1253578781.7103.186.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-21 at 15:40 +0200, Geert Uytterhoeven wrote:

> 
> With 32-bit userland, this boils down to:
> 
> | mmap addr 0x7fff0000 size 0x7fff0000
> | mmap returned 0x7fff0000
> 
> i.e. mmap() succeeds, but (1) the test expects it to fail, so the test returns
> TFAIL, but (2) ltp-pan still reports that the tests passed?

What is the output of /proc/<pid>/maps after that mmap ?

With a 64-bit kernel, 32-bit userspace has access to the entire 4G
address space, so mapping 2G-64k at the 2G-64k point can work, provided
you aren't overlapping an existing mapping such as the stack.

> In addition, sometimes mmapstress03 fails due to SEGV. I created a small test
> program that just does the above mmap(), and depending on the distro and what
> else I print later it crashes with a SEGV, too. Probably this happens because
> the mmap() did succeed, and corrupted some existing mappings, cfr. the notes
> for MAP_FIXED:

That's possible.

>        MAP_FIXED
>               Don’t  interpret  addr  as  a hint: place the mapping at exactly
>               that address.  addr must be a multiple of the page size.  If the
>               memory  region  specified  by addr and len overlaps pages of any
>               existing mapping(s), then the overlapped part  of  the  existing
>               mapping(s)  will  be discarded.  If the specified address cannot
>               be used, mmap() will fail.  Because requiring  a  fixed  address
>               for  a  mapping is less portable, the use of this option is dis‐
>               couraged.

Yeah, I suppose the test might be wiping out its own stack for example

IE. I think that test is just bogus :-)

> JFYI, with 64-bit userland, this boils down to:
> 
> | mmap addr 0x7fffffffffff0000 size 0x7fffffffffff0000
> | mmap returned 0xffffffffffffffff
> 
> i.e. mmap() fails as expected, and the test succeeds.

Right because on 64-bit userspace, you only are allowed something like
16T of address space.

> Does all of this sound OK?
> Thanks for your comments!

Yes, I think so far, it's just bogus tests :-)

Cheers,
Ben.

> With kind regards,
> 
> Geert Uytterhoeven
> Software Architect
> Techsoft Centre
> 
> Technology and Software Centre Europe
> The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
> 
> Phone:    +32 (0)2 700 8453
> Fax:      +32 (0)2 700 8622
> E-mail:   Geert.Uytterhoeven@sonycom.com
> Internet: http://www.sony-europe.com/
> 
> A division of Sony Europe (Belgium) N.V.
> VAT BE 0413.825.160 · RPR Brussels
> Fortis · BIC GEBABEBB · IBAN BE41293037680010
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev

