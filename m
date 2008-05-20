Return-Path: <linux-kernel-owner+w=401wt.eu-S1761078AbYETGec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761078AbYETGec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 02:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755684AbYETGeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 02:34:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755470AbYETGeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 02:34:22 -0400
Date: Mon, 19 May 2008 23:33:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] signals: fix sigqueue_free() vs __exit_signal()
 race
Message-Id: <20080519233330.b594783a.akpm@linux-foundation.org>
In-Reply-To: <20080517151418.GA9487@tv-sign.ru>
References: <20080517151418.GA9487@tv-sign.ru>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2008 19:14:18 +0400 Oleg Nesterov <oleg@tv-sign.ru> wrote:

> __exit_signal() does flush_sigqueue(tsk->pending) outside of ->siglock.
> This can race with another thread doing sigqueue_free(), we can free
> the same SIGQUEUE_PREALLOC sigqueue twice or corrupt the pending->list.
> 
> Note that even sys_exit_group() can trigger this race, not only
> sys_timer_delete().
> 
> Move the callsite of flush_sigqueue(tsk->pending) under ->siglock.
> 
> This patch doesn't touch flush_sigqueue(->shared_pending) below, it is
> called when there are no other threads which can play with signals,
> and sigqueue_free() can't be used outside of our thread group.

afacit this is the only needed-in-2.6.26 patch from these two
three-patch series, yes?
