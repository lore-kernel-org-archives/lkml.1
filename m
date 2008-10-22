Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbYJVXk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbYJVXk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 19:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbYJVXkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 19:40:10 -0400
Received: from mga14.intel.com ([143.182.124.37]:52735 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbYJVXkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 19:40:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,467,1220252400"; 
   d="scan'208";a="64022290"
Date: Wed, 22 Oct 2008 16:40:07 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Henroid, Andrew D" <andrew.d.henroid@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/2] i7300_idle driver v1.55
Message-ID: <20081022234006.GB28775@linux-os.sc.intel.com>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com> <e8b529091b2ab65f5a4783e292c2b472e309116e.1223706853.git.len.brown@intel.com> <20081011083347.GA31918@elte.hu> <alpine.LFD.1.10.0810161805360.3026@localhost.localdomain> <48FE07AE.4010203@linux.intel.com> <7E82351C108FA840AB1866AC776AEC4637CD27F3@orsmsx505.amr.corp.intel.com> <48FED3FA.6040703@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FED3FA.6040703@linux.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 12:19:22AM -0700, Andi Kleen wrote:
> Pallipadi, Venkatesh wrote:
> >
> > udelay may be more power efficient than polling.
> 
> Isn't that function a one off anyways?

Which function is one off?

> >
> >> ;
> >>> +static void __exit i7300_idle_exit(void)
> >>> +{
> >>> +     idle_notifier_unregister(&i7300_idle_nb);
> >> I still think this needs some kind of idle synchronization.
> >
> > This unregister uses atomic_notifier_chain_unregister() which
> > uses RCU and handles the race conditions that way.
> 
> I didn't do a full analysis, but I didn't think RCU protects
> against the idle handler itself.  At least not standard RCU.
> You would need to go through at least two quiescent periods,
> not one as standard code.
> 
> There used to be an older
> idle synchronization interface for this case (which was removed
> at some point), perhaps it needs to be readded.
> 
> Or just use stop_machine(). That protects against idle too
> and while it's a big hammer for unloading it should be ok.
> 

stop_machine() for unregistering idle callback will deadlock due to RCU.

I am not sure why we need two cycles. RCU in the unregister makes
sure that no CPU is executing the callback handler and only then unregister
returns. So, that will mean no one can be in the callback rountine and we are
safe to remove the module. Correct?

Thanks,
Venki

