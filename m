Return-Path: <linux-kernel-owner+w=401wt.eu-S1751517AbXB0Emu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbXB0Emu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 23:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbXB0Emu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 23:42:50 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60583 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbXB0Emt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 23:42:49 -0500
Date: Tue, 27 Feb 2007 10:12:46 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Aneesh Kumar" <aneesh.kumar@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Oleg Nesterov" <oleg@tv-sign.ru>,
       LKML <linux-kernel@vger.kernel.org>, "Andrew Morton" <akpm@osdl.org>,
       "Pavel Machek" <pavel@ucw.cz>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Gautham R Shenoy" <ego@in.ibm.com>
Subject: Re: [RFC][PATCH 1/3] Freezer: Fix vfork problem
Message-ID: <20070227044246.GA20419@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <200702261139.59130.rjw@sisk.pl> <200702261928.19274.rjw@sisk.pl> <20070226212554.GA93@tv-sign.ru> <200702270131.25656.rjw@sisk.pl> <cc723f590702262033k4fa6cbe0n8e327b8339c7a0e4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc723f590702262033k4fa6cbe0n8e327b8339c7a0e4@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27, 2007 at 10:03:53AM +0530, Aneesh Kumar wrote:
> This means that we are not going to wait for the kernel thread
> (Parent) to freeze. I guess what vatsa suggested in previous mail is
> better.
> 
> freeezer_do_not_count(void)
> {
>   if (current->mm) {
> 
>       current->flags |= PF_FREEZER_SKIP;
>   }
> 
> }
> 
> 
> freezer_count(void)
> {
> if (current->mm) {
> current->flags &= ~PF_FREEZER_SKIP;
> try_to_freeze();
>   }
> 
> }
> 
> 
> Now if do_fork is called from kernel_thread with CLONE_VFORK we make
> the freezer wait till that kernel thread is also frozen. I think this
> is important.  with khelper thread it is okey because it is a single
> threaded workqueue.

Yes, this assumes that vfork called by a kernel thread will usually wait
only until the vfork child exec's (and not until the child exit's).
That wait should be very short and hence we can wait for vfork parent as
well.

The advanatge of this is we let kernel threads get to freeze at a place of 
their choice (rather than in some common code like do_fork).

> If do_fork is called via a user process we can skip the Parent if the
> child got frozen before calling execve.

Yes, agreed.

-- 
Regards,
vatsa
