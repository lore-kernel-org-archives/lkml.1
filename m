Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbXKGBUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbXKGBUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 20:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757397AbXKGBQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 20:16:18 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:33563 "EHLO
	outbound7-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756316AbXKGBQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 20:16:15 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Date: Wed, 7 Nov 2007 02:12:58 +0100
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
cc: linux-kernel@vger.kernel.org, "Akinobu Mita" <akinobu.mita@gmail.com>,
       "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH] x86: fix cpu-hotplug regression
Message-ID: <20071107011258.GA31607@alberich.amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 07 Nov 2007 01:12:50.0731 (UTC)
 FILETIME=[50E71FB0:01C820DB]
X-WSS-ID: 6B2FCE9F07S1658046-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86: fix cpu-hotplug regression

Commit d435d862baca3e25e5eec236762a43251b1e7ffc
("cpu hotplug: mce: fix cpu hotplug error handling")
changed the error handling in mce_cpu_callback.

In cases where not all CPUs are brought up during
boot (e.g. using maxcpus and additional_cpus parameters)
mce_cpu_callback now returns NOTFIY_BAD because
for such CPUs cpu_data is not completely filled when
the notifier is called. Thus mce_create_device fails right
at its beginning:

        if (!mce_available(&cpu_data[cpu]))
                return -EIO;

As a quick fix I suggest to check boot_cpu_data for MCE.

To reproduce this regression:

(1) boot with maxcpus=2 addtional_cpus=2 on a 4 CPU x86-64 system
(2) # echo 1 >/sys/devices/system/cpu/cpu2/online
  -bash: echo: write error: Invalid argument

dmesg shows:

_cpu_up: attempt to bring up CPU 2 failed

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index b9f802e..5112a70 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -808,7 +808,7 @@ static __cpuinit int mce_create_device(unsigned int cpu)
 	int err;
 	int i;
 
-	if (!mce_available(&cpu_data(cpu)))
+	if (!mce_available(&boot_cpu_data))
 		return -EIO;
 
 	memset(&per_cpu(device_mce, cpu).kobj, 0, sizeof(struct kobject));
-- 
1.5.3.4




