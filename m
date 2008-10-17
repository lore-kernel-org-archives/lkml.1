Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbYJQMd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbYJQMd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbYJQMdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:33:19 -0400
Received: from bender.cm4all.net ([87.106.27.49]:47689 "EHLO bender.cm4all.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482AbYJQMdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:33:18 -0400
Date: Fri, 17 Oct 2008 14:32:07 +0200
From: Max Kellermann <mk@cm4all.com>
To: linux-kernel@vger.kernel.org, gcosta@redhat.com, ijc@hellion.org.uk
Subject: [PATCH] NFS regression in 2.6.26?, "task blocked for more than 120 seconds"
Message-ID: <20081017123207.GA14979@rabbit.intern.cm-ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ian: this is a follow-up to your post "NFS regression? Odd delays and
lockups accessing an NFS export" a few weeks ago
(http://lkml.org/lkml/2008/9/27/42).

I am able to trigger this bug within a few minutes on a customer's
machine (large web hoster, a *lot* of NFS traffic).

Symptom: with 2.6.26 (2.6.27.1, too), load goes to 100+, dmesg says
"INFO: task migration/2:9 blocked for more than 120 seconds." with
varying task names.  Except for the high load average, the machine
seems to work.

With git bisect, I was finally able to identify the guilty commit,
it's not "Ensure we zap only the access and acl caches when setting
new acls" like you guessed, Ian.  According to my bisect,
6becedbb06072c5741d4057b9facecb4b3143711 is the origin of the problem.
e481fcf8563d300e7f8875cae5fdc41941d29de0 (its parent) works well.

Glauber: that is your patch "x86: minor adjustments for do_boot_cpu"
(http://lkml.org/lkml/2008/3/19/143).  I don't understand this patch
well, and I fail to see a connection with the symptom, but maybe
somebody else does...

See patch below (applies to 2.6.27.1).  So far, it looks like the
problem is solved on the server, no visible side effects.

Max


Revert "x86: minor adjustments for do_boot_cpu"

According to a bisect, Glauber Costa's patch induced high load and
"task ... blocked for more than 120 seconds" messages in dmesg.  This
patch reverts 6becedbb06072c5741d4057b9facecb4b3143711.

Signed-off-by: Max Kellermann <mk@cm4all.com>
---

 arch/x86/kernel/smpboot.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)


diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7985c5b..789cf84 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -808,7 +808,7 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
  * Returns zero if CPU booted OK, else error code from wakeup_secondary_cpu.
  */
 {
-	unsigned long boot_error = 0;
+	unsigned long boot_error;
 	int timeout;
 	unsigned long start_ip;
 	unsigned short nmi_high = 0, nmi_low = 0;
@@ -828,7 +828,11 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 	}
 #endif
 
-	alternatives_smp_switch(1);
+	/*
+	 * Save current MTRR state in case it was changed since early boot
+	 * (e.g. by the ACPI SMI) to initialize new CPUs with MTRRs in sync:
+	 */
+	mtrr_save_state();
 
 	c_idle.idle = get_idle_for_cpu(cpu);
 
@@ -873,6 +877,8 @@ do_rest:
 	/* start_ip had better be page-aligned! */
 	start_ip = setup_trampoline();
 
+	alternatives_smp_switch(1);
+
 	/* So we see what's up   */
 	printk(KERN_INFO "Booting processor %d/%d ip %lx\n",
 			  cpu, apicid, start_ip);
@@ -891,11 +897,6 @@ do_rest:
 		store_NMI_vector(&nmi_high, &nmi_low);
 
 		smpboot_setup_warm_reset_vector(start_ip);
-		/*
-		 * Be paranoid about clearing APIC errors.
-	 	*/
-		apic_write(APIC_ESR, 0);
-		apic_read(APIC_ESR);
 	}
 
 	/*
@@ -986,12 +987,6 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 		return -ENOSYS;
 	}
 
-	/*
-	 * Save current MTRR state in case it was changed since early boot
-	 * (e.g. by the ACPI SMI) to initialize new CPUs with MTRRs in sync:
-	 */
-	mtrr_save_state();
-
 	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
 
 #ifdef CONFIG_X86_32
