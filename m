Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbYKJHby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbYKJHby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 02:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbYKJHbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 02:31:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50314 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbYKJHbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 02:31:43 -0500
Date: Mon, 10 Nov 2008 08:30:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Oleg Nesterov <oleg@tv-sign.ru>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Max Krasnyansky <maxk@qualcomm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11380] lockdep warning: cpu_add_remove_lock
	at:cpu_maps_update_begin+0x14/0x16
Message-ID: <20081110073047.GA28578@elte.hu>
References: <A3oCZU7cpuO.A.ChB.ZZ1FJB@chimera> <4B0Eqx89uNG.A.J5D.9b1FJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0Eqx89uNG.A.J5D.9b1FJB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.26 and 2.6.27.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> be listed and let me know (either way).
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11380
> Subject		: lockdep warning: cpu_add_remove_lock at:cpu_maps_update_begin+0x14/0x16
> Submitter	: Ingo Molnar <mingo@elte.hu>
> Date		: 2008-08-20 6:44 (82 days old)
> References	: http://marc.info/?l=linux-kernel&m=121921480931970&w=4

had a quick look again: i believe this one still triggers, and it's 
caused by some interaction between input code and workqueue code. I 
think it started triggering when Oleg's workqueue annotation patches 
went upstream:

6af8bf3: workqueues: add comments to __create_workqueue_key()
8448502: workqueues: do CPU_UP_CANCELED if CPU_UP_PREPARE fails
8de6d30: workqueues: schedule_on_each_cpu() can use schedule_work_on()
ef1ca23: workqueues: queue_work() can use queue_work_on()
a67da70: workqueues: lockdep annotations for flush_work()
3da1c84: workqueues: make get_online_cpus() useable for work->func()
8616a89: workqueues: schedule_on_each_cpu: use flush_work()
db70089: workqueues: implement flush_work()
1a4d9b0: workqueues: insert_work: use "list_head *" instead of "int tail"

plus when the cpu_active_map changes went upstream:

e761b77: cpu hotplug, sched: Introduce cpu_active_map and redo sched domain ma

so it's possibly an old input layer locking problem that only got 
exposed via current changes. It's not an input layer bug that got 
introduced ~80 days ago, but possibly an input layer problem. Or a CPU 
hotplug bug. Or a workqueue bug.

	Ingo
