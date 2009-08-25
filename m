Return-Path: <linux-kernel-owner+w=401wt.eu-S932097AbZHYUqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbZHYUqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 16:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755677AbZHYUqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 16:46:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:49466 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755550AbZHYUqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 16:46:18 -0400
Message-ID: <4A944D3C.5030100@kernel.org>
Date: Tue, 25 Aug 2009 13:44:44 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: Ravikiran G Thirumalai <kiran@scalex86.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, linux-kernel@vger.kernel.org,
       shai@scalex86.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH] x86: fix vsmp booting with phys_pkg_id changing
References: <20090825012632.GB6842@localdomain> <4A9372A1.9090905@kernel.org> <20090825171716.GC6456@localdomain> <20090825181500.GB3277@elte.hu> <20090825183130.GA5806@lenovo> <4A943290.5080606@kernel.org> <alpine.LFD.2.01.0908251155570.3218@localhost.localdomain> <20090825191231.GA22821@elte.hu> <4A9438D1.4030608@kernel.org> <20090825192416.GA6974@elte.hu> <20090825203640.GG6456@localdomain>
In-Reply-To: <20090825203640.GG6456@localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.31-rc7 does not boot on vSMPowered systems. 

[    8.501108] CPU31: Thermal monitoring enabled (TM1)
[    8.501127] CPU 31 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    8.650254] CPU31: Intel(R) Xeon(R) CPU           E5540  @ 2.53GHz stepping 04
[    8.710324] Brought up 32 CPUs
[    8.713916] Total of 32 processors activated (162314.96 BogoMIPS).
[    8.721489] ERROR: parent span is not a superset of domain->span
[    8.727686] ERROR: domain->groups does not contain CPU0
[    8.733091] ERROR: groups don't span domain->span
[    8.737975] ERROR: domain->cpu_power not set
[    8.742416]

bisected to
|
| commit 2759c3287de27266e06f1f4e82cbd2d65f6a044c
| x86: don't call read_apic_id if !cpu_has_apic
|

need to use apic id in phys_pkg_id for vsmp...

Reported-and-Tested-by: Ravikiran Thirumalai <kiran@scalex86.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/probe_64.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6/arch/x86/kernel/apic/probe_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/probe_64.c
+++ linux-2.6/arch/x86/kernel/apic/probe_64.c
@@ -44,6 +44,11 @@ static struct apic *apic_probe[] __initd
 	NULL,
 };
 
+static int apicid_phys_pkg_id(int initial_apic_id, int index_msb)
+{
+	return hard_smp_processor_id() >> index_msb;
+}
+
 /*
  * Check the APIC IDs in bios_cpu_apicid and choose the APIC mode.
  */
@@ -69,6 +74,11 @@ void __init default_setup_apic_routing(v
 		printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
 	}
 
+	if (is_vsmp_box()) {
+		/* need to update phys_pkg_id */
+		apic->phys_pkg_id = apicid_phys_pkg_id;
+	}
+
 	/*
 	 * Now that apic routing model is selected, configure the
 	 * fault handling for intr remapping.
