Return-Path: <linux-kernel-owner+w=401wt.eu-S1758338AbZJFXAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338AbZJFXAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 19:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756920AbZJFXAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 19:00:21 -0400
Received: from smtp-out.google.com ([216.239.45.13]:30435 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663AbZJFXAU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 19:00:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=R99bv2+xeDueJxIFgDJNTmzcjoR8KfDdGPYmvEi+uBnZo1JQtIpANiMlkX9bNkeDE
	yEjC8VLbe1ScnDISyJ4QQ==
MIME-Version: 1.0
In-Reply-To: <20091006114052.5FAA.A69D9226@jp.fujitsu.com>
References: <20091006112803.5FA5.A69D9226@jp.fujitsu.com>
	 <20091006114052.5FAA.A69D9226@jp.fujitsu.com>
Date: Tue, 6 Oct 2009 15:59:09 -0700
Message-ID: <604427e00910061559v34590d49x4cdd01b16df6fb1e@mail.gmail.com>
Subject: Re: [PATCH 2/2] mlock use lru_add_drain_all_async()
From: Ying Han <yinghan@google.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello KOSAKI-san,

Few questions on the lru_add_drain_all_async(). If i understand
correctly, the reason that we have lru_add_drain_all() in the mlock()
call is to isolate mlocked pages into the separate LRU in case they
are sitting in pagevec.

And I also understand the RT use cases you put in the patch
description, now my questions is that do we have race after applying
the patch? For example that if the RT task not giving up the cpu by
the time mlock returns, you have pages left in the pagevec which not
being drained back to the lru list. Do we have problem with that?

--Ying

On Mon, Oct 5, 2009 at 7:41 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>
> Recently, Peter Zijlstra reported RT-task can lead to prevent mlock
> very long time.
>
>  Suppose you have 2 cpus, cpu1 is busy doing a SCHED_FIFO-99 while(1),
>  cpu0 does mlock()->lru_add_drain_all(), which does
>  schedule_on_each_cpu(), which then waits for all cpus to complete the
>  work. Except that cpu1, which is busy with the RT task, will never run
>  keventd until the RT load goes away.
>
>  This is not so much an actual deadlock as a serious starvation case.
>
> Actually, mlock() doesn't need to wait to finish lru_add_drain_all().
> Thus, this patch replace it with lru_add_drain_all_async().
>
> Cc: Oleg Nesterov <onestero@redhat.com>
> Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/mlock.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/mlock.c b/mm/mlock.c
> index 22041aa..46a016f 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -458,7 +458,7 @@ SYSCALL_DEFINE2(mlock, unsigned long, start, size_t, len)
>        if (!can_do_mlock())
>                return -EPERM;
>
> -       lru_add_drain_all();    /* flush pagevec */
> +       lru_add_drain_all_async();      /* flush pagevec */
>
>        down_write(&current->mm->mmap_sem);
>        len = PAGE_ALIGN(len + (start & ~PAGE_MASK));
> @@ -526,7 +526,7 @@ SYSCALL_DEFINE1(mlockall, int, flags)
>        if (!can_do_mlock())
>                goto out;
>
> -       lru_add_drain_all();    /* flush pagevec */
> +       lru_add_drain_all_async();      /* flush pagevec */
>
>        down_write(&current->mm->mmap_sem);
>
> --
> 1.6.2.5
>
>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
