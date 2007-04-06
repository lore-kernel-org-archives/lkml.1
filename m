Return-Path: <linux-kernel-owner+w=401wt.eu-S932619AbXDFUBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619AbXDFUBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 16:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932700AbXDFUBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 16:01:35 -0400
Received: from mail.screens.ru ([213.234.233.54]:33024 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932619AbXDFUBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 16:01:34 -0400
Date: Sat, 7 Apr 2007 00:01:16 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Robin Holt <holt@sgi.com>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070406200116.GA169@tv-sign.ru>
References: <20070406084250.GA179@tv-sign.ru> <m18xd5amwq.fsf@ebiederm.dsl.xmission.com> <20070406094413.GA673@tv-sign.ru> <m1lkh58q16.fsf@ebiederm.dsl.xmission.com> <20070406154750.GA541@tv-sign.ru> <Pine.LNX.4.64.0704061013060.6730@woody.linux-foundation.org> <20070406193621.GA96@tv-sign.ru> <20070406194329.GB21322@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070406194329.GB21322@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06, Ingo Molnar wrote:
> 
> * Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> > > I'd almost prefer to just not add kernel threads to any parent 
> > > process list *at*all*.
> > 
> > Yes sure, I didn't argue with that. However, "->exit_state = -1" does 
> > matter, we can't detach process unless we make it auto-reap.
> 
> > Off course, we also need to add preparent_to_init() to kthread() and 
> > (say) stopmachine(). Or we can create kernel_thread_detached() and 
> > modify callers to use it.
> 
> this isnt a kernel-thread special case. The right solution IMO is to 
> first migrate wait4()'s ->children use over to a new p->exiting_children 
> list and then to gradually get rid of all remaining uses of p->children. 
> (the first patch of which i sent a few minutes ago)
> 
> that way wait4() will be sped up, and quite dramatically i believe. No 
> need to deal with kthreads here at all - those just wont ever show up in 
> the ->exiting_children list. Am i missing something?

Probably it is I who missed something :)

But why can't we do both changes? I think it is just ugly to use init to
reap the kernel thread. Ok, wait4() can find zombie quickly if we do the
->children split. But /sbin/init could be swapped out, we still need to
deliver SIGCHLD, etc.

And I personally agree with Linus, it is nice to hide the kernel threads
from /sbin/init (or whatever) completely.

No?

Oleg.

