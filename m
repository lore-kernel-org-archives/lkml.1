Return-Path: <linux-kernel-owner+w=401wt.eu-S1752569AbZKEJLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbZKEJLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 04:11:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbZKEJLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 04:11:04 -0500
Received: from ozlabs.org ([203.10.76.45]:53318 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbZKEJLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 04:11:01 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Valdis.Kletnieks@vt.edu
Subject: Re: 2.6.32-rc5-mmotm1101 - lockdep whinge during early boot
Date: Thu, 5 Nov 2009 19:41:03 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
References: <6417.1257351084@turing-police.cc.vt.edu>
In-Reply-To: <6417.1257351084@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911051941.03401.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Nov 2009 02:41:24 am Valdis.Kletnieks@vt.edu wrote:
 [    0.344147] swapper/1 is trying to acquire lock:
> [    0.344154]  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103c222>] cpu_maps_update_begin+0x12/0x14
> [    0.344174]
> [    0.344175] but task is already holding lock:
> [    0.344183]  (setup_lock){+.+.+.}, at: [<ffffffff81078755>] stop_machine_create+0x12/0x9b
> [    0.344200]
> [    0.344201] which lock already depends on the new lock.

Hi Vladis!

    Sigh.  I always find reading these a complete mindfuck.

stop_machine_create: setup_lock then cpu_add_remove_lock
	(in create_workqueue_key() -> cpu_maps_update_begin())
clocksource_done_booting: clocksource_mutex then setup_lock
	(in stop_machine_create(), as above)
cpu_up: cpu_add_remove_lock then clocksource_mutex
	(in mark_tsc_unstable() -> clocksource_change_rating())

AFAICT this is our circular dependency.  But I'm no closer to knowing how to
solve it.

Oleg (CC'd) made workqueues use cpu_maps_update_begin() instead of the
more obvious get_online_cpus() in 3da1c84c00c7e5f.  Reverting that seems like
a bad idea.

Or, if the clocksource list wasn't ordered, we could change the rating without
a lock.

Either way, the locking shark is well and truly jumped...
Rusty.
