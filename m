Return-Path: <linux-kernel-owner+w=401wt.eu-S1759240AbXELO7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240AbXELO7h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 10:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbXELO7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 10:59:31 -0400
Received: from mail.screens.ru ([213.234.233.54]:41320 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbXELO7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 10:59:30 -0400
Date: Sat, 12 May 2007 18:59:19 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ego@in.ibm.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: migrate_dead_tasks() vs sleep-after-exit_notify() problems?
Message-ID: <20070512145919.GC98@tv-sign.ru>
References: <200705110035.32229.rjw@sisk.pl> <200705120201.42619.rjw@sisk.pl> <20070512081622.GA26265@in.ibm.com> <200705121127.37655.rjw@sisk.pl> <20070512142558.GB98@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070512142558.GB98@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12, Oleg Nesterov wrote:
> 
> 	exit_notify()   ->exit_state != 0, and perhaps the task disappears
> 	                  from global process list

This, btw, means that do_exit()->__free_pipe_info() is not cpu-hotplug friendly.

The task may sleep on mutex_lock(->i_mutex), and dequeued from rq->arrays[].

The parent reaps this task, or it was TASK_DEAD and reaped itself.

CPU_DEAD comes, migration_call(CPU_DEAD) can do nothing with this task:

	- we already did release_task()->__unhash_process(), so
	  migrate_live_tasks() can't see it

	- migrate_dead_tasks() can't see it because it was deactivated.

No?

probably __might_sleep() should also check __exit_state.

Oleg.

