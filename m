Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbYA1Sfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbYA1Sfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 13:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYA1Sf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 13:35:27 -0500
Received: from ns1.suse.de ([195.135.220.2]:55272 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbYA1Sf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 13:35:26 -0500
Date: Mon, 28 Jan 2008 10:32:37 -0800
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Jacob Shin <jacob.shin@amd.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH 2/5] x86: fix runtime error in
	arch/x86/kernel/cpu/mcheck/mce_amd_64.c
Message-ID: <20080128183237.GA19829@suse.de>
References: <20080127233751.GA4524@kroah.com> <1201477122-4541-2-git-send-email-gregkh@suse.de> <20080128122434.GA24757@elte.hu> <20080128173706.GA17495@suse.de> <20080128175736.GC22487@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128175736.GC22487@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 06:57:36PM +0100, Ingo Molnar wrote:
> 
> * Greg KH <gregkh@suse.de> wrote:
> 
> > I have added a lot more "robustness" checks to the kobject core now, 
> > see the lkml messages about the maple bus for examples of where it is 
> > catching real problems already.  And the kobject debugging code is now 
> > "unified", printing out everything in a standard, easy to understand 
> > manner.
> > 
> > I really don't want to get into adding a "magic value" to a kobject 
> > field, and then checking it for every call, that too would have died 
> > on this kind of bug, just like the debug printk did :)
> > 
> > But if there's anything that you think I can add to make it easier to 
> > understand, please let me know.
> 
> anything that just causes the function to die on that bug reliably 
> during normal use, without having to enable DEBUG_KOBJECT which just 
> kills the system due to its verbosity. A magic value would be perfect. 

But for this case, how would we test that 0x18 is passed in for a
pointer to a kobject, without just blowing up instantly no matter what?

> Are kobjects protected against accidental copying? If not add &kobj to 
> the 'magic value' too, and check that - it becomes copying-resistent 
> that way and has the same cost to check. (which is negligible anyway)

Oh, that's a very cool idea, I like it :)

So I guess the complaint is that CONFIG_KOBJECT is too verbose?  I can
understand that, I'll look to clean things up as we have a lot of
"tracing" type functions in the debug output.  Hm, I wonder if the new
marker code could help with that...

> > The root problem of this bug was us using a goto to call forward into 
> > a major code block within a function.  Not just using a goto for error 
> > cleanup, like the kernel code "normally" does.  Because of that, I 
> > totally missed this code path when reading the function many times. 
> > It's nasty code complexity for no reason at all that causes more 
> > problems than is needed, combined with a total lack of documentation 
> > for how this kobject userspace interface is supposed to be used, that 
> > needs to be fixed.
> 
> no argument about that at all! This is exactly the same problem that the 
> spinlock/mutex/rwlock/etc. APIs were facing: it's used everywhere, and 
> that means dubious places as well that are not that well-known and are 
> rarely used. The more widely used a piece of kernel infrastructure is, 
> the more 'hardened' it must be against intentional or accidental abuse. 
> (at least with certain magic debug options enabled)
> 
> So please regard this a good thing - obscure APIs need no debugging 
> infrastructure - widely used ones do need quite extensive debugging 
> infrastructure.

I totally agree.

> For example locks currently have 4000 lines of code of debugging 
> infrastructure and 1500 lines of code of self-tests. The total amount of 
> core locking code is less 1000 lines of code. So for every line of 
> locking code there's more than 5 lines of debugging infrastructure (!). 

Heh, good point, I'll look into fixing this up to be more useful to the
"normal" developer, and not just the two of us doing kobject core
development :)

thanks,

greg k-h
