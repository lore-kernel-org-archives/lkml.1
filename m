Return-Path: <linux-kernel-owner+w=401wt.eu-S1764550AbXGaPCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764550AbXGaPCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 11:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761473AbXGaPCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 11:02:42 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42473 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761228AbXGaPCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 11:02:41 -0400
Date: Tue, 31 Jul 2007 08:02:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, alan@lxorguk.ukuu.org.uk,
       vatsa@linux.vnet.ibm.com, chrisw@sous-sol.org, clameter@sgi.com,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 14/26] sched: fix next_interval determination in idle_balance()
Message-ID: <20070731150234.GA11956@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070731042108.546594256@blue.kroah.org> <20070731043254.GO3975@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731043254.GO3975@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 09:32:54PM -0700, Greg KH wrote:
> -stable review patch.  If anyone has any objections, please let us know.

Hello, Greg,

No objections here -- on the contrary, very nice not to have to manually
"taskset" my rcutorture runs.  ;-)

						Thanx, Paul

> ------------------
> 
> From: Christoph Lameter <clameter@sgi.com>
> 
> Fix massive SMP imbalance on NUMA nodes observed on 2.6.21.5 with CFS. 
> (and later on reproduced without CFS as well).
> 
> The intervals of domains that do not have SD_BALANCE_NEWIDLE must be 
> considered for the calculation of the time of the next balance. 
> Otherwise we may defer rebalancing forever and nodes might stay idle for 
> very long times.
> 
> Siddha also spotted that the conversion of the balance interval to 
> jiffies is missing. Fix that to.
> 
> From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> 
> also continue the loop if !(sd->flags & SD_LOAD_BALANCE).
> 
> Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> It did in fact trigger under all three of mainline, CFS, and -rt 
> including CFS -- see below for a couple of emails from last Friday 
> giving results for these three on the AMD box (where it happened) and on 
> a single-quad NUMA-Q system (where it did not, at least not with such 
> severity).
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  kernel/sched.c |   22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> --- linux-2.6.21.6.orig/kernel/sched.c
> +++ linux-2.6.21.6/kernel/sched.c
> @@ -2831,17 +2831,21 @@ static void idle_balance(int this_cpu, s
>  	unsigned long next_balance = jiffies + 60 *  HZ;
> 
>  	for_each_domain(this_cpu, sd) {
> -		if (sd->flags & SD_BALANCE_NEWIDLE) {
> +		unsigned long interval;
> +
> +		if (!(sd->flags & SD_LOAD_BALANCE))
> +			continue;
> +
> +		if (sd->flags & SD_BALANCE_NEWIDLE)
>  			/* If we've pulled tasks over stop searching: */
>  			pulled_task = load_balance_newidle(this_cpu,
> -							this_rq, sd);
> -			if (time_after(next_balance,
> -				  sd->last_balance + sd->balance_interval))
> -				next_balance = sd->last_balance
> -						+ sd->balance_interval;
> -			if (pulled_task)
> -				break;
> -		}
> +								this_rq, sd);
> +
> +		interval = msecs_to_jiffies(sd->balance_interval);
> +		if (time_after(next_balance, sd->last_balance + interval))
> +			next_balance = sd->last_balance + interval;
> +		if (pulled_task)
> +			break;
>  	}
>  	if (!pulled_task)
>  		/*
> 
> -- 
