Return-Path: <linux-kernel-owner+w=401wt.eu-S1752526AbXBDUAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbXBDUAJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 15:00:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbXBDUAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 15:00:08 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:3594 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbXBDUAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 15:00:07 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sun, 4 Feb 2007 12:00:04 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Zach Brown <zach.brown@oracle.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
In-Reply-To: <Pine.LNX.4.64.0702031539370.9054@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0702041149560.18633@alien.or.mcafeemobile.com>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <Pine.LNX.4.64.0702031539370.9054@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Feb 2007, Davide Libenzi wrote:

> > - Signals.  I have no idea what behaviour we want.  Help?  My first guess is
> > that we'll want signal state to be shared by fibrils by keeping it in the
> > task_struct.  If we want something like individual cancellation,  we'll augment
> > signal_pending() with some some per-fibril test which will cause it to return
> > from TASK_INTERRUPTIBLE (the only reasonable way to implement generic
> > cancellation, I'll argue) as it would have if a signal was pending.
> 
> Fibril should IMO use current thread signal policies. I think a signal 
> should hit (wake) any TASK_INTERRUPTIBLE fibril, if the current thread 
> policies mandate that. I'd keep a list_head of currently scheduled-out 
> TASK_INTERRUPTIBLE fibrils, and I'd make them runnable when a signal is 
> delivered to the thread (wake_target bit #1 set to mean wake-all-interruptable-fibrils?).
> The other thing is signal_pending(). The sigpending flag test is not going 
> to work as is (cleared at the first do_signal). Setting a bit in each 
> fibril would mean walking the whole TASK_INTERRUPTIBLE fibril list. Maybe 
> a sequential signal counter in task_struct, matched by one in the fibril. 
> A signal would increment the task_struct counter, and a fibril 
> schedule-out would save the task_struct counter to the fibril. The 
> signal_pending() for a fibril is a compare of the two. Or something 
> similar.

Another thing linked to signals that was not talked about, is cancellation 
of an in-flight request. We want to give the ability to cancel an 
in-flight request, with something like async_cancel(cookie). In my 
userspace library I simply disable SA_RESTART of SIGUSR2, and I do a 
pthread_kill() on the thread servicing the request. But this will IMO have 
other implications (linked to signal delivery) in a kernel fibril-based 
implementation, to think about it.



- Davide


