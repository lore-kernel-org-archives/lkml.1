Return-Path: <linux-kernel-owner+w=401wt.eu-S1752886AbXE3AqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbXE3AqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 20:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbXE3AqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 20:46:09 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751185AbXE3AqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 20:46:07 -0400
Date: Tue, 29 May 2007 17:45:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch 2/2] m68k: Discontinuous memory support
Message-Id: <20070529174556.20c551a0.akpm@linux-foundation.org>
In-Reply-To: <20070528191715.597623909@mail.of.borg>
References: <20070528191630.377693320@mail.of.borg>
	<20070528191715.597623909@mail.of.borg>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2007 21:16:32 +0200
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> -#define __page_address(page)	(PAGE_OFFSET + (((page) - mem_map) << PAGE_SHIFT))
> -#define page_to_phys(page)	virt_to_phys((void *)__page_address(page))
> +#ifdef CONFIG_SINGLE_MEMORY_CHUNK
> +#define page_to_phys(page) \
> +	__pa(PAGE_OFFSET + (((page) - pg_data_map[0].node_mem_map) << PAGE_SHIFT))
> +#else
> +#define page_to_phys(page) ({						\
> +	struct pglist_data *pgdat;					\
> +	pgdat = pg_data_table[page_to_nid(page)];			\
> +	page_to_pfn(page) << PAGE_SHIFT;				\
> +})
> +#endif

macros which evaluate their args more than once are dangerous.
