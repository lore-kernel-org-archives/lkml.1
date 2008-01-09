Return-Path: <linux-kernel-owner+w=401wt.eu-S1754424AbYAIDtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbYAIDtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 22:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbYAIDtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 22:49:08 -0500
Received: from ozlabs.org ([203.10.76.45]:42303 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbYAIDtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 22:49:05 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 5/6] syslets: add generic syslets infrastructure
Date: Wed, 9 Jan 2008 14:48:44 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dan Williams <dan.j.williams@gmail.com>, Jeff Moyer <jmoyer@redhat.com>,
       Simon Holm Thogersen <odie@cs.aau.dk>, suresh.b.siddha@intel.com
References: <1196983219534-git-send-email-zach.brown@oracle.com> <200801091303.58920.rusty@rustcorp.com.au> <478438B4.6010101@oracle.com>
In-Reply-To: <478438B4.6010101@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801091448.46241.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2008 14:00:04 Zach Brown wrote:
> >     Firstly, why not just specify an address for the return value and be
> > done with it?  This infrastructure seems overkill, and you can always
> > extend later if required.
>
> Sorry, which infrastructure?
>
> Providing the function and stack to return to?  Sure, I could certainly
> entertain the idea of not having syslet tasks return to userspace in the
> first pass.  Ingo sure seemed excited by the idea.
>
> Or do you mean the syscall return value ending up in the userspace
> completion event ring?  That's mostly about being able to wait for
> pending syslets to complete.

The latter.  A ring is optimal for processing a huge number of requests, but 
if you're really going to be firing off syslet threads all over the place 
you're not going to be optimal anyway.  And being able to point the return 
value to the stack or into some datastructure is way nicer to code (zero 
setup == easy to understand and easy to convert).

For notification, see below.

> > Secondly, you really should allow integration with an eventfd so you
> > don't make the posix AIO mistake of providing a poll-incompatible
> > interface.
>
> Yeah, this seems straight forward enough that I haven't made it an
> initial priority.  I'm sure it will be helpful for people who are stuck
> integrating with entrenched software that wants to wait for pollable fds.

Unfortunately, waiting for someone to write a killer app which uses your new 
API is the road to disappointment.  The real target is convincing the handful 
of important apps (Samba, Apache, ...) to #ifdef around some small piece of 
code in order to get performance.  And a mere single design wart could mean 
that never happens.  Look at epoll, it's probably been the most successful 
and it's still damn niche.

> For more flexible software, though, it's compelling to now be able to
> aggregate waiting for completion of the existing waiting syscalls (poll,
> epoll_wait, futexes, whatever) by issuing them as concurrent syslets.

Is replacing epoll with syslets really going to win, even if you're writing 
apps from scratch?  Anyway a fast notification mechanism is a different 
problem than syslets, and should be separated.

> > Finally, and probably most alarmingly, AFAICT randomly changing TID will
> > break all threaded programs, which means this won't be fitted into
> > existing code bases, making it YA niche Linux-only API 8(
>
> I wonder if there isn't an opportunity to add a clone() flag which
> juggles the association between TIDs and task_structs.  I don't relish
> the idea of investigating the life cycles of task_struct references that
> derive from TIDs and seeing how those would race with a syslet blocking
> and cloning, but, well, maybe that's what needs to be done.

This must be solved, yet all avenues seem crawling with worms.  Redirecting 
find_task_by_pid() to find the original and converting all the places where 
we return tids to userspace?  Swapping tids when we clone?  Duplicate tids, 
with only the non-syslet one being returned from find_task_by_pid()?

> This all isn't my area of expertise, though, sadly.  It would be swell
> if someone wanted to look into it before I'm forced to learn yet another
> weird corner of the kernel.

Let's just tell Ingo it's impossible to solve :)

Rusty.
