Return-Path: <linux-kernel-owner+w=401wt.eu-S1754135AbYA1R6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbYA1R6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 12:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYA1R6C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 12:58:02 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33068 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414AbYA1R6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 12:58:00 -0500
Date: Mon, 28 Jan 2008 18:57:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Jacob Shin <jacob.shin@amd.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH 2/5] x86: fix runtime error in
	arch/x86/kernel/cpu/mcheck/mce_amd_64.c
Message-ID: <20080128175736.GC22487@elte.hu>
References: <20080127233751.GA4524@kroah.com> <1201477122-4541-2-git-send-email-gregkh@suse.de> <20080128122434.GA24757@elte.hu> <20080128173706.GA17495@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128173706.GA17495@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg KH <gregkh@suse.de> wrote:

> I have added a lot more "robustness" checks to the kobject core now, 
> see the lkml messages about the maple bus for examples of where it is 
> catching real problems already.  And the kobject debugging code is now 
> "unified", printing out everything in a standard, easy to understand 
> manner.
> 
> I really don't want to get into adding a "magic value" to a kobject 
> field, and then checking it for every call, that too would have died 
> on this kind of bug, just like the debug printk did :)
> 
> But if there's anything that you think I can add to make it easier to 
> understand, please let me know.

anything that just causes the function to die on that bug reliably 
during normal use, without having to enable DEBUG_KOBJECT which just 
kills the system due to its verbosity. A magic value would be perfect. 
Are kobjects protected against accidental copying? If not add &kobj to 
the 'magic value' too, and check that - it becomes copying-resistent 
that way and has the same cost to check. (which is negligible anyway)

> The root problem of this bug was us using a goto to call forward into 
> a major code block within a function.  Not just using a goto for error 
> cleanup, like the kernel code "normally" does.  Because of that, I 
> totally missed this code path when reading the function many times. 
> It's nasty code complexity for no reason at all that causes more 
> problems than is needed, combined with a total lack of documentation 
> for how this kobject userspace interface is supposed to be used, that 
> needs to be fixed.

no argument about that at all! This is exactly the same problem that the 
spinlock/mutex/rwlock/etc. APIs were facing: it's used everywhere, and 
that means dubious places as well that are not that well-known and are 
rarely used. The more widely used a piece of kernel infrastructure is, 
the more 'hardened' it must be against intentional or accidental abuse. 
(at least with certain magic debug options enabled)

So please regard this a good thing - obscure APIs need no debugging 
infrastructure - widely used ones do need quite extensive debugging 
infrastructure.

For example locks currently have 4000 lines of code of debugging 
infrastructure and 1500 lines of code of self-tests. The total amount of 
core locking code is less 1000 lines of code. So for every line of 
locking code there's more than 5 lines of debugging infrastructure (!). 
And we only print to the console if we think there is a bug. That 
extensive infrastructure is _good_, because locks are so central to all 
our data structures that catching bugs as soon as possible (in fact 
sooner than they trigger) aids in keeping bad code out of the kernel 
ASAP.

	Ingo
