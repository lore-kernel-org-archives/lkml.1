Return-Path: <linux-kernel-owner+w=401wt.eu-S1758298AbXKGNSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298AbXKGNSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 08:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbXKGNSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 08:18:38 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:17360 "EHLO
	outbound2-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751107AbXKGNSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 08:18:37 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
Date: Wed, 7 Nov 2007 14:18:36 +0100
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Andi Kleen" <ak@suse.de>
cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Akinobu Mita" <akinobu.mita@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: fix cpu-hotplug regression
Message-ID: <20071107131836.GB31607@alberich.amd.com>
References: <20071107011258.GA31607@alberich.amd.com>
 <200711070335.44416.ak@suse.de>
MIME-Version: 1.0
In-Reply-To: <200711070335.44416.ak@suse.de>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 07 Nov 2007 13:18:27.0012 (UTC)
 FILETIME=[AE8C6840:01C82140]
X-WSS-ID: 6B2F64AF24S1692785-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 03:35:43AM +0100, Andi Kleen wrote:
> On Wednesday 07 November 2007 02:12, Andreas Herrmann wrote:
> 
> > In cases where not all CPUs are brought up during
> > boot (e.g. using maxcpus and additional_cpus parameters)
> > mce_cpu_callback now returns NOTFIY_BAD because
> > for such CPUs cpu_data is not completely filled when
> > the notifier is called. Thus mce_create_device fails right
> > at its beginning:
> >
> >         if (!mce_available(&cpu_data[cpu]))
> >                 return -EIO;
> >
> > As a quick fix I suggest to check boot_cpu_data for MCE.
> 
> I guess it would be better to just move the device creation
> to after the CPU has booted. AKA call mce_create_dev() on CPU_ONLINE
> instead.

Yes, and this was the old behaviour. The mentioned patch changed it -
("do mce_create_device in CPU_UP_PREPARE instead of CPU_ONLINE").

Thinking twice about the problem it seems obvious that this part
of the patch should just be reverted.

Attached is a new fix (diff against 2.6.24-rc2).


Regards,

Andreas

--
[PATCH] x86: fix cpu hotplug regression (don't call mce_create_device on CPU_UP_PREPARE)

Fix regression introduced with d435d862baca3e25e5eec236762a43251b1e7ffc
("cpu hotplug: mce: fix cpu hotplug error handling").

For CPUs not brought up during boot (using maxcpus and additional_cpus
parameters) we don't know whether mce is supported or not at "CPU_UP_PREPARE"-time.
Thus mce_cpu_callback should be called after the CPU is online.


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index b9f802e..8e83070 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -855,12 +855,10 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	int err = 0;
 
 	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		err = mce_create_device(cpu);
 		break;
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		mce_remove_device(cpu);
-- 
1.5.3.4




