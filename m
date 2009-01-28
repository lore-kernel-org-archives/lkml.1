Return-Path: <linux-kernel-owner+w=401wt.eu-S1752268AbZA1OVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbZA1OVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 09:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbZA1OV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 09:21:29 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:57201 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbZA1OV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 09:21:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=X738CI84FS3Lkmm7VRv7Ub6ggJJf/d4qKZdMT5i9TGp6R8nFrn2LMla/PGWmweHME2
         5m41LDlWxV4gu/pHyrTTUhYWPXAYc5hbAIAjGJgkMcb8c/JvYOnE/LHx+gHt6yL1KNxF
         aBeBVeDNpcBHUBIYltcnSGoKih6zvl3LxCmbM=
MIME-Version: 1.0
In-Reply-To: <20090128093821.GA14549@in.ibm.com>
References: <497F69A4.2070007@intel.com> <20090127224303.GB5850@nowhere>
	 <20090128093821.GA14549@in.ibm.com>
Date: Wed, 28 Jan 2009 15:21:24 +0100
Message-ID: <c62985530901280621k54a47515g952cd29444a6054e@mail.gmail.com>
Subject: Re: [PATCH] tracer for sys_open() - sreadahead
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: ananth@in.ibm.com
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       powertop ml <power@bughost.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       srostedt@redhat.com, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/28 Ananth N Mavinakayanahalli <ananth@in.ibm.com>:
> On Tue, Jan 27, 2009 at 11:43:05PM +0100, Frederic Weisbecker wrote:
>> On Tue, Jan 27, 2009 at 12:08:04PM -0800, Kok, Auke wrote:
>> >
>> > This tracer monitors regular file open() syscalls. This is a fast
>> > and low-overhead alternative to strace, and does not allow or
>> > require to be attached to every process.
>> >
>> > The tracer only logs succesfull calls, as those are the only ones we
>> > are currently interested in, and we can determine the absolute path
>> > of these files as we log.
>> >
>> > Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
>>
>>
>> Hi Auke,
>>
>> Speaking about a global syscall tracer, I made a patch to trace only the syscalls
>> with the function-graph-tracer.
>>
>> http://lkml.org/lkml/2008/12/30/267
>>
>> Its approach and purpose is different than a tracer dedicated only to syscalls.
>> The function graph tracer traces execution graph of the functions and is more about
>> execution time spent and code flow whereas a syscall tracer can provide more specific
>> informations about syscalls.
>>
>> So both are not overlaping.
>>
>> But the low level part of my patch creates a thread flag _TIF_SYSCALL_TRACE which triggers
>> a ptrace hook when set.
>> This low-level part can easily be used by all tracers that would like to inspect syscalls.
>>
>> Just a change is needed: Steven requested that the part inside syscall_trace_enter become
>> a tracepoint, making it totally shareable between tracers and easy to turn on and off.
>>
>> And perhaps the parts that set/clear the flag on all tasks can be shared too.
>>
>> So we can start with this low-level syscall tracing facility. If you want, I can adapt
>> this low-level part and submit a patch this week or the next one to give you this base
>> infrastructure.
>>
>>
>> Once we have it, I think a syscall tracer can be fed with new syscalls events through
>> several patch iterations, starting with the open and close one :-)
>
> Here is something I did sometime ago that uses utrace. It is per task
> doesn't use ftrace and is just intended as a prototype. It traces both
> syscalls and returns.
>
> ---
>
> Here is the beginnings of a simple utrace based strace. Right now, one
> needs to invoke this program with a 'insmod <modname> tid=<tid>'.
>
> The output looks something like this:
> [267352.641112] Attached to 32604 => 0xd8f60090
> [267353.981046] 2
> [267353.981085] 197 0x1 0xbff8cd84 0x86cff4 0x86d4c0 0x86d4c0 0xbff8cd50a = 0
> [267353.981097] 192 0x0 0x1000 0x3 0x22 0xffffffff 0x0 = b7f8d000
> [267353.981124] 4 0x1 0xb7f8d000 0xd 0xd 0xb7f8d000 0xbff8cda8 = d
> [267353.981174] 4 0x1 0xb7f8d000 0x3 0x3 0xb7f8d000 0xbff8c7dc = 3
> [267353.981209] 252 0x0 0x0 0x86e0d0 0x0 0x86b274 0xbff8cee8 =
> [267353.981215] Task 32604 exited
> [267355.460180] Cannot find PID 32604
>
> I know strace does a pretty print, but this is a quick and dirty
> prototype.
> ---
>
> #include <linux/module.h>
> #include <linux/utrace.h>
> #include <linux/err.h>
> #include <asm/syscall.h>
>
> MODULE_DESCRIPTION("syscall trace");
> MODULE_LICENSE("GPL");
>
> static int target_tid;
>
> module_param_named(tid, target_tid, int, 0);
>
> static u32 task_syscall_entry(u32 action, struct utrace_attached_engine *engine,
>                struct task_struct *task, struct pt_regs *regs)
> {
>        long callno;
>        unsigned long args[6];
>
>        callno = syscall_get_nr(task, regs);
>        syscall_get_arguments(task, regs, 0, 6, args);
>
>        printk(KERN_INFO "%ld 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx = ",
>                callno, args[0], args[1], args[2], args[3], args[4], args[5]);
>        return UTRACE_RESUME;
> }
>
> static u32 task_syscall_exit(u32 action, struct utrace_attached_engine *engine,
>                struct task_struct *task, struct pt_regs *regs)
> {
>        long retval = syscall_get_return_value(task, regs);
>        printk("%lx\n", retval);
>        return UTRACE_RESUME;
> }
>
> static u32 task_exit(enum utrace_resume_action action,
>                struct utrace_attached_engine *engine, struct task_struct *task,
>                long orig_code, long *code)
> {
>        printk("\n");
>        printk(KERN_INFO "Task %d exited\n", target_tid);
>        return UTRACE_DETACH;
> }
>
> static const struct utrace_engine_ops syscall_ops =
> {
>        .report_syscall_entry = task_syscall_entry,
>        .report_syscall_exit = task_syscall_exit,
>        .report_exit = task_exit,
> };
>
> static int __init strace_init(void)
> {
>        struct pid *pid;
>        int ret = 0;
>        struct task_struct *target;
>        struct utrace_attached_engine *engine;
>
>        pid = find_get_pid(target_tid);
>        if (pid == NULL) {
>                printk(KERN_ERR "Cannot find PID %d\n", target_tid);
>                ret = -ESRCH;
>                goto out;
>        }
>
>        engine = utrace_attach_pid(pid, UTRACE_ATTACH_CREATE, &syscall_ops, 0);
>        if (IS_ERR(engine)) {
>                printk(KERN_ERR "utrace_attach_pid: %ld\n", PTR_ERR(engine));
>                ret = -EINVAL;
>                goto out;
>        } else if (engine == NULL) {
>                printk(KERN_ERR "utrace_attach_pid => NULL\n");
>                ret = -EINVAL;
>                goto out;
>        } else
>                printk(KERN_INFO "Attached to %d => 0x%p\n",
>                                target_tid, engine);
>
>        /*
>         * If utrace_attach_pid() succeeded above, we are sure the target
>         * is valid here
>         */
>        target = pid_task(pid, PIDTYPE_PID);
>        put_pid(pid);
>
>        ret = utrace_set_events(target, engine, UTRACE_EVENT_SYSCALL |
>                        UTRACE_EVENT(EXIT));
>        if (ret)
>                printk(KERN_ERR "utrace_set_events returned %d\n", ret);
>
> out:
>        return ret;
> }
>
> static void __exit strace_exit(void)
> {
>        int ret = 0;
>        struct pid *pid;
>        struct utrace_attached_engine *engine;
>        struct task_struct *target;
>
>        pid = find_get_pid(target_tid);
>        if (pid == NULL) {
>                printk(KERN_ERR "Cannot find PID %d\n", target_tid);
>                return;
>        }
>
>        target = pid_task(pid, PIDTYPE_PID);
>        put_pid(pid);
>        engine = utrace_attach_task(target, UTRACE_ATTACH_MATCH_OPS,
>                        &syscall_ops, 0);
>        if (IS_ERR(engine))
>                printk(KERN_ERR "Can't find self: %ld\n", PTR_ERR(engine));
>        else if (engine == NULL)
>                printk(KERN_ERR "Can't find self: no match\n");
>        else {
>                printk(KERN_INFO "Trying detach 0x%p from %d\n",
>                                engine, target_tid);
>                ret = utrace_control(target, engine, UTRACE_DETACH);
>                if (ret)
>                        printk(KERN_ERR "utrace_control returned %d\n",
>                                        ret);
>        }
> }
>
> module_init(strace_init);
> module_exit(strace_exit);
>


This is a very convenient Api. I would be glad to use it with ftrace.
But, what is it's status currently? Some projects to merge it?
