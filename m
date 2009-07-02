Return-Path: <linux-kernel-owner+w=401wt.eu-S1752393AbZGBMtC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbZGBMtC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 08:49:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbZGBMso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 08:48:44 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:46449 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752045AbZGBMsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 08:48:42 -0400
Subject: Exiting with locks still held (was Re: [PATCH] kmemleak: Fix
	scheduling-while-atomic bug)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       git-commits-head@vger.kernel.org
In-Reply-To: <20090701110438.GA15958@elte.hu>
References: <200907010300.n6130rRf026194@hera.kernel.org>
	 <20090701075332.GA17252@elte.hu>
	 <1246439937.8492.18.camel@pc1117.cambridge.arm.com>
	 <20090701093015.GA6862@elte.hu>
	 <1246441592.8492.38.camel@pc1117.cambridge.arm.com>
	 <20090701110438.GA15958@elte.hu>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 02 Jul 2009 13:48:19 +0100
Message-Id: <1246538899.13320.86.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jul 2009 12:48:20.0868 (UTC) FILETIME=[6117F440:01C9FB13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Wed, 2009-07-01 at 13:04 +0200, Ingo Molnar wrote:
> * Catalin Marinas <catalin.marinas@arm.com> wrote:
> > Since we are at locking, I just noticed this on my x86 laptop when
> > running cat /sys/kernel/debug/kmemleak (I haven't got it on an ARM
> > board):
> > 
> > ================================================
> > [ BUG: lock held when returning to user space! ]
> > ------------------------------------------------
> > cat/3687 is leaving the kernel with locks still held!
> > 1 lock held by cat/3687:
> > #0:  (scan_mutex){+.+.+.}, at: [<c01e0c5c>] kmemleak_open+0x3c/0x70
> > 
> > kmemleak_open() acquires scan_mutex and unconditionally releases 
> > it in kmemleak_release(). The mutex seems to be released as a 
> > subsequent acquiring works fine.
> > 
> > Is this caused just because cat may have exited without closing 
> > the file descriptor (which should be done automatically anyway)?
> 
> This lockdep warning has a 0% false positives track record so far: 
> all previous cases it triggered showed some real (and fatal) bug in 
> the underlying code.

In this particular case, there is no fatal problem as the mutex is
released shortly after this message.

> The above one probably means scan_mutex is leaked out of a /proc 
> syscall - that would be a bug in kmemleak.

It could be but I can't figure out a solution. If there is only one task
opening and closing the kmemleak file, everything is fine. In
combination with shell piping I think I get the kmemleak file descriptor
released from a different task than the one that opened it.

For example, the badly written code below opens kmemleak and acquires
the scan_mutex in the parent task but releases it in the child (it needs
a few tries to trigger it). With waitpid() in parent everything is fine.

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/wait.h>

int main(void)
{
	int fd = open("/sys/kernel/debug/kmemleak", O_RDONLY);

	printf("fd = %d\n", fd);
	if (fd < 0)
		return 2;

	if (!fork()) {
		/* child */
		sleep(2);
		close(fd);
		printf("fd closed in child\n");
	}

	return 0;
}

Running this gives (the ### lines are printed in the
kmemleak_open/release functions):

# ./cat-kmemleak
### kmemleak_open current->pid = 1409
fd = 3
=====================================
[ BUG: lock held at task exit time! ]
-------------------------------------
cat-kmemleak/1409 is exiting with locks still held!
1 lock held by cat-kmemleak/1409:
 #0:  (scan_mutex){+.+.+.}, at: [<c00662b1>] kmemleak_open+0x31/0x68

stack backtrace:
[<c0024025>] (unwind_backtrace+0x1/0x80) from [<c01cddd7>] (dump_stack+0xb/0xc)
[<c01cddd7>] (dump_stack+0xb/0xc) from [<c0043d2d>] (debug_check_no_locks_held+0x49/0x64)
[<c0043d2d>] (debug_check_no_locks_held+0x49/0x64) from [<c0031423>] (do_exit+0x3fb/0x43c)
[<c0031423>] (do_exit+0x3fb/0x43c) from [<c00314c5>] (do_group_exit+0x61/0x80)
[<c00314c5>] (do_group_exit+0x61/0x80) from [<c00314f3>] (sys_exit_group+0xf/0x14)
[<c00314f3>] (sys_exit_group+0xf/0x14) from [<c001fc41>] (ret_fast_syscall+0x1/0x40)

### kmemleak_release current->pid = 1410
fd closed in child


Any suggestions? Thanks.

-- 
Catalin

