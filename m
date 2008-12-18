Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753541AbYLRBoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbYLRBoE (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 20:44:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbYLRBnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 20:43:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750696AbYLRBnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 20:43:52 -0500
Date: Wed, 17 Dec 2008 17:42:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
        venkatesh.pallipadi@intel.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        dipankar@in.ibm.com, balbir@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, ego@in.ibm.com, andi@firstfloor.org,
        davecb@sun.com, tconnors@astro.swin.edu.au, maxk@qualcomm.com,
        gregory.haskins@gmail.com, pavel@suse.cz, svaidy@linux.vnet.ibm.com
Subject: Re: [PATCH v6 6/7] sched: add SD_BALANCE_NEWIDLE at MC and CPU
 level for sched_mc>0
Message-Id: <20081217174254.ea19a246.akpm@linux-foundation.org>
In-Reply-To: <20081217172738.534.3118.stgit@drishya.in.ibm.com>
References: <20081217172309.534.28847.stgit@drishya.in.ibm.com>
	<20081217172738.534.3118.stgit@drishya.in.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008 22:57:38 +0530
Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:

> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -782,6 +782,16 @@ enum powersavings_balance_level {
>  	((sched_mc_power_savings || sched_smt_power_savings) ?	\
>  	 SD_POWERSAVINGS_BALANCE : 0)

What's with all the crappy macros in here?

> +/*
> + * Optimise SD flags for power savings:
> + * SD_BALANCE_NEWIDLE helps agressive task consolidation and power savings.
> + * Keep default SD flags if sched_{smt,mc}_power_saving=0
> + */
> +
> +#define POWERSAVING_SD_FLAGS	\
> +	((sched_mc_power_savings || sched_smt_power_savings) ?	\
> +	  SD_BALANCE_NEWIDLE : 0)

This one purports to be a constant, but it isn't - it's code.

It would be cleaner, clearer and more idiomatic to do

static inline int powersaving_sd_flags(void)
{
	...
}

Also, doing (sched_mc_power_savings | sched_smt_power_saving) might
save a branch.

>  #define test_sd_parent(sd, flag)	((sd->parent &&		\
>  					 (sd->parent->flags & flag)) ? 1 : 0)

buggy when passed an expression with side-effects.  Doesn't need to be
implemented as a macro.


Sigh.


