Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbZDVKIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbZDVKIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 06:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756262AbZDVKHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 06:07:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:58970 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756195AbZDVKHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 06:07:42 -0400
Date: Wed, 22 Apr 2009 10:06:56 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       weidong.han@intel.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, weidong.han@intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090420200450.552359000@linux-os.sc.intel.com>
References: <20090420200450.552359000@linux-os.sc.intel.com>
Subject: [tip:x86/apic] x86: x2apic, IR: remove reinit_intr_remapped_IO_APIC()
Message-ID: <tip-ff166cb57a17124af75714a9c11f448f56f1a4a3@git.kernel.org>
Git-Commit-ID: ff166cb57a17124af75714a9c11f448f56f1a4a3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 22 Apr 2009 10:06:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff166cb57a17124af75714a9c11f448f56f1a4a3
Gitweb:     http://git.kernel.org/tip/ff166cb57a17124af75714a9c11f448f56f1a4a3
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 20 Apr 2009 13:02:30 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 22 Apr 2009 12:03:04 +0200

x86: x2apic, IR: remove reinit_intr_remapped_IO_APIC()

When interrupt-remapping is enabled, we are relying on
setup_IO_APIC_irqs() to configure remapped entries in the
IO-APIC, which comes little bit later after enabling
interrupt-remapping.

Meanwhile, restoration of old io-apic entries after enabling
interrupt-remapping will not make the interrupts through
io-apic functional anyway.

So remove the unnecessary reinit_intr_remapped_IO_APIC() step.

The longer story:

When interrupt-remapping is enabled, IO-APIC entries need to be
setup in the re-mappable format (pointing to
interrupt-remapping table entries setup by the OS). This
remapping configuration is happening in the same place where we
traditionally configure IO-APIC (i.e., in
setup_IO_APIC_irqs()).

So when we enable interrupt-remapping successfully, there is no
need to restore old io-apic RTE entries before we actually do a
complete configuration shortly in setup_IO_APIC_irqs(). Old
IO-APIC RTE's may be in traditional format (non re-mappable) or
in re-mappable format pointing to interrupt-remapping table
entries setup by BIOS. Restoring both of these will not make
IO-APIC functional. We have to rely on setup_IO_APIC_irqs() for
proper configuration by OS.

So I am removing this unnecessary and broken step.

[ Impact: remove unnecessary/broken IO-APIC setup step ]

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Weidong Han <weidong.han@intel.com>
Cc: dwmw2@infradead.org
LKML-Reference: <20090420200450.552359000@linux-os.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/io_apic.h |    2 --
 arch/x86/kernel/apic/apic.c    |    2 --
 arch/x86/kernel/apic/io_apic.c |   14 --------------
 3 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 34eaa37..1cf1450 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -166,8 +166,6 @@ extern void free_ioapic_entries(struct IO_APIC_route_entry **ioapic_entries);
 extern int save_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
 extern void mask_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
 extern int restore_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
-extern void reinit_intr_remapped_IO_APIC(int intr_remapping,
-	struct IO_APIC_route_entry **ioapic_entries);
 
 extern void probe_nr_irqs_gsi(void);
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index d32f558..1386dbe 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1412,8 +1412,6 @@ end_restore:
 		 * IR enabling failed
 		 */
 		restore_IO_APIC_setup(ioapic_entries);
-	else
-		reinit_intr_remapped_IO_APIC(x2apic_preenabled, ioapic_entries);
 
 	unmask_8259A();
 	local_irq_restore(flags);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4baa9cb..8aef5f9 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -833,20 +833,6 @@ int restore_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries)
 	return 0;
 }
 
-void reinit_intr_remapped_IO_APIC(int intr_remapping,
-	struct IO_APIC_route_entry **ioapic_entries)
-
-{
-	/*
-	 * for now plain restore of previous settings.
-	 * TBD: In the case of OS enabling interrupt-remapping,
-	 * IO-APIC RTE's need to be setup to point to interrupt-remapping
-	 * table entries. for now, do a plain restore, and wait for
-	 * the setup_IO_APIC_irqs() to do proper initialization.
-	 */
-	restore_IO_APIC_setup(ioapic_entries);
-}
-
 void free_ioapic_entries(struct IO_APIC_route_entry **ioapic_entries)
 {
 	int apic;
