Return-Path: <linux-kernel-owner+w=401wt.eu-S1762869AbYF3Sxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762869AbYF3Sxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbYF3SxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:53:25 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50852 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbYF3SxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:53:24 -0400
Date: Mon, 30 Jun 2008 13:53:18 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       "Andrew G. Morgan" <morgan@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] security: filesystem capabilities bugfix2
Message-ID: <20080630185318.GB30669@us.ibm.com>
References: <20080627205905.GB17415@us.ibm.com> <486357EC.5060205@kernel.org> <7852.1214837604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7852.1214837604@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> Serge E. Hallyn <serue@us.ibm.com> wrote:
> 
> > If I understand this right, then LSM_UNSAFE_PTRACE_CAP will only be set
> > if the tracer didn't have CAP_SYS_PTRACE.  So this seems sane to me.
> 
> Erm...  Firstly:

Yeah, inverse of what I said...

> 	int ptrace_attach(struct task_struct *task)
> 	{
> 	...
> 		if (capable(CAP_SYS_PTRACE))
> 			task->ptrace |= PT_PTRACE_CAP;
> 	...
> 	}
> 
> Then:
> 
> 	static int unsafe_exec(struct task_struct *p)
> 	{
> 		int unsafe = 0;
> 		if (p->ptrace & PT_PTRACED) {
> 			if (p->ptrace & PT_PTRACE_CAP)
> 				unsafe |= LSM_UNSAFE_PTRACE_CAP;
> 			else
> 				unsafe |= LSM_UNSAFE_PTRACE;
> 		}
> 		if (atomic_read(&p->fs->count) > 1 ||
> 		    atomic_read(&p->files->count) > 1 ||
> 		    atomic_read(&p->sighand->count) > 1)
> 			unsafe |= LSM_UNSAFE_SHARE;
> 
> 		return unsafe;
> 	}
> 
> So LSM_UNSAFE_PTRACE_CAP will only be set if the tracer _does_ have
> CAP_SYS_PTRACE.  That will be irrelevant, however, if any of fs, files or
> sighand are shared.
> 
> And finally:
> 
> 	void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
> 	{
> 	...
> 		if (bprm->e_uid != current->uid ||
> 		    bprm->e_gid != current->gid ||
> 		    !cap_issubset (new_permitted, current->cap_permitted)) {
> 	...
> 			if (unsafe & ~LSM_UNSAFE_PTRACE_CAP) {
> 				if (!capable(CAP_SETUID)) {
> 					bprm->e_uid = current->uid;
> 					bprm->e_gid = current->gid;
> 				}
> 				if (!capable (CAP_SETPCAP)) {
> 					new_permitted = cap_intersect(
> 						new_permitted,
> 						current->cap_permitted);
> 				}
> 			}
> 	...
> 	}
> 
> So if it's a 'set-privilege' binary, then if the tracer _doesn't_ have
> CAP_SYS_PTRACE, we look at downgrading the privileges of the process.
> 
> Without Andrew's patch, we only downgrade the capabilities if we don't have
> CAP_SETPCAP (and aren't sharing inheritables).
> 
> With Andrew's patch, capabilities are downgraded regardless of whether we have
> CAP_SETPCAP or not.  I guess that means that if you're tracing a binary whose
> filecaps say that it wants CAP_SETPCAP, then it retains CAP_SETPCAP.

I don't understand where that last sentence comes from.  Why would it
retain CAP_SETPCAP?

> I wonder if the tracing task should be examined here, and any capability the
> tracer isn't permitted should be denied the process doing the exec.

That sounds reasonable on its own, but it opens up a dangerous ability
for the partially-privileged tracer to manipulate the capability set for
the traced task.

Note that (as of recently) we do not allow the execution of a file with
partial privileges in its pE', precisely because it is dangerous to
allow pick-and-choosing of capabilities in a capability-unaware binary.

So frankly I wonder whether the existing downgrade is really safe...

-serge

> Anyway, in my commoncap.c prettification patch, I've dressed the limiter
> function up as follows:
> 
> 	/*
> 	 * Determine whether a exec'ing process's new permitted capabilities
> 	 * should be limited to just what it already has.
> 	 *
> 	 * This prevents processes that are being ptraced from gaining access
> 	 * to CAP_SETPCAP, unless the process they're tracing already has it,
> 	 * and the binary they're executing has filecaps that elevate it.
> 	 *
> 	 *  Returns 1 if they should be limited, 0 if they are not.
> 	 */
> 	static inline int cap_limit_ptraced_target(void)
> 	{
> 	#ifndef CONFIG_SECURITY_FILE_CAPABILITIES
> 		if (capable(CAP_SETPCAP))
> 			return 0;
> 	#endif
> 		return 1;
> 	}
> 
> David
