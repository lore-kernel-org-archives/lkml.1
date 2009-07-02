Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbZGBMyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbZGBMyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 08:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbZGBMyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 08:54:00 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:38006 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbZGBMx7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 08:53:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gzYWM/V0k+Vu9TWoSG8HT/+GjwctfeRM3NKs3dWV4pUANJ92x+Bw90PRmn8o38WEWO
         BZ88qbt+FDdm7WhP7VzU/SfYCKro3Qs7AKbAS76n6hz/R14mKRvq2+OR0UvYegU6oO2j
         hrfnL1nFQwtaV1K0hOr+5XUYVl9xyCWeNeKGY=
MIME-Version: 1.0
In-Reply-To: <1246538899.13320.86.camel@pc1117.cambridge.arm.com>
References: <200907010300.n6130rRf026194@hera.kernel.org>
	 <20090701075332.GA17252@elte.hu>
	 <1246439937.8492.18.camel@pc1117.cambridge.arm.com>
	 <20090701093015.GA6862@elte.hu>
	 <1246441592.8492.38.camel@pc1117.cambridge.arm.com>
	 <20090701110438.GA15958@elte.hu>
	 <1246538899.13320.86.camel@pc1117.cambridge.arm.com>
Date: Thu, 2 Jul 2009 15:54:00 +0300
X-Google-Sender-Auth: 3862c771364e3fa7
Message-ID: <84144f020907020554n1b098e28o8b4a4a58a08728e3@mail.gmail.com>
Subject: Re: Exiting with locks still held (was Re: [PATCH] kmemleak: Fix 
	scheduling-while-atomic bug)
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       git-commits-head@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On Thu, Jul 2, 2009 at 3:48 PM, Catalin Marinas<catalin.marinas@arm.com> wrote:
> It could be but I can't figure out a solution. If there is only one task
> opening and closing the kmemleak file, everything is fine. In
> combination with shell piping I think I get the kmemleak file descriptor
> released from a different task than the one that opened it.
>
> For example, the badly written code below opens kmemleak and acquires
> the scan_mutex in the parent task but releases it in the child (it needs
> a few tries to trigger it). With waitpid() in parent everything is fine.
>
> #include <stdio.h>
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <fcntl.h>
> #include <unistd.h>
> #include <sys/wait.h>
>
> int main(void)
> {
>        int fd = open("/sys/kernel/debug/kmemleak", O_RDONLY);
>
>        printf("fd = %d\n", fd);
>        if (fd < 0)
>                return 2;
>
>        if (!fork()) {
>                /* child */
>                sleep(2);
>                close(fd);
>                printf("fd closed in child\n");
>        }
>
>        return 0;
> }
>
> Running this gives (the ### lines are printed in the
> kmemleak_open/release functions):
>
> # ./cat-kmemleak
> ### kmemleak_open current->pid = 1409
> fd = 3
> =====================================
> [ BUG: lock held at task exit time! ]
> -------------------------------------
> cat-kmemleak/1409 is exiting with locks still held!
> 1 lock held by cat-kmemleak/1409:
>  #0:  (scan_mutex){+.+.+.}, at: [<c00662b1>] kmemleak_open+0x31/0x68
>
> stack backtrace:
> [<c0024025>] (unwind_backtrace+0x1/0x80) from [<c01cddd7>] (dump_stack+0xb/0xc)
> [<c01cddd7>] (dump_stack+0xb/0xc) from [<c0043d2d>] (debug_check_no_locks_held+0x49/0x64)
> [<c0043d2d>] (debug_check_no_locks_held+0x49/0x64) from [<c0031423>] (do_exit+0x3fb/0x43c)
> [<c0031423>] (do_exit+0x3fb/0x43c) from [<c00314c5>] (do_group_exit+0x61/0x80)
> [<c00314c5>] (do_group_exit+0x61/0x80) from [<c00314f3>] (sys_exit_group+0xf/0x14)
> [<c00314f3>] (sys_exit_group+0xf/0x14) from [<c001fc41>] (ret_fast_syscall+0x1/0x40)
>
> ### kmemleak_release current->pid = 1410
> fd closed in child
>
> Any suggestions? Thanks.

Well, you are not supposed to hold on to locks when returning from a
system call ("sys_open") anyway. You can probably do the exclusion
with a kmemcheck specific flag?

                        Pekka
