Return-Path: <linux-kernel-owner+w=401wt.eu-S1756329AbZFZUOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbZFZUOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 16:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbZFZUOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 16:14:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56996 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbZFZUOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 16:14:00 -0400
Date: Fri, 26 Jun 2009 18:59:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       earl_chew@agilent.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/2] exec: Make do_coredump more robust and safer when
	using pipes in core_pattern: recursive dump detection
Message-ID: <20090626165908.GB12063@redhat.com>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090625163050.d6a71a13.akpm@linux-foundation.org> <20090626180222.GD7337@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626180222.GD7337@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26, Neil Horman wrote:
>
> +		if (core_limit == 0) {
> +			 /*
> +			 * Normally core limits are irrelevant to pipes, since
> +			 * we're not writing to the file system, but we use
> +			 * core_limit of 0 here as a speacial value. Any
> +			 * non-zero limit gets set to RLIM_INFINITY below, but
> +			 * a limit of 0 skips the dump.  This is a consistent
> +			 * way to catch recursive crashes.  We can still crash
> +			 * if the core_pattern binary sets RLIM_CORE =  !0
> +			 * but it runs as root, and can do lots of stupid things
> +			 * Note that we use task_tgid_vnr here to grab the pid of the
> +			 * process group leader.  That way we get the right pid if a thread
> +			 * in a multi-threaded core_pattern process dies.
> +			 */
> +			printk(KERN_WARNING "Process %d(%s) has RLIMIT_CORE set to 0\n",
> +			       task_tgid_vnr(current), current->comm);
> +			printk(KERN_WARNING "Aborting core\n");

Andrew has already pointed out this, unprivileged-user-triggerable
printk.

Doesn't look good, if core_pattern starts with "|" any user can set
RLIMIT_CORE = 0 and then just do

	for (;;)
		if (pid = fork())
			kill(pid, SIGQUIT);

to DOS printk/syslog, no?

Oleg.

