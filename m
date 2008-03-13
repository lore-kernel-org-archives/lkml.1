Return-Path: <linux-kernel-owner+w=401wt.eu-S1756346AbYCMQtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346AbYCMQtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 12:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbYCMQtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 12:49:15 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:42870 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbYCMQtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 12:49:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=EZUw8zoL6u+1kfZh3LMBHhmrPQx7P6FIqfE2FxZdnCWapUyRYOj4tkaJrjBQBJNhWXKc8hjmG0CLAO0/RtnBirxGKxm5/Bo3oWxKHxHswoPM0/gLd4tltGsqZihe6oIelOG6MPwq/ll0x50xmzEhFm3lu0JMyIkXIeW0U4Yd4H8=
Message-ID: <998d0e4a0803130949s7de0e8e9vd953570e4569c5e5@mail.gmail.com>
Date: Thu, 13 Mar 2008 17:49:13 +0100
From: "J.C. Pizarro" <jcpiza@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: lock held when returning to user space
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 08:43:49 -0700, Daniel Walker wrote:
> On Wed, 2008-03-12 at 22:40 +0100, Jiri Kosina wrote:
> > No, as it is a real bug if you use mutexes in this way. What happens if
> > process that has called open() on your device (and has not closed it yet)
> > calls fork()?
> > Another breakage scenario -- what if the filedescriptor is sent through
> > unix socket to another process? etc.
>
> There's a number of places where a semaphore is used across system
> calls.
>
> for instance the usb skeleton,
> 	drivers/usb/usb-skeleton.c
>
> Several of the watchdog drivers,
> 	drivers/watchdog/s3c2410_wdt.c
>
> These need to be removed, but the usage is clearly not compatible with
> the mutex API ..
>
> If you convert them to atomic counts then you loose the sleeping aspect
> of the semaphore, which you'd have to add back somehow.
>
> The only API that seems straight forward is using complete's .. Then you
> get an atomic count and all the sleeping function calls you might want..
> (include/linux/completion.h) The problem with complete's is that you
> can't start them out at "1" or "completed" unless you actually run
> complete() once during initialization (that's kind of ugly) ..
>
> Daniel

They are not only bugs in the implementation,
they are bugs in the design or in the definition too!

Assuming the definition of fork in the OpenGroup.org
http://www.opengroup.org/onlinepubs/000095399/functions/fork.html

   "The fork() function shall create a new process. The new process
(child process)
    shall be an exact copy of the calling process (parent process) except as
    detailed below: ....."

Here there are some problems when a process is forked:
* when the process is multithreaded instead of monothreaded => dangerous!
   (why? e.g. one of the threads can fork from its own process that will
     have again many cloned threads duplicating its forbidden tasks and will
     have undefined behaviour because of this forked multithreaded process!)
* the locks have a state: "unlocked" or "locked by one correspondent process",
    but when the correspondent process is forked with some its locks locked by
    itself then the locks are "locked by 2 or more processes instead one"
    violating the theory of locking. There is no theorical solution
for this problem.
    (it's not solution that all the locks of the forked process are
unlocked because
     its program counter is "inside" of the mutual exclusion of the locked lock)
* even for semaphores, message passing, mutexes in shared memory (IPC), etc.
* when they are servers, it doesn't exist forked listen's ports from sockets!
* when they are clients, they can't duplicate sessions with same
TCP/IP client port!
* they can't duplicate pipes, streams, groups of children processes, etc.
* the same offsets of the opened files (or streams) for writing can imply them
     to overwrite characters or blocks of the same opened file.
* etc.

In the fork specification, it almost says e.g. that "the fork shall
not inherit" but
it doesn't say "how to solve it when it's inherited or not inherited"!

Eureka! You did understand the difference when you found an unsolvable bug!

   J.C.Pizarro
