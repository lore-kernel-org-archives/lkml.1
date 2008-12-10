Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbYLJTed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbYLJTed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 14:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbYLJTeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 14:34:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:48499 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbYLJTeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 14:34:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tzkrLl2ArcdSiWBLPx83jCPlrEPuuxzjZtjq3V3cyGW2fNzanF8iAjAWS5Lzsx8krY
         yetgT8nPvWMza2cW24TKD+cTJRGec1UsL7Zep57/pqIcUkZISQvCPvd2wJJpK19GqgJH
         Y5Tyc43IvtI3TRLV/JVP3fqAjJw16epyqH/zY=
Date: Wed, 10 Dec 2008 22:34:21 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] Do not pass the SLAB flags as GFP in slob
	kmem_cache_create
Message-ID: <20081210193421.GA2215@localhost>
References: <20081210173632.19697.67688.stgit@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081210173632.19697.67688.stgit@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Catalin Marinas - Wed, Dec 10, 2008 at 05:36:33PM +0000]
| It looks like the kmem_cache_create() function in the slob allocator
| passes the SLAB flags as GFP flags to the slob_alloc() function. The
| patch changes this call to pass GFP_KERNEL as the other allocators seem
| to do.
| 
| Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
| Cc: Matt Mackall <mpm@selenic.com>
| ---
|  mm/slob.c |    2 +-
|  1 files changed, 1 insertions(+), 1 deletions(-)
| 
| diff --git a/mm/slob.c b/mm/slob.c
| index ff5a98d..dce9258 100644
| --- a/mm/slob.c
| +++ b/mm/slob.c
| @@ -538,7 +538,7 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
|  	struct kmem_cache *c;
|  
|  	c = slob_alloc(sizeof(struct kmem_cache),
| -		flags, ARCH_KMALLOC_MINALIGN, -1);
| +		GFP_KERNEL, ARCH_KMALLOC_MINALIGN, -1);
|  
|  	if (c) {
|  		c->name = name;
|

Hi Catalin,

this would make the following line in slob_alloc

	...
	if (unlikely((gfp & __GFP_ZERO) && b))
		memset(b, 0, size);
 	...

useless. Not sure if it will be good :)

---
Some  CC: added

		- Cyrill -
