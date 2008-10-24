Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbYJXEkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbYJXEkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbYJXEjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:39:08 -0400
Received: from kroah.org ([198.145.64.141]:51641 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751244AbYJXEjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:39:04 -0400
Date: Thu, 23 Oct 2008 21:33:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@suse.cz>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 03/27] x86 ACPI: fix breakage of resume on 64-bit UP
	systems with SMP kernel
Message-ID: <20081024043336.GD30828@kroah.com>
References: <20081024042023.054190751@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-acpi-fix-breakage-of-resume-on-64-bit-up-systems-with-smp-kernel.patch"
In-Reply-To: <20081024043303.GA30828@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Rafael J. Wysocki <rjw@sisk.pl>

commit 3038edabf48f01421c621cb77a712b446d3a5d67 upstream

x86 ACPI: Fix breakage of resume on 64-bit UP systems with SMP kernel

We are now using per CPU GDT tables in head_64.S and the original
early_gdt_descr.address is invalidated after boot by
setup_per_cpu_areas().  This breaks resume from suspend to RAM on
x86_64 UP systems using SMP kernels, because this part of head_64.S
is also executed during the resume and the invalid GDT address
causes the system to crash.  It doesn't break on 'true' SMP systems,
because early_gdt_descr.address is modified every time
native_cpu_up() runs.  However, during resume it should point to the
GDT of the boot CPU rather than to another CPU's GDT.

For this reason, during suspend to RAM always make
early_gdt_descr.address point to the boot CPU's GDT.

This fixes http://bugzilla.kernel.org/show_bug.cgi?id=11568, which
is a regression from 2.6.26.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Reported-and-tested-by: Andy Wettstein <ajw1980@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/acpi/sleep.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -10,6 +10,7 @@
 #include <linux/dmi.h>
 #include <linux/cpumask.h>
 #include <asm/segment.h>
+#include <asm/desc.h>
 
 #include "realmode/wakeup.h"
 #include "sleep.h"
@@ -98,6 +99,8 @@ int acpi_save_state_mem(void)
 	header->trampoline_segment = setup_trampoline() >> 4;
 #ifdef CONFIG_SMP
 	stack_start.sp = temp_stack + 4096;
+	early_gdt_descr.address =
+			(unsigned long)get_cpu_gdt_table(smp_processor_id());
 #endif
 	initial_code = (unsigned long)wakeup_long64;
 	saved_magic = 0x123456789abcdef0;

-- 
