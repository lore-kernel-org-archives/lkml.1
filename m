Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbYEMPjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbYEMPjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 11:39:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756020AbYEMPiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 11:38:54 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:49844 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755752AbYEMPix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 11:38:53 -0400
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
Date: Mon, 12 May 2008 11:16:15 -0400
Message-Id: <1210605375.6206.68.camel@moss-spartans.epoch.ncsc.mil>
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

A normal ptrace attach implies full read-write (and more - control of
execution flow) access.  Also, access to /proc/pid/mem (i.e. the process
memory) has always required full ptrace access, even if only for read
(and mem_write is disabled by default).  We aren't changing that
situation with this patch.

What we are doing in this patch is enabling distinctions to be made by
security modules (without disturbing the base DAC/capabilities logic)
between such full ptrace access and reading of state such
as /proc/pid/environ, /proc/pid/exe and /proc/pid/fd/.  We often
encounter the latter in various programs that do not in fact need or
want to be able to ptrace the target process (e.g. monitoring programs,
killproc, mingetty, PolicyKit).  At present, we have to choose between
allowing this in policy (more permissive than required/desired) or
breaking functionality.  This was effectively a regression introduced
into SELinux by unrelated changes to proc back in 2.6.18 to tighten up
the DAC checking, which we aren't disturbing here.

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

That would require updating all callers to pass the mode vs. only
changing a few callers.  Also, it isn't just an access mode distinction
per se but rather a distinction between read access to parts of the
process state vs. full access to the process state, with the former
required by a variety of programs and the latter only required/desired
for full ptrace purposes.  The mem_read case is an example where we are
still applying a full ptrace check even though we are only reading (but
there we are reading the full process memory vs. just parts of its state
like its environ, exe link, and fd links).

I could do it the way you describe, but I'm not sure it will yield a
better result.  Maybe others can chime in with their preferences and I
can go with whatever consensus emerges.

-- 
Stephen Smalley
National Security Agency

