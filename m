Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab0CLD1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 22:27:21 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:63032 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab0CLD1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 22:27:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BGf50VAj1MPiPZOCr8bqPj4BLKoxcn8qxa6NHpSRwkbJqLnefVLxYxZJ+b0swyvv4I
         GmcaJGNETKi5++cEQ4NBrBKo4E3Bx8Hy8oXt7clhgPO7uXYuGYfi8WytsgVAeipJh/Gh
         8x8yiuQowhocZh5qR3mqrtuahVTC0L2W72MG4=
Date: Fri, 12 Mar 2010 04:27:17 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, lizf@cn.fujitsu.com, hpa@zytor.com,
       tglx@linutronix.de, mhiramat@redhat.com, heiko.carstens@de.ibm.com,
       benh@kernel.crashing.org, davem@davemloft.net, lethal@linux-sh.org,
       schwidefsky@de.ibm.com, brueckner@linux.vnet.ibm.com,
       tony.luck@intel.com
Subject: Re: [PATCH 00/12] tracing: add compat syscall support v2
Message-ID: <20100312032714.GB5076@nowhere>
References: <cover.1267214186.git.jbaron@redhat.com> <20100310190330.GB5000@nowhere> <20100311221227.GA5285@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100311221227.GA5285@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 05:12:28PM -0500, Jason Baron wrote:
> I kept separate namespaces to avoid collisions and generally simplify
> things. However, you are right - we can maintain namespace separation at the
> "sys32_blah", "compat_sys", level and map to a common "compat_blah" for the
> trace event name. We can avoid collisions by simply storing the "sys32" or
> "compat_sys" name in the syscall metadata structure name field. 


Well, the purpose is also to reach a state near to cross arch generic
for tools.

If we have a script that parses compat syscalls events in arch X, it
would be nice if it works on arch Y.

If arch X overrides compat_blah through sys32_blah and arch Y just keep
compat_blah, the script won't cross work.

The problem is not that trivial to solve though, I guess the best is to
remove the compat_blah trace event if we already have sys32_blah.
Also the syscall handler naming doesn't seem to be always unified (not
talking about the sys32 thing but the name of the syscall itself).

So let's start simple for now, we can just include everything and
solve that incrementally. But a good start would be to have a separate
compat_syscalls event subsystem.

 
> > - We probably want a compat_syscalls trace event subsystem (separated
> > from syscalls), can be done incrementally though
> > 
> > - Commit e7b8e675d9c71b868b66f62f725a948047514719
> >   (tracing: Unify arch_syscall_addr() implementations)
> > has made a good use of the unified syscall table name
> > between archs that support syscall tracing so that we
> > can, most of the time, directly dereference it from generic
> > code. Exotic archs can still override arch_syscall_addr()
> > if we can't do that with their syscall table.
> > I wish we can do that with the compat syscall tables too.
> > Compat syscall tables names seem to be less unified for now
> > though. Again, can be done incrementally.
> > 
> > Other than that, that's a cool batch!
> > 
> > Thanks!
> > 
> 
> the other question is how to go about getting arch support, since right
> now we break non-x86 arches which have CONFIG_FTRACE_SYSCALLS and
> CONFIG_COMPAT set with this patch.


I guess we can handle that with an ARCH_HAVE_FTRACE_COMPAT_SYSCALLS.
It's not that broken actually, compat syscalls events will just
not trigger.



> thanks,
> 
> -Jason

