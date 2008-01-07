Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbYAGOSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbYAGOSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 09:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbYAGOSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 09:18:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:58639 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbYAGOSI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 09:18:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,253,1196668800"; 
   d="scan'208";a="250567729"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: + restore-missing-sysfs-max_cstate-attr.patch added to -mm tree
Date: Mon, 7 Jan 2008 06:18:47 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE5532E4@orsmsx423.amr.corp.intel.com>
In-Reply-To: <20080106231848.762e93c1.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: + restore-missing-sysfs-max_cstate-attr.patch added to -mm tree
Thread-Index: AchQ/ZQTWMs58bglR1Gbxc9zVuGQ1gAOW9bw
References: <20071130142058.816d1693.akpm@linux-foundation.org><924EFEDD5F540B4284297C4DC59F3DEE2FAEAF@orsmsx423.amr.corp.intel.com><4750CC78.9070105@rtr.ca><20071130190227.1976e682@laptopd505.fenrus.org><4750D180.6080001@rtr.ca><20071130191816.3e744205@laptopd505.fenrus.org><4750D585.1030200@rtr.ca><477C2143.8090406@rtr.ca><924EFEDD5F540B4284297C4DC59F3DEE4FC485@orsmsx423.amr.corp.intel.com><477C622F.6010304@rtr.ca><20080104021619.GA15409@linux-os.sc.intel.com><47814958.3070208@rtr.ca> <20080106231848.762e93c1.akpm@linux-foundation.org>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, "Mark Lord" <lkml@rtr.ca>
Cc: "Arjan van de Ven" <arjan@infradead.org>, <abelay@novell.com>,
       <lenb@kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
       <rjw@sisk.pl>
X-OriginalArrivalTime: 07 Jan 2008 14:18:00.0228 (UTC) FILETIME=[1B8CA640:01C85138]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Andrew Morton [mailto:akpm@linux-foundation.org] 
>Sent: Sunday, January 06, 2008 11:19 PM
>To: Mark Lord
>Cc: Pallipadi, Venkatesh; Arjan van de Ven; abelay@novell.com; 
>lenb@kernel.org; Ingo Molnar; linux-kernel@vger.kernel.org; 
>linux-acpi@vger.kernel.org; rjw@sisk.pl
>Subject: Re: + restore-missing-sysfs-max_cstate-attr.patch 
>added to -mm tree
>
>On Sun, 06 Jan 2008 16:34:16 -0500 Mark Lord <lkml@rtr.ca> wrote:
>
>> Venki Pallipadi wrote:
>> > Reintroduce run time configurable max_cstate for !CPU_IDLE case.
>> > 
>> Can we get this patch upstream so that a stock 2.6.24 will work here?
>> 
>
>umm, OK, I queued it for 2.6.24.  I'll give people a day or so 
>to comment
>on this.
>
>I had to invent some silly changlelog for it.  Please review it for
>accuracy and completeness?
>
>It isn't complete, really.  How come we only make max_cstate 
>writeable if
>CONFIG_CPU_IDLE=n?  What happens to people who were reliant 
>upon writeable
>max_cstate who now enable CPU_IDLE?  Things still break?  What is the
>rationale behind this?  What constraints led us to this decision?

It is done only for !CPU_IDLE case to take care of regression at hand.
CPU_IDLE case technically is not a regression as it is a new config
option. It is not easy to implement this with CPU_IDLE as acpi driver
only provides the C-state mechanism and does not have the policy in it
anymore with CPU_IDLE. It still can be done with some hacky code. But, I
am incliced to switch this to using latency interface which is more
cleaner than max_cstate interface.

For example, max_cstate does not mean anything to the user, as BIOSes
normally tend to hide one C-state or more than one C-states behind one
OS visible C-state. Like C2 mapped to real C3 etc. Saying that I don't
want CPUs to enter any C-state more than 100uS latency is cleaner in
comparison (even though we depend on the latency number coming from the
BIOS).

Mark said this latency interface is not working as it is expected to at
this moment. I will look at that soon and then we will have an alternate
mechanism for this limiting C-state thing.

I am OK with the below changelog.

Thanks,
Venki

>From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
>
>This was writeable in 2.6.23 but the cpuidle merge made it 
>read-only.  But
>some people's scripts (ie: Mark's) were writing to it.
>
>As an unhappy compromise, make max_cstate writeable again if 
>the kernel was
>configured without CONFIG_CPU_IDLE.
>
>Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>Cc: Mark Lord <lkml@rtr.ca>
>Cc: Arjan van de Ven <arjan@infradead.org>
>Cc: Len Brown <lenb@kernel.org>
>Cc: Ingo Molnar <mingo@elte.hu>
>Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>---
>
> drivers/acpi/processor_idle.c |    4 ++++
> 1 file changed, 4 insertions(+)
>
>diff -puN 
>drivers/acpi/processor_idle.c~reintroduce-run-time-configurable
>-max_cstate-for-cpu_idle-case drivers/acpi/processor_idle.c
>--- 
>a/drivers/acpi/processor_idle.c~reintroduce-run-time-configurab
>le-max_cstate-for-cpu_idle-case
>+++ a/drivers/acpi/processor_idle.c
>@@ -76,7 +76,11 @@ static void (*pm_idle_save) (void) __rea
> #define PM_TIMER_TICKS_TO_US(p)		(((p) * 
>1000)/(PM_TIMER_FREQUENCY/1000))
> 
> static unsigned int max_cstate __read_mostly = 
>ACPI_PROCESSOR_MAX_POWER;
>+#ifdef CONFIG_CPU_IDLE
> module_param(max_cstate, uint, 0000);
>+#else
>+module_param(max_cstate, uint, 0644);
>+#endif
> static unsigned int nocst __read_mostly;
> module_param(nocst, uint, 0000);
> 
>_
>
>
