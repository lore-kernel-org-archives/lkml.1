Return-Path: <linux-kernel-owner+w=401wt.eu-S1760784AbYFRGYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760784AbYFRGYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 02:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760037AbYFRGX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 02:23:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:5897 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760120AbYFRGX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 02:23:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,663,1204531200"; 
   d="scan'208";a="296456243"
Date: Tue, 17 Jun 2008 23:23:57 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Simon Holm =?iso-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Patrick McHardy <kaber@trash.net>,
       Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Chuck Ebbert <cebbert@redhat.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: 2.6.26-git: NULL pointer deref in __switch_to
Message-ID: <20080618062357.GC23370@linux-os.sc.intel.com>
References: <4852B19E.4010202@trash.net> <1213651283.2495.46.camel@odie.local> <20080617235022.GA23370@linux-os.sc.intel.com> <200806181534.24085.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806181534.24085.rusty@rustcorp.com.au>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Rusty,

On Tue, Jun 17, 2008 at 10:34:23PM -0700, Rusty Russell wrote:
>    Firstly, thanks for figuring this out.  But math_state_restore() has nasty
> semantics now.  Currently lguest will work, because no code path following
> this call relies on being on the same CPU.
> 
> So, this patch is fine, but I wonder if I should just be forcing fpu
> allocation earlier for lguest tasks, so I can avoid this altogether?

Even with force fpu allocation, we need these fixes(except for the SYSENTER
hunk)

Just to clarify, dynamic fpu allocation didn't create these problems.
Some of these problems were there before aswell, and would show up as
fpu corruption for some of the tasks inside the lguest. With the
dynamic fpu allocation, it showed up as host kernel oops.

In future, if lguest driver code ever has a code path which relies
on running on the same cpu after math_state_restore(), yes they
can force allocate, by doing early math_state_restore() before
the guest starts.

But the current usage of lguest_set_ts() is clearly broken and violates
certain behavior expected by the fpu context switch handling routines.

thanks,
suresh
