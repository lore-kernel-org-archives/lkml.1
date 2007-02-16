Return-Path: <linux-kernel-owner+w=401wt.eu-S1423485AbXBPJdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423485AbXBPJdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 04:33:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423486AbXBPJdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 04:33:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40656 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423485AbXBPJdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 04:33:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: vatsa@in.ibm.com
Subject: Re: [RFC PATCH(Experimental) 1/4] freezer-cpu-hotplug core
Date: Fri, 16 Feb 2007 10:29:20 +0100
User-Agent: KMail/1.9.5
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Gautham R Shenoy <ego@in.ibm.com>,
       akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu, dipankar@in.ibm.com,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org
References: <20070214144031.GA15257@in.ibm.com> <20070216071617.GB4527@in.ibm.com> <20070216081209.GB2829@in.ibm.com>
In-Reply-To: <20070216081209.GB2829@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702161029.21560.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 16 February 2007 09:12, Srivatsa Vaddagiri wrote:
> On Fri, Feb 16, 2007 at 12:46:17PM +0530, Srivatsa Vaddagiri wrote:
> > frozen. The only exception is cleaning up of per-cpu threads (which is
> > not possible with processes frozen - if we can find a way to make that
> > possible, then everything can be done in CPU_DEAD).
> 
> How abt a patch like below?
> 
> 
> --- process.c.org	2007-02-16 13:38:39.000000000 +0530
> +++ process.c	2007-02-16 13:38:59.000000000 +0530
> @@ -47,7 +47,7 @@ void refrigerator(void)
>  	recalc_sigpending(); /* We sent fake signal, clean it up */
>  	spin_unlock_irq(&current->sighand->siglock);
>  
> -	while (frozen(current)) {
> +	while (frozen(current) && !kthread_should_stop()) {
>  		current->state = TASK_UNINTERRUPTIBLE;
>  		schedule();
>  	}
> 
> This should let us do kthread_stop() in CPU_DEAD itself (while processes
> are frozen)? That would allow us to do everything from CPU_DEAD itself
> (and not have CPU_DEAD_KILL_THREADS).

Well, the suspend code has been developed with the assumption that frozen
threads stay frozen until _we_ let them thaw by calling thaw_processes().  I'm
a bit afraid of this change.

Greetings,
Rafael
