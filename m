Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbZEGUku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbZEGUku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763118AbZEGUkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:40:37 -0400
Received: from smtp-out.google.com ([216.239.45.13]:47160 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbZEGUke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:40:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=wBk0aiZTbAGPQ/MSQLOuz0St0ayg/38fAVqfFP8rGNz1sOvhhC8ZKINrroPFhUKiq
	DDx/oszzixP9KSXl9UcqA==
Date: Thu, 7 May 2009 13:40:29 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pavel Machek <pavel@ucw.cz>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, torvalds@linux-foundation.org,
       jens.axboe@oracle.com, alan-jenkins@tuffmail.co.uk,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
In-Reply-To: <20090507203518.GA1652@ucw.cz>
Message-ID: <alpine.DEB.2.00.0905071337400.6598@chino.kir.corp.google.com>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905072133.48917.rjw@sisk.pl> <20090507130202.34cbe37a.akpm@linux-foundation.org> <200905072218.50782.rjw@sisk.pl> <alpine.DEB.2.00.0905071321440.646@chino.kir.corp.google.com>
 <20090507203518.GA1652@ucw.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009, Pavel Machek wrote:

> > Third time I'm going to suggest this, and I'd like a response on why it's 
> > not possible instead of being ignored.
> > 
> > All of your tasks are in D state other than kthreads, right?  That means 
> > they won't be in the oom killer (thus no zones are oom locked), so you can 
> > easily do this
> 
> Well, OOM killer may be running on behalf of some kthread at that
> point....? Quite unlikely, but possible AFAICT.

The oom killer doesn't care about the task's state, so this will be a 
genuine oom situation where it will kill a task (one in D state since 
kthreads are inherently immune) which will die when unfrozen.  That would 
have had to happen anyway when all tasks wake up since the system is 
completely out of memory (except for kswapd that is given access to memory 
reserves because of PF_MEMALLOC) so you're not worried about completely 
blocking out the oom killer anymore because the next kthread to invoke it 
in such a situation will end up being a no-op because it finds a task with 
TIF_MEMDIE set.
