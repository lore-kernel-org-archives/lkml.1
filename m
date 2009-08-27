Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbZH0P0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbZH0P0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 11:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbZH0P0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 11:26:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbZH0P0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 11:26:51 -0400
Message-ID: <4A96A690.3030804@redhat.com>
Date: Thu, 27 Aug 2009 11:30:24 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH 18/18] tracing/kprobes: Dump the culprit kprobe in case
 of kprobe recursion
References: <1251340337-5640-1-git-send-email-fweisbec@gmail.com> <1251340337-5640-19-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1251340337-5640-19-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

Frederic Weisbecker wrote:
> Kprobes can enter into a probing recursion, ie: a kprobe that does an
> endless loop because one of its core mechanism function used during
> probing is also probed itself.
> 
> This patch helps pinpointing the kprobe that raised such recursion
> by dumping it and raising a BUG instead of a warning (we also disarm
> the kprobe to try avoiding recursion in BUG itself). Having a BUG
> instead of a warning stops the stacktrace in the right place and
> doesn't pollute the logs with hundreds of traces that eventually end
> up in a stack overflow.

Thanks, but I also found similar bug cases.

> 
> Signed-off-by: Frederic Weisbecker<fweisbec@gmail.com>
> Cc: Masami Hiramatsu<mhiramat@redhat.com>
> Cc: Ananth N Mavinakayanahalli<ananth@in.ibm.com>
> ---
>   arch/x86/kernel/kprobes.c |    8 ++++++--
>   include/linux/kprobes.h   |    2 ++
>   kernel/kprobes.c          |    7 +++++++
>   3 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index 16ae961..ecee3d2 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -490,9 +490,13 @@ static int __kprobes reenter_kprobe(struct kprobe *p, struct pt_regs *regs,

Before this, kprobes checks p != kprobe_running(), but it's a
meaningless branch. Hitting a kprobe while KPROBES_HIT_SS always
treated as unrecoverable.

>   			/* A probe has been hit in the codepath leading up
>   			 * to, or just after, single-stepping of a probed
>   			 * instruction. This entire codepath should strictly
> -			 * reside in .kprobes.text section. Raise a warning
> -			 * to highlight this peculiar case.
> +			 * reside in .kprobes.text section.
> +			 * Raise a BUG or we'll continue in an endless
> +			 * reentering loop and eventually a stack overflow.
>   			 */
> +			arch_disarm_kprobe(p);
> +			dump_kprobe(p);
> +			BUG();
>   		}
>   	default:
>   		/* impossible cases */
> diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
> index bcd9c07..87eb79c 100644
> --- a/include/linux/kprobes.h
> +++ b/include/linux/kprobes.h
> @@ -296,6 +296,8 @@ void recycle_rp_inst(struct kretprobe_instance *ri, struct hlist_head *head);
>   int disable_kprobe(struct kprobe *kp);
>   int enable_kprobe(struct kprobe *kp);
> 
> +void dump_kprobe(struct kprobe *kp);
> +
>   #else /* !CONFIG_KPROBES: */
> 
>   static inline int kprobes_built_in(void)
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index ef177d6..f72e96c 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -1141,6 +1141,13 @@ static void __kprobes kill_kprobe(struct kprobe *p)
>   	arch_remove_kprobe(p);
>   }
> 
> +void __kprobes dump_kprobe(struct kprobe *kp)
> +{
> +	printk(KERN_WARNING "Dumping kprobe:\n");
> +	printk(KERN_WARNING "Name: %s\nAddress: %p\nOffset: %x\n",
> +	       kp->symbol_name, kp->addr, kp->offset);
> +}

Since kp->symbol_name + kp->offset = kp->addr, I recommend to show it
as "Kprobe at %s+%x:<%p>\n", kp->symbol_name, kp->offset, kp->addr.

> +
>   /* Module notifier call back, checking kprobes on the module */
>   static int __kprobes kprobes_module_callback(struct notifier_block *nb,
>   					     unsigned long val, void *data)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

