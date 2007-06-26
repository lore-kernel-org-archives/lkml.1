Return-Path: <linux-kernel-owner+w=401wt.eu-S1759710AbXFZThq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759710AbXFZThq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 15:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758994AbXFZTh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 15:37:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52810 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758766AbXFZTh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 15:37:28 -0400
Date: Tue, 26 Jun 2007 12:37:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, suresh.b.siddha@intel.com
Subject: Re: [patch 15/26] Slab defrag: Support generic defragmentation for
 inode slab caches
Message-Id: <20070626123709.211c67c4.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706261223110.20457@schroedinger.engr.sgi.com>
References: <20070618095838.238615343@sgi.com>
	<20070618095917.005535114@sgi.com>
	<20070626011836.f4abb4ff.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706261223110.20457@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007 12:28:50 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Tue, 26 Jun 2007, Andrew Morton wrote:
> 
> > Yes, this is tricky stuff.  I have vague ancestral memories that the sort
> > of inode work which you refer to here can cause various deadlocks, lockdep
> > warnings and such nasties when if we attempt to call it from the wrong
> > context (ie: from within fs code).
> 
> Right. Michael's test flushed one such issue out.
> 
> > Possibly we could prevent that by skipping all this code if the caller
> > didn't have __GFP_FS.
> 
> There is no check in vmscan.c as I thought earlier.
> 
> 
> Slab defragmentation: Only perform slab defrag if __GFP_FS is clear
> 
> Avoids slab defragmentation be triggered from filesystem operations.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> ---
>  mm/vmscan.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.22-rc4-mm2/mm/vmscan.c
> ===================================================================
> --- linux-2.6.22-rc4-mm2.orig/mm/vmscan.c	2007-06-26 12:25:28.000000000 -0700
> +++ linux-2.6.22-rc4-mm2/mm/vmscan.c	2007-06-26 12:26:18.000000000 -0700
> @@ -233,8 +233,9 @@ unsigned long shrink_slab(unsigned long 
>  		shrinker->nr += total_scan;
>  	}
>  	up_read(&shrinker_rwsem);
> -	kmem_cache_defrag(sysctl_slab_defrag_ratio,
> -		zone ? zone_to_nid(zone) : -1);
> +	if (!(gfp_mask & __GFP_FS))
> +		kmem_cache_defrag(sysctl_slab_defrag_ratio,
> +			zone ? zone_to_nid(zone) : -1);
>  	return ret;
>  }

This is inverted: __GFP_FS is set if we may perform fs operations.
