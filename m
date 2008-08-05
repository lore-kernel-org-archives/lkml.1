Return-Path: <linux-kernel-owner+w=401wt.eu-S1761330AbYHEPgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761330AbYHEPgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 11:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759216AbYHEPgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 11:36:32 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:42408 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760193AbYHEPgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 11:36:31 -0400
Date: Tue, 5 Aug 2008 19:40:04 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] posix-timers: lock_timer: make it readable
Message-ID: <20080805154004.GA9761@tv-sign.ru>
References: <20080805153213.GA9754@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805153213.GA9754@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05, Oleg Nesterov wrote:
>
> Cleanup. Imho makes the code much more understandable. At least this
> patch lessens both the source and compiled code.

To simplify the review, I am posting the code with this patch applied.

static struct k_itimer *lock_timer(timer_t timer_id, unsigned long *flags)
{
	struct k_itimer *timr;
	/*
	 * Watch out here.  We do a irqsave on the idr_lock and pass the
	 * flags part over to the timer lock.  Must not let interrupts in
	 * while we are moving the lock.
	 */
	spin_lock_irqsave(&idr_lock, *flags);
	timr = idr_find(&posix_timers_id, (int)timer_id);
	if (timr) {
		spin_lock(&timr->it_lock);
		if (timr->it_process &&
		    same_thread_group(timr->it_process, current)) {
			spin_unlock(&idr_lock);
			return timr;
		}
		spin_unlock(&timr->it_lock);
	}
	spin_unlock_irqrestore(&idr_lock, *flags);

	return NULL;
}

Oleg.

