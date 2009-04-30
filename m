Return-Path: <linux-kernel-owner+w=401wt.eu-S1760872AbZD3L0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760872AbZD3L0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 07:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbZD3L0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 07:26:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:33421 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbZD3L0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 07:26:14 -0400
Date: Thu, 30 Apr 2009 13:26:12 +0200
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Sachin Sant <sachinp@in.ibm.com>,
       linuxppc-dev@ozlabs.org, linux-next@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: Next April 28: boot failure on PowerPC with SLQB
Message-ID: <20090430112612.GD6900@wotan.suse.de>
References: <49F87FAB.9050408@in.ibm.com> <20090430041146.GB23746@wotan.suse.de> <49F938E4.2030703@in.ibm.com> <20090430064127.GF23746@wotan.suse.de> <49F973A0.8070106@in.ibm.com> <20090430103528.GA6900@wotan.suse.de> <1241087884.19252.5.camel@penberg-laptop> <20090430210004.05a61841.sfr@canb.auug.org.au> <20090430111825.GC6900@wotan.suse.de> <1241090429.19252.7.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241090429.19252.7.camel@penberg-laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 02:20:29PM +0300, Pekka Enberg wrote:
> On Thu, 2009-04-30 at 13:18 +0200, Nick Piggin wrote:
> > OK thanks. So I think we have 2 problems. One with MAX_ORDER <= 9
> > that is fixed by the previous patch, and another which is probably
> > due to having no memory on node 0 which I will take another look
> > at now.
> > 
> > We can merge the previous patch now, though.
> 
> Hmm, I'll bet this BUG_ON triggers for Stephen.
> 
> diff --git a/mm/slqb.c b/mm/slqb.c
> index a651843..e4b3859 100644
> --- a/mm/slqb.c
> +++ b/mm/slqb.c
> @@ -1391,6 +1391,7 @@ static noinline void *__slab_alloc_page(struct kmem_cache *s,
>  		struct kmem_cache_node *n;
>  
>  		n = s->node_slab[slqb_page_to_nid(page)];
> +		BUG_ON(!n);
>  		l = &n->list;
>  		page->list = l;

Yes I'm betting it does, but I can't see why it should. CPU0 should
have node_slab allocated for node 1 if node 1 has memory. And
conversely, slqb_page_to_nid(page) should never evaluate to 0 if
node 0 has no memory online.


