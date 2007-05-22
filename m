Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbXEVE4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbXEVE4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 00:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755234AbXEVE4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 00:56:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51277 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754914AbXEVE4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 00:56:42 -0400
Date: Mon, 21 May 2007 21:52:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
cc: ben.collins@ubuntu.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, sam@ravnborg.org, dwmw2@infradead.org,
       adobriyan@gmail.com
Subject: Re: [RFC] Crash on modpost, addend_386_rel()
In-Reply-To: <20070522.134015.65004318.nemoto@toshiba-tops.co.jp>
Message-ID: <alpine.LFD.0.98.0705212150000.3890@woody.linux-foundation.org>
References: <1179799287.7485.17.camel@cunning>
 <20070522.134015.65004318.nemoto@toshiba-tops.co.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 May 2007, Atsushi Nemoto wrote:
> 
> Anyway, here is a updated patch tested on i386 (RELOCATABLE=y/n), arm,
> and mips.  On calculation of 'location', sh_addr should be subtracted
> (thank you for debugging, Linus).  And this patch contains an another
> fix and an improvement of added_mips_rel

Would you mind also just making this whole logic (that is generic and 
shared with all the different arch versions) be an inline function of its 
own? 

> +	Elf_Shdr *sechdrs = elf->sechdrs;
> +	unsigned int *location;
> +	int section = sechdrs[rsection].sh_info;
> +
> +	location = (void *)elf->hdr + sechdrs[section].sh_offset +
> +		(r->r_offset - sechdrs[section].sh_addr);

so that all the functions could just use some generic

	location = reloc_location(elf, rsection, r);

or similar, instead of having that complex thing duplicated three times 
(arm, mips and i386)?

Especially since other architectures will likely end up doing the same 
thing too...

		Linus
