Return-Path: <linux-kernel-owner+w=401wt.eu-S932334AbXDAF2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334AbXDAF2X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 01:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932344AbXDAF2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 01:28:23 -0400
Received: from smtp.osdl.org ([65.172.181.24]:49764 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932334AbXDAF2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 01:28:22 -0400
Date: Sat, 31 Mar 2007 22:28:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <clameter@engr.sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 3/3] slab: avoid __initdata warning (may be a bogus one)
Message-Id: <20070331222813.bd66ae05.akpm@linux-foundation.org>
In-Reply-To: <20070330230814.19809.15981.stgit@americanbeauty.home.lan>
References: <20070330230746.19809.2000.stgit@americanbeauty.home.lan>
	<20070330230814.19809.15981.stgit@americanbeauty.home.lan>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Mar 2007 01:08:14 +0200 "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it> wrote:

> set_up_list3s is not __init and references initkmem_list3.
> 
> Also, kmem_cache_create calls setup_cpu_cache which calls set_up_list3s. The
> state machine _may_ prevent the code from accessing this data after freeing
> initdata (it makes sure it's used only up to boot), so this warning may be a
> false positive.
> 
> Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
> ---
> 
>  mm/slab.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index 0934f8d..0772faf 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -305,7 +305,7 @@ struct kmem_list3 {
>   * Need this for bootstrapping a per node allocator.
>   */
>  #define NUM_INIT_LISTS (2 * MAX_NUMNODES + 1)
> -struct kmem_list3 __initdata initkmem_list3[NUM_INIT_LISTS];
> +struct kmem_list3 initkmem_list3[NUM_INIT_LISTS];
>  #define	CACHE_CACHE 0
>  #define	SIZE_AC 1
>  #define	SIZE_L3 (1 + MAX_NUMNODES)

Yes, I think this is a flase positive - we'll never touch initkmem_list3[]
after free_initmem() because of the transitions of g_cpucache_up.

(In which case set_up_list3s() shoud be __init, too?)

Christoph, I think you looked at this previously?
