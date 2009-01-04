Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbZADLMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbZADLMV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 06:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbZADLMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 06:12:07 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:27426 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbZADLMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 06:12:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vzYGo/lY1j34U/FnRDRPEnAFF7Wi2Yliixaqo56YZQAMCLNkOq0cc2T/XB71QAkRfg
         Zg6hVsAkPoeScb2ZkeQ7gAaAlV5ENWuMKcYY+/6iMwXn0ZRPZn1chPJx/BbzgInPesLy
         p9MRpySxrbUFpjcD3482EQOeFb2u9KyT7hCeo=
Date: Sun, 4 Jan 2009 14:11:59 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: david@lang.hm, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>, yhlu.kernel@gmail.com
Subject: Re: early exception error
Message-ID: <20090104111159.GB7632@localhost>
References: <20090102174845.GD5372@localhost> <20090102175226.GE5372@localhost> <alpine.DEB.1.10.0901021131210.21567@asgard.lang.hm> <20090102203058.GH5372@localhost> <alpine.DEB.1.10.0901030823190.23262@asgard.lang.hm> <20090103161052.GB11093@localhost> <alpine.DEB.1.10.0901031118450.23262@asgard.lang.hm> <20090103190316.GB7367@localhost> <20090103212426.GC7367@localhost> <496001A3.1040201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496001A3.1040201@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Jiri Slaby - Sun, Jan 04, 2009 at 01:24:03AM +0100]
| On 01/03/2009 10:24 PM, Cyrill Gorcunov wrote:
| > [Cyrill Gorcunov - Sat, Jan 03, 2009 at 10:03:16PM +0300]
| > | (list restored)
| > | 
| > | [david@lang.hm - Sat, Jan 03, 2009 at 11:19:00AM -0800]
| > | ...
| > | >>>
| > | >>> two new screenshots at http://linux.lang.hm/linux
| > | >>>
| > | >>> 36 is a boot with just earlyprintk=vga
| > | >>> 37 is a boot with numa=noacpi
| > | >>> I also put the vmlinux file there, I'll put the System.map and config
| > | >>> there later (I did enable kernel_debug on this build as well)
| > | >>>
| > | >>> David Lang
| > | >>>
| > | >>
| > | >> David, I can't find vmlinux neither .config?
| > | >> Maybe they have hidden attribute?
| > | 
| > | ok, according to failing address we've a BUG_ON
| > | triggered
| > | 
| > | ---
| > | (gdb) l *0xffffffff8096452a
| > | 0xffffffff8096452a is in alloc_bootmem_core (mm/bootmem.c:442).
| > | 437		unsigned long fallback = 0;
| > | 438		unsigned long min, max, start, sidx, midx, step;
| > | 439	
| > | 440		BUG_ON(!size);
| > | 441		BUG_ON(align & (align - 1));
| > | 442		BUG_ON(limit && goal + size > limit);
| > | 443	
| > | 444		if (!bdata->node_bootmem_map)
| > | 445			return NULL;
| > | 446	
| > | (gdb) 
| > | ---
| > | 
| > | so we're in attempt to overrun 'limit'.
| > | Hmm...
| > | 
| > | 		- Cyrill -
| > 
| > Hardly possible that we trigger BUG here since I don't
| > see BUG: on the photo. Investigating.
| 
| Hint: line 442 in 2.6.28 is
| if (!bdata->node_bootmem_map)
| ;)
| 
| It's:
| 0xffffffff8096452a <alloc_bootmem_core+69>:     cmpq   $0x0,0x10(%rbp)
| and hence cr2 is 10.
| 
| node_data[nid] is NULL... But both of them are set up. Maybe too high nid (and
| pnum in sparse_init)?
|

It seems to be true!

What is worse we have a number of __nr_to_section users which
don't check for NULL returned and secondly

static inline struct mem_section *__nr_to_section(unsigned long nr)
{
	if (!mem_section[SECTION_NR_TO_ROOT(nr)])
		return NULL;
	return &mem_section[SECTION_NR_TO_ROOT(nr)][nr & SECTION_ROOT_MASK];
}

SECTION_NR_TO_ROOT is not modulo operation so we could run out of
mem_section[NR_SECTION_ROOTS].

David I'll cook some testing patch shortly.
Many thanks to Jiri!

		- Cyrill -
