Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab0CHTLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 14:11:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:10388 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576Ab0CHTLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 14:11:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,603,1262592000"; 
   d="scan'208";a="498832083"
Subject: Re: [patch 1/2] sched: check for prev_cpu == this_cpu in
 wake_affine()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Yanmin Zhang <yanmin_zhang@linux.jf.intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <1267817792.6384.37.camel@marge.simson.net>
References: <20100305184213.829832580@sbs-t61.sc.intel.com>
	 <1267817792.6384.37.camel@marge.simson.net>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 08 Mar 2010 11:09:51 -0800
Message-Id: <1268075392.2830.57.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Mike,

On Fri, 2010-03-05 at 11:36 -0800, Mike Galbraith wrote:
> Yeah, but with the 1 task + non-sync wakeup scenario, we miss the boat
> because select_idle_sibling() uses wake_affine() success as it's
> enabler.

But the wake_affine() decision is broken when this_cpu == prev_cpu. All
we need to do is to fix that, to recover that ~9% improvement.

> I have a slightly different patch for that in my tree.  There's no need
> to even call wake_affine() since the result is meaningless.

I don't think your below fix is correct because:


> -	if (affine_sd && wake_affine(affine_sd, p, sync))
> -		return cpu;
> +	if (affine_sd) {
> +		if (cpu == prev_cpu)
> +			return cpu;


by this time, we have overwritten cpu using the select_idle_sibling()
logic and cpu no longer points to this_cpu.

What we need is a comparison with this_cpu.

thanks,
suresh

