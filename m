Return-Path: <linux-kernel-owner+w=401wt.eu-S1754280AbYAIDAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbYAIDAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 22:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbYAIDAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 22:00:07 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:52501 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbYAIDAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 22:00:06 -0500
Message-ID: <478438B4.6010101@oracle.com>
Date: Tue, 08 Jan 2008 19:00:04 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org,
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
Subject: Re: [PATCH 5/6] syslets: add generic syslets infrastructure
References: <1196983219534-git-send-email-zach.brown@oracle.com> <1196983219370-git-send-email-zach.brown@oracle.com> <11969832192130-git-send-email-zach.brown@oracle.com> <200801091303.58920.rusty@rustcorp.com.au>
In-Reply-To: <200801091303.58920.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>     Firstly, why not just specify an address for the return value and be done 
> with it?  This infrastructure seems overkill, and you can always extend later 
> if required.

Sorry, which infrastructure?

Providing the function and stack to return to?  Sure, I could certainly
entertain the idea of not having syslet tasks return to userspace in the
first pass.  Ingo sure seemed excited by the idea.

Or do you mean the syscall return value ending up in the userspace
completion event ring?  That's mostly about being able to wait for
pending syslets to complete.

> Secondly, you really should allow integration with an eventfd so you don't 
> make the posix AIO mistake of providing a poll-incompatible interface.

Yeah, this seems straight forward enough that I haven't made it an
initial priority.  I'm sure it will be helpful for people who are stuck
integrating with entrenched software that wants to wait for pollable fds.

For more flexible software, though, it's compelling to now be able to
aggregate waiting for completion of the existing waiting syscalls (poll,
epoll_wait, futexes, whatever) by issuing them as concurrent syslets.

> Finally, and probably most alarmingly, AFAICT randomly changing TID will break 
> all threaded programs, which means this won't be fitted into existing code 
> bases, making it YA niche Linux-only API 8(

Yeah, this still needs to be investigated.  I haven't yet and I haven't
heard of anyone else trying their hand at it.

In the YANLOA mode apps would know that executing syslets is an implicit
clone() and would act accordingly.  "8(", indeed.

I wonder if there isn't an opportunity to add a clone() flag which
juggles the association between TIDs and task_structs.  I don't relish
the idea of investigating the life cycles of task_struct references that
derive from TIDs and seeing how those would race with a syslet blocking
and cloning, but, well, maybe that's what needs to be done.

This all isn't my area of expertise, though, sadly.  It would be swell
if someone wanted to look into it before I'm forced to learn yet another
weird corner of the kernel.

- z
