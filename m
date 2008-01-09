Return-Path: <linux-kernel-owner+w=401wt.eu-S1757365AbYAIBid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbYAIBid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756609AbYAIBiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 20:38:04 -0500
Received: from gw.goop.org ([64.81.55.164]:49219 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756591AbYAIBiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 20:38:02 -0500
Message-ID: <478424DE.3030609@goop.org>
Date: Tue, 08 Jan 2008 17:35:26 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 00 of 10] x86: unify asm/pgtable.h
References: <20080108232803.GA19906@elte.hu> <20080108234449.GA24274@elte.hu> <20080109000146.GA29095@elte.hu> <47841194.2010208@goop.org> <20080109002014.GB31289@elte.hu> <20080109002803.GA3732@elte.hu> <20080109003034.GA4658@elte.hu> <47841B09.3020507@goop.org> <20080109005914.GA24228@elte.hu> <47841E3C.9020106@goop.org> <20080109011233.GD25945@bingen.suse.de>
In-Reply-To: <20080109011233.GD25945@bingen.suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> of the if()?  If not, can't we just remove it and avoid this present 
>> problem?
>>     
>
> That would just hide your problem.
>   

The "problem" is a BUG() in pageattr_64.c:change_page_attr(), which to 
me looks spurious.  It arises because __PAGE_KERNEL_* doesn't contain 
_PAGE_GLOBAL, but PAGE_KERNEL_* does.  When ioremap() 
change_page_attr(), it does so in a way that guarentees that the test

	if (pgprot_val(prot) != pgprot_val(ref_prot)) {

in __change_page_attr() always succeeds.  When I folded _PAGE_GLOBAL 
into the __PAGE_KERNEL_* definitions, it mostly works except it causes 
this if() to fail, falling into the otherwise dead else clause and 
triggers a BUG().

I'm not really sure what the logic in here is supposed to be doing, but 
it seems to me that it isn't the difference between global and 
non-global mappings (I guess its really testing for cached vs uncached 
mappings).

Or to put it another way, what's the underlying rationale for making 
__PAGE_KERNEL_* not include the GLOBAL flag, but including it in the 
pgprot versions?  It means that code like this in ioremap_64.c:

		err = change_page_attr_addr(vaddr,npages,__pgprot(__PAGE_KERNEL|flags));

is subtly different from using PAGE_KERNEL | flags, because the latter 
also includes _PAGE_GLOBAL.

    J
