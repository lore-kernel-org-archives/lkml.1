Return-Path: <linux-kernel-owner+w=401wt.eu-S1753689AbZLVPr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbZLVPr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 10:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbZLVPr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 10:47:57 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:44782 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbZLVPr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 10:47:56 -0500
Date: Tue, 22 Dec 2009 09:47:39 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Haicheng Li <haicheng.li@linux.intel.com>
cc: linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Matt Mackall <mpm@selenic.com>, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: initialize unused alien cache entry as NULL at
 alloc_alien_cache().
In-Reply-To: <4B30BDA8.1070904@linux.intel.com>
Message-ID: <alpine.DEB.2.00.0912220945250.12048@router.home>
References: <4B30BDA8.1070904@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Dec 2009, Haicheng Li wrote:

>  	struct array_cache **ac_ptr;
> -	int memsize = sizeof(void *) * nr_node_ids;
> +	int memsize = sizeof(void *) * MAX_NUMNODES;
>  	int i;

Why does the alien cache pointer array size have to be increased? node ids
beyond nr_node_ids cannot be used.


>
>  	if (limit > 1)
>  		limit = 12;
>  	ac_ptr = kmalloc_node(memsize, gfp, node);

Use kzalloc to ensure zeroed memory.

>  	if (ac_ptr) {
> +		memset(ac_ptr, 0, memsize);
>  		for_each_node(i) {
> -			if (i == node || !node_online(i)) {
> -				ac_ptr[i] = NULL;
> +			if (i == node || !node_online(i))
>  				continue;
> -			}
>  			ac_ptr[i] = alloc_arraycache(node, limit, 0xbaadf00d,
> gfp);
>  			if (!ac_ptr[i]) {
>  				for (i--; i >= 0; i--)
>
