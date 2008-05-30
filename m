Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbYE3Wao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbYE3Wao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 18:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbYE3Waf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 18:30:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751160AbYE3Wae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 18:30:34 -0400
Date: Fri, 30 May 2008 15:30:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@linux.intel.com>
cc: Hugh Dickins <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>
Subject: Re: Top kernel oopses/warnings for the week of May 30th 2008
In-Reply-To: <48407909.5090608@linux.intel.com>
Message-ID: <alpine.LFD.1.10.0805301517500.3141@woody.linux-foundation.org>
References: <48402DAA.60202@linux.intel.com> <Pine.LNX.4.64.0805302017580.16427@blonde.site> <alpine.LFD.1.10.0805301403540.3141@woody.linux-foundation.org> <48407909.5090608@linux.intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 May 2008, Arjan van de Ven wrote:
> 
> ok for some it did gather this information, and it is
> 
> kernel BUG at mm/highmem.c:319!

That's just _odd_. The call chain actually has kmap() in it, and kmap 
does:

	if (!PageHighMem(page))
		return page_address(page);
	return kmap_high(page);

so if it's the one at line 319, which says

	BUG_ON(!PageHighMem(page));

then I wonder what happened to that PageHighMem() test of the page in 
between..

Ahh.. Not the same "page". It looks like it's in the 
flush_all_zero_pkmaps() path, and it's clearing some _other_ page in the 
pkmap table in order to make room for the new one. So the page that causes 
problems is from here:

	 page = pte_page(pkmap_page_table[i]);

rather than the one we're trying to map.

Not that it explains the BUG_ON(). We should only insert page table 
entries into the pkmap_page_table[] array in map_new_virtual(), which in 
turn is only called from kmap_high(), which in turn means that *those* 
pages have also gine through the PageHighMem() test.

So it sounds like we either
 - have corruption in pkmap_page_table[]
 - or pte_page() doesn't reverse mk_pte(page) propely, and one or the 
   other is broken.

Does anybody know if the fc9 x86-32 kernel is built with PAE enabled? 
Might this be another PAE bit-masking bug and thus possibly fixed by the 
PTE_MASK changes?

		Linus

