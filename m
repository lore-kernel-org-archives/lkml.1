Return-Path: <linux-kernel-owner+w=401wt.eu-S1759862AbZKFU6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759862AbZKFU6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 15:58:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759719AbZKFU6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 15:58:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44577 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407AbZKFU6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 15:58:02 -0500
Date: Fri, 6 Nov 2009 21:58:05 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: castet.matthieu@free.fr
Cc: linux-kernel@vger.kernel.org
Subject: Re: Using x86 segments against NULL pointer deference exploit
In-Reply-To: <1257512389.4af41dc504e1b@imp.free.fr>
Message-ID: <alpine.LRH.2.00.0911062155250.31913@twin.jikos.cz>
References: <1257512389.4af41dc504e1b@imp.free.fr>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Nov 2009, castet.matthieu@free.fr wrote:

> I am wondering why we can't set the KERNEL_DS data segment to not 
> contain the first page, ie changing it from R/W flat model to R/W expand 
> down from 0xffffffff to 4096.
> The modification seems simple : change GDT_ENTRY_KERNEL_DS [1], and some
> modification for syscall entry point that doesn't support segment (sysenter).

The question is -- why bother? We already have mmap_min_addr ... does this 
pontentially provide any additional advantage?

> The drawback of this it that the kernel can't access anymore data in the first
> segment. Is it needed for application like wine or dosemu ?
> Regards,
> 
> Matthieu
> 
> PS : why x86_64 segment got access bit set and x86_32 doesn't ?
> 
> [1]
> something like
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index cc25c2b..898a569 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -101,7 +101,7 @@ DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = {
> .gdt = {
>  	[GDT_ENTRY_DEFAULT_USER_CS]	= GDT_ENTRY_INIT(0xa0fb, 0, 0xfffff),
>  #else
>  	[GDT_ENTRY_KERNEL_CS]		= GDT_ENTRY_INIT(0xc09a, 0, 0xfffff),
> -	[GDT_ENTRY_KERNEL_DS]		= GDT_ENTRY_INIT(0xc092, 0, 0xfffff),
> +	[GDT_ENTRY_KERNEL_DS]		= GDT_ENTRY_INIT(0xc096, 0, 0x00001),
>  	[GDT_ENTRY_DEFAULT_USER_CS]	= GDT_ENTRY_INIT(0xc0fa, 0, 0xfffff),
>  	[GDT_ENTRY_DEFAULT_USER_DS]	= GDT_ENTRY_INIT(0xc0f2, 0, 0xfffff),
>  	/*

It's not that simple for various reasons ... PaX/Grsecurity people already 
did this in their patchset quite some time ago.

See http://www.grsecurity.net/~spender/uderef.txt

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

