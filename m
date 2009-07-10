Return-Path: <linux-kernel-owner+w=401wt.eu-S1755128AbZGJMvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbZGJMvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 08:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbZGJMvC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 08:51:02 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54576 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbZGJMvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 08:51:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "liqin.chen" <liqin.chen@sunplusct.com>
Subject: Re: [PATCH V2] score: add regset support
Date: Fri, 10 Jul 2009 14:49:44 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-2-generic; KDE/4.2.95; x86_64; ; )
Cc: Roland McGrath <roland@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       linux-arch@vger.kernel.org, linux-arch-owner@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <4A570650.3060309@sunplusct.com>
In-Reply-To: <4A570650.3060309@sunplusct.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200907101449.45286.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18KKF5ECKb9vXR0TAdm0/I/DbgjNSIM+8SFo/g
 Oq5YhXTgxe41BjFZH0va+KZhRWv40GGRlUPtqF/atwjr1WjeD+
 njcO41E7A+/URu+hNqjtQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 July 2009, liqin.chen wrote:
> +static int genregs_get(struct task_struct *target,
> +               const struct user_regset *regset,
> +               unsigned int pos, unsigned int count,
> +               void *kbuf, void __user *ubuf)
> +{
> +    const struct pt_regs *regs = task_pt_regs(target);
> +    int ret;
> +
> +    /* skip 8 * sizeof(unsigned long) not use for pt_regs */
> +    ret = user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf,
> +                    0, offsetof(struct pt_regs, regs));
> +
> +    /* r0 - r31 */
> +    ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> +                  regs->regs,
> +                  offsetof(struct pt_regs, regs),
> +                  offsetof(struct pt_regs, cel));
> +
> +    if (!ret)
> +        /* cel, ceh, sr0, sr1, sr2, epc, ema, psr, ecr, condition */
> +        ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> +                    &regs->cel,
> +                    offsetof(struct pt_regs, cel),
> +                    offsetof(struct pt_regs, is_syscall));

The two user_regset_copyout are consecutive, so AFAICT they can
be combined into a single function call.

> +
> +    if (!ret)
> +        ret = user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf,
> +                        sizeof(struct pt_regs), -1);
> +
> +    return ret;
> +}

While the code looks correct to me now based on Rolands comments,
I think it would be nicer to define separate pt_regs and user_regset
data structures to make the two independent and give you more
flexibility with the kernel stack layout in the future.

Maybe you could change

struct pt_regs {
       unsigned long pad0[6];
       unsigned long orig_r4;
       unsigned long orig_r7;
       unsigned long regs[32];

       unsigned long cel;
       unsigned long ceh;

       unsigned long sr0;      /* cnt */
       unsigned long sr1;      /* lcr */
       unsigned long sr2;      /* scr */

       unsigned long cp0_epc;
       unsigned long cp0_ema;
       unsigned long cp0_psr;
       unsigned long cp0_ecr;
       unsigned long cp0_condition;

       long is_syscall;
};

to

struct pt_regs {
       unsigned long regs[32];

       unsigned long cel;
       unsigned long ceh;

       unsigned long sr0;      /* cnt */
       unsigned long sr1;      /* lcr */
       unsigned long sr2;      /* scr */

       unsigned long cp0_epc;
       unsigned long cp0_ema;
       unsigned long cp0_psr;
       unsigned long cp0_ecr;
       unsigned long cp0_condition;
#ifdef __KERNEL__
       unsigned long orig_r4;
       unsigned long orig_r7;
       long is_syscall;
       unsigned long pad0[3];
#else
       unsigned long pad0[6];
#endif
};

> @@ -356,11 +430,17 @@ arch_ptrace(struct task_struct *child, long 
> request, long addr, long data)
>      }
>  
>      case PTRACE_GETREGS:
> -        ret = ptrace_getregs(child, (void __user *)datap);
> +        return copy_regset_to_user(child, &user_score_native_view,
> +                        REGSET_GENERAL,
> +                        0, sizeof(struct pt_regs),
> +                        (void __user *)datap);                        	
>          break;
>  
>      case PTRACE_SETREGS:
> -        ret = ptrace_setregs(child, (void __user *)datap);
> +        return copy_regset_from_user(child, &user_score_native_view,
> +                        REGSET_GENERAL,
> +                        0, sizeof(struct pt_regs),
> +                        (const void __user *)datap);
>          break;
>  
>      default:

I guess you still need to remove the PTRACE_PEEKUSR and PTRACE_POKEUSR
code, as mentioned by Roland.

Roland, Christoph: Do you think it would be reasonable to implement
this in common code? That would make it possible to have an empty
arch_ptrace() function.

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 61c78b2..a6b7862 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -570,6 +570,21 @@ int ptrace_request(struct task_struct *child, long request,
 			return 0;
 		return ptrace_resume(child, request, SIGKILL);
 
+#if defined(PTRACE_GENERIC_GETREGS) && defined(REGSET_GENERAL)
+	case PTRACE_GETREGS:
+		return copy_regset_to_user(child,
+				task_user_regset_view(child),
+				REGSET_GENERAL, 0,
+				sizeof(struct pt_regs),
+				(void __user *)datap);
+	case PTRACE_GETREGS:
+		return copy_regset_from_user(child,
+				task_user_regset_view(child),
+				REGSET_GENERAL, 0,
+				sizeof(struct pt_regs),
+				(void __user *)datap);
+#endif
+
 	default:
 		break;
 	}
