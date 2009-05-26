Return-Path: <linux-kernel-owner+w=401wt.eu-S1758534AbZEZVTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534AbZEZVTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756087AbZEZVTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:19:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:28601 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756568AbZEZVTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:19:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,254,1241420400"; 
   d="scan'208";a="693746938"
Subject: Re: [patch 2/2] x86: put offline CPUs into deepest mwait
 cstate_subcstate
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Li, Shaohua" <shaohua.li@intel.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>
In-Reply-To: <20090525005646.GA9093@sli10-desk.sh.intel.com>
References: <20090522231940.553094000@intel.com>
	 <20090522232230.162239000@intel.com>
	 <20090525005646.GA9093@sli10-desk.sh.intel.com>
Content-Type: text/plain
Date: Tue, 26 May 2009 14:17:46 -0700
Message-Id: <1243372667.4534.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-24 at 17:56 -0700, Li, Shaohua wrote:
> On Sat, May 23, 2009 at 07:19:42AM +0800, Pallipadi, Venkatesh wrote:
> > Offline CPUs can save power by going into deepest cstate, subcstate
> > instead of hlt loop.
> > 
> > Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> > ---
> >  arch/x86/kernel/acpi/cstate.c |   51 +++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 51 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
> > index bbbe4bb..5b0988a 100644
> > --- a/arch/x86/kernel/acpi/cstate.c
> > +++ b/arch/x86/kernel/acpi/cstate.c
> > @@ -150,6 +150,54 @@ void acpi_processor_ffh_cstate_enter(struct acpi_processor_cx *cx)
> >  }
> >  EXPORT_SYMBOL_GPL(acpi_processor_ffh_cstate_enter);
> >  
> > +static unsigned long mwait_play_dead_eax;
> > +
> > +static void mwait_play_dead(void)
> > +{
> > +	if (boot_cpu_data.x86 >= 4)
> > +		wbinvd();
> > +
> > +	while (1) {
> > +		__monitor((void *)&current_thread_info()->flags, 0, 0);
> > +		smp_mb();
> > +		__mwait(mwait_play_dead_eax, 0);
> > +	}
> > +}
> CPU is dead, can current_thread_info() still be used? Maybe just monitor a never changed
> address.
> 

We still execute in this while loop even for an offline CPU, in case CPU
just wakes up for whatever reason (HT sibling woke up etc). So, we
should have stack and current_thread_info() even when offline, and we
can use it here. I had a never changing variable in my earlier version
of this patch. But removed it as I don't see why we should have couple
of cache lines of data when we can avoid it.

> Looks the patch will always take the highest native C-state, is this safe, considering
> BIOS usually limit C-state?
> 

It may not be safe in terms of wakeup latency etc. So, we use BIOS CST
for normal C-states. When offline, we don't really care about latency
part. If CPU supports a C-state, we should be able to enter it and we
can save most power with deepest C-state. If there are functionality
issues with C-state, I am sure CPU feature (hw or microcode) will have
it disabled, instead of depending on BIOSes to disable it.

Thanks,
Venki

