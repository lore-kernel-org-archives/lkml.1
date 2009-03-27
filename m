Return-Path: <linux-kernel-owner+w=401wt.eu-S934250AbZC0BGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934250AbZC0BGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 21:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934035AbZC0BFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 21:05:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58099 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934131AbZC0BFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 21:05:45 -0400
Date: Thu, 26 Mar 2009 18:03:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-Id: <20090326180314.ccce1be2.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0903261742210.3994@localhost.localdomain>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
	<49C87B87.4020108@krogh.cc>
	<72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>
	<49C88C80.5010803@krogh.cc>
	<72dbd3150903241200v38720ca0x392c381f295bdea@mail.gmail.com>
	<20090325183011.GN32307@mit.edu>
	<alpine.LFD.2.00.0903251139260.3032@localhost.localdomain>
	<20090325220530.GR32307@mit.edu>
	<alpine.LFD.2.00.0903251622420.3032@localhost.localdomain>
	<20090326171148.9bf8f1ec.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0903261723250.3994@localhost.localdomain>
	<alpine.LFD.2.00.0903261742210.3994@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009 17:51:44 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Thu, 26 Mar 2009, Linus Torvalds wrote:
> > 
> > The only times tunables have worked for us is when they auto-tune. 
> > 
> > IOW, we don't have "use 35% of memory for buffer cache" tunables, we just 
> > dynamically auto-tune memory use. And no, we don't expect user space to 
> > run some "tuning program for their load" either.
> 
> IOW, what we could reasonably do is something along the lines of:
> 
>  - start off with some reasonable value for max background dirty (per 
>    block device) that defaults to something sane (quite possibly based on 
>    simply memory size).
> 
>  - assume that "foreground dirty" is just always 2* background dirty.
> 
>  - if we hit the "max foreground dirty" during memory allocation, then we 
>    shrink the background dirty value (logic: we never want to have to wait 
>    synchronously)
> 
>  - if we hit some maximum latency on writeback, shrink dirty aggressively 
>    and based on how long the latency was (because at that point we have a 
>    real _measure_ of how costly it is with that load).
> 
>  - if we start doing background dirtying, but never hit the foreground 
>    dirty even in dirty balancing (ie when a writer is actually _writing_, 
>    as opposed to hitting it when allocating memory by a non-writer), then 
>    slowly open up the window - we may be limiting too early.
> 
> .. add heuristics to taste. The point being, that if we do this based on 
> real loads, and based on hitting the real problems, then we might actually 
> be getting somewhere. In particular, if the filesystem sucks at writeout 
> (ie the limiter is not the _disk_, but the filesystem serialization), then 
> it should automatically also shrink the max dirty state. 
> 
> The tunable then could become the maximum latency we accept or something 
> like that. Or the hysteresis limits/rules for the soft "grow" or "shrink" 
> events. At that point, maybe we could even find something that works for 
> most people.
> 

hm.

It may not be too hard to account for seekiness.  Simplest case: if we
dirty a page and that page is file-contiguous to another already dirty
page then don't increment the dirty page count by "1": increment it by
0.01.

Another simple case would be to keep track of the _number_ of dirty
inodes rather than simply lumping all dirty pages together.

And then there's metadata.  The dirty balancing code doesn't account
for dirty inodes _at all_ at present.

(Many years ago there was a bug wherein we could have zillions of dirty
inodes and exactly zero dirty pages, and the writeback code wouldn't
trigger at all - the inodes would just sit there until a page got
dirtied - this might still be there).


Then again, perhaps we don't need all those discrete heuristic things. 
Maybe it can all be done in mark_buffer_dirty().  Do some clever
math+data-structure to track the seekiness of our dirtiness.  Delayed
allocation would mess that up though.

