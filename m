Return-Path: <linux-kernel-owner+w=401wt.eu-S1764235AbYEVEgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764235AbYEVEgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 00:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750820AbYEVEfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 00:35:54 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:40590 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750777AbYEVEfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 00:35:53 -0400
Date: Thu, 22 May 2008 13:34:10 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       mpm@selenic.com, dhowells@redhat.com
Subject: Re: [RFC/PATCH 1/3] SLAB: Add PageSlab checking to ksize()
Message-ID: <20080522043410.GA4050@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
	mpm@selenic.com, dhowells@redhat.com
References: <Pine.LNX.4.64.0805212124250.22291@sbz-30.cs.Helsinki.FI> <20080521234555.GB32707@linux-sh.org> <4834F2E2.3070806@cs.helsinki.fi> <Pine.LNX.4.64.0805212116260.19431@schroedinger.engr.sgi.com> <4834F4DC.3040009@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4834F4DC.3040009@cs.helsinki.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 07:21:48AM +0300, Pekka Enberg wrote:
> Christoph Lameter wrote:
> >>That's probably due to the fact that we use PageSlab for all pages with 
> >>SLUB
> >>and for bigblock pages in SLOB with this patch. Christoph, Matt, any
> >>suggestions how to fix the PageSlab check in nommu btw?
> >
> >I already posted a patch and commented numerous times. What else needs 
> >to be said? SLUB only uses PageSlab for kmalloc <=4kb.
> 
> (I missed your patch, btw.)
> 
> For SLOB, we will never use ksize() as it doesn't set PageSlab. Is that 
> not a problem?
> 
That means that kobjsize() will hand back PAGE_SIZE for non-compound
pages, which is what it's presently doing anyways. In the case of SLOB
bigblock pages allocated on pass-through to the page allocator, these are
compound pages anyways, so compound_page() should do the right thing
there? That only handles the kmalloc() path though, and not the
kmem_cache_alloc() cases.

Shouldn't SLOB's PageSlab usage should mimic that of SLUB in this case
instead? PG_slab doesn't buy us much if we can already sort out the size
through compound_order(), it's the kmem_cache_alloc() and <= PAGE_SIZE
kmalloc()'s where __GFP_COMP isn't true and where PG_slab should be set.
