Return-Path: <linux-kernel-owner+w=401wt.eu-S1750719AbXEFV0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750719AbXEFV0a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 17:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750755AbXEFV0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 17:26:30 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:42631 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbXEFV03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 17:26:29 -0400
Date: Sun, 6 May 2007 23:27:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm1
Message-ID: <20070506212723.GA11287@uranus.ravnborg.org>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org> <17296.1178434189@turing-police.cc.vt.edu> <20070506205732.GC10396@uranus.ravnborg.org> <20070506140857.550edb37.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070506140857.550edb37.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2007 at 02:08:57PM -0700, Andrew Morton wrote:
> On Sun, 6 May 2007 22:57:32 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > On Sun, May 06, 2007 at 02:49:49AM -0400, Valdis.Kletnieks@vt.edu wrote:
> > > On Sat, 05 May 2007 01:49:55 PDT, Andrew Morton said:
> > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/
> > > 
> > >   MODPOST vmlinux
> > > WARNING: mm/built-in.o - Section mismatch: reference to .init.text: from .text between 'kmem_cache_create' (at offset 0x20dff) and 'cache_reap'
> > > WARNING: mm/built-in.o - Section mismatch: reference to .init.text: from .text between 'kmem_cache_create' (at offset 0x20e41) and 'cache_reap'
> > > 
> > > Built with CONFIG_SLAB, CONFIG_SMP, x86_64.
> > 
> > It comes from this code (mm/slab.c):
> > /*
> >  * For setting up all the kmem_list3s for cache whose buffer_size is same as
> >  * size of kmem_list3.
> >  */
> > static void __init set_up_list3s(struct kmem_cache *cachep, int index)
> > {
> > 	int node;
> > 
> > 	for_each_online_node(node) {
> > 		cachep->nodelists[node] = &initkmem_list3[index + node];
> > 		cachep->nodelists[node]->next_reap = jiffies +
> > 		    REAPTIMEOUT_LIST3 +
> > 		    ((unsigned long)cachep) % REAPTIMEOUT_LIST3;
> > 	}
> > }
> > 
> > It is supposed to be used only during early init and thus marked __init.
> > And initkmem_list3 is marked __initdata so that matches.
> > 
> > But set_up_list3s() is used outside __init marked functions and thus result in an error.
> > 
> > I do not know how to fix this.
> > 
> 
> Yes, this is one of those rare places which triggers a warning but where no
> changes are needed.
> 
> I'm thinking that we could address this with a new section __nowarn and
> __nowarndata (or whatever).  These will have the same behaviour as regular
> .text and .data, only the symbol-checking tool would know about them and
> would suppress the warnings.
> 
> Perhaps there's some other way of communication this information from the C
> level down into the checker - I haven't thought about it much.

The current approach is to rely on symbols being proper resolved but binutils
are playing tricks and does not always provide info to resolve static symbols.
Originally I thought this was pure inlining issues but it seems to be more than
that.
But introducing a special section just to say "references to .init.text" is OK
seems like a bit of overengineering to me.
I will give it a try during the coming week.

	Sam
