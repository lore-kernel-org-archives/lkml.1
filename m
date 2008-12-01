Return-Path: <linux-kernel-owner+w=401wt.eu-S1753857AbYLAXKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbYLAXKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 18:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbYLAXKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 18:10:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60330 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751779AbYLAXKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 18:10:43 -0500
Date: Mon, 1 Dec 2008 15:09:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ying Han <yinghan@google.com>
Cc: oleg@redhat.com, menage@google.com, penberg@cs.helsinki.fi,
       nickpiggin@yahoo.com.au, hugh@veritas.com, matthew@wil.cx,
       rientjes@google.com, linux-kernel@vger.kernel.org
Subject: Re: + make-get_user_pages-interruptible.patch added to -mm tree
Message-Id: <20081201150947.85e25789.akpm@linux-foundation.org>
In-Reply-To: <604427e00812011500j48ae17d8w4f6f47eba7493af8@mail.gmail.com>
References: <20081127200459.GA25799@redhat.com>
	<604427e00812011500j48ae17d8w4f6f47eba7493af8@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2008 15:00:14 -0800
Ying Han <yinghan@google.com> wrote:

> On Thu, Nov 27, 2008 at 12:04 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > Ying Han wrote:
> >>
> >> -static int sigkill_pending(struct task_struct *tsk)
> >> +int sigkill_pending(struct task_struct *tsk)
> >>  {
> >>       return  sigismember(&tsk->pending.signal, SIGKILL) ||
> >>               sigismember(&tsk->signal->shared_pending.signal, SIGKILL);
> >> diff -puN mm/memory.c~make-get_user_pages-interruptible mm/memory.c
> >> --- a/mm/memory.c~make-get_user_pages-interruptible
> >> +++ a/mm/memory.c
> >> @@ -1219,12 +1219,12 @@ int __get_user_pages(struct task_struct
> >>                       struct page *page;
> >>
> >>                       /*
> >> -                      * If tsk is ooming, cut off its access to large memory
> >> -                      * allocations. It has a pending SIGKILL, but it can't
> >> -                      * be processed until returning to user space.
> >> +                      * If we have a pending SIGKILL, don't keep
> >> +                      * allocating memory.
> >>                        */
> >> -                     if (unlikely(test_tsk_thread_flag(tsk, TIF_MEMDIE)))
> >> -                             return i ? i : -ENOMEM;
> >> +                     if (unlikely(sigkill_pending(current) ||
> >> +                                     sigkill_pending(tsk)))
> >
> > Please do not export/use sigkill_pending(). It is "private" for ptrace_stop()
> > (and actually should die imho).
> >
> > We have fatal_signal_pending() for that.
> >
> > Oleg.
> >

(top-posting repaired..)

> Thanks Oleg, i looked at the code again and this is a reasonable
> change. I will make the change on the patch.
> Andrew,
>     should i make a patch based on current change or make the same
> patch as [V6]?

I don't mind either way.  I guess a fresh new patch would simplify
review for everyone.

Note that fatal_signal_pending() is not an exact replacement for
sigkill_pending() - fatal_signal_pending() doesn't test the shared
pending signals.


