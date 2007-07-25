Return-Path: <linux-kernel-owner+w=401wt.eu-S934104AbXGYSUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934104AbXGYSUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 14:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758824AbXGYSUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 14:20:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:30751 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754607AbXGYSUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 14:20:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,581,1175497200"; 
   d="scan'208";a="270529000"
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
From: "Li, Tong N" <tong.n.li@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Chris Snook <csnook@redhat.com>
In-Reply-To: <20070725120358.GA30755@elte.hu>
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com>
	 <20070725110159.GA15076@elte.hu>  <20070725120358.GA30755@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 25 Jul 2007 11:20:05 -0700
Message-Id: <1185387605.14095.16.camel@tongli.jf.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
X-OriginalArrivalTime: 25 Jul 2007 18:20:05.0345 (UTC) FILETIME=[6C9F1D10:01C7CEE8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-25 at 14:03 +0200, Ingo Molnar wrote:

> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/sched.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux/include/linux/sched.h
> ===================================================================
> --- linux.orig/include/linux/sched.h
> +++ linux/include/linux/sched.h
> @@ -681,7 +681,7 @@ enum cpu_idle_type {
>  #define SCHED_LOAD_SHIFT	10
>  #define SCHED_LOAD_SCALE	(1L << SCHED_LOAD_SHIFT)
>  
> -#define SCHED_LOAD_SCALE_FUZZ	(SCHED_LOAD_SCALE >> 5)
> +#define SCHED_LOAD_SCALE_FUZZ	(SCHED_LOAD_SCALE >> 1)
>  
>  #ifdef CONFIG_SMP
>  #define SD_LOAD_BALANCE		1	/* Do load balancing on this domain. */

Hi Ingo,

The problem I see is that the current load balancing code is quite
hueristic and can be quite inaccurate sometimes. Its goal is to maintain
roughly equal load on each core, where load is defined to be the sum of
the weights of all tasks on a core. If all tasks have the same weight,
this is a simple problem. If different weights exist, this is an NP-hard
problem and our current hueristic can perform badly under various
workloads. A simple example, if we have four tasks on two cores and they
have weights 1, 5, 7, 7. The balanced partition would have 1 and 7 on
core 1 and 5 and 7 on core 2. But you can see the load isn't evenly
distributed; in fact, it's not possible to evenly distribute the load in
this case. Thus, my opinion is that only balancing the load as we do now
is not enough to achieve SMP fairness. My patch was intended to address
this problem.

  tong

PS. I now have a lockless implementation of my patch. Will post later
today.
