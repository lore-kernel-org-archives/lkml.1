Return-Path: <linux-kernel-owner+w=401wt.eu-S1751676AbZJ1S5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbZJ1S5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 14:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbZJ1S5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 14:57:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:32232 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbZJ1S5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 14:57:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,641,1249282800"; 
   d="scan'208";a="204862397"
Subject: Re: [PATCH] [GIT PULL] tracing: allow to change permissions for
 text with dynamic ftrace enabled
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1256686285.26028.487.camel@gandalf.stny.rr.com>
References: <1256666023.26028.411.camel@gandalf.stny.rr.com>
	 <1256671227.2691.15.camel@sbs-t61.sc.intel.com>
	 <1256668438.26028.414.camel@gandalf.stny.rr.com>
	 <1256682364.2691.33.camel@sbs-t61.sc.intel.com>
	 <1256679318.26028.468.camel@gandalf.stny.rr.com>
	 <1256685826.15873.41.camel@sbs-t61.sc.intel.com>
	 <1256686285.26028.487.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 28 Oct 2009 11:56:18 -0800
Message-Id: <1256759778.2683.185.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 16:31 -0700, Steven Rostedt wrote: 
> On Tue, 2009-10-27 at 15:23 -0800, Suresh Siddha wrote:
> 
> > > 
> > > I'll test it out, and if it does work, you can write up a formal patch
> > > and remove the !define that I added.
> > 
> > I just saw one more place calling do_ftrace_mod_code(). So moved this
> > check inside the do_ftrace_mod_code(). Does this cover all the cases?
> > Thanks.
> 
> For ftrace, probably. But I just realized this may have other
> consequences. The CPA_DEBUG tests setting a bit in the page table at
> random locations.

CPA_DEBUG is setting/clearing unused bit 9. It has no interaction with
RW bits. Though the random page and random length selections may end up
splitting the large page mappings for kernel text. This is a different
issue that needs to be addressed (perhaps I can ignore this bit 9 as
well for the kernel text mapping. In general it sounds like a bad idea
to break any large page mappings to small page mappings for cpa debug
tests, especially when we don't restore the large page mapping when we
clear those unused bits once the test is done. Will look into this).

> The code you added makes any change to kernel text
> page attributes remove the RW bit.

Only for CONFIG_DEBUG_RODATA.

> On boot up, it is considered that
> kernel text is writable.

For CONFIG_DEBUG_RODATA, during the boot we change it to RO.

> Perhaps you need to add a check in your if statement to only prevent
> that bit when kernel_set_to_readonly is not true.

Are you worried that kernel_set_to_readonly might not be true but we
might have the kernel text mapping read-only?

As ftrace is now using kernel identity mapping on 64-bit, we can change
the semantics of kernel_set_to_readonly to reflect the status of kernel
identity mapping for 64-bit. I can update the comments.

thanks,
suresh

