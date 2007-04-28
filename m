Return-Path: <linux-kernel-owner+w=401wt.eu-S1161187AbXD1FuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161187AbXD1FuJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 01:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161161AbXD1FuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 01:50:08 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161115AbXD1Ftn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 01:49:43 -0400
Date: Fri, 27 Apr 2007 22:48:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Matt Mackall <mpm@selenic.com>, Alexey Dobriyan <adobriyan@sw.ru>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: - maps2-add-proc-pid-pagemap-interface-fix.patch removed from
 -mm tree
Message-Id: <20070427224844.8d6d5503.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704280607330.9554@blonde.wat.veritas.com>
References: <200704270814.l3R8EnFJ023047@shell0.pdx.osdl.net>
	<20070427104533.GA6001@localhost.sw.ru>
	<20070427132713.fc9d82c0.akpm@linux-foundation.org>
	<20070427204155.GT11115@waste.org>
	<20070427143131.60d0afc1.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704280607330.9554@blonde.wat.veritas.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007 06:13:39 +0100 (BST) Hugh Dickins <hugh@veritas.com> wrote:

> On Fri, 27 Apr 2007, Andrew Morton wrote:
> > 
> > hm, could do.  might_sleep() is intertwined with preempt in complex ways,
> > but we did decouple that at the config level.  no_mmap_sem() will dtrt for
> > all preempt settings.
> > 
> > But I'll be keeping this as a -mm-only debug patch (which brings us up to
> > about thirty of 'em), so I think it's best to make it unconfigurable so we
> > get maximum coverage.
> > 
> > That's if it actually works.  I haven't tried running it yet, and I have a
> > feeling that running it might cause a big "doh" moment.  We'll see.
> 
> Yes, I'm expecting the crucial
> 
> > +	WARN_ON(rwsem_is_locked(&mm->mmap_sem))
> 
> to give a bogus warning every time another thread (or /proc,
> or swapoff, or whatever) happens to have this mmap_sem locked.
> might_sleep() is quite different, works on our thread's info.
> 

Yes.  lockdep has a way of working out if this task already has a
particular lock for reading or writing, but it isn't immediately obvious
how to extract that.

I guess a simple hack would be do do a down_read() on it.  If it's already
held for reading, lockdep should warn.  If it's already held for writing
someone will notice.

Oh well, it's not my top priority.
