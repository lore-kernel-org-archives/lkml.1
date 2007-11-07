Return-Path: <linux-kernel-owner+w=401wt.eu-S1758489AbXKGOPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489AbXKGOPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 09:15:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbXKGOPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 09:15:40 -0500
Received: from wx-out-0506.google.com ([66.249.82.225]:57838 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820AbXKGOPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 09:15:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QgUwsnXe/2xR5TkwoslAsJjbuv4iO7vFpVFXP2nKOIKltuDY3W8U2Ch8aBt9iSs/B7sZkwSdmVhH05zapRMVJCRzvX9s+KcVwY0p7FsUUph/xgu5Z3YEELHcXR0AKI+ZVvGdt2gK2oxAgUfO2/yI91gHFYyjNULx915WDFx8hZk=
Message-ID: <961aa3350711070615m4a165546k4fa888cb546846f6@mail.gmail.com>
Date: Wed, 7 Nov 2007 23:15:38 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Andreas Herrmann" <andreas.herrmann3@amd.com>
Subject: Re: [PATCH] x86: fix cpu-hotplug regression
Cc: "Andi Kleen" <ak@suse.de>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20071107131836.GB31607@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071107011258.GA31607@alberich.amd.com>
	 <200711070335.44416.ak@suse.de>
	 <20071107131836.GB31607@alberich.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> [PATCH] x86: fix cpu hotplug regression (don't call mce_create_device on CPU_UP_PREPARE)
>
> Fix regression introduced with d435d862baca3e25e5eec236762a43251b1e7ffc
> ("cpu hotplug: mce: fix cpu hotplug error handling").
>
> For CPUs not brought up during boot (using maxcpus and additional_cpus
> parameters) we don't know whether mce is supported or not at "CPU_UP_PREPARE"-time.
> Thus mce_cpu_callback should be called after the CPU is online.

Thank you for finding and fixing the problem.
I added two fixes to your patch:

- Avoid mce_remove_device() for the CPU that is not correctly initialized
  by mce_create_device() failure.

- make CPU_ONLINE callback always return NOTIFY_OK.
  Because CPU_ONLINE callback return value is always ignored.

> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>

[akinobu.mita@gmail.com: make CPU_ONLINE callback always return NOTIFY_OK]
[akinobu.mita@gmail.com: avoid mce_remove_device() for not initialized device]

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

Index: 2.6-git/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ 2.6-git/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -802,6 +802,8 @@ static struct sysdev_attribute *mce_attr
 	NULL
 };

+static cpumask_t mce_device_initialized = CPU_MASK_NONE;
+
 /* Per cpu sysdev init.  All of the cpus still share the same ctl bank */
 static __cpuinit int mce_create_device(unsigned int cpu)
 {
@@ -825,6 +827,7 @@ static __cpuinit int mce_create_device(u
 		if (err)
 			goto error;
 	}
+	cpu_set(cpu, mce_device_initialized);

 	return 0;
 error:
@@ -841,10 +844,14 @@ static void mce_remove_device(unsigned i
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
