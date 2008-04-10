Return-Path: <linux-kernel-owner+w=401wt.eu-S1756270AbYDJGxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbYDJGxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 02:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756004AbYDJGww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 02:52:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60903 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755971AbYDJGwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 02:52:50 -0400
Date: Wed, 9 Apr 2008 23:51:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] powerpc TLF_RESTORE_SIGMASK
Message-Id: <20080409235156.33ee33f2.akpm@linux-foundation.org>
In-Reply-To: <20080403210842.6C88C26F98D@magilla.localdomain>
References: <20080403210842.6C88C26F98D@magilla.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  3 Apr 2008 14:08:42 -0700 (PDT) Roland McGrath <roland@redhat.com> wrote:

> This requires the earlier HAVE_SET_RESTORE_SIGMASK patch series.
> This does the same for powerpc that I posted the x86 change for.
> 
> ---
> Replace TIF_RESTORE_SIGMASK with TLF_RESTORE_SIGMASK and define
> our own set_restore_sigmask() function.  This saves the costly
> SMP-safe set_bit operation, which we do not need for the sigmask
> flag since TIF_SIGPENDING always has to be set too.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>
> ---
>  arch/powerpc/kernel/entry_32.S    |    4 ++--
>  arch/powerpc/kernel/signal.c      |   12 ++++++------
>  arch/powerpc/kernel/signal_32.c   |    2 +-
>  include/asm-powerpc/thread_info.h |   17 +++++++++++++----
>  4 files changed, 22 insertions(+), 13 deletions(-)

This crashes my powerpc mac g5.

EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
Unable to handle kernel paging request for data at address 0x0000003d
Faulting instruction address: 0xc0000000000dbc3c
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=4 PowerMac
Modules linked in: autofs
NIP: c0000000000dbc3c LR: c0000000000dbda8 CTR: c0000000000dbd40
REGS: c000000178607a70 TRAP: 0300   Not tainted  (2.6.25-rc8-mm2)
MSR: 9000000000009032 <EE,ME,IR,DR>  CR: 42284448  XER: 20000000
DAR: 000000000000003d, DSISR: 0000000040000000
TASK = c000000178f792e0[2488] 'zsh' THREAD: c000000178604000 CPU: 0
GPR00: c0000000000dbda8 c000000178607cf0 c0000000006df7e8 000000000000000d 
GPR04: 0000000000000000 0000000000000001 00000000ffb46c08 0000000000000001 
GPR08: 00000000f7ff8000 c000000178607ea0 c0000000000dbd40 000000000000000d 
GPR12: 100000000000d032 c000000000622e80 0000000010090000 0000000000000000 
GPR16: 0000000000000001 0000000010090000 0000000010092ff8 00000000100ac34c 
GPR20: 0000000000000000 0000000000000001 0000000000000000 0000000000000001 
GPR24: 0000000000000000 00000000ffb46c08 000000000000000d 0000000000000000 
GPR28: 0000000000000000 0000000000000001 c00000000068ff50 ffffffffffffffea 
NIP [c0000000000dbc3c] .vfs_llseek+0x1c/0x84
LR [c0000000000dbda8] .sys_llseek+0x68/0xf0
Call Trace:
[c000000178607cf0] [c00000000009e210] .audit_syscall_exit+0x3fc/0x40c (unreliable)
[c000000178607d70] [c0000000000dbda8] .sys_llseek+0x68/0xf0
[c000000178607e30] [c00000000000872c] syscall_exit+0x0/0x40
Instruction dump:
e93c0018 e9690010 e80b0068 7fff0214 4bffff94 7c0802a6 fbc1fff0 ebc2abe8 
7c6b1b78 f8010010 f821ff81 60000000 <80030030> 7809f7e3 e93e8000 41820024 

It happens after the boot, during the first login-over-ssh.

This is with most of the rest of the -mm poopile applied.  i386 and x86_64
seem OK.

