Return-Path: <linux-kernel-owner+w=401wt.eu-S1422775AbXBUSsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422775AbXBUSsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422797AbXBUSsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:48:46 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41006 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1422775AbXBUSsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:48:45 -0500
Date: Wed, 21 Feb 2007 10:48:43 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jsipek@fsl.cs.sunysb.edu, unionfs@filesystems.org, bunk@stusta.de,
       hooanon05@yahoo.co.jp
Subject: Re: [PATCH 1/3] slab: introduce krealloc
In-Reply-To: <45DC916E.1020300@cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0702211041061.24941@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702211003290.8172@sbz-30.cs.Helsinki.FI>
 <Pine.LNX.4.64.0702210951580.24344@schroedinger.engr.sgi.com>
 <45DC8DA1.6030100@cs.helsinki.fi> <Pine.LNX.4.64.0702211023300.24719@schroedinger.engr.sgi.com>
 <45DC916E.1020300@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007, Pekka Enberg wrote:

> Christoph Lameter wrote:
> > 2. Check if the size specified is larger than the next smallest general
> > cache and only copy if we would really would allocate from a different
> > cache.
> 
> Yeah, I was thinking about this too but decided against it (for now) as I am
> mostly concerned with removing the slab abuses from unionfs. Also, it is not
> immediately obvious we want to do this for all cases of krealloc so I'd prefer

Why not? Its a realloc call and these are the classic semantics of 
realloc. Otherwise realloc will always move the memory.

> to keep the API for a while and decide to optimize or not optimize later. Note
> that we would only get rid of one of the kfree callers, the other one doesn't
> want to do krealloc(), it never reuses the old values.

Check that both sizes fall into the same general cache. Do the following 
at the beginning of the function

struct kmem_cache *cachep = page_get_slab(virt_to_page(object));

if (new_size && cachep == kmem_find_general_cachep(new_size, 
cachep->gfpflags))
	/*
	 * Old and new object size us the same general slab so we do not 
	 * have to do anything
	 */
	return object;

