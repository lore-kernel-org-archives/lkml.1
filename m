Return-Path: <linux-kernel-owner+w=401wt.eu-S1763324AbZEGWIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763324AbZEGWIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 18:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932128AbZEGWGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 18:06:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39050 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502AbZEGWGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 18:06:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Date: Fri, 8 May 2009 00:05:43 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905072336.11383.rjw@sisk.pl> <alpine.DEB.2.00.0905071439370.24404@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0905071439370.24404@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905080005.44589.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 May 2009, David Rientjes wrote:
> On Thu, 7 May 2009, Rafael J. Wysocki wrote:
> 
> > > The fact is that _all_ allocations here are implicitly __GFP_NO_OOM_KILL 
> > > whether it specifies it or not since the oom killer would simply kill a 
> > > task in D state which can't exit or free memory and subsequent allocations 
> > > would make the oom killer a no-op because there's an eligible task with 
> > > TIF_MEMDIE set.  The only thing you're saving with __GFP_NO_OOM_KILL is 
> > > calling the oom killer in a first place and killing an unresponsive task 
> > 
> > That's exactly what we're trying to do.  We don't want tasks to get killed just
> > because we're freeing memory for hibernation image.
> > 
> 
> Then, again, why can't you just lock out the oom killer as I suggested if 
> __GFP_NO_OOM_KILL is actually implied for all allocations when 
> preallocating?  It prevents adding an unnecessary gfp flag, sprinkling it 
> around in the hibernation code,

In one place really.

> and a comment would actually explain why it's the right thing to do (i.e. no
> other threads other than kthreads could possibly be executing the oom killer
> and if they are oom then we'll have to kill a userspace task anyway when
> thawed).

Quite frankly, I prefer my freezer-based patch to this.  I'm not really
inclined to fiddle with the mm internals from within snapshot.c .

Still, I trust the Andrew's experience and that's why I'm going to try the
__GFP_NO_OOM_KILL first, as I already said.  If there is a problem with it,
I'm going to use the freezer-based approach.
 
> > > but that would have to happen anyway when thawed since the system is oom 
> > > (or otherwise lockup for GFP_KERNEL with order < PAGE_ALLOC_COSTLY_ORDER).
> > 
> > Are you sure?  The image memory is freed before thawing tasks.
> > 
> 
> If you try to allocate any non-__GFP_NORETRY memory such as GFP_KERNEL 
> with order < PAGE_ALLOC_COSTLY_ORDER and direct reclaim cannot free memory 
> (and the oom killer is implicitly a no-op whether you specify 
> __GFP_NO_OOM_KILL or not), then you could loop endlessly in the page 
> allocator.  When allocating GFP_IMAGE you need to ensure that can't happen 
> and __GFP_NORETRY may not be your best option because it could fail 
> unnecessarily when reclaim could have helped.

I'm really unsure what you mean and how that is related to your previous remark
about what's going to happen after the thawing of tasks.

Thanks,
Rafael
