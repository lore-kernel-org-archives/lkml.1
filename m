Return-Path: <linux-kernel-owner+w=401wt.eu-S1760763AbYEMOBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760763AbYEMOBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 10:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757305AbYEMOB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 10:01:27 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:47379 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756282AbYEMOB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 10:01:26 -0400
Subject: Re: [RFC][PATCH] security:  split ptrace checking in proc
From: Stephen Smalley <sds@tycho.nsa.gov>
To: casey@schaufler-ca.com
Cc: lsm <linux-security-module@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <648615.23893.qm@web36601.mail.mud.yahoo.com>
References: <648615.23893.qm@web36601.mail.mud.yahoo.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 13 May 2008 10:01:10 -0400
Message-Id: <1210687270.6206.129.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-05-12 at 07:06 -0700, Casey Schaufler wrote:
> --- Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > Enable security modules to distinguish reading of process state
> > information from full ptrace access by introducing a distinct helper
> > function for such checks and passing a boolean flag down to the
> > security_ptrace hook.  This allows security modules to permit access
> > to reading process state without granting full ptrace access.
> 
> This will obviously suffice, but why pass a boolean instead
> of the access actually desired? What I mean is that instead
> of passing a read-only flag, you could pass in READ or READWRITE
> to indicate which access you require. Although I don't have
> a case in mind, it seems that your interface is unnecessarily
> contrained if you have a read-only boolean.

It isn't quite a read vs. readwrite distinction.  A normal ptrace attach
implies full control of the target process (which goes even beyond
simple read/write to control flow).  Read access to /proc/pid/mem (the
process memory) has also always required full ptrace access, and we
aren't changing that situation with this patch as I'm not aware of any
need to allow it w/o allowing full ptrace access.

What the patch is doing is enabling distinctions to be made by security
modules (without disturbing the base DAC or capability checks) between
full ptrace access and limited reading of specific elements of state,
such as reading /proc/pid/environ or reading the special
symlinks /proc/pid/exec and /proc/pid/fd/<n>.  We often encounter the
latter in various programs that do not need to be able to ptrace the
target process (e.g. monitoring programs, procps, lsof, PolicyKit).  At
present we have to choose between allowing full ptrace in policy (more
permissive than required/desired) or breaking functionality (or in some
cases, just silencing the denials via dontaudit but this can hide
genuine attacks).

> > diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
> > index f98501b..f8a5e75 100644
> > --- a/include/linux/ptrace.h
> > +++ b/include/linux/ptrace.h
> > @@ -97,6 +97,7 @@ extern void __ptrace_unlink(struct task_struct *child);
> >  extern void ptrace_untrace(struct task_struct *child);
> >  extern int ptrace_may_attach(struct task_struct *task);
> >  extern int __ptrace_may_attach(struct task_struct *task);
> > +extern int ptrace_may_readstate(struct task_struct *task);
> 
> I would prefer a mode parameter to ptrace_may_attach to the
> specific function for read access. Again, what you have will
> work for your case, but may lead to yet another interface later
> if someone wants a slightly different check.

As above, it isn't quite a read vs. readwrite mode distinction (which is
why I called it ptrace_may_readstate rather than just ptrace_may_read),
and the advantage of implementing it via a new interface is that we only
need to update the callers where we want to apply this different
checking, leaving all other callers unmodified and unaffected.  So while
I could do it the way you describe, I'm not sure it would yield a better
result.  Maybe others can chime in with their opinions.

-- 
Stephen Smalley
National Security Agency

