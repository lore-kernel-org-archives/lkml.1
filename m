Return-Path: <linux-kernel-owner+w=401wt.eu-S1757770AbYC1Ubf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770AbYC1Ubf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbYC1Ub0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:31:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:21531 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177AbYC1UbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:31:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,572,1199692800"; 
   d="scan'208";a="362365639"
Date: Fri, 28 Mar 2008 13:30:15 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: David Brownell <david-b@pacbell.net>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25 regression: powertop says 120K wakeups/sec
Message-ID: <20080328203014.GA16105@linux-os.sc.intel.com>
References: <20080322202454.9D69DCC0EF@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <200803281201.54380.david-b@pacbell.net> <924EFEDD5F540B4284297C4DC59F3DEEC83CDD@orsmsx423.amr.corp.intel.com> <200803281244.27012.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803281244.27012.david-b@pacbell.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 12:44:26PM -0700, David Brownell wrote:
> On Friday 28 March 2008, Pallipadi, Venkatesh wrote:
> 
> > >> > I noticed this with 2.6.25-rc2 (if not before), and the problem
> > >> > is still there with 2.6.25-rc6-git (as of this AM).
> > >
> > >A 2.6.24 kernel I still had stashed away didn't act odd; the
> > >problem joined us before 2.6.25-rc1 was tagged.
> > >
> > 
> > There was a fix that went in recently (one or two days back) that should
> > have fixed this.
> > Commit 8e92b6605da989
> > 
> > Can you check with latest git to see whether this is still a problem?
> 
> The problem is still there in GIT as of this morning, which
> includes 8e92b6605da989 ...
> 
> Comments on why bc71bec91f9875ef825d12104acf3bf4ca215fa4 seems
> to be causing this?  I think it's just bad reports getting to
> userspace, rather than an actual 120K wakeups/second.  (The
> report is of course not always 120K, but it's usually in that
> range.)

No. If powertop is reporting that many wakeups, there should be that many as
powertop gets wakeups from usage in /proc/acpi/processor/CPU*/power

Can you send me the output of
# grep . /sys/devices/system/cpu/cpu*/cpuidle/*/*
with upstream kernel.

Below is a test patch which should effectively revert commit bc71bec91f987
Can you check with this patch on latest git and see whether things come back
to normal.

Also, it will help if you can send the output of acpidump from this system.

Thanks,
Venki


---
 drivers/acpi/processor_idle.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/acpi/processor_idle.c
===================================================================
--- linux-2.6.orig/drivers/acpi/processor_idle.c	2008-03-28 12:07:23.000000000 -0700
+++ linux-2.6/drivers/acpi/processor_idle.c	2008-03-28 13:17:31.000000000 -0700
@@ -943,16 +943,15 @@ static int acpi_processor_get_power_info
 			if (acpi_processor_ffh_cstate_probe
 					(pr->id, &cx, reg) == 0) {
 				cx.entry_method = ACPI_CSTATE_FFH;
-			} else if (cx.type == ACPI_STATE_C1) {
+			} else if (cx.type != ACPI_STATE_C1) {
 				/*
 				 * C1 is a special case where FIXED_HARDWARE
 				 * can be handled in non-MWAIT way as well.
 				 * In that case, save this _CST entry info.
+				 * That is, we retain space_id of SYSTEM_IO for
+				 * halt based C1.
 				 * Otherwise, ignore this info and continue.
 				 */
-				cx.entry_method = ACPI_CSTATE_HALT;
-				snprintf(cx.desc, ACPI_CX_DESC_LEN, "ACPI HLT");
-			} else {
 				continue;
 			}
 		} else {
@@ -1398,8 +1397,6 @@ static inline void acpi_idle_do_entry(st
 	if (cx->entry_method == ACPI_CSTATE_FFH) {
 		/* Call into architectural FFH based C-state */
 		acpi_processor_ffh_cstate_enter(cx);
-	} else if (cx->entry_method == ACPI_CSTATE_HALT) {
-		acpi_safe_halt();
 	} else {
 		int unused;
 		/* IO port based C-state */
@@ -1443,7 +1440,7 @@ static int acpi_idle_enter_c1(struct cpu
 		acpi_idle_update_bm_rld(pr, cx);
 
 	t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
-	acpi_idle_do_entry(cx);
+	acpi_safe_halt();
 	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
 
 	local_irq_enable();
