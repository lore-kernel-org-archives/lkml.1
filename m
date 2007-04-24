Return-Path: <linux-kernel-owner+w=401wt.eu-S1423110AbXDXU6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423110AbXDXU6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423112AbXDXU6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:58:37 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49146 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423111AbXDXU6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:58:36 -0400
Date: Tue, 24 Apr 2007 13:58:35 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, pj@sgi.com
Subject: Re: Pagecache: find_or_create_page does not call a proper page
 allocator function
In-Reply-To: <20070424135348.4e69ac23.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704241354470.13382@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704231408530.691@schroedinger.engr.sgi.com>
 <20070423142919.5809e03f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704231503540.975@schroedinger.engr.sgi.com>
 <20070423154224.15ebf8f7.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241339460.26223@blonde.wat.veritas.com>
 <20070424101116.1cb7512e.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241954050.28487@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0704241254420.12907@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0704242109290.11314@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0704241326410.13005@schroedinger.engr.sgi.com>
 <20070424134206.95bd6c92.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241344100.13005@schroedinger.engr.sgi.com>
 <20070424135348.4e69ac23.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007, Andrew Morton wrote:

> > Then I think we should disable page migration for allocations that do not 
> > allow access to the policy zone. That would fix it.
> 
> Can't we use mapping_gfp_mask() when allocating the destination page?

There is no point in migrating something if you cannot reach the 
destination. If the policy zone is not allowed by an allocation then the 
page cannot be migrated because (on 32 bit NUMA) there is only a single 
ZONE_NORMAL on the system. A different node requires a HIGHMEM allocation!
 
> It would be better to do so, really.  Who knows, mapping_gfp_mask() might
> be extented in the future to say "I want GFP_NOIO" or something.  Or a
> filesystem might specify GFP_KERNEL for regular pagecache pages or
> whatever.

Hmmm..... How about a VM_DONTMIGRATE flag instead? That would be easy to 
check and could be set by a device that must have all pages of the address
space conforming to the gfp mask.

Or more general

VM_STRICT_ALLOC?

> Generally, the interface is "address_space tells core kernel how to
> allocate its pages", and to be nice we should honour that in all places
> where we allocate a page for an address_space.
> 
> If we'd had any brains we would have implemented this function as an
> address_space_operations callback, but we don't so we didn't.

We have enough flags I think.
