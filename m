Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbZEKIqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbZEKIqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 04:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbZEKIqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 04:46:03 -0400
Received: from smtp-out.google.com ([216.239.45.13]:38590 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726AbZEKIqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 04:46:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=q8ZyltBJP0xvwszzWivo5fCne/zdrF5/fTYQT4RvTQpRvxmZhwHfTxUvxGVD8fiKm
	zL58123HrnVAGzDUExhbg==
Date: Mon, 11 May 2009 01:45:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, San Mehat <san@android.com>,
       Arve Hjonnevag <arve@android.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 08/11 -mmotm] oom: invoke oom killer for __GFP_NOFAIL
In-Reply-To: <20090511104310.B9C1.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0905110143190.24726@chino.kir.corp.google.com>
References: <20090511085750.B9AC.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0905101719040.31823@chino.kir.corp.google.com> <20090511104310.B9C1.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, KOSAKI Motohiro wrote:

> > What exactly are you objecting to?  You don't want the oom killer called 
> > for a __GFP_NOFAIL allocation above PAGE_ALLOC_COSTLY_ORDER that could not 
> > reclaim any memory and would prefer that it loop endlessly in the page 
> > allocator?  What's the purpose of that if the oom killer could free a very 
> > large memory hogging task?
> 
> My point is, if we change gfp-flags meaning, we should change
> unintentional affected caller.
> 
> Do you oppose this?
> 

include/linux/gfp.h states this:

 * __GFP_NOFAIL: The VM implementation _must_ retry infinitely: the caller
 * cannot handle allocation failures.

That is the only desciption given to users of __GFP_NOFAIL, so they should 
be able to trust it.  The fact is that in mmotm it's possible for such an 
allocation to fail without even attempting to free some memory via the oom 
killer (and I disagree that killing a large memory hogging task will not 
allow large allocations such as those greater than PAGE_ALLOC_COSTLY_ORDER 
to succeed, which is a question of fragmentation and not purely VM size).
