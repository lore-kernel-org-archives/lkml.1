Return-Path: <linux-kernel-owner+w=401wt.eu-S1752930AbZAZPIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbZAZPIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 10:08:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbZAZPH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 10:07:58 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:28730 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbZAZPH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 10:07:57 -0500
Subject: Re: [patch 36/51] revert "mm: vmalloc use mutex for purge"
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christophe Saout <christophe@saout.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20090127163443.1BEC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20090116081359.567a4dc9.akpm@linux-foundation.org>
	 <1232123976.4946.18.camel@leto.intern.saout.de>
	 <20090127163443.1BEC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Mon, 26 Jan 2009 10:07:50 -0500
Message-Id: <1232982471.7679.76.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-26 at 22:57 +0900, KOSAKI Motohiro wrote:
> (cc to Lee Schermerhorn)

Thank you, Kosaki-san.  I hadn't noticed this thread was related to the
unevictable lru.  I went back and re-read the thread.  The bit about Xen
tearing down current->mm early on process termination is cause for
concern.   more below...
> 
> sorry for late reply.
> I returned from lca yesterday.
> 
> > > > From: Dean Roe <roe@sgi.com>
> > > > Subject: Prevent NULL pointer deref in grab_swap_token
> > > > References: 159260
> > > > 
> > > > grab_swap_token() assumes that the current process has an mm struct,
> > > > which is not true for kernel threads invoking get_user_pages().  Since
> > > > this should be extremely rare, just return from grab_swap_token()
> > > > without doing anything.
> > > > 
> > > > Signed-off-by: Dean Roe <roe@sgi.com>
> > > > Acked-by: mason@suse.de
> > > > Acked-by: okir@suse.de
> > > > 
> > > > 
> > > >  mm/thrash.c |    3 +++
> > > >  1 file changed, 3 insertions(+)
> > > > 
> > > > --- a/mm/thrash.c
> > > > +++ b/mm/thrash.c
> > > > @@ -31,6 +31,9 @@ void grab_swap_token(void)
> > > >  	int current_interval;
> > > >  
> > > >  	global_faults++;
> > > > +	if (current->mm == NULL)
> > > > +		return;
> > > > +
> > > >  
> > > >  	current_interval = global_faults - current->mm->faultstamp;
> > > >  
> > > 
> > > Confused.  Why was there a random, seemingly-unrelated patch at the end
> > > of this email?
> > 
> > This is a patch I also saw while trying to understand the problem with
> > Xen and UNEVICTABLE_LRU.  This patch is actually in the SuSE kernel and
> > claims to have something to do with kernel threads.
> > 
> > However for Xen, the problem is not a kernel threads, it's a regular
> > process thread (reiserfsck in to be specific, which mlockall's itself
> > into memory) and using this patch makes the null pointer deref Oops go
> > away, but still leaves scary messages in the log (a bunch of WARN_ON's).
> 
> hm, I guess you test both UNEVICTABLE_LRU on/off and this problem 
> happend only if CONFIG_UNEVICTABLE_LRU=y, right?
> 
> if so, I really wonder this result.
> above mean the page have both following two condition.
> 
>  - vma of the page have VM_LOCKED flag.
>  - pte of the page is NOT present
> 
> I can't imazine how to reproduce it.
> Could you please tell me how to reproduce? (sorry, I don't know xen at all)

I'm in the same boat, vis a vis xen.  But, if xen has cleared the ptes
in the process of tearing down the mm before we try to munlock the vmas
in exit_mmap(), we'll see this situation.   The munlock code assumes
that VM_LOCKED vmas were fully populated when mlocked, so
get_user_pages() should always find and return resident pages.  If it
does find a non-present pte, get_user_pages() will try to fault it
in--answering Christophe's confusion about getting into swap code.  

Now, we could let get_user_pages() ignore non-present pte's when called
for munlock [we can detect this condition], but that would probably
strand pages on the unevictable lru.  We've been careful, so far, not to
let this happen. 

Hmmm, we may need to ignore non-present pte during munlock() to handle
the case where the task was OOM-killed during mlock()--or SIGKILLed, now
that get_user_pages() is "preemptible"--leaving a partially populated
vma.  But, we need to be sure that any resident pages mlocked by the vma
do get munlocked.  Need to think about this more.

In any case, if xen wants to tear down an mm with VM_LOCKED vmas
independent of exit_mmap() [and I don't understand why it needs to do
this], then it must also take the responsibility to munlock any pages
mapped into that vma, while the mm and ptes are still intact, and then
clear the VM_LOCKED so we don't try to munlock them later.  A call to
munlock_vma_pages_all() for each VM_LOCKED vma should handle this.   See
exit_mmap().

> 
> and, Can you post your bunch of WARN_ON list and .config?

Yeah, I'd like to see those.
> 
> 
> 
> > I fail to understand why __get_user_pages of mlock'ed pages wants to go
> > into swap code, but then I'm not an expert in Linux mm.  Maybe this
> > happens because current->mm is already down and some code gets confused.

Most likely...

> > While googling around I found a comment that during mm teardown, the
> > kernel shall better not try to access user pages, I can't remember what
> > exactly it was about.

Lee

