Return-Path: <linux-kernel-owner+w=401wt.eu-S1755771AbYINWCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbYINWCT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 18:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbYINWCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 18:02:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33781 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429AbYINWCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 18:02:10 -0400
Date: Mon, 15 Sep 2008 00:02:08 +0200
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sysfs: fix deadlock
Message-ID: <20080914220208.GF27080@wotan.suse.de>
References: <20080910113717.GB16811@wotan.suse.de> <1221046892.30429.85.camel@twins.programming.kicks-ass.net> <20080910114755.GA9696@elte.hu> <20080910121217.GA16013@elte.hu> <20080910144812.GB18644@wotan.suse.de> <1221058864.30429.291.camel@twins.programming.kicks-ass.net> <20080910152651.GE18644@wotan.suse.de> <20080911082709.GA14378@elte.hu> <20080911104323.GB23775@wotan.suse.de> <20080912092411.GB10305@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080912092411.GB10305@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 11:24:11AM +0200, Ingo Molnar wrote:
> 
> [ Greg, please see the sysfs fix further below. ]
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > >  - moved the might_sleep() check outside the in_atomic() check,
> > 
> > Hmm... but then it has the same failure case again in the is_preempt() 
> > code, does it not?
> > 
> > I guess we should just convert that guy to either use get_user_atomic, 
> > (which would mean implementing that for x86), or use 
> > copy_from_user_inatomic.
> 
> i've done the v3 patch below - that seems to have passed all my testing 
> without any new bugs found. I've reinstated your the clear_user() 
> might_fault() check, plus i removed it from __[get|put]_user_size, which 
> the _inatomic() API variants use. That enabled me to utilize the 
> _inatomic() API in probe_kernel_address().
> 
> we still have the checks in put_user()/get_user() and in all the 
> copy_*_user() APIs, which should be strong enough. [ I havent fully 
> checked whether __get_user_size() might be used by some less frequent 
> API - if it is then that API should grow a might_fault() check. ]
> 
> > > i've attached the config.
> > > 
> > > at first sight it looks like a genuine bug in fs/sysfs/bin.c?
> > 
> > Yes, it is a real bug by the looks. bin.c takes bb->mutex under 
> > mmap_sem when it is mmapped, and then does its copy_*_user under 
> > bb->mutex too.
> 
> ok - second patch attached below, Greg, could you please apply? This is 
> for v2.6.27 too i think.
> 
> > > i.e. your patches are working as expected and the extended 
> > > validation mechanism is finding real bugs :-)
> > 
> > Yeah it's nice. I'm just hoping we don't come across one that is as 
> > difficult to fix as prepare_write/commit_write were ;)
> > 
> > Here is a basic fix for the sysfs lor.
> 
> and that did the trick here - the patch with a tidied up changelog is 
> attached further below. [ the second patch is standalone and does not 
> need the first patch which is relative to tip/master ]
> 
> thanks Nick, i think this is a great addition to lockdep! It already 
> found two real locking bugs within a day. If you can think of any other 
> proactive methods to widen our lock hierarchy knowledge that would be 
> great to add. I think what we want is to insert knowledge about other 
> unlikely lock acquire events, for locks that have a historic pattern of 
> producing regular locking bugs.

Well thanks to Peter as well. Actually I don't suppose this will throw
off the lockstat statistics a bit? (although I guess serious lockstat
profiling might not have prove locking turned on?).

The user fault I guess is the main thing like this in the VM that I can
think of.

The user fault I guess is the main thing like this in the VM that I can
think of.
