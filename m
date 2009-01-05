Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbZAEVyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbZAEVyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 16:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbZAEVyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 16:54:32 -0500
Received: from relay1.sgi.com ([192.48.179.29]:53805 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753162AbZAEVyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 16:54:31 -0500
Date: Mon, 5 Jan 2009 15:54:29 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Greg KH <greg@kroah.com>,
       Nick Piggin <npiggin@suse.de>, Robin Holt <holt@sgi.com>
Subject: Re: 2.6.27.8 scheduler bug - threads not being scheduled for long periods
Message-ID: <20090105215429.GA20319@sgi.com>
References: <20090105175641.GA17055@sgi.com> <1231188958.11687.12.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231188958.11687.12.camel@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 09:55:58PM +0100, Peter Zijlstra wrote:
> On Mon, 2009-01-05 at 11:56 -0600, Dimitri Sivanich wrote:
> > One place we've found this happens is in update_curr(), which calculates a
> > delta_exec value as follows:
> >         delta_exec = (unsigned long)(now - curr->exec_start);
> > 
> > Sometimes this value will be very large, as 'now' (the rq clock time) will
> > be less than 'exec_start'.  When this happens, __update_curr() will
> > calculate a delta_exec_weighted based on this large value and add it to the
> > thread's vruntime:
> >         curr->vruntime += delta_exec_weighted;
> 
> So you're saying your rq->clock = sched_clock_cpu(cpu) = sched_clock()
> [on ia64] goes backwards?
> 
> If so, then that's an architecture bug, sched_clock() must never be seen
> to go backwards!

Actually, sched_clock() should not go backwards on any one cpu, but the readings will be different between cpus.

Also, we noticed the following code is being used for sched_clock_cpu():
u64 sched_clock_cpu(int cpu)
{
        if (unlikely(!sched_clock_running))
                return 0;
        return sched_clock();
}

and is called when smp_processor_id() != cpu.
