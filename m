Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbYA1GLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbYA1GLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 01:11:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbYA1GLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 01:11:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60985 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbYA1GLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 01:11:34 -0500
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Only print kernel debug information for OOMs caused by kernel allocations
Date: Mon, 28 Jan 2008 07:10:07 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20080116222421.GA7953@wotan.suse.de> <20080127215249.94db142b.akpm@linux-foundation.org>
In-Reply-To: <20080127215249.94db142b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801280710.08204.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008 06:52, Andrew Morton wrote:
> On Wed, 16 Jan 2008 23:24:21 +0100 Andi Kleen <ak@suse.de> wrote:
> > I recently suffered an 20+ minutes oom thrash disk to death and computer
> > completely unresponsive situation on my desktop when some user program
> > decided to grab all memory. It eventually recovered, but left lots
> > of ugly and imho misleading messages in the kernel log. here's a minor
> > improvement

As a followup this was with swap over dm crypt. I've recently heard
about other people having trouble with this too so this setup seems to trigger
something bad in the VM.

> That information is useful for working out why a userspace allocation
> attempt failed.  If we don't print it, and the application gets killed and
> thus frees a lot of memory, we will just never know why the allocation
> failed.

But it's basically only either page fault (direct or indirect) or write et.al.
who do these page cache allocations. Do you really think it is that important
to distingush these cases individually? In 95+% of all cases it should
be a standard user page fault which always has the same backtrace.

To figure out why the application really oom'ed for those you would
need a user level backtrace, but the message doesn't supply that one anyways. 

All other cases will still print the full backtrace so if some kernel 
subsystem runs amok it should be still possible to diagnose it.

Please reconsider.

>
> >  struct page *__page_cache_alloc(gfp_t gfp)
> >  {
> > +	struct task_struct *me = current;
> > +	unsigned old = (~me->flags) & PF_USER_ALLOC;
> > +	struct page *p;
> > +
> > +	me->flags |= PF_USER_ALLOC;
> >  	if (cpuset_do_page_mem_spread()) {
> >  		int n = cpuset_mem_spread_node();
> > -		return alloc_pages_node(n, gfp, 0);
> > -	}
> > -	return alloc_pages(gfp, 0);
> > +		p = alloc_pages_node(n, gfp, 0);
> > +	} else
> > +		p = alloc_pages(gfp, 0);
> > +	/* Clear USER_ALLOC if it wasn't set originally */
> > +	me->flags ^= old;
> > +	return p;
> >  }
>
> That's appreciable amount of new overhead for at best a fairly marginal
> benefit.  Perhaps __GFP_USER could be [re|ab]used.

It's a few non atomic bit operations. You really think that is considerable
overhead? Also all should be cache hot already. My guess is that even with the 
additional function call it's < 10 cycles more.

> Alternatively: if we've printed the diagnostic on behalf of this process
> and then decided to kill it, set some flag to prevent us from printing it
> again.

Do you really think that would help?  I thought these messages came usually
from different processes.

-Andi
