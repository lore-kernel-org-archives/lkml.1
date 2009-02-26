Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbZBZUkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbZBZUkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 15:40:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbZBZUj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 15:39:56 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58935 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbZBZUjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 15:39:55 -0500
Date: Thu, 26 Feb 2009 21:36:53 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] signals: don't copy siginfo_t on dequeue
Message-ID: <20090226203653.GA9285@redhat.com>
References: <20090226184433.GA15644@damson.getinternet.no> <20090226191509.GA6204@redhat.com> <19f34abd0902261218u388de998l1204857bde9bbe32@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0902261218u388de998l1204857bde9bbe32@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26, Vegard Nossum wrote:
>
> 2009/2/26 Oleg Nesterov <oleg@redhat.com>:
> > So. dequeue_signal() returns NULL if there is no siginfo queued. In that
> > case we assume that the signal is not pending.
> >
> > But this is not right. Think about SEND_SIG_FORCED, or __sigqueue_alloc()
> > failure when the signal is sent. Or look at zap_other_threads() for example,
> > it just sets the bit in ->pending but doesn't queue siginfo.
>
> I will investigate.

Cough. Well, I must admit I am a bit skeptical about this patch ;) Because
I suspect it will add more complications to the code. And _I think_ avoiding
copy_siginfo() does not buy too much. I will be happy if I am wrong, though.

But. If you are going to do another version, then please note there is another
problem with this patch, SIGQUEUE_PREALLOC.

If collect_signal() returns SIGQUEUE_PREALLOC info, we can not drop ->siglock.
I mean, once we drop ->siglock, this info can be freed, so for example

			spin_unlock(&tsk->sighand->siglock);
	-               do_schedule_next_timer(info);
	+               do_schedule_next_timer(&signal->info);

even this part is not safe.

Also. The patch uses __sigqueue_free() to free the delivered siginfo, but
this is not safe without ->siglock, we can race with sigqueue_free().

Oleg.

