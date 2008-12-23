Return-Path: <linux-kernel-owner+w=401wt.eu-S1751507AbYLWOah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507AbYLWOah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 09:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbYLWOa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 09:30:28 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50096 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbYLWOa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 09:30:27 -0500
Date: Tue, 23 Dec 2008 09:29:16 -0500
From: Josef Bacik <jbacik@redhat.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Theodore Tso <tytso@mit.edu>, adilger@sun.com,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: annotate unhandled kmem_cache_alloc() error
Message-ID: <20081223142915.GA23303@unused.rdu.redhat.com>
References: <20081223104016.GC7217@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081223104016.GC7217@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2008 at 07:40:18PM +0900, Akinobu Mita wrote:
> kmem_cache_alloc() error in ext4_mb_free_metadata is not handled.
> I don't know how to fix it. But I can put BUG_ON to let others
> know the problem.
> 
> Cc: Theodore Tso <tytso@mit.edu>
> Cc: adilger@sun.com
> Cc: linux-ext4@vger.kernel.org
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  fs/ext4/mballoc.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: 2.6-rc/fs/ext4/mballoc.c
> ===================================================================
> --- 2.6-rc.orig/fs/ext4/mballoc.c
> +++ 2.6-rc/fs/ext4/mballoc.c
> @@ -4417,6 +4417,7 @@ ext4_mb_free_metadata(handle_t *handle, 
>  	BUG_ON(e4b->bd_buddy_page == NULL);
>  
>  	new_entry  = kmem_cache_alloc(ext4_free_ext_cachep, GFP_NOFS);
> +	BUG_ON(!new_entry);
>  	new_entry->start_blk = block;
>  	new_entry->group  = group;
>  	new_entry->count = count;

BUG_ON is good for devel things, but for stable stuff it's better to let
somebody know an error occured rather than panic'ing the box.  The proper
solution would be to do

if (!new_entry)
	return -ENOMEM;

or if there is some out: label set ret to -ENOMEM and goto out, whatever is
appropriate in the context.  Thanks,

Josef
