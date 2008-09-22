Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113AbYIVOhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbYIVOhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 10:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbYIVOhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 10:37:11 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:52820 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbYIVOhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 10:37:10 -0400
Date: Mon, 22 Sep 2008 18:43:03 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Krishna Kumar <krkumar2@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] [PATCH 1/1]: timers: Change add_timer to use add_timer_on
Message-ID: <20080922144303.GA295@tv-sign.ru>
References: <20080922043425.21118.24172.sendpatchset@localhost.localdomain> <20080922043438.21118.93359.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922043438.21118.93359.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(add Thomas)

On 09/22, Krishna Kumar wrote:
>
> timer: Change add_timer to not check for existing timer.

Perhaps the changelog should explain why ;)

But, besides the removing BUG_ON(), the patch does something else.

>  static inline void add_timer(struct timer_list *timer)
>  {
> -	BUG_ON(timer_pending(timer));
> -	__mod_timer(timer, timer->expires);
> +	add_timer_on(timer, raw_smp_processor_id());
>  }

This is racy wrt CPU hotplug. The CPU can be cpu_down()'ed right
after raw_smp_processor_id() returns, and before we actually add
the timer.

Another problem is that now it is add_timer() becomes unsafe wrt
concurrent del_timer/del_timer_sync, because add_timer_on() does
not lock the timer, it only locks the target base.

Oleg.

