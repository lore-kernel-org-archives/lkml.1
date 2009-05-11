Return-Path: <linux-kernel-owner+w=401wt.eu-S1757081AbZEKItW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081AbZEKItW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 04:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755908AbZEKItN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 04:49:13 -0400
Received: from smtp-out.google.com ([216.239.45.13]:38806 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbZEKItM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 04:49:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=VeH/iI2GP27By7fcFqXJhVWtjW1ty+ktAF6x8p/CphX+cIYGFDEdBs4WEYIHtzo/7
	A+iHmDYtPPmYSuOB+IP7A==
Date: Mon, 11 May 2009 01:49:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Minchan Kim <minchan.kim@gmail.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, San Mehat <san@android.com>,
       Arve Hjonnevag <arve@android.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 08/11 -mmotm] oom: invoke oom killer for __GFP_NOFAIL
In-Reply-To: <20090511164008.894320db.minchan.kim@barrios-desktop>
Message-ID: <alpine.DEB.2.00.0905110146140.24726@chino.kir.corp.google.com>
References: <20090511085750.B9AC.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0905101719040.31823@chino.kir.corp.google.com> <20090511104310.B9C1.A69D9226@jp.fujitsu.com> <20090511164008.894320db.minchan.kim@barrios-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, Minchan Kim wrote:

> I agree KOSAKI's opinion. 
> We already have a different flags. 
> 
>  * __GFP_REPEAT: Try hard to allocate the memory, but the allocation attempt
>  * _might_ fail.  This depends upon the particular VM implementation.
>  *
>  * __GFP_NOFAIL: The VM implementation _must_ retry infinitely: the caller
>  * cannot handle allocation failures.
> 
> When we use __GFP_NOFAIL, we always have to use it carefully.
> If you change the meaning of __GFP_NOFAIL, the intension of them who have been used it carefully  may be lost. It's my concern.
> 

You pointed out yourself that __GFP_NOFAIL allocations can fail by way of 
having alloc_pages() return NULL even without attempting to free memory by 
the oom killer for order > PAGE_ALLOC_COSTLY_ORDER.  The definition you 
posted above is unambiguous to me, it means we must retry infinitely.  And 
that's very stupid if we are going to neglect to free memory by killing a 
task and relying solely on reclaim which may not make any progress.
