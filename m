Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752293AbYLRP3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbYLRP3o (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 10:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbYLRP3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 10:29:35 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:33053 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751093AbYLRP3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 10:29:34 -0500
Subject: Re: [PATCH 05/15] kmemleak: Add the slub memory allocation/freeing
	hooks
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <1229597465.1047.54.camel@penberg-laptop>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
	 <20081210182721.30323.55530.stgit@pc1117.cambridge.arm.com>
	 <4941866D.5040005@cs.helsinki.fi>
	 <1229089544.15045.24.camel@pc1117.cambridge.arm.com>
	 <1229597465.1047.54.camel@penberg-laptop>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 18 Dec 2008 15:28:55 +0000
Message-Id: <1229614135.16418.33.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Dec 2008 15:28:56.0693 (UTC) FILETIME=[57872A50:01C96125]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Thu, 2008-12-18 at 12:51 +0200, Pekka Enberg wrote:
> On Fri, 2008-12-12 at 13:45 +0000, Catalin Marinas wrote:
> > Pekka Enberg wrote:
> > > Hmm, I'm not sure I understand why struct kmem_cache_cpu ->freelist is 
> > > never scanned. 
> >
> > Why would the ->freelist be a problem? I don't fully understand the slub
> > allocator. Aren't objects added to the freelist only after they were
> > freed? In __slab_alloc there seems to be a line:
> > 
> > c->page->freelist = NULL;
> > 
> > so the freelist won't count as a reference anymore. After freeing an
> > object, kmemleak no longer cares about references to it.
> 
> I think we're talking about two different things here. Don't we then
> have false negatives because we reach ->freelist of struct
> kmem_cache_cpu which contains a pointer to an object that is free'd
> (take a look at slab_free() fast-path)?

Just to make sure I understand it correctly, the slab_free() fast path
stores the pointer to the freed object into c->freelist. However, this
object is no longer tracked by kmemleak because of the
kmemleak_free_recursive() call at the beginning of this function (false
negatives make sense only for allocated objects).

On the slab_alloc() fast path, the pointer to an allocated object is
obtained from the c->freelist pointer but this seems to be overridden by
the pointer to the next free object, object[c->offset], which isn't yet
tracked by kmemleak. So, during a memory scan, it shouldn't matter that
the kmem_cache_cpu structures are called as they don't contain any
pointer to an allocated (not free) object.

The new slabs are allocated with alloc_pages() and these are not tracked
by kmemleak.

Is my understanding correct? Thanks.

-- 
Catalin

