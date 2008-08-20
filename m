Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbYHTBnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbYHTBnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 21:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbYHTBm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 21:42:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:23882 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbYHTBm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 21:42:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,238,1217833200"; 
   d="scan'208";a="372074355"
Subject: Re: [PATH -mm] Fix a race condtion of oops_in_progress
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080819024129.e0c48ff8.akpm@linux-foundation.org>
References: <1219025007.5663.22.camel@yhuang-dev.sh.intel.com>
	 <20080818210657.c7f3cd87.akpm@linux-foundation.org>
	 <1219124280.5663.88.camel@yhuang-dev.sh.intel.com>
	 <20080818224643.865da7a3.akpm@linux-foundation.org>
	 <20080819024129.e0c48ff8.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 09:42:55 +0800
Message-Id: <1219196575.5663.127.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-19 at 02:41 -0700, Andrew Morton wrote:
[...]
> > > It seems that asm/atomic.h is used for both atomic_t declaration and
> > > implementation, how about separate them? That it, add a new file
> > > asm/atomic_def.h, put typedef there, and include asm/atomic_def.h in
> > > kernel.h?
> > 
> > yup, that sounds sensible.
> 
> otoh, it means altering every architectures's atomic.h.

Yes. But the advantage is that we can use atomic_t in almost all header
files. I already have a patch for this.

> Finding a different header file for the oops_in_progress declaration
> might be more practical.
> 
> Or we could just do nothing.  How realistic is this race?

The possibility of race is fairly low in real life. Multiple OOPS on
difference CPU occur simultaneously? But its possibility increases
significantly for kernel panic related regression testing. Recently, I
am working on a kernel MCE regression testing suite, where panic may be
triggered on multiple CPU simultaneously as the result of MCE. I can
observe the race condition at quite high possibility.

> umm, how about making it a function?
> 
> static atomic_t oops_in_progress = ATOMIC_INIT(0);
> 
> int oops_is_in_progress(void)
> {
> 	return atomic_read(&oops_in_progress);
> }
> 
> int oops_in_progress_inc(void)
> {
> 	atomic_inc(&oops_in_progress);
> }
> 
> then just open-code the atomic_inc and atomic_dec in
> lib/bust_spinlocks.c and call oops_in_progress_inc() from
> debug_locks_off().

There is an issue of this solution, the oops_in_process is assigned
directly on some architecture. Although we can add a function such as
oops_in_progress_set(int val), it seems like a hack.

Best Regards,
Huang Ying


