Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934202Ab0BYVoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 16:44:09 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47987 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934187Ab0BYVn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 16:43:59 -0500
Subject: Re: [PATCH 2/3] sched: enforce per-cpu utilization limits on
 runtime balancing
From: Peter Zijlstra <peterz@infradead.org>
To: Fabio Checconi <fchecconi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Paul Turner <pjt@google.com>,
       Dario Faggioli <faggioli@gandalf.sssup.it>,
       Michael Trimarchi <michael@evidence.eu.com>,
       Dhaval Giani <dhaval@retis.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>, linux-kernel@vger.kernel.org,
       Fabio Checconi <fabio@gandalf.sssup.it>
In-Reply-To: <91b76b9b7555024d9afd7264eeae1b2db6a5e74c.1266931410.git.fabio@helm.retis>
References: <cover.1266931410.git.fabio@helm.retis>
	 <91b76b9b7555024d9afd7264eeae1b2db6a5e74c.1266931410.git.fabio@helm.retis>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Feb 2010 21:28:24 +0100
Message-ID: <1267129704.22519.560.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-23 at 19:56 +0100, Fabio Checconi wrote:
> +static inline void double_spin_lock(raw_spinlock_t *lock1,
> +                                   raw_spinlock_t *lock2)
> +       __acquires(lock1)
> +       __acquires(lock2)
> +{
> +       if (lock1 < lock2) {
> +               raw_spin_lock(lock1);
> +               raw_spin_lock_nested(lock2, SINGLE_DEPTH_NESTING);
> +       } else {
> +               raw_spin_lock(lock2);
> +               raw_spin_lock_nested(lock1, SINGLE_DEPTH_NESTING);
> +       }
> +}
> +
> +static inline void double_spin_unlock(raw_spinlock_t *lock1,
> +                                     raw_spinlock_t *lock2)
> +       __releases(lock1)
> +       __releases(lock2)
> +{
> +       raw_spin_unlock(lock1);
> +       lock_set_subclass(&lock2->dep_map, 0, _RET_IP_);
> +       raw_spin_unlock(lock2);
> +} 

If you release both there is no need to re-set the subclass.

