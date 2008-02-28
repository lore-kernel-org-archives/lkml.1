Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbYB1FFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbYB1FFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 00:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750755AbYB1FF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 00:05:29 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:32894 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbYB1FF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 00:05:28 -0500
Date: Thu, 28 Feb 2008 10:35:08 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, hidave.darkstar@gmail.com,
       akpm@linux-foundation.org, fzu@wemgehoertderstaat.de, mingo@elte.hu,
       dipankar@in.ibm.com, niv@us.ibm.com, dvhltc@us.ibm.com
Subject: Re: [PATCH] Fix hibernate/resume in presence of PREEMPT_RCU and
	hotplug
Message-ID: <20080228050507.GA31289@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20080228002110.GA20091@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228002110.GA20091@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 04:21:10PM -0800, Paul E. McKenney wrote:
> Hello!
> 
> This fixes a oops encountered when doing hibernate/resume in presence
> of PREEMPT_RCU.  The problem was that the code failed to disable preemption
> when accessing a per-CPU variable.  This is OK when called from code
> that already has preemption disabled, but such is not the case from
> the suspend/resume code path.

Well, rcu_offline_cpu() is called from the cpu-offline callback path, and
AFAICS, it doesn't disable preemption.

I wonder how we're seeing this only now! Indeed a good catch!

Reviewed-by: Gautham R Shenoy <ego@in.ibm.com>

> 
> Reported-by: Dave Young <hidave.darkstar@gmail.com>
> Tested-by: Dave Young <hidave.darkstar@gmail.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  rcupreempt.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff -urpNa -X dontdiff linux-2.6.25-rc3/kernel/rcupreempt.c linux-2.6.25-rc3-rcuoffline/kernel/rcupreempt.c
> --- linux-2.6.25-rc3/kernel/rcupreempt.c	2008-02-26 16:58:43.000000000 -0800
> +++ linux-2.6.25-rc3-rcuoffline/kernel/rcupreempt.c	2008-02-26 17:04:17.000000000 -0800
> @@ -702,8 +702,9 @@ void rcu_offline_cpu(int cpu)
>  	 * fix.
>  	 */
> 
> +	local_irq_save(flags);
>  	rdp = RCU_DATA_ME();
> -	spin_lock_irqsave(&rdp->lock, flags);
> +	spin_lock(&rdp->lock);
>  	*rdp->nexttail = list;
>  	if (list)
>  		rdp->nexttail = tail;

-- 
Thanks and Regards
gautham
