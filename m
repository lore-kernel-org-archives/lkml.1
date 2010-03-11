Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526Ab0CKWNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 17:13:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758512Ab0CKWM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 17:12:58 -0500
Date: Thu, 11 Mar 2010 17:12:28 -0500
From: Jason Baron <jbaron@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, lizf@cn.fujitsu.com, hpa@zytor.com,
       tglx@linutronix.de, mhiramat@redhat.com, heiko.carstens@de.ibm.com,
       benh@kernel.crashing.org, davem@davemloft.net, lethal@linux-sh.org,
       schwidefsky@de.ibm.com, brueckner@linux.vnet.ibm.com,
       tony.luck@intel.com
Subject: Re: [PATCH 00/12] tracing: add compat syscall support v2
Message-ID: <20100311221227.GA5285@redhat.com>
References: <cover.1267214186.git.jbaron@redhat.com>
 <20100310190330.GB5000@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100310190330.GB5000@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 08:03:35PM +0100, Frederic Weisbecker wrote:
> On Fri, Feb 26, 2010 at 04:36:55PM -0500, Jason Baron wrote:
> > Hi,
> > 
> > Re-post to add infrastructure for compat syscall event tracing support. This
> > patch series also adds x86_64 arch specific support as an example consumer
> > of the new infrastructure.
> > 
> > The new interface consists of:
> > 
> > 1) int is_compat_task(void);
> >   - most arches seem to have this already
> > 2) unsigned long arch_compat_syscall_addr(int nr);
> >   - returns a pointer to the compat syscall entry corresponding to syscall 'nr'
> > 3) int NR_syscalls_compat;
> >   - number of entries in the compat syscall table.
> > 
> > Thus, arches that set CONFIG_FTRACE_SYSCALLS and CONFIG_COMPAT are going to
> > need to implement the above interfaces in order to build. Thus, I'm 'cc arch
> > maintainers.
> > 
> > Naming. I've also introduced a couple of new syscall macros:
> > 
> > ARCH_COMPAT_SYSCALL_DEFINE#N()
> > COMPAT_SYSCALL_DEFINE#N()
> > 
> > These tack on, "arch_compat_sys" and "compat_sys" respectively, to the
> > beginning of the compat syscall names.
> > 
> > thanks,
> > 
> > -Jason
> 
> 
> 
> That's a very nice work!
> 
> Some neats about it, some of them can be probably done
> incrementally:
> 
> 
> - The new COMPAT_SYSCALL_DEFINE/ARCH_COMPAT_SYSCALL_DEFINE
> macros nicely standardize the syscalls naming. Most arch use
> the sys32_* prefix for compat though. We could simply make
> ARCH_COMPAT_SYSCALL_DEFINE() prepend with sys32_* as this
> will involve less changes in the syscall table of archs that
> want the compat syscall tracing support. (Although in itself,
> having arch_compat_ prefixes is also an intuitive naming)
> 

ok. i'll make the ARCH_COMPAT_SYSCALL_DEFINE output "sys32_blah"

> - Why bothering with a trace event namespace separation between
> arch overriden compat syscalls and common ones?
> Tools want to deal with a single shot of syscalls:compat_*, and
> not syscalls:compat_* + syscalls:arch_compat_*
> Even in the trace, such a naming separation may look weird.
> The *_SYSCALL_DEFINE macros can make it easy to use different
> names between syscall functions and syscall trace event names.
> So, we can keep the distinct arch_compat (or sys32 that involves
> less changes) and compat prefixes for functions names, as arch_compat
> may call compat things; and have only compat prefixes as trace events
> names. And may be if we have collisions between arch and generic
> compat callback names, let's drop the generic one as it will
> never trigger, since it's not in the syscall table anyway.
> 

I kept separate namespaces to avoid collisions and generally simplify
things. However, you are right - we can maintain namespace separation at the
"sys32_blah", "compat_sys", level and map to a common "compat_blah" for the
trace event name. We can avoid collisions by simply storing the "sys32" or
"compat_sys" name in the syscall metadata structure name field. 

> - We probably want a compat_syscalls trace event subsystem (separated
> from syscalls), can be done incrementally though
> 
> - Commit e7b8e675d9c71b868b66f62f725a948047514719
>   (tracing: Unify arch_syscall_addr() implementations)
> has made a good use of the unified syscall table name
> between archs that support syscall tracing so that we
> can, most of the time, directly dereference it from generic
> code. Exotic archs can still override arch_syscall_addr()
> if we can't do that with their syscall table.
> I wish we can do that with the compat syscall tables too.
> Compat syscall tables names seem to be less unified for now
> though. Again, can be done incrementally.
> 
> Other than that, that's a cool batch!
> 
> Thanks!
> 

the other question is how to go about getting arch support, since right
now we break non-x86 arches which have CONFIG_FTRACE_SYSCALLS and
CONFIG_COMPAT set with this patch.

thanks,

-Jason
