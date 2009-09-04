Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbZIDMwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbZIDMwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 08:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756538AbZIDMwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 08:52:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756773AbZIDMwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 08:52:09 -0400
Date: Fri, 4 Sep 2009 14:46:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Roland McGrath <roland@redhat.com>,
       Tom Horsley <tom.horsley@att.net>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH 1/1] exec: do not sleep in TASK_TRACED under
	->cred_guard_mutex
Message-ID: <20090904124604.GA6248@redhat.com>
References: <20090903160514.GA23646@redhat.com> <29983.1252053547@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29983.1252053547@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > But I strongly believe we should blame another patch
> >
> > 	"CRED: Make execve() take advantage of copy-on-write credentials"
> > 	a6f76f23d297f70e2a6b3ec607f7aeeea9e37e8d
> >
> > The tracee must not sleep in TASK_TRACED holding this mutex (it was named
> > cred_exec_mutex). Even if we remove ->cred_guard_mutex from mm_for_maps()
> > and proc_pid_attr_write(), another task doing PTRACE_ATTACH should not
> > hang until it is killed or the tracee resumes.

(Argh. Sorry David, the changelog should have mentioned tracehook_report_exec()
 more explicitely).

So, David, do you agree with this patch? Do you think it can go to 2.6.31 ?


> Btw, should mm_for_maps() use mutex_lock_interruptible()?  There doesn't seem
> any point making it non-interruptible (except for kill signals) - unless that
> would muck up seqfile handling.

Perhaps, but we should change m_start() first, it should check IS_ERR() instead
of mm != NULL. Afaics, vfs_read()->seq_read() path will return ERESTART...
correctly.

I am not sure would be right though, short reads can confuse user space. And
this can't solve the problem, this only helps to react to signals.

Oleg.

