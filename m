Return-Path: <linux-kernel-owner+w=401wt.eu-S1760979AbXIRVPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760979AbXIRVPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 17:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760009AbXIRVPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 17:15:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40941 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759307AbXIRVPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 17:15:11 -0400
Date: Tue, 18 Sep 2007 14:14:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Clarify pci_iomap() usage for MMIO-only devices
In-Reply-To: <43e72e890709181402x7335d0acp306cf576fac6c070@mail.gmail.com>
Message-ID: <alpine.LFD.0.999.0709181408390.16478@woody.linux-foundation.org>
References: <43e72e890709171322x76ab6b70xd29bf97e3643c553@mail.gmail.com> 
 <20070918113401.6a8a737f@the-village.bc.nu> 
 <43e72e890709181146s604e0f9fl8b0c16627469c77f@mail.gmail.com> 
 <alpine.LFD.0.999.0709181159440.16478@woody.linux-foundation.org> 
 <43e72e890709181207j7c85dc29sb355a9f5a4207411@mail.gmail.com> 
 <alpine.LFD.0.999.0709181219020.16478@woody.linux-foundation.org> 
 <43e72e890709181312sf2b421cn49be3389b3786a2a@mail.gmail.com> 
 <alpine.LFD.0.999.0709181323260.16478@woody.linux-foundation.org>
 <43e72e890709181402x7335d0acp306cf576fac6c070@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Sep 2007, Luis R. Rodriguez wrote:
> 
> ACK but do we really need to benchmark this if we *know* we are
> creating unnecessary branches? How about Jeff's suggestion of
> introducing pci_mmio_map() ?

Here's the counter-argument:

 - the run-time expense of this is basically *zero*

 - the expense of badly written drivers is absolutely *huge*

The fewer "clever" interfaces we have for no good reason, and the less 
unnecessary stuff that really doesn't matter, the more we help the 
*second* case.

The fact is, for device drivers, the *true* performance issues are nowhere 
*near* the actual IO accessor functions, and are all at a much higher 
level for all but a very very limited set of drivers. And I think you're 
making the important issues *worse*.

Really. "pci_mmio_map()" may not be a bad interface, but you're simply 
working on entirely the wrong problem. The problem is not an out-of-line 
IO accessor function - the problem is that you're making it even more 
complicated to write drivers.

The whole point of the "iomap()" interface was *never* about making the 
driver interfaces faster. It was about making them *cleaner*. And you're 
screwing that up!

The old situation with SATA drivers that had

	if (iomem)
		writel(..)
	else
		outl(..)

in the cases that needed it (and used hardcoded writel/outl in the cases 
that didn't) was an example of code that "in theory" is faster. But 
dammit, in practice that mattered not one whit, and what iomap() tries to 
do is to attack the _real_ problem we had in that area. 

Which had nothing what-so-ever to do with any branches.

		Linus
