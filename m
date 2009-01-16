Return-Path: <linux-kernel-owner+w=401wt.eu-S1765976AbZAPJnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765976AbZAPJnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 04:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759628AbZAPJnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 04:43:17 -0500
Received: from mail.suse.de ([195.135.220.2]:57608 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757908AbZAPJnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 04:43:14 -0500
Date: Fri, 16 Jan 2009 10:43:12 +0100
From: Nick Piggin <npiggin@suse.de>
To: Christophe Saout <christophe@saout.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 36/51] revert "mm: vmalloc use mutex for purge"
Message-ID: <20090116094312.GD22810@wotan.suse.de>
References: <200901152151.n0FLpFvI009218@imap1.linux-foundation.org> <20090116025531.GI17810@wotan.suse.de> <1232098736.4808.17.camel@leto.intern.saout.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232098736.4808.17.camel@leto.intern.saout.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 10:38:56AM +0100, Christophe Saout wrote:
> Hi Nick,
> 
> > Weird. It seem to be something to do with Xen (and btrfs? or was it reproduced
> > without?).
> 
> I got this bug without btrfs.  Seen on both Xen x86_32 and x86_64.
> 
> Note that I also some a different issue with CONFIG_UNEVICTABLE_LRU.
> Seems like Xen tears down current->mm early on process termination, so
> that __get_user_pages in exit_mmap causes nasty messages when the
> process had any mlocked pages.  (in fact, it somehow manages to get into
> the swapping code and produces a null pointer dereference trying to get
> a swap token)

There is an oops there, yes. I remember I patch we have, although it was
specifically for kernel threads rather than this issue. Xen could easily
have bigger issues if it is exiting the mm before that final get_user_pages.

 

> > Anyway, I agree with the revert for the moment, but I'm worried that it might
> > be hiding another bug... I might add a few might_sleep and in_atomic warnings
> > around the place to see if it might find the culprit without crashing machines.
> 
> If you need some testing, please tell me.  On a dual-core machine this
> bug happens within few minutes of a compiler run.

Ok, thanks... I'll see if I can get to it next week.

---

From: Dean Roe <roe@sgi.com>
Subject: Prevent NULL pointer deref in grab_swap_token
References: 159260

grab_swap_token() assumes that the current process has an mm struct,
which is not true for kernel threads invoking get_user_pages().  Since
this should be extremely rare, just return from grab_swap_token()
without doing anything.

Signed-off-by: Dean Roe <roe@sgi.com>
Acked-by: mason@suse.de
Acked-by: okir@suse.de


 mm/thrash.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/thrash.c
+++ b/mm/thrash.c
@@ -31,6 +31,9 @@ void grab_swap_token(void)
 	int current_interval;
 
 	global_faults++;
+	if (current->mm == NULL)
+		return;
+
 
 	current_interval = global_faults - current->mm->faultstamp;
 
