Return-Path: <linux-kernel-owner+w=401wt.eu-S1759483AbXERAq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483AbXERAq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 20:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757173AbXERAqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 20:46:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:23093 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757105AbXERAqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 20:46:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,550,1170662400"; 
   d="scan'208";a="246885262"
Date: Thu, 17 May 2007 17:43:55 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, mingo@elte.hu, ak@suse.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Zou, Nanhai" <nanhai.zou@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Packard, Keith" <keith.packard@intel.com>
Subject: Re: [patch] x86_64, irq: check remote IRR bit before migrating level triggered irq
Message-ID: <20070518004355.GA12088@linux-os.sc.intel.com>
References: <20070517230324.GB8089@linux-os.sc.intel.com> <m1irar0zqt.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1irar0zqt.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 04:58:02PM -0700, Eric W. Biederman wrote:
> In essence this makes sense, and it may be the best work around for
> buggy hardware available.   However I am not convinced that the remote
> IRR on ioapics works reliably enough to be used for anything.   I
> tested this earlier and I could not successfully poll the remote irr
> bit to see if an ioapic had received an irq acknowledgement.  Instead
> I locked up irq controllers.
> 
> If remote IRR worked reliably I could have pulled the irq migration
> out of irq context.  So this fix looks dubious to me.

We are just reading IOAPIC RTE's. So not sure why this can lead to lock
up's. This patch is not reading any new HW registers. It just
checks for certain bit values from the register that the code reads
anyhow.

Remote IRR should work reliably otherwise we will see lot more issues,
I guess.

> 
> Why is the EOI delayed?  Can we work around that?

Under some stress conditions, EOI can get retried because of which
it is getting delayed.

> 
> It would be nice if ioapics and local apics actually obeyed the pci
> ordering rules where a read would flush all traffic.  And we do have a
> read in there.
> 
> I'm assuming the symptom you are seeing on current kernels is that
> occasionally
> the irq gets stuck and never fires again?

yes.

> I'm not certain I like the patch either, but I need to look more closely.
> You are mixing changes to generic and arch specific code together.
> 
> I think pending_eoi should not try to reuse __DO_ACTION as that
> helper bit of code does not seem appropriate.

Wanted to minimize the code duplicacy and hence overloaded existing
macros.

> 
> It would probably be best if the pending_eoi check was in
> ack_apic_level with the rest of the weird logic we are working around.

Just wanted to make sure that we give some time for the EOI to actually
reach the IO-APIC.

> 
> Could we please have more detail on this hardware behavior.  Why is
> the EIO write write delayed?   Why can't we just issue reads in
> appropriate places to flush the write?

Because the EOI to IOAPIC gets generated as a side effect of processor
EOI.

thanks,
suresh
