Return-Path: <linux-kernel-owner+w=401wt.eu-S1758255AbYBFT21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255AbYBFT21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 14:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757231AbYBFT2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 14:28:13 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:4383 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756857AbYBFT2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 14:28:11 -0500
Date: Wed, 6 Feb 2008 14:25:55 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com
Cc: nhorman@tuxdriver.com, kexec@lists.infradead.org
Subject: [PATCH], issue EOI to APIC prior to calling crash_kexec in die_nmi path
Message-ID: <20080206192555.GA24910@hmsendeavour.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey all-
	A hang on kdump was reported to me awhile back, only when systems died
via nmi watchdog panic.  The hang wouldn't always be in the same place, but it
would usually be somewhere down in purgatory.  In looking at the code, it
occured to me that since, during an nmi interrupt, we won't be able to handle
additional interrupts, that we won't be able to halt the other processors on a
system like we try to do in machine_crash_shutdown.  As such, it appears that
leaving the other cpus running exposes us to the risk that another processor
will encounter an error and halt the system while we are trying to boot the
kdump kernel, and that can result in a hang.  I wrote the attached patch to end
the nmi interrupt prior to calling crash_kexec from within die_nmi, and testing
here has proven successfull.

Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 traps_32.c |    2 ++
 traps_64.c |    5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)


diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 3cf7297..4443e8e 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -751,6 +751,8 @@ void __kprobes die_nmi(struct pt_regs *regs, const char *msg)
 	 * and might aswell get out now while we still can.
 	*/
 	if (!user_mode_vm(regs)) {
+		nmi_exit();
+		local_irq_enable();
 		current->thread.trap_no = 2;
 		crash_kexec(regs);
 	}
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index efc66df..0a50e70 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -608,8 +608,11 @@ void __kprobes die_nmi(char *str, struct pt_regs *regs, int do_panic)
 	 */
 	printk(str, smp_processor_id());
 	show_registers(regs);
-	if (kexec_should_crash(current))
+	if (kexec_should_crash(current)) {
+		nmi_exit();
+		local_irq_enable();
 		crash_kexec(regs);
+	}
 	if (do_panic || panic_on_oops)
 		panic("Non maskable interrupt");
 	oops_end(flags, NULL, SIGBUS);
-- 
/***************************************************
 *Neil Horman
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
