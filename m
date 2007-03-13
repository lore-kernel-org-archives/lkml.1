Return-Path: <linux-kernel-owner+w=401wt.eu-S1753020AbXCMFfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbXCMFfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 01:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbXCMFfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 01:35:51 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:52494 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbXCMFfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 01:35:50 -0400
Date: Tue, 13 Mar 2007 11:12:41 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Anton Blanchard <anton@samba.org>, Andrew Morton <akpm@osdl.org>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Aneesh Kumar <aneesh.kumar@gmail.com>
Subject: Re: [PATCH] kthread_should_stop_check_freeze (was: Re: [PATCH -mm 3/7] Freezer: Remove PF_NOFREEZE from rcutorture thread)
Message-ID: <20070313054241.GB19071@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <200702260800.49603.rjw@sisk.pl> <20070303005843.GG2373@linux.vnet.ibm.com> <20070303173240.GA249@tv-sign.ru> <200703111849.09966.rjw@sisk.pl> <20070313052716.GA11982@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070313052716.GA11982@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 10:57:16AM +0530, Gautham R Shenoy wrote:
> CPU_DEAD:
> thaw_process(p);
> kthread_stop(p);
> p = NULL;

This neednt guarantee that the thread will see the stop request before
it exits the kthread_should_stop_freeze() function. There will always
be races .. So the only safe way for a thread to know whether it is time
to exit is:

	while (!kthread_should_stop_freeze()) {
		 if (!cpu_online(home_cpu)) 
			goto wait_to_die;

		...

	}

wait_to_die:

	while (!kthread_should_stop()) {
		/* sleep */
	}


-- 
Regards,
vatsa
