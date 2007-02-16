Return-Path: <linux-kernel-owner+w=401wt.eu-S966191AbXBPIML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966191AbXBPIML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 03:12:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966192AbXBPIML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 03:12:11 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:41188 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966191AbXBPIMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 03:12:10 -0500
Date: Fri, 16 Feb 2007 13:42:09 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@osdl.org, paulmck@us.ibm.com,
       mingo@elte.hu, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [RFC PATCH(Experimental) 1/4] freezer-cpu-hotplug core
Message-ID: <20070216081209.GB2829@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070214144031.GA15257@in.ibm.com> <20070214144229.GA19789@in.ibm.com> <20070214202209.GC301@tv-sign.ru> <20070216071617.GB4527@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070216071617.GB4527@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 12:46:17PM +0530, Srivatsa Vaddagiri wrote:
> frozen. The only exception is cleaning up of per-cpu threads (which is
> not possible with processes frozen - if we can find a way to make that
> possible, then everything can be done in CPU_DEAD).

How abt a patch like below?


--- process.c.org	2007-02-16 13:38:39.000000000 +0530
+++ process.c	2007-02-16 13:38:59.000000000 +0530
@@ -47,7 +47,7 @@ void refrigerator(void)
 	recalc_sigpending(); /* We sent fake signal, clean it up */
 	spin_unlock_irq(&current->sighand->siglock);
 
-	while (frozen(current)) {
+	while (frozen(current) && !kthread_should_stop()) {
 		current->state = TASK_UNINTERRUPTIBLE;
 		schedule();
 	}

This should let us do kthread_stop() in CPU_DEAD itself (while processes
are frozen)? That would allow us to do everything from CPU_DEAD itself
(and not have CPU_DEAD_KILL_THREADS).


-- 
Regards,
vatsa
