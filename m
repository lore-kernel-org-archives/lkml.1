Return-Path: <linux-kernel-owner+w=401wt.eu-S932591AbXBNVHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591AbXBNVHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 16:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932593AbXBNVHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 16:07:05 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:3486 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932591AbXBNVHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 16:07:03 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 14 Feb 2007 13:06:59 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Benjamin LaHaise <bcrl@kvack.org>
cc: Russell King <rmk+lkml@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 06/11] syslets: core, documentation
In-Reply-To: <20070214203438.GL32271@kvack.org>
Message-ID: <Pine.LNX.4.64.0702141241030.7796@alien.or.mcafeemobile.com>
References: <20060529212109.GA2058@elte.hu> <20070213142042.GG638@elte.hu>
 <20070214103655.GB4241@flint.arm.linux.org.uk> <20070214105039.GC6801@elte.hu>
 <20070214110419.GC4241@flint.arm.linux.org.uk>
 <Pine.LNX.4.64.0702140919200.7480@alien.or.mcafeemobile.com>
 <20070214180344.GI32271@kvack.org> <Pine.LNX.4.64.0702141135390.7796@alien.or.mcafeemobile.com>
 <20070214200347.GK32271@kvack.org> <Pine.LNX.4.64.0702141206190.7796@alien.or.mcafeemobile.com>
 <20070214203438.GL32271@kvack.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007, Benjamin LaHaise wrote:

> On Wed, Feb 14, 2007 at 12:14:29PM -0800, Davide Libenzi wrote:
> > I think you may have mis-interpreted my words. *When* a schedule would 
> > block a synco execution try, then you do have a context switch. Noone 
> > argue that, and the code is clear. The sys_async_exec thread will block, 
> > and a newly woke up thread will re-emerge to sys_async_exec with a NULL 
> > returned to userspace. But in a "cachehit" case (no schedule happens 
> > during the syscall/*let execution), there is no context switch at all. 
> > That is the whole point of the optimization.
> 
> And I will repeat myself: that cannot be done.  Tell me how the following 
> what if scenario works: you're in an MMX optimized memory copy and you take 
> a page fault.  How does returning to the submittor of the async operation 
> get the correct MMX state restored?  It doesn't.

Bear with me Ben, and let's follow this up :) If you are in the middle of 
an MMX copy operation, inside the syscall, you are:

- Userspace, on task A, calls sys_async_exec

- Userspace in _not_ doing any MMX stuff before the call

- We execute the syscall

- Task A, executing the syscall and inside an MMX copy operation, gets a 
  page fault

- We get a schedule

- Task A MMX state will *follow* task A, that will be put to sleep

- We wake task B that will return to userspace

So if the MMX work happens inside the syscall execution, we're fine 
because its context will follow the same task being put into sleep.
Problem would be to preserve the *caller* (userspace) context. But than 
can be done in a lazy way (detecting if task A user the FPU) like we're 
currently doing it, once we detect a schedule-out condition. That wouldn't 
be the most common case for many userspace programs in any case.




- Davide


