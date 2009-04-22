Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbZDVJBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbZDVJBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 05:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbZDVJBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 05:01:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44643 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbZDVJBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 05:01:12 -0400
Date: Wed, 22 Apr 2009 11:01:09 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RT] - Mismatching declaration and export
Message-ID: <20090422090109.GC2479@pengutronix.de>
References: <1240338205.13601.17.camel@quadrophenia.thebigcorporation.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1240338205.13601.17.camel@quadrophenia.thebigcorporation.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Apr 21, 2009 at 11:23:25AM -0700, Sven-Thorsten Dietrich wrote:
> Subject: Make function declaration match EXPORT()
> -unsigned long __lockfunc _spin_lock_irqsave_nested(spinlock_t *lock, int subclass)
> +unsigned long __lockfunc __spin_lock_irqsave_nested(spinlock_t *lock, int subclass)

	ukl@octopus:~/gsrc/linux-2.6$ git show v2.6.29.1-rt8:kernel/spinlock.c | sed -n -e '357,376p'
	unsigned long __lockfunc __spin_lock_irqsave_nested(raw_spinlock_t *lock, int subclass)
	{
		unsigned long flags;

		local_irq_save(flags);
		preempt_disable();
		spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
		/*
		 * On lockdep we dont want the hand-coded irq-enable of
		 * _raw_spin_lock_flags() code, because lockdep assumes
		 * that interrupts are not re-enabled during lock-acquire:
		 */
	#ifdef CONFIG_LOCKDEP
		LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
	#else
		_raw_spin_lock_flags(lock, &flags);
	#endif
		return flags;
	}
	EXPORT_SYMBOL(__spin_lock_irqsave_nested);

so this seems to be already included in 2.6.29.1-rt8.  Where is it
missing?

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
