Return-Path: <linux-kernel-owner+w=401wt.eu-S1751724AbXBJSTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbXBJSTT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 13:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbXBJSTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 13:19:19 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:2562 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbXBJSTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 13:19:18 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 10 Feb 2007 10:19:15 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: bert hubert <bert.hubert@netherlabs.nl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
In-Reply-To: <20070210104712.GA20878@outpost.ds9a.nl>
Message-ID: <Pine.LNX.4.64.0702100921180.11630@alien.or.mcafeemobile.com>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <Pine.LNX.4.64.0702091419470.8424@woody.linux-foundation.org>
 <20070210104712.GA20878@outpost.ds9a.nl>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Feb 2007, bert hubert wrote:

> On Fri, Feb 09, 2007 at 02:33:01PM -0800, Linus Torvalds wrote:
> 
> >  - IF the system call blocks, we call the architecture-specific 
> >    "schedule_async()" function before we even get any scheduler locks, and 
> >    it can just do a fork() at that time, and let the *child* return to the 
> >    original user space. The process that already started doing the system 
> >    call will just continue to do the system call.
> 
> Ah - cool. The average time we have to wait is probably far greater than the
> fork overhead, microseconds versus milliseconds. 
> 
> However, and there probably is a good reason for this, why isn't it possible
> to do it the other way around, and have the *child* do the work and the
> original return to userspace?

If the parent is going to schedule(), someone above has already dropped 
the parent's task_struct inside a wait queue, so the *parent* will be the 
wakeup target [1].
Linus take to the generic AIO is a neat one, but IMO continuos fork/exits 
are going to be expensive. Even if the task is going to sleep, that does 
not mean that the parent (well, in Linus case, the child actually) does 
not have more stuff to feed to async(). IMO the frequency of AIO 
submission and retrieval can get pretty high (hence the frequency of 
fork/exit), and there might be a price to pay for it at the end.
IMO one solution, following the non-fibril way, may be:

- Keep a pool of per-process threads (a per-process pool already has stuff 
  like "files" already correctly setup, just for example - no need to 
  teach everywhere around the kernel of the "async" special case)

- When a schedule happen on the submission thread, we get a thread 
  (task_struct really) of the available pool

- We setup the submission (now going to sleep) thread return IP to an 
  async_complete (or whatever name) stub. This will drop a result in a 
  queue, and wake the async_wait (or whatever name) wait queue head

- We may want to swap at least the PID (signals, ...?) between the two, so 
  even if we're re-emrging with a new task_struct, the TID will be the same

- We make the "returning" thread to come back to userspace through some 
  special helper ala ret_from_fork (ret_from_async ?)

- We want also to keep a record (hash?) of userspace cookies and threads 
  currently servicing them, so that we can implement cancel (send signal)

Open issues:

- What if the pool becomes empty since all thread are stuck under schedule?
  o Grow the pool (and delay-shrink at quiter times)?
  o Make the caller really sleep?
  o Fall back in queue-request mode?

- Look at the Devil hiding in the details and showing up many times during 
  the process

Yup, I can see Zach having a lot of fun with it ;)



[1] Well, you could add a list_head to the task_struct, and teach the 
    add-to-waitqueue to drop a reference to all the wait queue entries 
    hosting the task_struct. Then walk&fix (likely be only one entry) when 
    you swap the submission thread context (thread_info, per_call stuff, ...) 
    over a service thread task_struct. At that point you can re-emerge 
    with the same task_struct. Pretty nasty though.


- Davide


