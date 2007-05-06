Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbXEFU4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbXEFU4j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 16:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620AbXEFU4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 16:56:39 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:54230 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754483AbXEFU4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 16:56:38 -0400
Date: Sun, 6 May 2007 22:57:32 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm1
Message-ID: <20070506205732.GC10396@uranus.ravnborg.org>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org> <17296.1178434189@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17296.1178434189@turing-police.cc.vt.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2007 at 02:49:49AM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Sat, 05 May 2007 01:49:55 PDT, Andrew Morton said:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/
> 
>   MODPOST vmlinux
> WARNING: mm/built-in.o - Section mismatch: reference to .init.text: from .text between 'kmem_cache_create' (at offset 0x20dff) and 'cache_reap'
> WARNING: mm/built-in.o - Section mismatch: reference to .init.text: from .text between 'kmem_cache_create' (at offset 0x20e41) and 'cache_reap'
> 
> Built with CONFIG_SLAB, CONFIG_SMP, x86_64.

It comes from this code (mm/slab.c):
/*
 * For setting up all the kmem_list3s for cache whose buffer_size is same as
 * size of kmem_list3.
 */
static void __init set_up_list3s(struct kmem_cache *cachep, int index)
{
	int node;

	for_each_online_node(node) {
		cachep->nodelists[node] = &initkmem_list3[index + node];
		cachep->nodelists[node]->next_reap = jiffies +
		    REAPTIMEOUT_LIST3 +
		    ((unsigned long)cachep) % REAPTIMEOUT_LIST3;
	}
}

It is supposed to be used only during early init and thus marked __init.
And initkmem_list3 is marked __initdata so that matches.

But set_up_list3s() is used outside __init marked functions and thus result in an error.

I do not know how to fix this.

	Sam
