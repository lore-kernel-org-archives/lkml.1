Return-Path: <linux-kernel-owner+w=401wt.eu-S1750819AbXBND3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750819AbXBND3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 22:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750820AbXBND3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 22:29:00 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4697 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbXBND3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 22:29:00 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 13 Feb 2007 19:28:56 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system
 call support
In-Reply-To: <20070213142010.GA638@elte.hu>
Message-ID: <Pine.LNX.4.64.0702131900280.32055@alien.or.mcafeemobile.com>
References: <20070213142010.GA638@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007, Ingo Molnar wrote:

> I'm pleased to announce the first release of the "Syslet" kernel feature 
> and kernel subsystem, which provides generic asynchrous system call 
> support:
> [...]

Ok, I had little to time review the code, but it has been a long 
working day, so bear with me if I missed something.
I don't see how sys_async_exec would not block, based on your patches. 
Let's try to follow:

- We enter sys_async_exec

- We may fill the pool, but that's nothing interesting ATM. A bunch of 
  threads will be created, and they'll end up sleeping inside the 
  cachemiss_loop

- We set the async_ready pointer and we fall inside exec_atom

- There we copy the atom (nothing interesting from a scheduling POV) and 
  we fall inside __exec_atom

- In __exec_atom we do the actual syscall call. Note that we're still the 
  task/thread that called sys_async_exec

- So we enter the syscall, and now we end up in schedule because we're 
  just unlucky

- We notice that the async_ready pointer is not NULL, and we call 
  __async_schedule

- Finally we're in pick_new_async_thread and we pick one of the ready 
  threads sleeping in cachemiss_loop

- We copy the pt_regs to the newly picked-up thread, we set its async head 
  pointer, we set the current task async_ready pointer to NULL, we 
  re-initialize the async_thread structure (the old async_ready), and we 
  put ourselves in the busy_list

- Then we roll back to the schedule that started everything, and being 
  still "prev" for the scheduler, we go to sleep

So the sys_async_exec task is going to block. Now, am I being really 
tired, or the cachemiss fast return is simply not there?
There's another problem AFAICS:

- We woke up one of the cachemiss_loop threads in pick_new_async_thread

- The threads wakes up, mark itself as busy, and look at the ->work 
  pointer hoping to find something to work on

But we never set that pointer to a userspace atom AFAICS. Me blind? :)




- Davide


