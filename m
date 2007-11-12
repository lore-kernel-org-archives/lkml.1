Return-Path: <linux-kernel-owner+w=401wt.eu-S1759173AbXKLRis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759173AbXKLRis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 12:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758446AbXKLRi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 12:38:26 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:43847 "EHLO
	outbound9-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759747AbXKLRiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 12:38:24 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Date: Mon, 12 Nov 2007 18:38:03 +0100
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
cc: "Akinobu Mita" <akinobu.mita@gmail.com>, ak@suse.de, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH]  x86: don't call mce_create_device on CPU_UP_PREPARE
Message-ID: <20071112173803.GD5560@alberich.amd.com>
References: <20071107011258.GA31607@alberich.amd.com>
 <200711070335.44416.ak@suse.de>
 <20071107131836.GB31607@alberich.amd.com>
 <961aa3350711070615m4a165546k4fa888cb546846f6@mail.gmail.com>
 <20071109121634.c7812697.akpm@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20071109121634.c7812697.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 12 Nov 2007 17:38:01.0993 (UTC)
 FILETIME=[C606A790:01C82552]
X-WSS-ID: 6B2650F607S2253726-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2007 at 12:16:34PM -0800, Andrew Morton wrote:
> Andreas, could you please review and preferably runtime-test this new
> version?

Reviewed and tested.
Akinobu's changes are necessary as well.
Test was ok.

> Assuming that all goes well could one of you please prepare a final patch
> with a complete changelog?

Attached is a new patch with a "combined changelog".
Patch is against v2.6.24-rc2-247-g6e800af.


Regards,

Andreas
--

x86: don't call mce_create_device on CPU_UP_PREPARE

Fix regression introduced with d435d862baca3e25e5eec236762a43251b1e7ffc
("cpu hotplug: mce: fix cpu hotplug error handling").

A CPU which was not brought up during boot (using maxcpus and additional_cpus
parameters) couldn't be onlined anymore. For such a CPU it seemed that MCE
was not supported during CPU_UP_PREPARE-time which caused mce_cpu_callback
to return NOTIFY_BAD to notifier_call_chain.
To fix this we:

 - call mce_create_device for CPU_ONLINE event (instead of CPU_UP_PREPARE),
 - avoid mce_remove_device() for the CPU that is not correctly initialized
   by mce_create_device() failure,
 - make mce_cpu_callback always return NOTIFY_OK for CPU_ONLINE event.
   Because CPU_ONLINE callback return value is always ignored.

[akinobu.mita@gmail.com: avoid mce_remove_device() for not initialized device]
[akinobu.mita@gmail.com: make mce_cpu_callback always return NOTIFY_OK]
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce_64.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index b9f802e..447b351 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -802,6 +802,8 @@ static struct sysdev_attribute *mce_attributes[] = {
 	NULL
 };
 
+static cpumask_t mce_device_initialized = CPU_MASK_NONE;
+
 /* Per cpu sysdev init.  All of the cpus still share the same ctl bank */
 static __cpuinit int mce_create_device(unsigned int cpu)
 {
@@ -825,6 +827,7 @@ static __cpuinit int mce_create_device(unsigned int cpu)
 		if (err)
 			goto error;
 	}
+	cpu_set(cpu, mce_device_initialized);
 
 	return 0;
 error:
@@ -841,10 +844,14 @@ static void mce_remove_device(unsigned int cpu)
 {
 	int i;
 
+	if (!cpu_isset(cpu, mce_device_initialized))
+		return;
+
 	for (i = 0; mce_attributes[i]; i++)
 		sysdev_remove_file(&per_cpu(device_mce,cpu),
 			mce_attributes[i]);
 	sysdev_unregister(&per_cpu(device_mce,cpu));
+	cpu_clear(cpu, mce_device_initialized);
 }
 
 /* Get notified when a cpu comes on/off. Be hotplug friendly. */
@@ -852,21 +859,18 @@ static int
 mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
-	int err = 0;
 
 	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		err = mce_create_device(cpu);
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		mce_create_device(cpu);
 		break;
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		mce_remove_device(cpu);
 		break;
 	}
-	return err ? NOTIFY_BAD : NOTIFY_OK;
+	return NOTIFY_OK;
 }
 
 static struct notifier_block mce_cpu_notifier = {
-- 
1.5.3.4




