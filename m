Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123AbZHXTHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbZHXTHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 15:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbZHXTHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 15:07:09 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:54300 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbZHXTHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 15:07:08 -0400
X-Greylist: delayed 2405 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Aug 2009 15:07:07 EDT
Date: Mon, 24 Aug 2009 11:26:59 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, shai@scalex86.org
Subject: [patch] x86: 2.6.31-rc7 crash due to buggy flat_phys_pkg_id
Message-ID: <20090824182659.GA6842@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-rc7 does not boot on vSMPowered systems.  The sched domains
seem to build incorrectly with error messages of the sort:

[    8.501108] CPU31: Thermal monitoring enabled (TM1)
[    8.501127] CPU 31 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    8.650254] CPU31: Intel(R) Xeon(R) CPU           E5540  @ 2.53GHz
stepping 04
[    8.710324] Brought up 32 CPUs
[    8.713916] Total of 32 processors activated (162314.96 BogoMIPS).
[    8.721489] ERROR: parent span is not a superset of domain->span
[    8.727686] ERROR: domain->groups does not contain CPU0
[    8.733091] ERROR: groups don't span domain->span
[    8.737975] ERROR: domain->cpu_power not set
[    8.742416]

This is followed by oopsen in the scheduler code
with NULL pointer deference in find_busiest_group.

Git bisection pointed to the following commit:

commit 2759c3287de27266e06f1f4e82cbd2d65f6a044c
x86: don't call read_apic_id if !cpu_has_apic

Upon examining the history of the commit, the above commit seems to be a fix
for:

commit 4797f6b021a3fa399942245d07a1feb30df81bb8
x86: read apic ID in the !acpi_lapic case

However, there appears to be bug in the commit
2759c3287de27266e06f1f4e82cbd2d65f6a044c, where flat_phys_pkg_id
uses initial apic id instead of hard_smp_processor_id() on SMP machines.
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=2759c3287de27266e06f1f4e82cbd2d65f6a044c

This patch fixes the bug and causes vSMPowered systems to boot up
correctly,

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Cc: Yinghai Lu <yinghai@kernel.org>

Index: linux-2.6.31-rc6/arch/x86/kernel/apic/apic_flat_64.c
===================================================================
--- linux-2.6.31-rc6.orig/arch/x86/kernel/apic/apic_flat_64.c	2009-08-21 12:42:16.000000000 -0700
+++ linux-2.6.31-rc6/arch/x86/kernel/apic/apic_flat_64.c	2009-08-21 14:12:21.654837472 -0700
@@ -161,7 +161,8 @@ static int flat_apic_id_registered(void)
 
 static int flat_phys_pkg_id(int initial_apic_id, int index_msb)
 {
-	return initial_apic_id >> index_msb;
+	return cpu_has_apic ? hard_smp_processor_id() >> index_msb :
+	    initial_apic_id >> index_msb;
 }
 
 struct apic apic_flat =  {
