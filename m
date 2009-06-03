Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbZFCWKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbZFCWKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 18:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbZFCWKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 18:10:45 -0400
Received: from smtp-out.google.com ([216.239.33.17]:35673 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912AbZFCWKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 18:10:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=c6itvE9AqoDStxCbRwHizRQ3d0zLwD91m1QPTSNyTSmHRxQGFLLetJlKJBlq0GDV/
	JMcfb/njW1m3fmzf+gWdg==
Date: Wed, 3 Jun 2009 15:10:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nick Piggin <npiggin@suse.de>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3 -mmotm] oom: invoke oom killer for __GFP_NOFAIL
In-Reply-To: <alpine.DEB.2.00.0906020104480.27792@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0906031507400.16042@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0906011828040.6936@chino.kir.corp.google.com> <alpine.DEB.2.00.0906011830490.6936@chino.kir.corp.google.com> <20090601225602.3482cd0d.akpm@linux-foundation.org> <alpine.DEB.2.00.0906020016060.24915@chino.kir.corp.google.com>
 <1243928095.23657.5633.camel@twins> <20090602075836.GB16201@wotan.suse.de> <alpine.DEB.2.00.0906020104480.27792@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jun 2009, David Rientjes wrote:

> With my patch, we kill a memory hogging task that will free some memory so 
> the allocation will succeed (or multiple tasks if insufficient contiguous 
> memory is available).  Kernel allocations use __GFP_NOFAIL, so the fault 
> of this memory freeing is entirely on the caller, not the page allocator.
> 
> My preference for handling this is to merge my patch (obviously :), and 
> then hopefully deprecate __GFP_NOFAIL as much as possible although I don't 
> suspect it could be eradicated forever.
> 

I really hope this patch isn't getting dropped because it fixes the 
possibility that a __GFP_NOFAIL allocation will fail when its definition 
is to the contrary.  Depending on the size of the allocation, that can 
cause a panic in at least the reiserfs, ntfs, cxgb3, and gfs2 cases.

As I mentioned before, it's a noble goal to deprecate __GFP_NOFAIL as much 
as possible and (at the least) prevent it from trying high-order 
allocation attempts.  The current implementation of the flag is 
problematic, however, and this patch addresses it by attempting to free 
some memory when direct reclaim fails.

This change has already been acked by Rik van Riel in 
http://marc.info/?l=linux-kernel&m=124199910508930 and Mel Gorman in 
http://marc.info/?l=linux-kernel&m=124203850416159.
