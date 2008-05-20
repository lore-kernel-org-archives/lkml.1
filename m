Return-Path: <linux-kernel-owner+w=401wt.eu-S1764065AbYETKSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764065AbYETKSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 06:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbYETKRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 06:17:53 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:44313 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756363AbYETKRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 06:17:50 -0400
Date: Tue, 20 May 2008 13:17:32 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] signals: fix sigqueue_free() vs __exit_signal() race
Message-ID: <20080520091732.GB101@tv-sign.ru>
References: <20080517151418.GA9487@tv-sign.ru> <20080519233330.b594783a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080519233330.b594783a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19, Andrew Morton wrote:
>
> On Sat, 17 May 2008 19:14:18 +0400 Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> > __exit_signal() does flush_sigqueue(tsk->pending) outside of ->siglock.
> > This can race with another thread doing sigqueue_free(), we can free
> > the same SIGQUEUE_PREALLOC sigqueue twice or corrupt the pending->list.
> > 
> > Note that even sys_exit_group() can trigger this race, not only
> > sys_timer_delete().
> > 
> > Move the callsite of flush_sigqueue(tsk->pending) under ->siglock.
> > 
> > This patch doesn't touch flush_sigqueue(->shared_pending) below, it is
> > called when there are no other threads which can play with signals,
> > and sigqueue_free() can't be used outside of our thread group.
> 
> afacit this is the only needed-in-2.6.26 patch from these two
> three-patch series, yes?

Yes, other patches are not bugfixes.

Probably this fix is not "urgent" too, the race is very old and nobody
complained.

Oleg.

