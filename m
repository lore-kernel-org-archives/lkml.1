Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbYKTLFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbYKTLFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbYKTLFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:05:38 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37166 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025AbYKTLFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:05:38 -0500
Date: Thu, 20 Nov 2008 09:04:57 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Possible memory leak via slub kmem_cache_create
Message-ID: <20081120110457.GD30491@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christoph Lameter <cl@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <1227111954.27162.28.camel@pc1117.cambridge.arm.com> <Pine.LNX.4.64.0811191319360.23084@quilx.com> <1227174711.5784.9.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227174711.5784.9.camel@pc1117.cambridge.arm.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Nov 20, 2008 at 09:51:50AM +0000, Catalin Marinas escreveu:
> On Wed, 2008-11-19 at 13:22 -0600, Christoph Lameter wrote:
> > proto_register could add another field somewhere and store the pointer to
> > the name there? Then free the string on proto_unregister.
> 
> The patch below fixes this issue for proto_register. There is another
> similar case in net/dccp/ccid.c. I cc'ed the person who added the
> original proto_register code and he also seems to be the DCCP
> maintainer.
> 
> My point is that the API is slightly different when slub is used since
> kmem_cache_name is no longer guaranteed to return the same pointer
> passed to kmem_cache_create. Maybe a documentation update:
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index ea76bcb..9723a72 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -2124,6 +2124,8 @@ static int __init_refok setup_cpu_cache(struct kmem_cache 
>   *
>   * @name must be valid until the cache is destroyed. This implies that
>   * the module calling this has to destroy the cache before getting unloaded.
> + * Note that kmem_cache_name() is not guaranteed to return the same pointer,
> + * therefore applications must manage it themselves.
>   *
>   * The flags are
>   *
> 
> And the proto_register fix below (if it looks alright, I'll submit it
> separately):
> 
> 
> Fix memory leak in the proto_register function
> 
> From: Catalin Marinas <catalin.marinas@arm.com>
> 
> If the slub allocator is used, kmem_cache_create() may merge two or more
> kmem_cache's into one but the cache name pointer is not updated and
> kmem_cache_name() is no longer guaranteed to return the pointer passed
> to the former function. This patch stores the kmalloc'ed pointers in the
> corresponding request_sock_ops and timewait_sock_ops structures.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks, when I wrote this there X was only 'a' in slXb :-)

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
