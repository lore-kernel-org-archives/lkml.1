Return-Path: <linux-kernel-owner+w=401wt.eu-S932608AbYB2ScS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbYB2ScS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757015AbYB2ScG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:32:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:63306 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756890AbYB2ScF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:32:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,427,1199692800"; 
   d="scan'208";a="526725479"
Date: Fri, 29 Feb 2008 10:24:32 -0800
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: Jan Willies <jan@willies.info>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-acpi@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 100% C0 with 2.6.25-rc
Message-ID: <20080229182432.GA28660@linux-os.sc.intel.com>
References: <47BD600F.9090502@willies.info> <200802211733.54759.rjw@sisk.pl> <47BEF0A6.9000405@willies.info> <B5B0CFF685D7DF46A05CF1678CFB42ED20E00658@orsmsx423.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <B5B0CFF685D7DF46A05CF1678CFB42ED20E00658@orsmsx423.amr.corp.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 09:03:55AM -0800, Pallipadi, Venkatesh wrote:
>  
> 
> >-----Original Message-----
> >From: Jan Willies [mailto:jan@willies.info] 
> >Sent: Friday, February 22, 2008 7:56 AM
> >To: Rafael J. Wysocki
> >Cc: linux-acpi@vger.kernel.org; Ingo Molnar; LKML; Thomas 
> >Gleixner; Pallipadi, Venkatesh
> >Subject: Re: 100% C0 with 2.6.25-rc
> >
> >Rafael J. Wysocki wrote:
> >> On Thursday, 21 of February 2008, Jan Willies wrote:
> >>> Since 2.6.25-rc1 I have a lot of wakeups/s (≈134191,4) and 
> >spend 100% in C0.
> >>> It worked fine with 2.6.24 and commandline nolapic. Without 
> >nolapic I had 80k
> >>> wakeups/s after some time, but not right from the start like now.  
> >> 
> >> We have a regression from 2.6.24, apparently interrupts-related.
> >
> >After a lot of bisecting I've found the bad commit: 
> >
> >9b12e18cdc1553de62d931e73443c806347cd974 is first bad commit
> >commit 9b12e18cdc1553de62d931e73443c806347cd974
> >Author: venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
> >Date:   Thu Jan 31 17:35:05 2008 -0800
> >
> >    ACPI: cpuidle: Support C1 idle time accounting
> >    
> >    Show C1 idle time in /sysfs cpuidle interface. C1 idle time may not
> >    be entirely accurate in all cases. It includes the time spent
> >    in the interrupt handler after wakeup with "hlt" based C1. 
> >But, it will
> >    be accurate with "mwait" based C1.
> >
> >
> >Reverting the commit brings my laptop back to C2.
> >
> 
> Thanks for the bisect info. I will look at the bad side effects that patch
> may be having and I should have a patch for you to test later today....
> 

Jan replied later on this issue that he is not able to reproduce this problem
any more. Looking at the above, I could see a potential problem where
menu governor may get confused by the C-state residency time from poll
idle or C1 idle, where this timing info is not accurate. This inaccuracy is
due to interrupts being handled before we account for C-state exit.

Patch below fixes this and is needed regardless of the issue pointed out by
Jan Willies here. But, I am suspecting that the patch will also fix the
problem reported by Jan.

Do not mark TIME_VALID for CO poll state.
Mark C1 time as valid only with mwait (CSTATE_FFH) entry method.

This makes governors use the timing information only when it is correct and
eliminates any wrong policy decisions that may result from invalid timing
information.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.git/drivers/acpi/processor_idle.c
===================================================================
--- linux-2.6.git.orig/drivers/acpi/processor_idle.c	2008-02-15 02:18:14.000000000 -0800
+++ linux-2.6.git/drivers/acpi/processor_idle.c	2008-02-26 07:02:30.000000000 -0800
@@ -1686,7 +1686,9 @@
 		switch (cx->type) {
 			case ACPI_STATE_C1:
 			state->flags |= CPUIDLE_FLAG_SHALLOW;
-			state->flags |= CPUIDLE_FLAG_TIME_VALID;
+			if (cx->entry_method == ACPI_CSTATE_FFH)
+				state->flags |= CPUIDLE_FLAG_TIME_VALID;
+
 			state->enter = acpi_idle_enter_c1;
 			dev->safe_state = state;
 			break;
Index: linux-2.6.git/drivers/cpuidle/cpuidle.c
===================================================================
--- linux-2.6.git.orig/drivers/cpuidle/cpuidle.c	2008-02-15 02:18:14.000000000 -0800
+++ linux-2.6.git/drivers/cpuidle/cpuidle.c	2008-02-22 03:59:01.000000000 -0800
@@ -224,7 +224,7 @@
 	state->exit_latency = 0;
 	state->target_residency = 0;
 	state->power_usage = -1;
-	state->flags = CPUIDLE_FLAG_POLL | CPUIDLE_FLAG_TIME_VALID;
+	state->flags = CPUIDLE_FLAG_POLL;
 	state->enter = poll_idle;
 }
 #else
