Return-Path: <linux-kernel-owner+w=401wt.eu-S1422919AbXD3Dsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422919AbXD3Dsc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 23:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422926AbXD3Dsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 23:48:32 -0400
Received: from smtp-out.google.com ([216.239.33.17]:4466 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422919AbXD3Dsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 23:48:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Be6WTiTsa4j347mU/WSo04N+npHNKSmT5XllY6Tcua5awkzPba+xaJ6p/wC6yNWLs
	Bgak+HQtGuVSha7gLAa7g==
Message-ID: <cc96a5040704292048x211af9a9t5bfe60d942874ae1@mail.gmail.com>
Date: Sun, 29 Apr 2007 20:48:20 -0700
From: "Tim Hockin" <thockin@google.com>
To: ak@suse.de, vojtech@suse.cz
Subject: Re: [PATCH] x86_64: support poll() on /dev/mcelog
Cc: linux-kernel@vger.kernel.org, akpm@google.com
In-Reply-To: <20070430022406.GA10158@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070430022406.GA10158@google.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Crap - I have just got soft lockup detected.  Back to debug.

Call Trace:
 <IRQ>  [<ffffffff80227e80>] wake_up_process+0x10/0x20
  [<ffffffff8025361a>] softlockup_tick+0xea/0x110
  [<ffffffff80235d53>] run_local_timers+0x13/0x20
  [<ffffffff80235e67>] update_process_times+0x57/0x90
  [<ffffffff802116b0>] mcheck_check_cpu+0x0/0x40
  [<ffffffff80214bd4>] smp_local_timer_interrupt+0x34/0x60
  [<ffffffff8021538e>] smp_apic_timer_interrupt+0x4e/0x70
  [<ffffffff8020a436>] apic_timer_interrupt+0x66/0x70


On 4/29/07, Tim Hockin <thockin@google.com> wrote:
> From: Tim Hockin <thockin@google.com>
>
> Background:
>  /dev/mcelog is typically polled manually.  This is less than optimal for
>  some situations.  Calling poll() on /dev/mcelog does not work.
>
> Description:
>  This patch adds support for poll() to /dev/mcelog.  This results in
>  immediate wakeup of user apps whenever the poller finds MCEs.  Because
>  the exception handler can not take any locks, it can not call the wakeup
>  itself.  Instead, it uses a thread_info flag (TIF_MCE_NOTIFY) which is
>  caught at the next return from interrupt, calling the mce_user_notify()
>  routine.
>
>  This patch also does some small cleanup for essentially unused variables,
>  and moves the user notification into the body of the poller, so it is
>  only called once, rather than once per CPU.
>
> Result:
>  Applications can now poll() on /dev/mcelog.  When an error is logged
>  (whether through the poller or through an exception) the applications are
>  woken up promptly.  This should not affect any previous behaviors.  If no
>  MCEs are being logged, there is no overhead.
>
> Alternatives:
>  I considered simply supporting poll() through the poller and not using
>  TIF_MCE_NOTIFY at all.  However, the time between an uncorrectable error
>  happening and the user application being notified is *the*most* critical
>  window for us.  Many uncorrectable errors can be logged to the network if
>  given a chance.
>
> Testing:
>  I used an error-injecting DIMM to create lots of correctable DRAM errors
>  and verified that my user app is woken up in sync with the polling interval.
>  I also used the northbridge to inject uncorrectable ECC errors, and
>  verified (printk() to the rescue) that the notify routine is called and the
>  user app does wake up.
>
> Patch:
>  This patch is against 2.6.21-rc7.
>
> Signed-Off-By: Tim Hockin <thockin@google.com>
>
> ---
>
> This is the first public version version of this patch.  The TIF_*
> approach was suggested by Mike Waychison and Andi did not yell at me when
> I suggested it. :)
>
>
> diff -pruN linux-2.6.20+th/arch/x86_64/kernel/entry.S linux-2.6.20+th2v2/arch/x86_64/kernel/entry.S
> --- linux-2.6.20+th/arch/x86_64/kernel/entry.S  2007-04-24 22:46:19.000000000 -0700
> +++ linux-2.6.20+th2v2/arch/x86_64/kernel/entry.S       2007-04-29 18:10:40.000000000 -0700
> @@ -585,7 +585,7 @@ bad_iret:
>  retint_careful:
>         CFI_RESTORE_STATE
>         bt    $TIF_NEED_RESCHED,%edx
> -       jnc   retint_signal
> +       jnc   retint_mce
>         TRACE_IRQS_ON
>         sti
>         pushq %rdi
> @@ -597,7 +597,23 @@ retint_careful:
>         cli
>         TRACE_IRQS_OFF
>         jmp retint_check
> -
> +
> +       /* handle a waiting machine check */
> +retint_mce:
> +       bt $TIF_MCE_NOTIFY,%edx
> +       jnc retint_signal
> +       TRACE_IRQS_ON
> +       sti
> +       pushq %rdi
> +       CFI_ADJUST_CFA_OFFSET   8
> +       call mce_notify_user
> +       popq %rdi
> +       CFI_ADJUST_CFA_OFFSET   -8
> +       GET_THREAD_INFO(%rcx)
> +       cli
> +       TRACE_IRQS_OFF
> +       jmp retint_check
> +
>  retint_signal:
>         testl $(_TIF_SIGPENDING|_TIF_NOTIFY_RESUME|_TIF_SINGLESTEP),%edx
>         jz    retint_swapgs
> diff -pruN linux-2.6.20+th/arch/x86_64/kernel/mce.c linux-2.6.20+th2v2/arch/x86_64/kernel/mce.c
> --- linux-2.6.20+th/arch/x86_64/kernel/mce.c    2007-04-27 14:19:08.000000000 -0700
> +++ linux-2.6.20+th2v2/arch/x86_64/kernel/mce.c 2007-04-29 18:27:22.000000000 -0700
> @@ -20,6 +20,8 @@
>  #include <linux/percpu.h>
>  #include <linux/ctype.h>
>  #include <linux/kmod.h>
> +#include <linux/poll.h>
> +#include <linux/thread_info.h>
>  #include <asm/processor.h>
>  #include <asm/msr.h>
>  #include <asm/mce.h>
> @@ -39,8 +41,7 @@ static int mce_dont_init;
>  static int tolerant = 1;
>  static int banks;
>  static unsigned long bank[NR_BANKS] = { [0 ... NR_BANKS-1] = ~0UL };
> -static unsigned long console_logged;
> -static int notify_user;
> +static unsigned long notify_user;
>  static int rip_msr;
>  static int mce_bootlog = 1;
>  static atomic_t mce_events;
> @@ -48,6 +49,8 @@ static atomic_t mce_events;
>  static char trigger[128];
>  static char *trigger_argv[2] = { trigger, NULL };
>
> +static DECLARE_WAIT_QUEUE_HEAD(mce_wait);
> +
>  /*
>   * Lockless MCE logging infrastructure.
>   * This avoids deadlocks on printk locks without having to break locks. Also
> @@ -94,8 +97,7 @@ void mce_log(struct mce *mce)
>         mcelog.entry[entry].finished = 1;
>         wmb();
>
> -       if (!test_and_set_bit(0, &console_logged))
> -               notify_user = 1;
> +       set_bit(0, &notify_user);
>  }
>
>  static void print_mce(struct mce *m)
> @@ -167,15 +169,19 @@ static inline void mce_get_rip(struct mc
>         }
>  }
>
> -static void do_mce_trigger(void)
> +/*
> + * This is only called in normal interrupt context.  This is where we do
> + * anything we need to alert userspace.  This is called directly from the
> + * poller and also from entry.S thanks to TIF_MCE_NOTIFY.
> + */
> +void mce_notify_user(void)
>  {
> -       static atomic_t mce_logged;
> -       int events = atomic_read(&mce_events);
> -       if (events != atomic_read(&mce_logged) && trigger[0]) {
> -               /* Small race window, but should be harmless.  */
> -               atomic_set(&mce_logged, events);
> +       clear_thread_flag(TIF_MCE_NOTIFY);
> +       clear_bit(0, &notify_user);
> +
> +       wake_up_interruptible(&mce_wait);
> +       if (trigger[0])
>                 call_usermodehelper(trigger, trigger_argv, NULL, -1);
> -       }
>  }
>
>  /*
> @@ -251,12 +257,8 @@ void do_machine_check(struct pt_regs * r
>         }
>
>         /* Never do anything final in the polling timer */
> -       if (!regs) {
> -               /* Normal interrupt context here. Call trigger for any new
> -                  events. */
> -               do_mce_trigger();
> +       if (!regs)
>                 goto out;
> -       }
>
>         /* If we didn't find an uncorrectable error, pick
>            the last one (shouldn't happen, just being safe). */
> @@ -288,6 +290,9 @@ void do_machine_check(struct pt_regs * r
>                         do_exit(SIGBUS);
>         }
>
> +       /* notify userspace ASAP */
> +       set_thread_flag(TIF_MCE_NOTIFY);
> +
>   out:
>         /* Last thing done in the machine check exception to clear state. */
>         wrmsrl(MSR_IA32_MCG_STATUS, 0);
> @@ -344,20 +349,18 @@ static void mcheck_timer(struct work_str
>         on_each_cpu(mcheck_check_cpu, NULL, 1, 1);
>
>         /*
> -        * It's ok to read stale data here for notify_user and
> -        * console_logged as we'll simply get the updated versions
> -        * on the next mcheck_timer execution and atomic operations
> -        * on console_logged act as synchronization for notify_user
> -        * writes.
> +        * It's ok to read stale data here for notify_user as we'll simply
> +        * get the updated version on the next mcheck_timer execution.
>          */
> -       if (notify_user && console_logged) {
> +       if (notify_user) {
>                 static unsigned long last_print;
>                 unsigned long now = jiffies;
>
> +               /* alert userspace */
> +               mce_notify_user();
> +
>                 /* if we logged an MCE, reduce the polling interval */
>                 next_interval = max(next_interval/2, HZ/100);
> -               notify_user = 0;
> -               clear_bit(0, &console_logged);
>                 if (time_after_eq(now, last_print + (check_interval*HZ))) {
>                         last_print = now;
>                         printk(KERN_INFO "Machine check events logged\n");
> @@ -530,6 +533,14 @@ static ssize_t mce_read(struct file *fil
>         return err ? -EFAULT : buf - ubuf;
>  }
>
> +static unsigned int mce_poll(struct file *file, poll_table *wait)
> +{
> +       poll_wait(file, &mce_wait, wait);
> +       if (rcu_dereference(mcelog.next))
> +               return POLLIN | POLLRDNORM;
> +       return 0;
> +}
> +
>  static int mce_ioctl(struct inode *i, struct file *f,unsigned int cmd, unsigned long arg)
>  {
>         int __user *p = (int __user *)arg;
> @@ -554,6 +565,7 @@ static int mce_ioctl(struct inode *i, st
>
>  static const struct file_operations mce_chrdev_ops = {
>         .read = mce_read,
> +       .poll = mce_poll,
>         .ioctl = mce_ioctl,
>  };
>
> diff -pruN linux-2.6.20+th/include/asm-x86_64/thread_info.h linux-2.6.20+th2v2/include/asm-x86_64/thread_info.h
> --- linux-2.6.20+th/include/asm-x86_64/thread_info.h    2007-02-04 10:44:54.000000000 -0800
> +++ linux-2.6.20+th2v2/include/asm-x86_64/thread_info.h 2007-04-27 23:13:59.000000000 -0700
> @@ -115,6 +115,7 @@ static inline struct thread_info *stack_
>  #define TIF_SYSCALL_AUDIT      7       /* syscall auditing active */
>  #define TIF_SECCOMP            8       /* secure computing */
>  #define TIF_RESTORE_SIGMASK    9       /* restore signal mask in do_signal */
> +#define TIF_MCE_NOTIFY         10      /* notify userspace of an MCE */
>  /* 16 free */
>  #define TIF_IA32               17      /* 32bit process */
>  #define TIF_FORK               18      /* ret_from_fork */
> @@ -133,6 +134,7 @@ static inline struct thread_info *stack_
>  #define _TIF_SYSCALL_AUDIT     (1<<TIF_SYSCALL_AUDIT)
>  #define _TIF_SECCOMP           (1<<TIF_SECCOMP)
>  #define _TIF_RESTORE_SIGMASK   (1<<TIF_RESTORE_SIGMASK)
> +#define _TIF_MCE_NOTIFY                (1<<TIF_MCE_NOTIFY)
>  #define _TIF_IA32              (1<<TIF_IA32)
>  #define _TIF_FORK              (1<<TIF_FORK)
>  #define _TIF_ABI_PENDING       (1<<TIF_ABI_PENDING)
>
