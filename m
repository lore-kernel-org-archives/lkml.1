Return-Path: <linux-kernel-owner+w=401wt.eu-S1030715AbXCSWJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030715AbXCSWJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 18:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030729AbXCSWJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 18:09:17 -0400
Received: from lazybastard.de ([212.112.238.170]:38984 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030715AbXCSWJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 18:09:16 -0400
Date: Mon, 19 Mar 2007 23:04:14 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>, Christoph Lameter <clameter@sgi.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>, ast@domdv.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
Message-ID: <20070319220413.GA27302@lazybastard.org>
References: <Pine.LNX.4.64.0703191022310.8671@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0703191007230.23929@schroedinger.engr.sgi.com> <20070319204945.GJ10459@waste.org> <20070319141038.212d4ac9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070319141038.212d4ac9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 March 2007 14:10:38 -0700, Andrew Morton wrote:
> 
> Would prefer to do:
> 
> static inline void kmem_cache_free_if_not_null(struct kmem_cache *cachep,
> 						void *objp)
> {
> 	if (objp)
> 		kmem_cache_free(cachep, objp);
> }
> 
> so that we don't add extra overhead to all the thousands of existing,
> well-behaved callsites.

In principle, this would work.  But two things need changing, imho:
1. Don't inline the function.  kmem_cache_free() has only about 34 NULL
   callers, if my grep is reliable, so this case is arguable.  But in
   general, out-of-line functions are better than many extra
   conditionals pulled in through the inline one.
2. Switch the names.  According to Rusty's benchmark, the easiest way to
   use and interface should be the correct one.  Every new driver
   written by a rookie will call kmem_cache_free(), simply because the
   name seems simpler.

void kmem_cache_free_fast(struct kmem_cache *cachep, void *objp)
{
	/* old kmem_cache_free() */
}

void kmem_cache_free(struct kmem_cache *cachep, void *objp)
{
	if (likely(objp))
		kmem_cache_free_fast(cachep, objp);
}

Jörn

-- 
Correctness comes second.
Features come third.
Performance comes last.
Maintainability is easily forgotten.
