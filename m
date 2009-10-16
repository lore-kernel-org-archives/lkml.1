Return-Path: <linux-kernel-owner+w=401wt.eu-S1754447AbZJPG1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbZJPG1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 02:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbZJPG1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 02:27:10 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:3601 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbZJPG1I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 02:27:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=FMDoG44nJKg8DZqmTYiFxbwIXy78syo5P9ZWRCJp8BFpXKACbbnl8Y1Xfb+7KoLWRF
         azrfjEQAcs4Wy6Dkp6IhKGqF4EAKyqjDI6Q6ii2iaKKzNSyiPv4wKvDIOctC4lsl4axh
         HvJqKIqy7MfM6kGzqXtPB1LtnmOGbfQ07mLZI=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20091016042041.GA7220@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com>
	 <20091013045439.GI28435@us.ibm.com> <20091016042041.GA7220@us.ibm.com>
Date: Fri, 16 Oct 2009 08:25:59 +0200
Message-ID: <cfd18e0f0910152325m4a9125c2q18f36f5bd7d4a0@mail.gmail.com>
Subject: Re: [RFC][v8][PATCH 9/10]: Define clone3() syscall
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       serue@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de,
       peterz@infradead.org, Louis.Rilling@kerlabs.com, roland@redhat.com,
       kosaki.motohiro@jp.fujitsu.com, randy.dunlap@oracle.com,
       linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com,
       Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sukadev

On Fri, Oct 16, 2009 at 6:20 AM, Sukadev Bhattiprolu
<sukadev@linux.vnet.ibm.com> wrote:
> Here is an updated patch with the following interface:
>
>        long sys_clone3(unsigned int flags_low, struct clone_args __user *cs,
>                        pid_t *pids);
>
> There are just two other (minor) changes pending to this patchset:
>
>        - PATCH 7: add a CLONE_UNUSED bit to VALID_CLONE_FLAGS().
>        - PATCH 10: update documentation to reflect new interface.
>
> If this looks ok, we repost entire patchset next week.

I know I'm late to this discussion, but why the name clone3()? It's
not consistent with any other convention used fo syscall naming,
AFAICS. I think a name like clone_ext() or clonex() (for extended)
might make more sense.

Cheers,

Michael


> ---
>
> Subject: [RFC][v8][PATCH 9/10]: Define clone3() syscall
>
> Container restart requires that a task have the same pid it had when it was
> checkpointed. When containers are nested the tasks within the containers
> exist in multiple pid namespaces and hence have multiple pids to specify
> during restart.
>
> clone3(), intended for use during restart, is the same as clone(), except
> that it takes a 'pids' paramter. This parameter lets caller choose
> specific pid numbers for the child process, in the process's active and
> ancestor pid namespaces. (Descendant pid namespaces in general don't matter
> since processes don't have pids in them anyway, but see comments in
> copy_target_pids() regarding CLONE_NEWPID).
>
> Clone2() system call also attempts to address a second limitation of the
> clone() system call. clone() is restricted to 32 clone flags and most (all ?)
> of these are in use. If a new clone flag is needed, we will be forced to
> define a new variant of the clone() system call.
>
> To prevent unprivileged processes from misusing this interface, clone3()
> currently needs CAP_SYS_ADMIN, when the 'pids' parameter is non-NULL.
>
> See Documentation/clone3 in next patch for more details of clone3() and an
> example of its usage.
>
> NOTE:
>        - System calls are restricted to 6 parameters and the number and sizes
>          of parameters needed for sys_clone3() exceed 6 integers. The new
>          prototype works around this restriction while providing some
>          flexibility if clone3() needs to be further extended in the future.
> TODO:
>        - We should convert clone-flags to 64-bit value in all architectures.
>          Its probably best to do that as a separate patchset since clone_flags
>          touches several functions and that patchset seems independent of this
>          new system call.
>
>
> Changelog[v9-rc1]:
>        - [Roland McGrath, H. Peter Anvin] To avoid confusion on 64-bit
>          architectures split the new clone-flags into 'low' and 'high'
>          words and pass in the 'lower' flags as the first argument.
>          This would maintain similarity of the clone3() with clone()/
>          clone2(). Also has the side-effect of the name matching the
>          number of parameters :-)
>        - [Roland McGrath] Rename structure to 'clone_args' and add a
>          'child_stack_size' field
>
> Changelog[v8]
>        - [Oren Laadan] parent_tid and child_tid fields in 'struct clone_arg'
>          must be 64-bit.
>        - clone2() is in use in IA64. Rename system call to clone3().
>
> Changelog[v7]:
>        - [Peter Zijlstra, Arnd Bergmann] Rename system call to clone2()
>          and group parameters into a new 'struct clone_struct' object.
>
> Changelog[v6]:
>        - (Nathan Lynch, Arnd Bergmann, H. Peter Anvin, Linus Torvalds)
>          Change 'pid_set.pids' to a 'pid_t pids[]' so size of 'struct pid_set'
>          is constant across architectures.
>        - (Nathan Lynch) Change pid_set.num_pids to unsigned and remove
>          'unum_pids < 0' check.
>
> Changelog[v4]:
>        - (Oren Laadan) rename 'struct target_pid_set' to 'struct pid_set'
>
> Changelog[v3]:
>        - (Oren Laadan) Allow CLONE_NEWPID flag (by allocating an extra pid
>          in the target_pids[] list and setting it 0. See copy_target_pids()).
>        - (Oren Laadan) Specified target pids should apply only to youngest
>          pid-namespaces (see copy_target_pids())
>        - (Matt Helsley) Update patch description.
>
> Changelog[v2]:
>        - Remove unnecessary printk and add a note to callers of
>          copy_target_pids() to free target_pids.
>        - (Serge Hallyn) Mention CAP_SYS_ADMIN restriction in patch description.
>        - (Oren Laadan) Add checks for 'num_pids < 0' (return -EINVAL) and
>          'num_pids == 0' (fall back to normal clone()).
>        - Move arch-independent code (sanity checks and copy-in of target-pids)
>          into kernel/fork.c and simplify sys_clone_with_pids()
>
> Changelog[v1]:
>        - Fixed some compile errors (had fixed these errors earlier in my
>          git tree but had not refreshed patches before emailing them)
>
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
>
> ---
>  arch/x86/include/asm/syscalls.h    |    2
>  arch/x86/include/asm/unistd_32.h   |    1
>  arch/x86/kernel/process_32.c       |   61 +++++++++++++++++++++++
>  arch/x86/kernel/syscall_table_32.S |    1
>  include/linux/types.h              |   11 ++++
>  kernel/fork.c                      |   96 ++++++++++++++++++++++++++++++++++++-
>  6 files changed, 171 insertions(+), 1 deletion(-)
>
> Index: linux-2.6/include/linux/types.h
> ===================================================================
> --- linux-2.6.orig/include/linux/types.h        2009-10-15 20:29:47.000000000 -0700
> +++ linux-2.6/include/linux/types.h     2009-10-15 20:53:22.000000000 -0700
> @@ -204,6 +204,17 @@ struct ustat {
>        char                    f_fpack[6];
>  };
>
> +struct clone_args {
> +       u64 clone_flags_high;
> +       u64 child_stack_base;
> +       u64 child_stack_size;
> +       u64 parent_tid_ptr;
> +       u64 child_tid_ptr;
> +       u32 nr_pids;
> +       u32 clone_args_size;
> +       u64 reserved1;
> +};
> +
>  #endif /* __KERNEL__ */
>  #endif /*  __ASSEMBLY__ */
>  #endif /* _LINUX_TYPES_H */
> Index: linux-2.6/arch/x86/include/asm/syscalls.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/syscalls.h      2009-10-15 20:29:47.000000000 -0700
> +++ linux-2.6/arch/x86/include/asm/syscalls.h   2009-10-15 20:38:53.000000000 -0700
> @@ -55,6 +55,8 @@ struct sel_arg_struct;
>  struct oldold_utsname;
>  struct old_utsname;
>
> +asmlinkage long sys_clone3(unsigned int flags_low,
> +                       struct clone_args __user *cs, pid_t *pids);
>  asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
>                          unsigned long, unsigned long, unsigned long);
>  asmlinkage int old_mmap(struct mmap_arg_struct __user *);
> Index: linux-2.6/arch/x86/include/asm/unistd_32.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/unistd_32.h     2009-10-15 20:29:47.000000000 -0700
> +++ linux-2.6/arch/x86/include/asm/unistd_32.h  2009-10-15 20:38:53.000000000 -0700
> @@ -342,6 +342,7 @@
>  #define __NR_pwritev           334
>  #define __NR_rt_tgsigqueueinfo 335
>  #define __NR_perf_counter_open 336
> +#define __NR_clone3            337
>
>  #ifdef __KERNEL__
>
> Index: linux-2.6/arch/x86/kernel/process_32.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/process_32.c 2009-10-15 20:29:47.000000000 -0700
> +++ linux-2.6/arch/x86/kernel/process_32.c      2009-10-15 20:38:53.000000000 -0700
> @@ -443,6 +443,67 @@ int sys_clone(struct pt_regs *regs)
>        return do_fork(clone_flags, newsp, regs, 0, parent_tidptr, child_tidptr);
>  }
>
> +asmlinkage long
> +sys_clone3(unsigned int flags_low, struct clone_args __user *ucs,
> +               pid_t __user *pids)
> +{
> +       int rc;
> +       struct clone_args kcs;
> +       unsigned long flags;
> +       int __user *parent_tid_ptr;
> +       int __user *child_tid_ptr;
> +       unsigned long __user child_stack;
> +       unsigned long stack_size;
> +       struct pt_regs *regs;
> +
> +       rc = copy_from_user(&kcs, ucs, sizeof(kcs));
> +       if (rc)
> +               return -EFAULT;
> +
> +       /*
> +        * TODO: If size of clone_args is not what the kernel expects, it
> +        *       could be that kernel is newer and has an extended structure.
> +        *       When that happens, this check needs to be smarter (and we
> +        *       need an additional copy_from_user()). For now, assume exact
> +        *       match.
> +        */
> +       if (kcs.clone_args_size != sizeof(kcs))
> +               return -EINVAL;
> +
> +       /*
> +        * To avoid future compatibility issues, ensure unused fields are 0.
> +        */
> +       if (kcs.reserved1 || kcs.clone_flags_high)
> +               return -EINVAL;
> +
> +       /*
> +        * TODO: Convert 'clone-flags' to 64-bits on all architectures.
> +        * TODO: When ->clone_flags_high is non-zero, copy it in to the
> +        *       higher word(s) of 'flags':
> +        *
> +        *              flags = (kcs.clone_flags_high << 32) | flags_low;
> +        */
> +       flags = flags_low;
> +       parent_tid_ptr = (int *)kcs.parent_tid_ptr;
> +       child_tid_ptr =  (int *)kcs.child_tid_ptr;
> +
> +       stack_size = (unsigned long)kcs.child_stack_size;
> +       child_stack = (unsigned long)kcs.child_stack_base + stack_size;
> +
> +       regs = task_pt_regs(current);
> +
> +       if (!child_stack)
> +               child_stack = user_stack_pointer(regs);
> +
> +       /*
> +        * TODO: On 32-bit systems, clone_flags is passed in as 32-bit value
> +        *       to several functions. Need to convert clone_flags to 64-bit.
> +        */
> +       return do_fork_with_pids(flags, child_stack, regs, stack_size,
> +                               parent_tid_ptr, child_tid_ptr, kcs.nr_pids,
> +                               pids);
> +}
> +
>  /*
>  * sys_execve() executes a new program.
>  */
> Index: linux-2.6/arch/x86/kernel/syscall_table_32.S
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/syscall_table_32.S   2009-10-15 20:29:47.000000000 -0700
> +++ linux-2.6/arch/x86/kernel/syscall_table_32.S        2009-10-15 20:38:53.000000000 -0700
> @@ -336,3 +336,4 @@ ENTRY(sys_call_table)
>        .long sys_pwritev
>        .long sys_rt_tgsigqueueinfo     /* 335 */
>        .long sys_perf_counter_open
> +       .long sys_clone3
> Index: linux-2.6/kernel/fork.c
> ===================================================================
> --- linux-2.6.orig/kernel/fork.c        2009-10-15 20:38:50.000000000 -0700
> +++ linux-2.6/kernel/fork.c     2009-10-15 20:38:53.000000000 -0700
> @@ -1330,6 +1330,86 @@ struct task_struct * __cpuinit fork_idle
>  }
>
>  /*
> + * If user specified any 'target-pids' in @upid_setp, copy them from
> + * user and return a pointer to a local copy of the list of pids. The
> + * caller must free the list, when they are done using it.
> + *
> + * If user did not specify any target pids, return NULL (caller should
> + * treat this like normal clone).
> + *
> + * On any errors, return the error code
> + */
> +static pid_t *copy_target_pids(int unum_pids, pid_t __user *upids)
> +{
> +       int j;
> +       int rc;
> +       int size;
> +       int knum_pids;          /* # of pids needed in kernel */
> +       pid_t *target_pids;
> +
> +       if (!unum_pids)
> +               return NULL;
> +
> +       knum_pids = task_pid(current)->level + 1;
> +       if (unum_pids > knum_pids)
> +               return ERR_PTR(-EINVAL);
> +
> +       /*
> +        * To keep alloc_pid() simple, allocate an extra pid_t in target_pids[]
> +        * and set it to 0. This last entry in target_pids[] corresponds to the
> +        * (yet-to-be-created) descendant pid-namespace if CLONE_NEWPID was
> +        * specified. If CLONE_NEWPID was not specified, this last entry will
> +        * simply be ignored.
> +        */
> +       target_pids = kzalloc((knum_pids + 1) * sizeof(pid_t), GFP_KERNEL);
> +       if (!target_pids)
> +               return ERR_PTR(-ENOMEM);
> +
> +       /*
> +        * A process running in a level 2 pid namespace has three pid namespaces
> +        * and hence three pid numbers. If this process is checkpointed,
> +        * information about these three namespaces are saved. We refer to these
> +        * namespaces as 'known namespaces'.
> +        *
> +        * If this checkpointed process is however restarted in a level 3 pid
> +        * namespace, the restarted process has an extra ancestor pid namespace
> +        * (i.e 'unknown namespace') and 'knum_pids' exceeds 'unum_pids'.
> +        *
> +        * During restart, the process requests specific pids for its 'known
> +        * namespaces' and lets kernel assign pids to its 'unknown namespaces'.
> +        *
> +        * Since the requested-pids correspond to 'known namespaces' and since
> +        * 'known-namespaces' are younger than (i.e descendants of) 'unknown-
> +        * namespaces', copy requested pids to the back-end of target_pids[]
> +        * (i.e before the last entry for CLONE_NEWPID mentioned above).
> +        * Any entries in target_pids[] not corresponding to a requested pid
> +        * will be set to zero and kernel assigns a pid in those namespaces.
> +        *
> +        * NOTE: The order of pids in target_pids[] is oldest pid namespace to
> +        *       youngest (target_pids[0] corresponds to init_pid_ns). i.e.
> +        *       the order is:
> +        *
> +        *              - pids for 'unknown-namespaces' (if any)
> +        *              - pids for 'known-namespaces' (requested pids)
> +        *              - 0 in the last entry (for CLONE_NEWPID).
> +        */
> +       j = knum_pids - unum_pids;
> +       size = unum_pids * sizeof(pid_t);
> +
> +       rc = copy_from_user(&target_pids[j], upids, size);
> +       if (rc) {
> +               rc = -EFAULT;
> +               goto out_free;
> +       }
> +
> +       return target_pids;
> +
> +out_free:
> +       kfree(target_pids);
> +       return ERR_PTR(rc);
> +}
> +
> +/*
>  *  Ok, this is the main fork-routine.
>  *
>  * It copies the process, and if successful kick-starts
> @@ -1347,7 +1427,7 @@ long do_fork_with_pids(unsigned long clo
>        struct task_struct *p;
>        int trace = 0;
>        long nr;
> -       pid_t *target_pids = NULL;
> +       pid_t *target_pids;
>
>        /*
>         * Do some preliminary argument and permissions checking before we
> @@ -1381,6 +1461,16 @@ long do_fork_with_pids(unsigned long clo
>                }
>        }
>
> +       target_pids = copy_target_pids(num_pids, upids);
> +       if (target_pids) {
> +               if (IS_ERR(target_pids))
> +                       return PTR_ERR(target_pids);
> +
> +               nr = -EPERM;
> +               if (!capable(CAP_SYS_ADMIN))
> +                       goto out_free;
> +       }
> +
>        /*
>         * When called from kernel_thread, don't do user tracing stuff.
>         */
> @@ -1442,6 +1532,10 @@ long do_fork_with_pids(unsigned long clo
>        } else {
>                nr = PTR_ERR(p);
>        }
> +
> +out_free:
> +       kfree(target_pids);
> +
>        return nr;
>  }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface" http://blog.man7.org/
