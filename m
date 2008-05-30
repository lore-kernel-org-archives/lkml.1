Return-Path: <linux-kernel-owner+w=401wt.eu-S1753217AbYE3Weg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbYE3Weg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 18:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214AbYE3WeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 18:34:20 -0400
Received: from mga06.intel.com ([134.134.136.21]:64920 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754886AbYE3WeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 18:34:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,568,1204531200"; 
   d="scan'208";a="286572223"
Message-ID: <484080EC.9090707@linux.intel.com>
Date: Fri, 30 May 2008 15:34:20 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Hugh Dickins <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>
Subject: Re: Top kernel oopses/warnings for the week of May 30th 2008
References: <48402DAA.60202@linux.intel.com> <Pine.LNX.4.64.0805302017580.16427@blonde.site> <alpine.LFD.1.10.0805301403540.3141@woody.linux-foundation.org> <48407909.5090608@linux.intel.com> <alpine.LFD.1.10.0805301517500.3141@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805301517500.3141@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 30 May 2008, Arjan van de Ven wrote:
>> ok for some it did gather this information, and it is
>>
>> kernel BUG at mm/highmem.c:319!
> 
> That's just _odd_. The call chain actually has kmap() in it, and kmap 
> does:
> 
> 	if (!PageHighMem(page))
> 		return page_address(page);
> 	return kmap_high(page);
> 
> so if it's the one at line 319, which says
> 
> 	BUG_ON(!PageHighMem(page));
> 
> then I wonder what happened to that PageHighMem() test of the page in 
> between..
> 
> Ahh.. Not the same "page". It looks like it's in the 
> flush_all_zero_pkmaps() path, and it's clearing some _other_ page in the 
> pkmap table in order to make room for the new one. So the page that causes 
> problems is from here:
> 
> 	 page = pte_page(pkmap_page_table[i]);
> 
> rather than the one we're trying to map.
> 
> Not that it explains the BUG_ON(). We should only insert page table 
> entries into the pkmap_page_table[] array in map_new_virtual(), which in 
> turn is only called from kmap_high(), which in turn means that *those* 
> pages have also gine through the PageHighMem() test.
> 
> So it sounds like we either
>  - have corruption in pkmap_page_table[]
>  - or pte_page() doesn't reverse mk_pte(page) propely, and one or the 
>    other is broken.
> 
> Does anybody know if the fc9 x86-32 kernel is built with PAE enabled? 

versions that do identify themselves as "2.6.25-14.fc9.i686.PAE", and these ones didn't,
(they're all in the "2.6.25-14.fc9.i686" form) so this is a kernel without PAE.
