Return-Path: <linux-kernel-owner+w=401wt.eu-S1763217AbZAPQjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763217AbZAPQjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 11:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbZAPQjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 11:39:37 -0500
Received: from websrv.werbeagentur-aufwind.de ([88.198.253.206]:58394 "EHLO
	websrv.werbeagentur-aufwind.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753277AbZAPQjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 11:39:36 -0500
Subject: Re: [patch 36/51] revert "mm: vmalloc use mutex for purge"
From: Christophe Saout <christophe@saout.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20090116081359.567a4dc9.akpm@linux-foundation.org>
References: <200901152151.n0FLpFvI009218@imap1.linux-foundation.org>
	 <20090116025531.GI17810@wotan.suse.de>
	 <1232098736.4808.17.camel@leto.intern.saout.de>
	 <20090116094312.GD22810@wotan.suse.de>
	 <20090116081359.567a4dc9.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 16 Jan 2009 17:39:36 +0100
Message-Id: <1232123976.4946.18.camel@leto.intern.saout.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

(comment below)

> > On Fri, Jan 16, 2009 at 10:38:56AM +0100, Christophe Saout wrote:
> > > Hi Nick,
> > > 
> > > > Weird. It seem to be something to do with Xen (and btrfs? or was it reproduced
> > > > without?).
> > > 
> > > I got this bug without btrfs.  Seen on both Xen x86_32 and x86_64.
> > > 
> > > Note that I also some a different issue with CONFIG_UNEVICTABLE_LRU.
> > > Seems like Xen tears down current->mm early on process termination, so
> > > that __get_user_pages in exit_mmap causes nasty messages when the
> > > process had any mlocked pages.  (in fact, it somehow manages to get into
> > > the swapping code and produces a null pointer dereference trying to get
> > > a swap token)
> > 
> > There is an oops there, yes. I remember I patch we have, although it was
> > specifically for kernel threads rather than this issue. Xen could easily
> > have bigger issues if it is exiting the mm before that final get_user_pages.
> > 
> >  
> > 
> > > > Anyway, I agree with the revert for the moment, but I'm worried that it might
> > > > be hiding another bug... I might add a few might_sleep and in_atomic warnings
> > > > around the place to see if it might find the culprit without crashing machines.
> > > 
> > > If you need some testing, please tell me.  On a dual-core machine this
> > > bug happens within few minutes of a compiler run.
> > 
> > Ok, thanks... I'll see if I can get to it next week.
> > 
> > ---
> > 
> > From: Dean Roe <roe@sgi.com>
> > Subject: Prevent NULL pointer deref in grab_swap_token
> > References: 159260
> > 
> > grab_swap_token() assumes that the current process has an mm struct,
> > which is not true for kernel threads invoking get_user_pages().  Since
> > this should be extremely rare, just return from grab_swap_token()
> > without doing anything.
> > 
> > Signed-off-by: Dean Roe <roe@sgi.com>
> > Acked-by: mason@suse.de
> > Acked-by: okir@suse.de
> > 
> > 
> >  mm/thrash.c |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > --- a/mm/thrash.c
> > +++ b/mm/thrash.c
> > @@ -31,6 +31,9 @@ void grab_swap_token(void)
> >  	int current_interval;
> >  
> >  	global_faults++;
> > +	if (current->mm == NULL)
> > +		return;
> > +
> >  
> >  	current_interval = global_faults - current->mm->faultstamp;
> >  
> 
> Confused.  Why was there a random, seemingly-unrelated patch at the end
> of this email?

This is a patch I also saw while trying to understand the problem with
Xen and UNEVICTABLE_LRU.  This patch is actually in the SuSE kernel and
claims to have something to do with kernel threads.

However for Xen, the problem is not a kernel threads, it's a regular
process thread (reiserfsck in to be specific, which mlockall's itself
into memory) and using this patch makes the null pointer deref Oops go
away, but still leaves scary messages in the log (a bunch of WARN_ON's).

I fail to understand why __get_user_pages of mlock'ed pages wants to go
into swap code, but then I'm not an expert in Linux mm.  Maybe this
happens because current->mm is already down and some code gets confused.
While googling around I found a comment that during mm teardown, the
kernel shall better not try to access user pages, I can't remember what
exactly it was about.

Cheers,
	Christophe


