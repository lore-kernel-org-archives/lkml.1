Return-Path: <linux-kernel-owner+w=401wt.eu-S1752152AbXHAUcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbXHAUcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 16:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbXHAUcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 16:32:08 -0400
Received: from mail.screens.ru ([213.234.233.54]:38264 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbXHAUcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 16:32:07 -0400
Date: Thu, 2 Aug 2007 00:32:12 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Daniel Walker <dwalker@mvista.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to workqueue infrastructure
Message-ID: <20070801203212.GC225@tv-sign.ru>
References: <20070801002407.4973.54778.stgit@novell1.haskins.net> <1185940340.2636.97.camel@imap.mvista.com> <1185987663.12034.99.camel@twins> <20070801181253.GA90@tv-sign.ru> <1185992994.2636.142.camel@imap.mvista.com> <20070801201802.GA225@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070801201802.GA225@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02, Oleg Nesterov wrote:
>
> And I don't understand why rt_mutex_setprio() is called just before
> calling work->func(). This means that a high-priority work could
> be delayed by the low-priority ->current_work.

Aha, I missed the rt_mutex_setprio() in insert_work().

This is not good either. Suppose we have

	void work_handler(struct work_struct *self)
	{
		if (!try_lock()) {
			// try again later...
			queue_work(wq, self);
			return;
		}

		do_the_work();
	}

What if that work was queued by the low-priority thread, and
then a high-priority thread inserts a new work when work_handler()
is running?

Oleg.

