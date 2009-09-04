Return-Path: <linux-kernel-owner+w=401wt.eu-S933216AbZIDIl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933216AbZIDIl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 04:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756650AbZIDIl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 04:41:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756701AbZIDIl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 04:41:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090903160514.GA23646@redhat.com>
References: <20090903160514.GA23646@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Roland McGrath <roland@redhat.com>,
       Tom Horsley <tom.horsley@att.net>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH 1/1] exec: do not sleep in TASK_TRACED under ->cred_guard_mutex
Date: Fri, 04 Sep 2009 09:39:07 +0100
Message-ID: <29983.1252053547@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> But I strongly believe we should blame another patch
> 
> 	"CRED: Make execve() take advantage of copy-on-write credentials"
> 	a6f76f23d297f70e2a6b3ec607f7aeeea9e37e8d
> 
> The tracee must not sleep in TASK_TRACED holding this mutex (it was named
> cred_exec_mutex). Even if we remove ->cred_guard_mutex from mm_for_maps()
> and proc_pid_attr_write(), another task doing PTRACE_ATTACH should not
> hang until it is killed or the tracee resumes.

Ummm...  I don't see how this is relevant.

Yes, a task must not sleep in TASK_TRACED if it is holding this mutex, but how
does that apply to do_exec(), mm_for_maps() or proc_pid_attr_write()?  A
process can't be in any of those three if it is in the TASK_TRACED state.

A process can only be in the TASK_TRACED state in one of two ways: its parent
moved it there from the TASK_STOPPED state, or it put itself in that state -
neither of which should apply here.

Apart from that, I've no objection to dropping the guard semaphore earlier.

I do think though, the problem is elsewhere.  Are we failing to unlock the
semaphore somewhere?  Or double locking it, I wonder?  Has Tom tried lockdep?

Btw, should mm_for_maps() use mutex_lock_interruptible()?  There doesn't seem
any point making it non-interruptible (except for kill signals) - unless that
would muck up seqfile handling.

> +int prepare_bprm_creds(struct linux_binprm *bprm)
> +{

__acquires()

> +void free_bprm(struct linux_binprm *bprm)
> +{

__releases()
