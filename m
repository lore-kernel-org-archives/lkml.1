Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbYLBN20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbYLBN20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 08:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbYLBN2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 08:28:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38099 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbYLBN2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 08:28:17 -0500
Date: Tue, 2 Dec 2008 14:26:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ying Han <yinghan@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, menage@google.com,
       penberg@cs.helsinki.fi, nickpiggin@yahoo.com.au, hugh@veritas.com,
       matthew@wil.cx, rientjes@google.com, linux-kernel@vger.kernel.org
Subject: Re: + make-get_user_pages-interruptible.patch added to -mm tree
Message-ID: <20081202132609.GA8159@redhat.com>
References: <20081127200459.GA25799@redhat.com> <604427e00812011500j48ae17d8w4f6f47eba7493af8@mail.gmail.com> <20081201150947.85e25789.akpm@linux-foundation.org> <604427e00812011517tbf5685fr7263225aaa3adb3f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <604427e00812011517tbf5685fr7263225aaa3adb3f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01, Ying Han wrote:
>
> On Mon, Dec 1, 2008 at 3:09 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > Note that fatal_signal_pending() is not an exact replacement for
> > sigkill_pending() - fatal_signal_pending() doesn't test the shared
> > pending signals.
> >
> yeah, i noticed that and that is why i used the sigkill_pending
> initially. But after a deeper look
> at the signal code, i found for SIGKILL ( signal we care about in this
> patch ), tsk->pending is a
> superset of tsk->signal->shared_pending.

Yes. If we have SIGKILL in ->shared_pending, we must have it in
in ->pending too.

The only exception is when we send SIGKILL to the already dying task
which has already dequeued SIGKILL from ->pending. And we do have a
special case: coredumping. elf_core_dump() does get_user_pages()
when the process is "almost" dead, it has SIGNAL_GROUP_EXIT.

So, if get_user_pages() calls sigkill_pending() instead of
fatal_signal_pending(), this can help. But:

	- this relies on the fact that we always queue SIGKILL
	  even if the task is dead. This behaviour can be changed.

	- this doesn't stop the coredumping, it will continue
	  with DUMP_SEEK(). Yes, this is better if we want to
	  stop this thread to populate the memory, but I think
	  we should just fix the coredumping - it should be
	  interruptible.

Actually, the patch exists:
	http://marc.info/?l=linux-kernel&m=121665710711931

Oleg.

