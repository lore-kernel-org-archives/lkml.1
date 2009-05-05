Return-Path: <linux-kernel-owner+w=401wt.eu-S1759241AbZEEXV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241AbZEEXV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 19:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbZEEXVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 19:21:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52482 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbZEEXVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 19:21:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Date: Wed, 6 May 2009 01:20:34 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: rientjes@google.com, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905060019.36542.rjw@sisk.pl> <20090505153739.2cc9d244.akpm@linux-foundation.org>
In-Reply-To: <20090505153739.2cc9d244.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905060120.35698.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 May 2009, Andrew Morton wrote:
> On Wed, 6 May 2009 00:19:35 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > > > +			&& !processes_are_frozen()) {
> > > >  		if (!try_set_zone_oom(zonelist, gfp_mask)) {
> > > >  			schedule_timeout_uninterruptible(1);
> > > >  			goto restart;
> > > 
> > > Cool, that looks like the semantics of __GFP_NO_OOM_KILL without requiring 
> > > a new gfp flag.  Thanks.
> > 
> > Well, you're welcome.
> > 
> > BTW, I think that Andrew was actually right when he asked if I checked whether
> > the existing __GFP_NORETRY would work as-is for __GFP_FS set and
> > __GFP_NORETRY unset.  Namely, in that case we never reach the code before
> > nopage: that checks __GFP_NORETRY, do we?
> > 
> > So I think we shouldn't modify the 'else if' condition above and check for
> > !processes_are_frozen() at the beginning of the block below.
> 
> Confused.
> 
> I'm suspecting that hibernation can allocate its pages with
> __GFP_FS|__GFP_WAIT|__GFP_NORETRY|__GFP_NOWARN, and the page allocator
> will dtrt: no oom-killings.
> 
> In which case, processes_are_frozen() is not needed at all?

__GFP_NORETRY alone causes it to fail relatively quickly, but I'll try with
the combination.

Anyway, even if the hibernation code itself doesn't trigger the OOM killer,
but anyone else allocates memory in parallel or after we've preallocated the
image memory, that may still trigger it.  So it seems processes_are_frozen()
may still be useful?
