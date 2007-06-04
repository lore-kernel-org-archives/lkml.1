Return-Path: <linux-kernel-owner+w=401wt.eu-S1759213AbXFDQki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213AbXFDQki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 12:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758654AbXFDQkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 12:40:17 -0400
Received: from [198.99.130.12] ([198.99.130.12]:48112 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758320AbXFDQkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 12:40:15 -0400
Date: Mon, 4 Jun 2007 12:31:45 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Syslets, signals, and security
Message-ID: <20070604163145.GA7144@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Syslets seem like a fundamentally good idea to me, but the current
implementation, using CLONE_THREAD threads, seems like a basic
problem.

First, there are signals.  If the app has an interval timer enabled,
every thread will inherit it and you will have 32 threads getting
alarms, which seems surprising and wasteful.  I can imagine other
signals (like SIGWINCH and  SIGHUP) which might be surprising to
receive multiple times in an obstensibly single-threaded process.

Second, security.  What happens if a well-written server starts life
as root, does some (async) I/O, and setuids to a non-root uid?  There
will be a bunch of async threads still running as root, with the
result that async operations (and the main thread) will more than
occassionally regain root privs.

You can fix this by going around to all the threads in the thread
group and changing their ->uid, but that seems somewhat kludgy.  You
could also fix this by killing off the async threads on a setuid, and
make the app recreate the async threads under its new uid.  However,
the current interface has no way to give the userspace stacks back to
the process, so this would force a memory leak on the process.

There's also ptrace, which (as I think Zach already mentioned) gets
along badly with syslets.

Offhand, it seems to me that the underlying problem is that the
threads all have their own task_structs and userspaces.

If only the main thread can receive signals and exit to userspace, the
signal surprises go away.

Similarly, if they all share a task structure, the setuid problem goes
away.

There are also warts in the current interface due to all of the
threads possibly being able to return to userspace:
	they all need to be provided with userspace stacks
	they need to be given an user IP to execute
	there is a new system call for them to call when they land in
userspace.

Since the basic schedulable unit is currently a task_struct, and
syslets would prefer to have multiple schedulable units per
task_struct, this would imply some surgery on the task_struct and the
scheduler.  What I think we'd want is for the basic schedulable unit
to be not much more than a kernel stack and a register set.  A
(non-kernel-thread) task_struct would still be associated 1-1 with a
userspace, but could have multiple schedulable units, one of which is
allowed to exit to userspace.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
