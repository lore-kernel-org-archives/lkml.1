Return-Path: <linux-kernel-owner+w=401wt.eu-S1764551AbZFQDTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764551AbZFQDTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 23:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757908AbZFQDTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 23:19:08 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:3577 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739AbZFQDTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 23:19:07 -0400
Subject: Re: [PATCH 0/1] Recurse when searching for empty slots in
 resources trees
From: Andrew Patterson <andrew.patterson@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>
In-Reply-To: <alpine.LFD.2.01.0906161804030.16802@localhost.localdomain>
References: <20090616220419.14021.84524.stgit@bob.kio>
	 <alpine.LFD.2.01.0906161511390.16802@localhost.localdomain>
	 <1245192703.8234.226.camel@bluto.andrew>
	 <alpine.LFD.2.01.0906161556020.16802@localhost.localdomain>
	 <1245195498.8234.236.camel@bluto.andrew>
	 <alpine.LFD.2.01.0906161640250.16802@localhost.localdomain>
	 <alpine.LFD.2.01.0906161717220.16802@localhost.localdomain>
	 <alpine.LFD.2.01.0906161804030.16802@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 03:19:04 +0000
Message-Id: <1245208744.19708.243.camel@grinch>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-16 at 18:04 -0700, Linus Torvalds wrote:
> 
> On Tue, 16 Jun 2009, Linus Torvalds wrote:
> > 
> > Can you try this patch?
> 

This looks functionally equivalent to the current code.  I get way too
much output to be useful.  I can log the serial port if we need it all,
or I can change it to just look at the buses in question if desired. 

My hardware got changed around on me, so I will have to try this
tomorrow with the original hardware config.

Andrew


> Oops. As Jesse pointed out, there was no patch.
> 
> _This_ time.
> 
> 		Linus
> 
> ---
>  kernel/resource.c |   13 ++++++++++---
>  1 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/resource.c b/kernel/resource.c
> index ac5f3a3..d9d7ede 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -140,6 +140,13 @@ __initcall(ioresources_init);
>  
>  #endif /* CONFIG_PROC_FS */
>  
> +#define set_parent(x,p) __set_parent(__FUNCTION__, x, p)
> +static void __set_parent(const char *fn, struct resource *x, struct resource *parent)
> +{
> +	WARN("%s: parent of '%s' is '%s'\n", fn, x->name, parent ? parent->name : "none");
> +	x->parent = parent;
> +}
> +
>  /* Return the conflict entry if you can't request it */
>  static struct resource * __request_resource(struct resource *root, struct resource *new)
>  {
> @@ -159,7 +166,7 @@ static struct resource * __request_resource(struct resource *root, struct resour
>  		if (!tmp || tmp->start > end) {
>  			new->sibling = tmp;
>  			*p = new;
> -			new->parent = root;
> +			set_parent(new, root);
>  			return NULL;
>  		}
>  		p = &tmp->sibling;
> @@ -395,13 +402,13 @@ static struct resource * __insert_resource(struct resource *parent, struct resou
>  			break;
>  	}
>  
> -	new->parent = parent;
> +	set_parent(new, parent);
>  	new->sibling = next->sibling;
>  	new->child = first;
>  
>  	next->sibling = NULL;
>  	for (next = first; next; next = next->sibling)
> -		next->parent = new;
> +		set_parent(next, new);
>  
>  	if (parent->child == first) {
>  		parent->child = new;
> 
-- 
Andrew Patterson
Hewlett-Packard

