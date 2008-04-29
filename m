Return-Path: <linux-kernel-owner+w=401wt.eu-S1757234AbYD2Odc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234AbYD2Odc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbYD2OdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:33:25 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:38658 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbYD2OdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:33:24 -0400
Date: Tue, 29 Apr 2008 18:33:50 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [PATCH 5/8] cpu: cpu-hotplug deadlock
Message-ID: <20080429143350.GA246@tv-sign.ru>
References: <20080429125659.GA23562@in.ibm.com> <20080429130201.GF23562@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429130201.GF23562@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29, Gautham R Shenoy wrote:
>
> cpu_hotplug.mutex is basically a lock-internal lock; but by keeping it locked
> over the 'write' section (cpu_hotplug_begin/done) a lock inversion happens when
> some of the write side code calls into code that would otherwise take a
> read lock.
>
> And it so happens that read-in-write recursion is expressly permitted.
>
> Fix this by turning cpu_hotplug into a proper stand alone unfair reader/writer
> lock that allows reader-in-reader and reader-in-writer recursion.

While the patch itself is very clean and understandable, I can't understand
the changelog ;)

Could you explain what is the semantics difference? The current code allows
read-in-write recursion too.

The only difference I can see is that now cpu_hotplug_begin() doesn't rely
on cpu_add_remove_lock any longer (currently the caller must hold this lock),
but this (good) change is not documented.

>  static void cpu_hotplug_done(void)
>  {
> +	spin_lock(&cpu_hotplug.lock);
>  	cpu_hotplug.active_writer = NULL;
> -	mutex_unlock(&cpu_hotplug.lock);
> +	if (!list_empty(&cpu_hotplug.writer_queue.task_list))

waitqueue_active() ?

> +		wake_up(&cpu_hotplug.writer_queue);
> +	else
> +		wake_up_all(&cpu_hotplug.reader_queue);

Please note that wake_up() and wake_up_all() doesn't differ here, because
cpu_hotplug_begin() use prepare_to_wait(), not prepare_to_wait_exclusive().
I'd suggest to change cpu_hotplug_begin(), and use wake_up() for both
cases.

(actually, since write-locks should be very rare, perhaps we don't need
 2 wait_queues ?)

Oleg.

