Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbZFRRHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbZFRRHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 13:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbZFRRH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 13:07:27 -0400
Received: from smtp-out.google.com ([216.239.33.17]:23636 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbZFRRH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 13:07:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=F2+eflieJ45FLLNFOQG/UnK/EClEQMUgoXn0swqdBg9lQ3P5yrE2di0HB+VivpCb+
	slc8nFUA5IGQufHYo4zXA==
Date: Thu, 18 Jun 2009 10:07:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michael Tokarev <mjt@tls.msk.ru>
cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29.1: nfsd: page allocation failure - nfsd or kernel
 problem?
In-Reply-To: <4A3A00D9.8090504@msgid.tls.msk.ru>
Message-ID: <alpine.DEB.2.00.0906180956560.2894@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0906161203160.27742@p34.internal.lan> <alpine.DEB.2.00.0906161205260.27742@p34.internal.lan> <4A37FE48.6070306@msgid.tls.msk.ru> <4A38ACC0.3060501@msgid.tls.msk.ru> <alpine.DEB.2.00.0906170542170.3600@p34.internal.lan>
 <4A38C7CA.7040005@msgid.tls.msk.ru> <20090617185139.GF24040@fieldses.org> <4A395119.5060108@msgid.tls.msk.ru> <alpine.DEB.2.00.0906171335590.4786@chino.kir.corp.google.com> <4A3A00D9.8090504@msgid.tls.msk.ru>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009, Michael Tokarev wrote:

> David Rientjes wrote:
> > On Thu, 18 Jun 2009, Michael Tokarev wrote:
> > 
> > > > 	http://bugzilla.kernel.org/show_bug.cgi?id=13518
> > > Does not look similar.
> > > 
> > > I repeated the issue here.  The slab which is growing here is buffer_head.
> > > It's growing slowly -- right now, after ~5 minutes of constant writes over
> > > nfs, its size is 428423 objects, growing at about 5000 objects/minute
> > > rate.
> > > When stopping writing, the cache shrinks slowly back to an acceptable
> > > size, probably when the data gets actually written to disk.
> > 
> > Not sure if you're referring to the bugzilla entry or Justin's reported
> > issue.  Justin's issue is actually allocating a skbuff_head_cache slab while
> > the system is oom.
> 
> We have the same issue - I replied to Justin's initial email with exactly
> the same trace as him.  I didn't see your reply up until today, -- the one
> you're referring to below.
> 

If it's the exact same trace, then the page allocation failure is 
occurring as the result of slab's growth of the skbuff_head_cache cache, 
not buffer_head.

So it appears as though the issue you're raising is that buffer_head is 
consuming far too much memory, which causes the system to be oom when 
attempting a GFP_ATOMIC allocation for skbuff_head_cache and is otherwise 
unseen with alloc_buffer_head() because it is allowed to invoke direct 
reclaim:

	$ grep -r alloc_buffer_head\( fs/*
	fs/buffer.c:		bh = alloc_buffer_head(GFP_NOFS);
	fs/buffer.c:struct buffer_head *alloc_buffer_head(gfp_t gfp_flags)
	fs/gfs2/log.c:	bh = alloc_buffer_head(GFP_NOFS | __GFP_NOFAIL);
	fs/jbd/journal.c:	new_bh = alloc_buffer_head(GFP_NOFS|__GFP_NOFAIL);
	fs/jbd2/journal.c:	new_bh = alloc_buffer_head(GFP_NOFS|__GFP_NOFAIL);

> As far as I can see, the warning itself, while harmless, indicates some
> deeper problem.  Namely, we shouldn't have an OOM condition - the system
> is doing nothing but NFS, there's only one NFS client which writes single
> large file, the system has 2GB (or 4Gb on another machine) RAM.  It should
> not OOM to start with.
> 

Thanks to the page allocation failure that Justin posted earlier, which 
shows the state of the available system memory, it shows that the machine 
truly is oom.  You seem to have isolated that to an enormous amount of 
buffer_head slab, which is a good start.

> Well, there ARE side-effects actually.  When the issue happens, the I/O
> over NFS slows down to almost zero bytes/sec for some while, and resumes
> slowly after about half a minute - sometimes faster, sometimes slower.
> Again, the warning itself is harmless, but it shows a deeper issue.  I
> don't think it's wise to ignore the sympthom -- the actual cause should
> be fixed instead.  I think.
> 

Since the GFP_ATOMIC allocation cannot trigger reclaim itself, it must 
rely on other allocations or background writeout to free the memory and 
this will be considerably slower than a blocking allocation.  The page 
allocation failure messages from Justin's post indicate there are 0 pages 
under writeback at the time of oom yet ZONE_NORMAL has reclaimable memory; 
this is the result of the nonblocking allocation.
