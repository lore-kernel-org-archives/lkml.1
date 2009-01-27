Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbZA0WvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbZA0WvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 17:51:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbZA0Wuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 17:50:55 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:10514 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbZA0Wuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 17:50:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VGL6wSRlb0WovNouKVbxsdKlPGBs4LoXdmwFSM1U/0DWQIX4ozSNUiog5h9jONjVFg
         2zwa38w3glOHgngjwdPkmafDBgHKkmHEeOzbDtRxOTM/fnsxHp/8iWPYmHq58gszg7nx
         KrGkV7ABxUpn1S3YZPA4rhpeeeff361zL3/HI=
Date: Tue, 27 Jan 2009 23:50:49 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       powertop ml <power@bughost.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       srostedt@redhat.com, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] tracer for sys_open() - sreadahead
Message-ID: <20090127225048.GA4652@nowhere>
References: <497F69A4.2070007@intel.com> <20090127224303.GB5850@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127224303.GB5850@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 11:43:03PM +0100, Frederic Weisbecker wrote:
> On Tue, Jan 27, 2009 at 12:08:04PM -0800, Kok, Auke wrote:
> > 
> > This tracer monitors regular file open() syscalls. This is a fast
> > and low-overhead alternative to strace, and does not allow or
> > require to be attached to every process.
> > 
> > The tracer only logs succesfull calls, as those are the only ones we
> > are currently interested in, and we can determine the absolute path
> > of these files as we log.
> > 
> > Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
> 
> 
> Hi Auke,
> 
> Speaking about a global syscall tracer, I made a patch to trace only the syscalls
> with the function-graph-tracer.
> 
> http://lkml.org/lkml/2008/12/30/267
> 
> Its approach and purpose is different than a tracer dedicated only to syscalls.
> The function graph tracer traces execution graph of the functions and is more about
> execution time spent and code flow whereas a syscall tracer can provide more specific
> informations about syscalls.
> 
> So both are not overlaping.
> 
> But the low level part of my patch creates a thread flag _TIF_SYSCALL_TRACE which triggers

s/_TIF_SYSCALL_TRACE/_TIF_SYSCALL_FTRACE

_TIF_SYSCALL_TRACE is the one used by ptrace.


> a ptrace hook when set.
> This low-level part can easily be used by all tracers that would like to inspect syscalls.
> 
> Just a change is needed: Steven requested that the part inside syscall_trace_enter become
> a tracepoint, making it totally shareable between tracers and easy to turn on and off.
> 
> And perhaps the parts that set/clear the flag on all tasks can be shared too.
> 
> So we can start with this low-level syscall tracing facility. If you want, I can adapt
> this low-level part and submit a patch this week or the next one to give you this base
> infrastructure.
> 
> 
> Once we have it, I think a syscall tracer can be fed with new syscalls events through
> several patch iterations, starting with the open and close one :-)
> 
> Are you ok with that?
> 
> Steven, Ingo, do you agree?
> 
>  
> > 
> > diff --git a/fs/open.c b/fs/open.c
> > index a3a78ce..8cf2a6b 100644
> > --- a/fs/open.c
> > +++ b/fs/open.c
> > @@ -30,6 +30,10 @@
> >  #include <linux/audit.h>
> >  #include <linux/falloc.h>
> > 
> > +#include <trace/fs.h>
> > +
> > +DEFINE_TRACE(do_sys_open);
> > +
> >  int vfs_statfs(struct dentry *dentry, struct kstatfs *buf)
> >  {
> >         int retval = -ENODEV;
> > @@ -1040,6 +1044,7 @@ long do_sys_open(int dfd, const char __user *filename, int
> > flags, int mode)
> >                                 fsnotify_open(f->f_path.dentry);
> >                                 fd_install(fd, f);
> >                         }
> > +                       trace_do_sys_open(f, flags, mode, fd);
> >                 }
> >                 putname(tmp);
> >         }
> > diff --git a/include/trace/fs.h b/include/trace/fs.h
> > new file mode 100644
> > index 0000000..870eec2
> > --- /dev/null
> > +++ b/include/trace/fs.h
> > @@ -0,0 +1,11 @@
> > +#ifndef _TRACE_FS_H
> > +#define _TRACE_FS_H
> > +
> > +#include <linux/fs.h>
> > +#include <linux/tracepoint.h>
> > +
> > +DECLARE_TRACE(do_sys_open,
> > +       TPPROTO(struct file *filp, int flags, int mode, long fd),
> > +               TPARGS(filp, flags, mode, fd));
> > +
> > +#endif
> > diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> > index e2a4ff6..0400815 100644
> > --- a/kernel/trace/Kconfig
> > +++ b/kernel/trace/Kconfig
> > @@ -149,6 +149,15 @@ config CONTEXT_SWITCH_TRACER
> >           This tracer gets called from the context switch and records
> >           all switching of tasks.
> > 
> > +config OPEN_CLOSE_TRACER
> > +       bool "Trace open() calls"
> > +       depends on DEBUG_KERNEL
> > +       select TRACING
> > +       select MARKERS
> > +       help
> > +         This tracer records open() syscalls. These calls are made when
> > +         files are accessed on disk.
> > +
> >  config BOOT_TRACER
> >         bool "Trace boot initcalls"
> >         depends on DEBUG_KERNEL
> > diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> > index 349d5a9..25cec6c 100644
> > --- a/kernel/trace/Makefile
> > +++ b/kernel/trace/Makefile
> > @@ -20,6 +20,7 @@ obj-$(CONFIG_RING_BUFFER) += ring_buffer.o
> > 
> >  obj-$(CONFIG_TRACING) += trace.o
> >  obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
> > +obj-$(CONFIG_OPEN_CLOSE_TRACER) += trace_open_close.o
> >  obj-$(CONFIG_SYSPROF_TRACER) += trace_sysprof.o
> >  obj-$(CONFIG_FUNCTION_TRACER) += trace_functions.o
> >  obj-$(CONFIG_IRQSOFF_TRACER) += trace_irqsoff.o
> > diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> > index 4d3d381..24c17d2 100644
> > --- a/kernel/trace/trace.h
> > +++ b/kernel/trace/trace.h
> > @@ -30,6 +30,7 @@ enum trace_type {
> >         TRACE_USER_STACK,
> >         TRACE_HW_BRANCHES,
> >         TRACE_POWER,
> > +       TRACE_OPEN,
> > 
> >         __TRACE_LAST_TYPE
> >  };
> > diff --git a/kernel/trace/trace_open_close.c b/kernel/trace/trace_open_close.c
> > new file mode 100644
> > index 0000000..4250efc
> > --- /dev/null
> > +++ b/kernel/trace/trace_open_close.c
> > @@ -0,0 +1,148 @@
> > +/*
> > + * trace open calls
> > + * Copyright (C) 2009 Intel Corporation
> > + *
> > + * Based extensively on trace_sched_switch.c
> > + * Copyright (C) 2007 Steven Rostedt <srostedt@redhat.com>
> > + *
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/fs.h>
> > +#include <linux/debugfs.h>
> > +#include <linux/kallsyms.h>
> > +#include <linux/uaccess.h>
> > +#include <linux/ftrace.h>
> > +#include <trace/fs.h>
> > +
> > +#include "trace.h"
> > +
> > +
> > +static struct trace_array      *ctx_trace;
> > +static int __read_mostly       open_trace_enabled;
> > +static atomic_t                        open_ref;
> > +
> > +static void probe_do_sys_open(struct file *filp, int flags, int mode, long fd)
> > +{
> > +       char *buf;
> > +       char *fname;
> > +
> > +       if (!atomic_read(&open_ref))
> > +               return;
> > +
> > +       if (!open_trace_enabled)
> > +               return;
> > +
> > +       buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
> > +       if (!buf)
> > +               return;
> > +       fname = d_path(&filp->f_path, buf, PAGE_SIZE);
> > +
> > +       if (IS_ERR(fname))
> > +               goto out;
> > +
> > +       ftrace_printk("%s: open(\"%s\", %d, %d) = %ld\n",
> > +               current->comm, fname, flags, mode, fd);
> > +out:
> > +       kfree(buf);
> > +}
> > +
> > +static void open_trace_reset(struct trace_array *tr)
> > +{
> > +       tr->time_start = ftrace_now(tr->cpu);
> > +       tracing_reset_online_cpus(tr);
> > +}
> > +
> > +static int open_trace_register(void)
> > +{
> > +       int ret;
> > +
> > +       ret = register_trace_do_sys_open(probe_do_sys_open);
> > +       if (ret) {
> > +               pr_info("open trace: Could not activate tracepoint"
> > +                       " probe to do_open\n");
> > +       }
> > +
> > +       return ret;
> > +}
> > +
> > +static void open_trace_unregister(void)
> > +{
> > +       unregister_trace_do_sys_open(probe_do_sys_open);
> > +}
> > +
> > +static void open_trace_start(void)
> > +{
> > +       long ref;
> > +
> > +       ref = atomic_inc_return(&open_ref);
> > +       if (ref == 1)
> > +               open_trace_register();
> > +}
> > +
> > +static void open_trace_stop(void)
> > +{
> > +       long ref;
> > +
> > +       ref = atomic_dec_and_test(&open_ref);
> > +       if (ref)
> > +               open_trace_unregister();
> > +}
> > +
> > +void open_trace_start_cmdline_record(void)
> > +{
> > +       open_trace_start();
> > +}
> > +
> > +void open_trace_stop_cmdline_record(void)
> > +{
> > +       open_trace_stop();
> > +}
> > +
> > +static void open_start_trace(struct trace_array *tr)
> > +{
> > +       open_trace_reset(tr);
> > +       open_trace_start_cmdline_record();
> > +       open_trace_enabled = 1;
> > +}
> > +
> > +static void open_stop_trace(struct trace_array *tr)
> > +{
> > +       open_trace_enabled = 0;
> > +       open_trace_stop_cmdline_record();
> > +}
> > +
> > +static int open_trace_init(struct trace_array *tr)
> > +{
> > +       ctx_trace = tr;
> > +
> > +       open_start_trace(tr);
> > +       return 0;
> > +}
> > +
> > +static void reset_open_trace(struct trace_array *tr)
> > +{
> > +       open_stop_trace(tr);
> > +}
> > +
> > +static struct tracer open_trace __read_mostly =
> > +{
> > +       .name           = "open",
> > +       .init           = open_trace_init,
> > +       .reset          = reset_open_trace,
> > +};
> > +
> > +__init static int init_open_trace(void)
> > +{
> > +       int ret = 0;
> > +
> > +       if (atomic_read(&open_ref))
> > +               ret = open_trace_register();
> > +       if (ret) {
> > +               pr_info("error registering open trace\n");
> > +               return ret;
> > +       }
> > +       return register_tracer(&open_trace);
> > +}
> > +device_initcall(init_open_trace);
> > +
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/

