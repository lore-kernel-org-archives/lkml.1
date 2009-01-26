Return-Path: <linux-kernel-owner+w=401wt.eu-S1752438AbZAZN5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbZAZN5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 08:57:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbZAZN50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 08:57:26 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58375 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbZAZN50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 08:57:26 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christophe Saout <christophe@saout.de>
Subject: Re: [patch 36/51] revert "mm: vmalloc use mutex for purge"
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
In-Reply-To: <1232123976.4946.18.camel@leto.intern.saout.de>
References: <20090116081359.567a4dc9.akpm@linux-foundation.org> <1232123976.4946.18.camel@leto.intern.saout.de>
Message-Id: <20090127163443.1BEC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Mon, 26 Jan 2009 22:57:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc to Lee Schermerhorn)

sorry for late reply.
I returned from lca yesterday.

> > > From: Dean Roe <roe@sgi.com>
> > > Subject: Prevent NULL pointer deref in grab_swap_token
> > > References: 159260
> > > 
> > > grab_swap_token() assumes that the current process has an mm struct,
> > > which is not true for kernel threads invoking get_user_pages().  Since
> > > this should be extremely rare, just return from grab_swap_token()
> > > without doing anything.
> > > 
> > > Signed-off-by: Dean Roe <roe@sgi.com>
> > > Acked-by: mason@suse.de
> > > Acked-by: okir@suse.de
> > > 
> > > 
> > >  mm/thrash.c |    3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > --- a/mm/thrash.c
> > > +++ b/mm/thrash.c
> > > @@ -31,6 +31,9 @@ void grab_swap_token(void)
> > >  	int current_interval;
> > >  
> > >  	global_faults++;
> > > +	if (current->mm == NULL)
> > > +		return;
> > > +
> > >  
> > >  	current_interval = global_faults - current->mm->faultstamp;
> > >  
> > 
> > Confused.  Why was there a random, seemingly-unrelated patch at the end
> > of this email?
> 
> This is a patch I also saw while trying to understand the problem with
> Xen and UNEVICTABLE_LRU.  This patch is actually in the SuSE kernel and
> claims to have something to do with kernel threads.
> 
> However for Xen, the problem is not a kernel threads, it's a regular
> process thread (reiserfsck in to be specific, which mlockall's itself
> into memory) and using this patch makes the null pointer deref Oops go
> away, but still leaves scary messages in the log (a bunch of WARN_ON's).

hm, I guess you test both UNEVICTABLE_LRU on/off and this problem 
happend only if CONFIG_UNEVICTABLE_LRU=y, right?

if so, I really wonder this result.
above mean the page have both following two condition.

 - vma of the page have VM_LOCKED flag.
 - pte of the page is NOT present

I can't imazine how to reproduce it.
Could you please tell me how to reproduce? (sorry, I don't know xen at all)

and, Can you post your bunch of WARN_ON list and .config?



> I fail to understand why __get_user_pages of mlock'ed pages wants to go
> into swap code, but then I'm not an expert in Linux mm.  Maybe this
> happens because current->mm is already down and some code gets confused.
> While googling around I found a comment that during mm teardown, the
> kernel shall better not try to access user pages, I can't remember what
> exactly it was about.





