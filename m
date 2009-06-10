Return-Path: <linux-kernel-owner+w=401wt.eu-S1758741AbZFJDjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbZFJDjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 23:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756148AbZFJDea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 23:34:30 -0400
Received: from kroah.org ([198.145.64.141]:56857 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756388AbZFJDe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 23:34:28 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 17:23:44 2009
Message-Id: <20090610002344.559460966@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 17:13:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-acpi@vger.kernel.org, lenb@kernel.org,
       Shaohua Li <shaohua.li@intel.com>, Len Brown <len.brown@intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 21/60] cpuidle: make AMC C1E work in processor_idle
References: <20090610001328.251476848@blue.kroah.org>
Content-Disposition: inline; filename=cpuidle-make-amc-c1e-work-in-processor_idle.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Shaohua Li <shaohua.li@intel.com>

commit 87ad57bacb25c3f24c54f142ef445f68277705f0 upstream

When AMD C1E is enabled, local APIC timer will stop even in C1. This patch uses
broadcast ipi to replace local APIC timer in C1.

http://bugzilla.kernel.org/show_bug.cgi?id=13233

[ impact: avoid boot hang in AMD CPU with C1E enabled ]

Tested-by: Dmitry Lyzhyn <thisistempbox@yahoo.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/processor_idle.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -303,6 +303,9 @@ static void acpi_timer_check_state(int s
 	struct acpi_processor_power *pwr = &pr->power;
 	u8 type = local_apic_timer_c2_ok ? ACPI_STATE_C3 : ACPI_STATE_C2;
 
+	if (boot_cpu_has(X86_FEATURE_AMDC1E))
+		type = ACPI_STATE_C1;
+
 	/*
 	 * Check, if one of the previous states already marked the lapic
 	 * unstable
@@ -1154,6 +1157,7 @@ static int acpi_processor_power_verify(s
 		switch (cx->type) {
 		case ACPI_STATE_C1:
 			cx->valid = 1;
+			acpi_timer_check_state(i, pr, cx);
 			break;
 
 		case ACPI_STATE_C2:
@@ -1476,12 +1480,14 @@ static int acpi_idle_enter_c1(struct cpu
 	if (pr->flags.bm_check)
 		acpi_idle_update_bm_rld(pr, cx);
 
+	acpi_state_timer_broadcast(pr, cx, 1);
 	t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
 	acpi_idle_do_entry(cx);
 	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
 
 	local_irq_enable();
 	cx->usage++;
+	acpi_state_timer_broadcast(pr, cx, 0);
 
 	return ticks_elapsed_in_us(t1, t2);
 }


