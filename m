Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbYLCUJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbYLCUJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbYLCTxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:53:00 -0500
Received: from kroah.org ([198.145.64.141]:60134 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751042AbYLCTw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:52:56 -0500
Date: Wed, 3 Dec 2008 11:51:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com,
       chrisw@sous-sol.org
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
       alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@elte.hu>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: [patch 048/104] x86: call dmi-quirks for HP Laptops after
	early-quirks are executed
Message-ID: <20081203195132.GW8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-call-dmi-quirks-for-hp-laptops-after-early-quirks-are-executed.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Andreas Herrmann <andreas.herrmann3@amd.com>

commit 35af28219e684a36cc8b1ff456c370ce22be157d upstream.

Impact: make warning message disappear - functionality unchanged

Problems with bogus IRQ0 override of those laptops should be fixed
with commits

x86: SB600: skip IRQ0 override if it is not routed to INT2 of IOAPIC
x86: SB450: skip IRQ0 override if it is not routed to INT2 of IOAPIC

that introduce early-quirks based on chipset configuration.

For further information, see
http://bugzilla.kernel.org/show_bug.cgi?id=11516

Instead of removing the related dmi-quirks completely we'd like to
keep them for (at least) one kernel version -- to double-check whether
the early-quirks really took effect. But the dmi-quirks need to be
called after early-quirks are executed. With this patch calling
sequence for dmi-quriks is changed as follows:

 acpi_boot_table_init()   (dmi-quirks)
 ...
 early_quirks()           (detect bogus IRQ0 override)
 ...
 acpi_boot_init()         (late dmi-quirks and setup IO APIC)

Note: Plan is to remove the "late dmi-quirks" with next kernel version.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/acpi/boot.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1593,6 +1593,11 @@ static struct dmi_system_id __initdata a
 		     DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 360"),
 		     },
 	 },
+	{}
+};
+
+/* second table for DMI checks that should run after early-quirks */
+static struct dmi_system_id __initdata acpi_dmi_table_late[] = {
 	/*
 	 * HP laptops which use a DSDT reporting as HP/SB400/10000,
 	 * which includes some code which overrides all temperature
@@ -1721,6 +1726,9 @@ int __init early_acpi_boot_init(void)
 
 int __init acpi_boot_init(void)
 {
+	/* those are executed after early-quirks are executed */
+	dmi_check_system(acpi_dmi_table_late);
+
 	/*
 	 * If acpi_disabled, bail out
 	 * One exception: acpi=ht continues far enough to enumerate LAPICs

