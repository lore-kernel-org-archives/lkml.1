Return-Path: <linux-kernel-owner+w=401wt.eu-S1753002AbZLAEGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbZLAEGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 23:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbZLAEGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 23:06:47 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:49145 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbZLAEGq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 23:06:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NG/tZQuXMdI3wiYPob9bGYfSp6gq4KGsxsO5b+lue3naOCoMPcx5GmotcPKBZ7Tlub
         kGd1bKu8q+H3SR/iT7m3KqpaivsOvbTedSuKPwtFCQJ8mxrX0WR87gT1RtiYRPV3ewU+
         EpZ0vnrO9nwFVr4UFeD2pmY1J9irlhq03RCF4=
MIME-Version: 1.0
In-Reply-To: <1256956383-2652-1-git-send-email-mcree@orcon.net.nz>
References: <4AE8D005.1030302@twiddle.net>
	 <1256956383-2652-1-git-send-email-mcree@orcon.net.nz>
Date: Mon, 30 Nov 2009 23:06:52 -0500
Message-ID: <b4198de60911302006u43f52bd5xe198615971352696@mail.gmail.com>
Subject: Re: [PATCH] Alpha: Rearrange thread info flags fixing two regressions
From: Matt Turner <mattst88@gmail.com>
To: Michael Cree <mcree@orcon.net.nz>
Cc: Richard Henderson <rth@twiddle.net>, linux-alpha@vger.kernel.org,
       linux-kernel@vger.kernel.org, ink@jurassic.park.msu.ru,
       David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 30, 2009 at 9:33 PM, Michael Cree <mcree@orcon.net.nz> wrote:
> The removal of the TIF_NOTIFY_RESUME flag, commit a583f1b54249b
> "remove unused TIF_NOTIFY_RESUME flag," resulted in incorrect
> setting of the unaligned access control flags by the prctl syscall.
>
> The re-addition of the TIF_NOTIFY_RESUME flag, commit d0420c83f39f
> "KEYS: Extend TIF_NOTIFY_RESUME to (almost) all architectures [try #6]"
> further caused problems, namely incorrect operands to assembler code
> as evidenced by:
>
> AS      arch/alpha/kernel/entry.o
> arch/alpha/kernel/entry.S: Assembler messages:
> arch/alpha/kernel/entry.S:326: Warning: operand out of range (0x0000000000000406 is not between 0x0000000000000000 and 0x00000000000000ff)
>
> Both regressions fixed by (1) rearranging TIF_NOTIFY_RESUME flag to be
> in lower 8 bits of the thread info flags, and (2) making sure that
> ALPHA_UAC_SHIFT matches the rearrangement of the thread info flags.
>
> Signed-off-by: Michael Cree <mcree@orcon.net.nz>
> ---
>  arch/alpha/include/asm/thread_info.h |   27 +++++++++++++++------------
>  1 files changed, 15 insertions(+), 12 deletions(-)
>
> diff --git a/arch/alpha/include/asm/thread_info.h b/arch/alpha/include/asm/thread_info.h
> index e7a07f6..3ba4ded 100644
> --- a/arch/alpha/include/asm/thread_info.h
> +++ b/arch/alpha/include/asm/thread_info.h
> @@ -61,21 +61,24 @@ register struct thread_info *__current_thread_info __asm__("$8");
>  /*
>  * Thread information flags:
>  * - these are process state flags and used from assembly
> - * - pending work-to-be-done flags come first to fit in and immediate operand.
> + * - pending work-to-be-done flags come first and must be assigned to be
> + *   within bits 0 to 7 to fit in and immediate operand.
> + * - ALPHA_UAC_SHIFT below must be kept consistent with the unaligned
> + *   control flags.
>  *
>  * TIF_SYSCALL_TRACE is known to be 0 via blbs.
>  */
>  #define TIF_SYSCALL_TRACE      0       /* syscall trace active */
> -#define TIF_SIGPENDING         1       /* signal pending */
> -#define TIF_NEED_RESCHED       2       /* rescheduling necessary */
> -#define TIF_POLLING_NRFLAG     3       /* poll_idle is polling NEED_RESCHED */
> -#define TIF_DIE_IF_KERNEL      4       /* dik recursion lock */
> -#define TIF_UAC_NOPRINT                5       /* see sysinfo.h */
> -#define TIF_UAC_NOFIX          6
> -#define TIF_UAC_SIGBUS         7
> -#define TIF_MEMDIE             8
> -#define TIF_RESTORE_SIGMASK    9       /* restore signal mask in do_signal */
> -#define TIF_NOTIFY_RESUME      10      /* callback before returning to user */
> +#define TIF_NOTIFY_RESUME      1       /* callback before returning to user */
> +#define TIF_SIGPENDING         2       /* signal pending */
> +#define TIF_NEED_RESCHED       3       /* rescheduling necessary */
> +#define TIF_POLLING_NRFLAG     8       /* poll_idle is polling NEED_RESCHED */
> +#define TIF_DIE_IF_KERNEL      9       /* dik recursion lock */
> +#define TIF_UAC_NOPRINT                10      /* see sysinfo.h */
> +#define TIF_UAC_NOFIX          11
> +#define TIF_UAC_SIGBUS         12
> +#define TIF_MEMDIE             13
> +#define TIF_RESTORE_SIGMASK    14      /* restore signal mask in do_signal */
>  #define TIF_FREEZE             16      /* is freezing for suspend */
>
>  #define _TIF_SYSCALL_TRACE     (1<<TIF_SYSCALL_TRACE)
> @@ -94,7 +97,7 @@ register struct thread_info *__current_thread_info __asm__("$8");
>  #define _TIF_ALLWORK_MASK      (_TIF_WORK_MASK         \
>                                 | _TIF_SYSCALL_TRACE)
>
> -#define ALPHA_UAC_SHIFT                6
> +#define ALPHA_UAC_SHIFT                10
>  #define ALPHA_UAC_MASK         (1 << TIF_UAC_NOPRINT | 1 << TIF_UAC_NOFIX | \
>                                 1 << TIF_UAC_SIGBUS)
>
> --
> 1.6.3.3
>
> --

Applied to alpha-2.6.git. Thanks!

Matt
