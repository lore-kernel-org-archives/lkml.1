Return-Path: <linux-kernel-owner+w=401wt.eu-S1763014AbXEUQaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763014AbXEUQaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756908AbXEUQaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:30:10 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:34204 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755978AbXEUQaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:30:08 -0400
Date: Mon, 21 May 2007 09:30:07 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
In-Reply-To: <20070520133505.46147.qmail@web52609.mail.re2.yahoo.com>
Message-ID: <Pine.LNX.4.64.0705210917280.25871@schroedinger.engr.sgi.com>
References: <20070520133505.46147.qmail@web52609.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007, Srihari Vijayaraghavan wrote:

> With no CONFIG_SLUB_DEBUG, things have slightly improved. No more panic. Good.
> Serial console is working. Good. But there is another problem:

Well this indicates that something destroys the sysfs pointer structure 
that SLUB is using. Could you reenable CONFIG_SLUB_DEBUG and boot with the 
option "slub_debug" on the kernel command line?

Also enable the list debug options in kernel hacking.

This should show up on the console since the failure is in slub_sysfs_init 
which is long after the console has been enabled. I wonder why it did not 
show so far?

> Freeing unused kernel memory: 308k freed
> BUG: spinlock bad magic on CPU#1, init/1
>  lock: ffff81011ec0a100, .magic: ffff8101, .owner: <none>/-1, .owner_cpu: -1
> 
> Call Trace:
>  [<ffffffff802fc516>] _raw_spin_lock+0x22/0xf6
>  [<ffffffff8026f684>] vma_adjust+0x219/0x454
>  [<ffffffff8026f684>] vma_adjust+0x219/0x454
>  [<ffffffff8026fe0d>] vma_merge+0x147/0x1f4
>  [<ffffffff80270b55>] do_mmap_pgoff+0x414/0x7c7
>  [<ffffffff8040aa34>] _spin_unlock_irq+0x24/0x27
>  [<ffffffff8020f528>] sys_mmap+0xe5/0x110
>  [<ffffffff80209dde>] system_call+0x7e/0x83

Hmmmm..... We have seen this before

http://marc.info/?l=linux-kernel&m=117891943401284&w=2

I suspect this is due to an interaction with other debug flags you have 
set. What I see in your .config is

CONFIG_DEBUG_RT_MUTEXES=y

Try to switch this off if switching off the lockdep flags does not hel.

CONFIG_DEBUG_PI_LIST=y

Will go off with the above

# CONFIG_RT_MUTEX_TESTER is not set

Leave off

CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y

Try toggling if the disabling lockdep flags does not work.


CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y

I suspect the above are the main candidates for trouble. Could you
switch those off?


# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y

# CONFIG_DEBUG_KOBJECT is not set

Debug kobject may be helpful.

CONFIG_DEBUG_BUGVERBOSE=y



