Return-Path: <linux-kernel-owner+w=401wt.eu-S1752295AbZA1RPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295AbZA1RPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 12:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbZA1RPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 12:15:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:42341 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbZA1RPM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 12:15:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ibA7FmgNJRjfW/Cpcvwo8DLSce74LncKmiV3jOjPCBhmvy1R+hbnGatagf7JgImf08
         Eyx+EnHuijdfzNLMPWndm2VCic5JNpF1npMcjW4L9+20RCZJVL2xaZa0ZY3ncRSccEdy
         knHaScQRky2peWvFSGG88en1MFqLxJLVAMyfg=
MIME-Version: 1.0
In-Reply-To: <20090128170009.GB5365@in.ibm.com>
References: <497F69A4.2070007@intel.com> <20090127224303.GB5850@nowhere>
	 <20090128093821.GA14549@in.ibm.com>
	 <c62985530901280621k54a47515g952cd29444a6054e@mail.gmail.com>
	 <20090128170009.GB5365@in.ibm.com>
Date: Wed, 28 Jan 2009 18:15:10 +0100
Message-ID: <c62985530901280915s75f41cfs1af2489878535e8d@mail.gmail.com>
Subject: Re: [PATCH] tracer for sys_open() - sreadahead
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: ananth@in.ibm.com
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       powertop ml <power@bughost.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       srostedt@redhat.com, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/28 Ananth N Mavinakayanahalli <ananth@in.ibm.com>:
> On Wed, Jan 28, 2009 at 03:21:24PM +0100, Frédéric Weisbecker wrote:
>> 2009/1/28 Ananth N Mavinakayanahalli <ananth@in.ibm.com>:
>> > On Tue, Jan 27, 2009 at 11:43:05PM +0100, Frederic Weisbecker wrote:
>> >> On Tue, Jan 27, 2009 at 12:08:04PM -0800, Kok, Auke wrote:
>
> ...
>
>> > Here is something I did sometime ago that uses utrace. It is per task
>> > doesn't use ftrace and is just intended as a prototype. It traces both
>> > syscalls and returns.
>> >
>> > ---
>> >
>> > Here is the beginnings of a simple utrace based strace. Right now, one
>> > needs to invoke this program with a 'insmod <modname> tid=<tid>'.
>> >
>> > The output looks something like this:
>> > [267352.641112] Attached to 32604 => 0xd8f60090
>> > [267353.981046] 2
>> > [267353.981085] 197 0x1 0xbff8cd84 0x86cff4 0x86d4c0 0x86d4c0 0xbff8cd50a = 0
>> > [267353.981097] 192 0x0 0x1000 0x3 0x22 0xffffffff 0x0 = b7f8d000
>> > [267353.981124] 4 0x1 0xb7f8d000 0xd 0xd 0xb7f8d000 0xbff8cda8 = d
>> > [267353.981174] 4 0x1 0xb7f8d000 0x3 0x3 0xb7f8d000 0xbff8c7dc = 3
>> > [267353.981209] 252 0x0 0x0 0x86e0d0 0x0 0x86b274 0xbff8cee8 =
>> > [267353.981215] Task 32604 exited
>> > [267355.460180] Cannot find PID 32604
>> >
>> > I know strace does a pretty print, but this is a quick and dirty
>> > prototype.
>> > ---
>> >
>> > #include <linux/module.h>
>> > #include <linux/utrace.h>
>> > #include <linux/err.h>
>> > #include <asm/syscall.h>
>> >
>> > MODULE_DESCRIPTION("syscall trace");
>> > MODULE_LICENSE("GPL");
>> >
>> > static int target_tid;
>> >
>> > module_param_named(tid, target_tid, int, 0);
>> >
>> > static u32 task_syscall_entry(u32 action, struct utrace_attached_engine *engine,
>> >                struct task_struct *task, struct pt_regs *regs)
>> > {
>> >        long callno;
>> >        unsigned long args[6];
>> >
>> >        callno = syscall_get_nr(task, regs);
>> >        syscall_get_arguments(task, regs, 0, 6, args);
>> >
>> >        printk(KERN_INFO "%ld 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx = ",
>> >                callno, args[0], args[1], args[2], args[3], args[4], args[5]);
>> >        return UTRACE_RESUME;
>> > }
>> >
>> > static u32 task_syscall_exit(u32 action, struct utrace_attached_engine *engine,
>> >                struct task_struct *task, struct pt_regs *regs)
>> > {
>> >        long retval = syscall_get_return_value(task, regs);
>> >        printk("%lx\n", retval);
>> >        return UTRACE_RESUME;
>> > }
>> >
>> > static u32 task_exit(enum utrace_resume_action action,
>> >                struct utrace_attached_engine *engine, struct task_struct *task,
>> >                long orig_code, long *code)
>> > {
>> >        printk("\n");
>> >        printk(KERN_INFO "Task %d exited\n", target_tid);
>> >        return UTRACE_DETACH;
>> > }
>> >
>> > static const struct utrace_engine_ops syscall_ops =
>> > {
>> >        .report_syscall_entry = task_syscall_entry,
>> >        .report_syscall_exit = task_syscall_exit,
>> >        .report_exit = task_exit,
>> > };
>> >
>> > static int __init strace_init(void)
>> > {
>> >        struct pid *pid;
>> >        int ret = 0;
>> >        struct task_struct *target;
>> >        struct utrace_attached_engine *engine;
>> >
>> >        pid = find_get_pid(target_tid);
>> >        if (pid == NULL) {
>> >                printk(KERN_ERR "Cannot find PID %d\n", target_tid);
>> >                ret = -ESRCH;
>> >                goto out;
>> >        }
>> >
>> >        engine = utrace_attach_pid(pid, UTRACE_ATTACH_CREATE, &syscall_ops, 0);
>> >        if (IS_ERR(engine)) {
>> >                printk(KERN_ERR "utrace_attach_pid: %ld\n", PTR_ERR(engine));
>> >                ret = -EINVAL;
>> >                goto out;
>> >        } else if (engine == NULL) {
>> >                printk(KERN_ERR "utrace_attach_pid => NULL\n");
>> >                ret = -EINVAL;
>> >                goto out;
>> >        } else
>> >                printk(KERN_INFO "Attached to %d => 0x%p\n",
>> >                                target_tid, engine);
>> >
>> >        /*
>> >         * If utrace_attach_pid() succeeded above, we are sure the target
>> >         * is valid here
>> >         */
>> >        target = pid_task(pid, PIDTYPE_PID);
>> >        put_pid(pid);
>> >
>> >        ret = utrace_set_events(target, engine, UTRACE_EVENT_SYSCALL |
>> >                        UTRACE_EVENT(EXIT));
>> >        if (ret)
>> >                printk(KERN_ERR "utrace_set_events returned %d\n", ret);
>> >
>> > out:
>> >        return ret;
>> > }
>> >
>> > static void __exit strace_exit(void)
>> > {
>> >        int ret = 0;
>> >        struct pid *pid;
>> >        struct utrace_attached_engine *engine;
>> >        struct task_struct *target;
>> >
>> >        pid = find_get_pid(target_tid);
>> >        if (pid == NULL) {
>> >                printk(KERN_ERR "Cannot find PID %d\n", target_tid);
>> >                return;
>> >        }
>> >
>> >        target = pid_task(pid, PIDTYPE_PID);
>> >        put_pid(pid);
>> >        engine = utrace_attach_task(target, UTRACE_ATTACH_MATCH_OPS,
>> >                        &syscall_ops, 0);
>> >        if (IS_ERR(engine))
>> >                printk(KERN_ERR "Can't find self: %ld\n", PTR_ERR(engine));
>> >        else if (engine == NULL)
>> >                printk(KERN_ERR "Can't find self: no match\n");
>> >        else {
>> >                printk(KERN_INFO "Trying detach 0x%p from %d\n",
>> >                                engine, target_tid);
>> >                ret = utrace_control(target, engine, UTRACE_DETACH);
>> >                if (ret)
>> >                        printk(KERN_ERR "utrace_control returned %d\n",
>> >                                        ret);
>> >        }
>> > }
>> >
>> > module_init(strace_init);
>> > module_exit(strace_exit);
>> >
>>
>>
>> This is a very convenient Api. I would be glad to use it with ftrace.
>> But, what is it's status currently? Some projects to merge it?
>
> Its currently available as a git tree:
> git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-utrace.git
>
> There is work going on to merge it upstream. Roland McGrath will be able
> to better answer when. However, one of the biggest requirements to merge
> it is an in-kernel user. Hopefully Frank's prototype and/or an ftrace
> integration of the above snippet should be incentive to push for some
> in-tree users :-)
>
> Ananth
>

I hope so. That would be used by the function graph tracer and a
syscall tracer, and probably for other special tracers
needs. If Ingo and Steven are ok with it.
