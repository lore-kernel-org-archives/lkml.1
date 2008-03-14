Return-Path: <linux-kernel-owner+w=401wt.eu-S1759848AbYCNTm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848AbYCNTm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 15:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757876AbYCNTl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 15:41:27 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:60159 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759240AbYCNTlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 15:41:24 -0400
Date: Fri, 14 Mar 2008 20:40:41 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Len Brown <lenb@kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>, Adam Belay <abelay@novell.com>,
       Andi Kleen <andi@firstfloor.org>, Lee Revell <rlrevell@joe-job.com>
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080314204041.6e376568@mjolnir.drzeus.cx>
In-Reply-To: <20080313173437.5f00f70e@mjolnir.drzeus.cx>
References: <Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org>
	<20080310100008.GA9520@elf.ucw.cz>
	<20080310134915.45ae7446@mjolnir.drzeus.cx>
	<200803121511.17389.lenb@kernel.org>
	<20080313173437.5f00f70e@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 17:34:37 +0100
Pierre Ossman <drzeus-list@drzeus.cx> wrote:

> On Wed, 12 Mar 2008 15:11:17 -0400
> Len Brown <lenb@kernel.org> wrote:
> 
> > 
> > You'll see "desc" change if ACPI pulls a _CST change on you.
> > 
> 
> It does not. But my C3 desc looks like this:
> 
> state3/desc:ACPI FFH INTEL MWAIT 0x50
> 

I must have done something wrong. I now see a switch between C6 and C3
when I play with the AC cord.

On that theme, I've tested fiddling with the real C-states. I've added
a new max_hwcstate that makes ACPI downgrade MWAIT hints. I also made
some odd discoveries:

C3: More or less completely silent (I haven't tested it in a really
quiet environment yet).
C4: Constant noise
C5: Constant noise
C6: Intermittent noise

When I say constant, I mean that the noise is not generated as a result
of switching between modes (to any extent I can see at least). The
average time spent in C3 (as reported by Powertop) is over 200 ms. So
that would give a frequency of around 5 Hz, not a consistent tone of
several kHz.

Here's said patch. Please comment as I hope this can be merged:

diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
index 8ca3557..389ea8b 100644
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -47,6 +47,9 @@ EXPORT_SYMBOL(acpi_processor_power_init_bm_check);
 
 /* The code below handles cstate entry with monitor-mwait pair on Intel*/
 
+static unsigned int max_hwcstate __read_mostly = -1;
+module_param(max_hwcstate, uint, 0644);
+
 struct cstate_entry {
 	struct {
 		unsigned int eax;
@@ -80,6 +83,7 @@ int acpi_processor_ffh_cstate_probe(unsigned int cpu,
 	unsigned int edx_part;
 	unsigned int cstate_type; /* C-state type and not ACPI C-state type */
 	unsigned int num_cstate_subtype;
+	unsigned int hint;
 
 	if (!cpu_cstate_entry || c->cpuid_level < CPUID_MWAIT_LEAF )
 		return -1;
@@ -100,16 +104,40 @@ int acpi_processor_ffh_cstate_probe(unsigned int cpu,
 	cpuid(CPUID_MWAIT_LEAF, &eax, &ebx, &ecx, &edx);
 
 	/* Check whether this particular cx_type (in CST) is supported or not */
-	cstate_type = (cx->address >> MWAIT_SUBSTATE_SIZE) + 1;
-	edx_part = edx >> (cstate_type * MWAIT_SUBSTATE_SIZE);
-	num_cstate_subtype = edx_part & MWAIT_SUBSTATE_MASK;
+	hint = cx->address;
+	for (;;) {
+		/* Compute main C-state */
+		cstate_type = (hint >> MWAIT_SUBSTATE_SIZE) + 1;
+
+		/* Determine number of sub-states for this C-state */
+		edx_part = edx >> (cstate_type * MWAIT_SUBSTATE_SIZE);
+		num_cstate_subtype = edx_part & MWAIT_SUBSTATE_MASK;
+
+		/* Check if it's within constraints, and supported */
+		if ((cstate_type > max_hwcstate) ||
+			(num_cstate_subtype <=
+				(hint & MWAIT_SUBSTATE_MASK))) {
+			/* Move down a C-state and drop sub-state */
+			cstate_type--;
+			hint = (cstate_type - 1) << MWAIT_SUBSTATE_SIZE;
+			/* Out of states, abort */
+			if (cstate_type == 0) {
+				retval = -1;
+				goto out;
+			}
+		} else {
+			break;
+		}
+	}
 
-	retval = 0;
-	if (num_cstate_subtype < (cx->address & MWAIT_SUBSTATE_MASK)) {
-		retval = -1;
-		goto out;
+	if (hint != cx->address) {
+		printk(KERN_DEBUG "ACPI: Downgrading hardware C%d to C%d\n",
+			(cx->address >> MWAIT_SUBSTATE_SIZE) + 1,
+			(hint >> MWAIT_SUBSTATE_SIZE) + 1);
 	}
 
+	retval = 0;
+
 	/* mwait ecx extensions INTERRUPT_BREAK should be supported for C2/C3 */
 	if (!(ecx & CPUID5_ECX_EXTENSIONS_SUPPORTED) ||
 	    !(ecx & CPUID5_ECX_INTERRUPT_BREAK)) {
@@ -119,15 +147,15 @@ int acpi_processor_ffh_cstate_probe(unsigned int cpu,
 	percpu_entry->states[cx->index].ecx = MWAIT_ECX_INTERRUPT_BREAK;
 
 	/* Use the hint in CST */
-	percpu_entry->states[cx->index].eax = cx->address;
+	percpu_entry->states[cx->index].eax = hint;
 
 	if (!mwait_supported[cstate_type]) {
 		mwait_supported[cstate_type] = 1;
 		printk(KERN_DEBUG "Monitor-Mwait will be used to enter C-%d "
 		       "state\n", cx->type);
 	}
-	snprintf(cx->desc, ACPI_CX_DESC_LEN, "ACPI FFH INTEL MWAIT 0x%x",
-		 cx->address);
+	snprintf(cx->desc, ACPI_CX_DESC_LEN, "ACPI FFH INTEL MWAIT 0x%x (0x%x)",
+		 hint, cx->address);
 
 out:
 	set_cpus_allowed(current, saved_mask);


Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
