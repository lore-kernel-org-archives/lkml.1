Return-Path: <linux-kernel-owner+w=401wt.eu-S1761714AbYCDRUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761714AbYCDRUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 12:20:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbYCDRUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 12:20:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751461AbYCDRUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 12:20:35 -0500
Date: Tue, 4 Mar 2008 09:19:36 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Pavel Roskin <proski@gnu.org>, Zan Lynx <zlynx@acm.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
 symbols
In-Reply-To: <20080304125744.GF29777@elte.hu>
Message-ID: <alpine.LFD.1.00.0803040907420.12253@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org> <1204304352.6767.21.camel@localhost> <alpine.LFD.1.00.0802290906520.17889@woody.linux-foundation.org> <1204305609.21719.16.camel@dv> <alpine.LFD.1.00.0802290929590.17889@woody.linux-foundation.org>
 <1204313978.2316.8.camel@dv> <20080229211513.GI27212@elte.hu> <1204324265.2316.70.camel@dv> <20080303105752.GA23594@elte.hu> <20080304003723.z79pcavdk4wgoc44@webmail.spamcop.net> <20080304125744.GF29777@elte.hu>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 4 Mar 2008, Ingo Molnar wrote:
> 
> so ... i suspect the requirement would be for 
> NdisMAllocateSharedMemory() to return a linear address that is DMA-able, 
> and to properly map it to a physical address via dma_map_single(). I can 
> see only one complication in pushing this to user-space: physical 
> fragmentation of allocations. What are the typical buffer sizes that 
> NDIS drivers request from the kernel? Is it frequently above 4K?

Ingo, i's simply not possible to put ndiswrapper in user-space sanely.

Drivers are drivers. They'll want (shared) interrupts, they want DMA, they 
want to do things like cli/sti. 

The USB drivers *may* be abstracted enough that they don't do any of that, 
but quite frankly, I doubt it.

> if the NDIS API is done halfways right, then there's no need for any of 
> these buffers to be in kernel-space and for the driver to run in kernel 
> space.

Don't be silly. When you claim this is the only way things are "halfway 
right", then none of the Linux kernel driver interfaces are even *close* 
to halfway right. Sure, the NDIS ABI has to b more abstracted than the 
Linux kernel one (because it's a binary ABI that survives over multiple 
Windows versions, not a source code API), but the fact is, NDIS is 
designed for kernel-mode, not user mode.

So asking people to make ndiswrapper be user-mode only is simply not 
realistic.

The question on the table is not whether we can make it user-mode 
(especially since no major kernel contributor is likely to even care 
enough to really help code anyway), but whether we should let ndiswrapper 
continue using GPLONLY symbols.

Quite frankly, my position on this has always been that the GPLv2 
explicitly covers _derived_ works only, and that very obviously a Windows 
driver isn't a derived work of the kernel. So as far as I'm concerned, 
ndiswrapper may be distasteful froma technical and support angle, but not 
against the license.

So I'm personally perfectly happy to say that we should revert that commit 
0aa5bd52d0c49ca56d24584c646e6544ccbb3dc9, but what I've wanted to hear 
from the very beginning was simply to get a list of symbols that currently 
clash, and hear from the people who maintain the symbols whether they 
really meant for that commit to be valid.

That's the only issue here. Not whether ndiswrapper could do a part of its 
job in user space (because the answer to that latter question is: no. 
Everything is "possible", of course, but realistically, that's simply not 
going to happen).

It sounds like there aren't that many symbols affected at the core: the 
workqueue stuff certainly isn't worth bothering about. The USB things that 
ndiswrapper wants is much more involved, and more likely to have issues, 
but I'm cc'ing Greg here to see.

IOW: I _personally_ don't think there are any license issues, but I do 
want to have the situation clear to people involved.

		Linus
