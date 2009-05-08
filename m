Return-Path: <linux-kernel-owner+w=401wt.eu-S1753599AbZEHFjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbZEHFjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 01:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbZEHFjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 01:39:22 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:23083 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbZEHFjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 01:39:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=V5WwGHy1L9s1TXuVwTWk+PGtzwpX33pwHaX63P8i9PqQdFMk+vRxEigB2irw3MRU4r
         Oy9ONaIGvtN6TXThfHKGZea3LoWnDQIRzfM26RUphhJ0QSB9ZcF2tuaWCJsFd6/nL3kN
         aD84sPmXBTwk29MyV6sPrknk5CFKtlSIudass=
Subject: Re: [RFC 1/1] seccomp: Add bitmask of allowed system calls.
From: Tom Zanussi <tzanussi@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Adam Langley <agl@google.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, markus@google.com
In-Reply-To: <20090507230021.GC6472@nowhere>
References: <396556a20805301217k293e5718h6bbf02b234897235@europa>
	 <20090507221447.GE28770@elte.hu>
	 <a84d7bc60905071534l1e65f216mfd9330e93e4da4e2@mail.gmail.com>
	 <20090507230021.GC6472@nowhere>
Content-Type: text/plain
Date: Fri, 08 May 2009 00:32:25 -0500
Message-Id: <1241760745.9416.37.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-08 at 01:00 +0200, Frederic Weisbecker wrote:
> On Thu, May 07, 2009 at 03:34:58PM -0700, Adam Langley wrote:
> > > That assessment is incorrect, there's no difference between safety
> > > here really.
> > >
> > > LSM cannot magically inspect user-space memory either when multiple
> > > threads may access it. The point would be to define filters for
> > > system call _arguments_, which are inherently thread-local and safe.
> > 
> > If I hook security_operations.socket_connect, I can validate the struct
> > sockaddr after the final copy_from_user. However, since the sockaddr lives in
> > userspace memory, if I try and validate it from ftrace SYSCALL_ENTER, I can't
> > know that it won't change before sys_connect reads it again.
> > 
> > Because of that, there are system calls which an LSM hook can safely accept
> > that an ftrace hook cannot. However, as you point out, any arguments passed in
> > registers are inheriently safe and these may be sufficiently powerful.
> > 
> > > There are two problems with the bitmap scheme, which i also
> > > suggested in a previous thread but then found it to be lacking:
> > >
> > > 1) enumeration: you define a bitmap. That will be problematic
> > >   between compat and native 64-bit (both have different syscall
> > >   vectors).
> > 
> > I /think/ it works out, but I've been bitten before with subtle 32/64 bit
> > compat issues and accept that it's a bit ugly.
> > 
> > > 2) flexibility. It's an on/off selection per syscall. With the
> > >   filter we have on, off, or filtered. That's a _whole_ lot more
> > >   flexible.
> > 
> > Absolutely.
> > 
> > Is there a git tree that I can pull this parsing code from?
> > (git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > maybe?). I can patch in the seccomp-on-ftrace work and try building the
> > filtering on top of that. I'll see how it turns out anyway.
> 
> 
> Hi,
> 
> The most uptodate one is:
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
> on the tracing/filters topic.
> 
> See kernel/trace/trace_events_filter.c
> 
> You might want to reuse some current syscall tracing facility.
> An automated resolution table is built on bootime, you can look
> at the end of arch/x86/kernel/ftrace.c
> 
> This table links each syscalls nr to the matching attribute entry of syscall
> in which you can find:
> 
> - parameters names
> - parameters types
> - syscall name
> 
 
I guess it would be easier for seccomp to make use of the filtering and
reuse the syscall tracing facility if we added filtering to the syscall
tracer first.  It would be useful to do for the syscall tracer anyway,
regardless of whether it (or something similar) ended up being used by
seccomp.

Frederic, did you have any plans for that?  If not, I can take a look
when I get the chance...

Tom

> You can look at the hooks in include/linux/syscall.h:
> The sections inside
> #ifdef CONFIG_FTRACE_SYSCALLS
> 
> Well, it's a bit insane to read, so you can also look
> at include/trace/syscall.h and kernel/trace/trace_syscalls.c and
> see how it is used and how it could be reused.
> 
> 
> Thanks,
> Frederic.
> 

