Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbYAGHTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbYAGHTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 02:19:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbYAGHTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 02:19:39 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54856 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564AbYAGHTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 02:19:37 -0500
Date: Sun, 6 Jan 2008 23:18:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Lord <lkml@rtr.ca>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, abelay@novell.com,
       lenb@kernel.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, rjw@sisk.pl
Subject: Re: + restore-missing-sysfs-max_cstate-attr.patch added to -mm tree
Message-Id: <20080106231848.762e93c1.akpm@linux-foundation.org>
In-Reply-To: <47814958.3070208@rtr.ca>
References: <20071130142058.816d1693.akpm@linux-foundation.org>
	<924EFEDD5F540B4284297C4DC59F3DEE2FAEAF@orsmsx423.amr.corp.intel.com>
	<4750CC78.9070105@rtr.ca>
	<20071130190227.1976e682@laptopd505.fenrus.org>
	<4750D180.6080001@rtr.ca>
	<20071130191816.3e744205@laptopd505.fenrus.org>
	<4750D585.1030200@rtr.ca>
	<477C2143.8090406@rtr.ca>
	<924EFEDD5F540B4284297C4DC59F3DEE4FC485@orsmsx423.amr.corp.intel.com>
	<477C622F.6010304@rtr.ca>
	<20080104021619.GA15409@linux-os.sc.intel.com>
	<47814958.3070208@rtr.ca>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 06 Jan 2008 16:34:16 -0500 Mark Lord <lkml@rtr.ca> wrote:

> Venki Pallipadi wrote:
> > Reintroduce run time configurable max_cstate for !CPU_IDLE case.
> > 
> > Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> > 
> > Index: linux-2.6.24-rc/drivers/acpi/processor_idle.c
> > ===================================================================
> > --- linux-2.6.24-rc.orig/drivers/acpi/processor_idle.c
> > +++ linux-2.6.24-rc/drivers/acpi/processor_idle.c
> > @@ -76,7 +76,11 @@ static void (*pm_idle_save) (void) __rea
> >  #define PM_TIMER_TICKS_TO_US(p)		(((p) * 1000)/(PM_TIMER_FREQUENCY/1000))
> >  
> >  static unsigned int max_cstate __read_mostly = ACPI_PROCESSOR_MAX_POWER;
> > +#ifdef CONFIG_CPU_IDLE
> >  module_param(max_cstate, uint, 0000);
> > +#else
> > +module_param(max_cstate, uint, 0644);
> > +#endif
> >  static unsigned int nocst __read_mostly;
> >  module_param(nocst, uint, 0000);
> >  
> ..
> 
> Can we get this patch upstream so that a stock 2.6.24 will work here?
> 

umm, OK, I queued it for 2.6.24.  I'll give people a day or so to comment
on this.

I had to invent some silly changlelog for it.  Please review it for
accuracy and completeness?

It isn't complete, really.  How come we only make max_cstate writeable if
CONFIG_CPU_IDLE=n?  What happens to people who were reliant upon writeable
max_cstate who now enable CPU_IDLE?  Things still break?  What is the
rationale behind this?  What constraints led us to this decision?




From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

This was writeable in 2.6.23 but the cpuidle merge made it read-only.  But
some people's scripts (ie: Mark's) were writing to it.

As an unhappy compromise, make max_cstate writeable again if the kernel was
configured without CONFIG_CPU_IDLE.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Mark Lord <lkml@rtr.ca>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_idle.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/acpi/processor_idle.c~reintroduce-run-time-configurable-max_cstate-for-cpu_idle-case drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~reintroduce-run-time-configurable-max_cstate-for-cpu_idle-case
+++ a/drivers/acpi/processor_idle.c
@@ -76,7 +76,11 @@ static void (*pm_idle_save) (void) __rea
 #define PM_TIMER_TICKS_TO_US(p)		(((p) * 1000)/(PM_TIMER_FREQUENCY/1000))
 
 static unsigned int max_cstate __read_mostly = ACPI_PROCESSOR_MAX_POWER;
+#ifdef CONFIG_CPU_IDLE
 module_param(max_cstate, uint, 0000);
+#else
+module_param(max_cstate, uint, 0644);
+#endif
 static unsigned int nocst __read_mostly;
 module_param(nocst, uint, 0000);
 
_

