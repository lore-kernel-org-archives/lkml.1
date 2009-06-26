Return-Path: <linux-kernel-owner+w=401wt.eu-S1761385AbZFZUY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761385AbZFZUY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 16:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbZFZUYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 16:24:20 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43052 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbZFZUYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 16:24:19 -0400
Date: Fri, 26 Jun 2009 16:24:11 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       earl_chew@agilent.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/2] exec: Make do_coredump more robust and safer when
	using pipes in core_pattern: recursive dump detection
Message-ID: <20090626202411.GH7337@hmsreliant.think-freely.org>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090625163050.d6a71a13.akpm@linux-foundation.org> <20090626180222.GD7337@hmsreliant.think-freely.org> <20090626165908.GB12063@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626165908.GB12063@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 06:59:08PM +0200, Oleg Nesterov wrote:
> On 06/26, Neil Horman wrote:
> >
> > +		if (core_limit == 0) {
> > +			 /*
> > +			 * Normally core limits are irrelevant to pipes, since
> > +			 * we're not writing to the file system, but we use
> > +			 * core_limit of 0 here as a speacial value. Any
> > +			 * non-zero limit gets set to RLIM_INFINITY below, but
> > +			 * a limit of 0 skips the dump.  This is a consistent
> > +			 * way to catch recursive crashes.  We can still crash
> > +			 * if the core_pattern binary sets RLIM_CORE =  !0
> > +			 * but it runs as root, and can do lots of stupid things
> > +			 * Note that we use task_tgid_vnr here to grab the pid of the
> > +			 * process group leader.  That way we get the right pid if a thread
> > +			 * in a multi-threaded core_pattern process dies.
> > +			 */
> > +			printk(KERN_WARNING "Process %d(%s) has RLIMIT_CORE set to 0\n",
> > +			       task_tgid_vnr(current), current->comm);
> > +			printk(KERN_WARNING "Aborting core\n");
> 
> Andrew has already pointed out this, unprivileged-user-triggerable
> printk.
> 
> Doesn't look good, if core_pattern starts with "|" any user can set
> RLIMIT_CORE = 0 and then just do
> 
> 	for (;;)
> 		if (pid = fork())
> 			kill(pid, SIGQUIT);
> 
> to DOS printk/syslog, no?
> 
I don't think SIGQUIT will trigger this, but SIGSEGV will.  Regardless, if you
do that, I would think you have bigger problems on your system.  I would be
silent about this, but I'm not sure thats a better solution

Neil

> Oleg.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
