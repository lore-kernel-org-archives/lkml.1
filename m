Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbZCLFvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbZCLFvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 01:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbZCLFu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 01:50:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751204AbZCLFu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 01:50:57 -0400
Date: Wed, 11 Mar 2009 22:47:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Avi Kivity <avi@redhat.com>,
       linux-aio <linux-aio@kvack.org>, zach.brown@oracle.com, bcrl@kvack.org,
       linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] fs: fput() can be called from interrupt context
Message-Id: <20090311224712.fb8db075.akpm@linux-foundation.org>
In-Reply-To: <49B89B22.7080303@cosmosbay.com>
References: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com>
	<49B54143.1010607@redhat.com>
	<x49sklmd1fo.fsf@segfault.boston.devel.redhat.com>
	<49B57CB0.5020300@cosmosbay.com>
	<49B875F7.3030305@cosmosbay.com>
	<49B87CFE.4000701@cosmosbay.com>
	<49B89B22.7080303@cosmosbay.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009 06:18:26 +0100 Eric Dumazet <dada1@cosmosbay.com> wrote:

> Eric Dumazet a __crit :
> > Eric Dumazet a __crit :
> >> Eric Dumazet a __crit :
> >>> Jeff Moyer a __crit :
> >>>> Avi Kivity <avi@redhat.com> writes:
> >>>>
> >>>>> Jeff Moyer wrote:
> >>>>>> Hi,
> >>>>>>
> >>>>>> Believe it or not, I get numerous questions from customers about the
> >>>>>> suggested tuning value of aio-max-nr.  aio-max-nr limits the total
> >>>>>> number of io events that can be reserved, system wide, for aio
> >>>>>> completions.  Each time io_setup is called, a ring buffer is allocated
> >>>>>> that can hold nr_events I/O completions.  That ring buffer is then
> >>>>>> mapped into the process' address space, and the pages are pinned in
> >>>>>> memory.  So, the reason for this upper limit (I believe) is to keep a
> >>>>>> malicious user from pinning all of kernel memory.  Now, this sounds like
> >>>>>> a much better job for the memlock rlimit to me, hence the following
> >>>>>> patch.
> >>>>>>   
> >>>>> Is it not possible to get rid of the pinning entirely?  Pinning
> >>>>> interferes with page migration which is important for NUMA, among
> >>>>> other issues.
> >>>> aio_complete is called from interrupt handlers, so can't block faulting
> >>>> in a page.  Zach mentions there is a possibility of handing completions
> >>>> off to a kernel thread, with all of the performance worries and extra
> >>>> bookkeeping that go along with such a scheme (to help frame my concerns,
> >>>> I often get lambasted over .5% performance regressions).
> >>> This aio_completion from interrupt handlers keep us from using SLAB_DESTROY_BY_RCU
> >>> instead of call_rcu() for "struct file" freeing.
> >>>
> >>> http://lkml.org/lkml/2008/12/17/364
> >>>
> >>> I would love if we could get rid of this mess...
> >> Speaking of that, I tried to take a look at this aio stuff and have one question.
> >>
> >> Assuming that __fput() cannot be called from interrupt context.
> >> -> fput() should not be called from interrupt context as well.
> >>
> >> How comes we call fput(req->ki_eventfd) from really_put_req()
> >> from interrupt context ?
> >>
> >> If user program closes eventfd, then inflight AIO requests can trigger
> >> a bug.
> >>
> > 
> > Path could be :
> > 
> > 1) fput() changes so that calling it from interrupt context is possible
> >    (Using a working queue to make sure __fput() is called from process context)
> > 
> > 2) Changes aio to use fput() as is (and zap its internal work_queue and aio_fput_routine() stuff)
> > 
> > 3) Once atomic_long_dec_and_test(&filp->f_count) only performed in fput(),
> >    SLAB_DESTROY_BY_RCU for "struct file" get back :)
> > 
> 
> Please find first patch against linux-2.6
> 
> Next patch (2) can cleanup aio code, but it probably can wait linux-2.6.30
> 
> Thank you
> 
> [PATCH] fs: fput() can be called from interrupt context
> 
> Current aio/eventfd code can call fput() from interrupt context, which is
> not allowed.

The changelog forgot to tell us where this happens, and under what
circumstances.

See, there might be other ways of fixing the bug,

> In order to fix the problem and prepare SLAB_DESTROY_BY_RCU use for "struct file"
> allocation/freeing in 2.6.30, we might extend existing workqueue infrastructure and
> allow fput() to be called from interrupt context.
> 
> This unfortunalty adds a pointer to 'struct file'.
> 
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> ---
>  fs/file.c               |   55 ++++++++++++++++++++++++++------------
>  fs/file_table.c         |   10 +++++-
>  include/linux/fdtable.h |    1
>  include/linux/fs.h      |    1
>  4 files changed, 49 insertions(+), 18 deletions(-)

which might not have some or all of the above problems.


I assume you're referring to really_put_req(), and commit
9c3060bedd84144653a2ad7bea32389f65598d40.

>From the above email straggle I extract "If user program closes
eventfd, then inflight AIO requests can trigger a bug" and I don't
immediately see anything in there which would prevent this.

Did you reproduce the bug, and confirm that the patch fixes it?

Are there simpler ways of fixing it?  Maybe sneak a call to
wait_for_all_aios() into the right place?  I doubt if it's performance
critical, as nobody seems to have ever hit the bug.

Bear in mind that if the bug _is_ real then it's now out there, and
we would like a fix which is usable by 2.6.<two-years-worth>.

etcetera..
