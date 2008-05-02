Return-Path: <linux-kernel-owner+w=401wt.eu-S934529AbYEBMO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934529AbYEBMO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 08:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763451AbYEBMOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 08:14:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43236 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbYEBMOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 08:14:18 -0400
Subject: Re: questions on calc_delta_mine() in sched.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Joel Schopp <jschopp@austin.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <481A2BF6.2070406@austin.ibm.com>
References: <481A2BF6.2070406@austin.ibm.com>
Content-Type: text/plain
Date: Fri, 02 May 2008 14:14:01 +0200
Message-Id: <1209730442.6508.3.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-01 at 15:45 -0500, Joel Schopp wrote:
> Ingo,
> 
> I have a few questions regarding  this code in kernel/sched.c
> 
> static unsigned long
> calc_delta_mine(unsigned long delta_exec, unsigned long weight,
>          struct load_weight *lw)
> {
>      u64 tmp;
> 
>      if (unlikely(!lw->inv_weight))
>          lw->inv_weight = (WMULT_CONST-lw->weight/2) / (lw->weight+1);
> 
> 
> Q1) This code is hit often in scenarios I run, is this really unlikely for 
> others?

I think it became a lot more likely recently, perhaps removing that
unlikely is not such a bad idea.

> Q2) The rest of the code in sched.c seems to make inv_weight == 
> WMULT_CONST/weight and I was wondering if you could explain why this 
> instance is different.

because the rest of the code is wrong, there are only 2 other sites, and
I have a patch that removes those div64_64() with =0;

The idea is to use rounding division: (x + y/2) / y
but we can't because 'x' is touching the limits of our modulo space,
hence we do: (x - y/2) / y
which comes in 1 short, that fixup has been lost along the way.

> Q3) That division is pretty expensive, could we sacrifice some accuracy and 
> do a precompute table?  Do you have another idea how we could get rid of 
> the divide?

Is a full memory miss not more expensive on most modern machines?

And, no sadly I have no ideas on how to get rid of it ;-/

