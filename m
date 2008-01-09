Return-Path: <linux-kernel-owner+w=401wt.eu-S1757577AbYAIBmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbYAIBmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbYAIBmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 20:42:35 -0500
Received: from ns2.suse.de ([195.135.220.15]:52849 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195AbYAIBme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 20:42:34 -0500
Date: Wed, 9 Jan 2008 02:42:33 +0100
From: Andi Kleen <ak@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 00 of 10] x86: unify asm/pgtable.h
Message-ID: <20080109014233.GG25945@bingen.suse.de>
References: <20080109000146.GA29095@elte.hu> <47841194.2010208@goop.org> <20080109002014.GB31289@elte.hu> <20080109002803.GA3732@elte.hu> <20080109003034.GA4658@elte.hu> <47841B09.3020507@goop.org> <20080109005914.GA24228@elte.hu> <47841E3C.9020106@goop.org> <20080109011233.GD25945@bingen.suse.de> <478424DE.3030609@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478424DE.3030609@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 05:35:26PM -0800, Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
>>> of the if()?  If not, can't we just remove it and avoid this present 
>>> problem?
>>>     
>>
>> That would just hide your problem.
>>   
>
> The "problem" is a BUG() in pageattr_64.c:change_page_attr(), which to me 
> looks spurious.  It arises because __PAGE_KERNEL_* doesn't contain 
> _PAGE_GLOBAL, but PAGE_KERNEL_* does.  When ioremap() change_page_attr(), 
> it does so in a way that guarentees that the test
>
> 	if (pgprot_val(prot) != pgprot_val(ref_prot)) {
>
> in __change_page_attr() always succeeds.  When I folded _PAGE_GLOBAL into 
> the __PAGE_KERNEL_* definitions, it mostly works except it causes this if() 
> to fail, falling into the otherwise dead else clause and triggers a BUG().

That means your callers pass in the wrong values.

> I'm not really sure what the logic in here is supposed to be doing, but it 
> seems to me that it isn't the difference between global and non-global 
> mappings (I guess its really testing for cached vs uncached mappings).

No it is testing for all page attributes. That can be cached vs uncached
but also rw vs ro and nx vs non nx and everything else you can set
as bits on ptes.

While changing global sounds weird the pageattr-test code I recently
submitted does just that for test purposes.


> Or to put it another way, what's the underlying rationale for making 
> __PAGE_KERNEL_* not include the GLOBAL flag, but including it in the pgprot 
> versions?  It means that code like this in ioremap_64.c:

There is none, but that is not what change_page_attr() cares about.
It just cares that you pass in the correct bits and you don't currently.

I think you're missing the forrest because of all the trees currently.

-Andi

