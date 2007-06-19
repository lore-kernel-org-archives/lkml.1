Return-Path: <linux-kernel-owner+w=401wt.eu-S1759594AbXFSFkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594AbXFSFkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 01:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbXFSFk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 01:40:29 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37691 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbXFSFk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 01:40:29 -0400
Date: Tue, 19 Jun 2007 11:19:01 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>, pwil3058@bigpond.net.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: v2.6.21.4-rt11
Message-ID: <20070619054901.GA10981@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070615195545.GA28872@elte.hu> <20070616011605.GH9301@linux.vnet.ibm.com> <20070616084434.GG2559@linux.vnet.ibm.com> <20070616161213.GA2994@linux.vnet.ibm.com> <20070618151215.GA9750@linux.vnet.ibm.com> <Pine.LNX.4.64.0706180948250.4751@schroedinger.engr.sgi.com> <20070618173558.GA17865@linux.vnet.ibm.com> <Pine.LNX.4.64.0706181054530.6596@schroedinger.engr.sgi.com> <20070619021558.GD7160@linux-os.sc.intel.com> <Pine.LNX.4.64.0706182040500.30213@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706182040500.30213@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 08:46:03PM -0700, Christoph Lameter wrote:
> @@ -2493,17 +2493,18 @@ static void idle_balance(int this_cpu, s
>  	unsigned long next_balance = jiffies + 60 *  HZ;
> 
>  	for_each_domain(this_cpu, sd) {
> -		if (sd->flags & SD_BALANCE_NEWIDLE) {
> +		unsigned long interval;
> +

Do we need a :

		if (!(sd->flags & SD_LOAD_BALANCE))
			continue;

here?

Otherwise patch look good and fixes the problem Paul observed earlier.

> +		if (sd->flags & SD_BALANCE_NEWIDLE)
>  			/* If we've pulled tasks over stop searching: */
> -			pulled_task = load_balance_newidle(this_cpu,
> -							this_rq, sd);
> -			if (time_after(next_balance,
> -				  sd->last_balance + sd->balance_interval))
> -				next_balance = sd->last_balance
> -						+ sd->balance_interval;
> -			if (pulled_task)
> -				break;
> -		}
> +			pulled_task = load_balance_newidle(this_cpu,this_rq, sd);
> +
> +		interval = msecs_to_jiffies(sd->balance_interval);


> +		if (time_after(next_balance,
> +			  sd->last_balance + interval))
> +			next_balance = sd->last_balance + interval;
> +		if (pulled_task)
> +			break;
>  	}
>  	if (!pulled_task)
>  		/*

-- 
Regards,
vatsa
