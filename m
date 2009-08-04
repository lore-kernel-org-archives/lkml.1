Return-Path: <linux-kernel-owner+w=401wt.eu-S933153AbZHDRdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153AbZHDRdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 13:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932928AbZHDRdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 13:33:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:60359 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932873AbZHDRdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 13:33:50 -0400
Subject: Re: [PATCH 0/4] Virtual Machine Time Accounting
From: Peter Zijlstra <peterz@infradead.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Laurent Vivier <Laurent.Vivier@bull.net>, Ingo Molnar <mingo@elte.hu>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <20090804192924.217930fc@skybase>
References: <46C99371.7070705@bull.net> <1249395398.7924.223.camel@twins>
	 <20090804170747.11801f0a@skybase> <1249403202.4762.12.camel@laptop>
	 <20090804192924.217930fc@skybase>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 19:33:14 +0200
Message-Id: <1249407194.4762.28.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-04 at 19:29 +0200, Martin Schwidefsky wrote:

> > So its going to split user time into user and guest. Does that really
> > make sense? For the host kernel it really is just another user process,
> > no?
> 
> The code (at least in parts) is already upstream. Look at the
> account_guest_time function:
> 
> static void account_guest_time(struct task_struct *p, cputime_t cputime,
>                                cputime_t cputime_scaled)
> {
>         cputime64_t tmp;
>         struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
> 
>         tmp = cputime_to_cputime64(cputime);
> 
>         /* Add guest time to process. */
>         p->utime = cputime_add(p->utime, cputime);
>         p->utimescaled = cputime_add(p->utimescaled, cputime_scaled);
>         account_group_user_time(p, cputime);
>         p->gtime = cputime_add(p->gtime, cputime);
> 
>         /* Add guest time to cpustat. */
>         cpustat->user = cputime64_add(cpustat->user, tmp);
>         cpustat->guest = cputime64_add(cpustat->guest, tmp);
> }
> 
> The cpu time for a guest is added to p->utime AND p->gtime. That is
> done not to break existing tools that know nothing about guest time.
> A guest time aware tool can subtract the p->gtime from p->utime to
> get the time spent by the process outside of the guest context.

But why? How a vcpu anything other than yet another userspace process?

