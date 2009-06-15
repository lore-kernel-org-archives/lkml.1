Return-Path: <linux-kernel-owner+w=401wt.eu-S1760594AbZFOOZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760594AbZFOOZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbZFOOZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:25:33 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:44734 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbZFOOZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:25:32 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH, RFC] Re: TSC features, ...
Date: Mon, 15 Jun 2009 09:25:29 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>, Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <alpine.LFD.2.01.0906081128410.6847@localhost.localdomain> <200906150810.15799.lkml@morethan.org>
In-Reply-To: <200906150810.15799.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906150925.31854.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon June 15 2009, Michael S. Zick wrote:
> On Mon June 8 2009, Linus Torvalds wrote:
> > 
> > Hmm. This all really should be just
> > 
> > 	static int check_est_cpu(unsigned int cpuid)
> > 	{
> > 		struct cpuinfo_x86 *cpu = &cpu_data(cpuid);
> > 		return cpu_has(cpu, X86_FEATURE_EST);
> > 	}
> > 
> > I suspect, with no vendor tests. That's the whole _point_ of CPU features, 
> > after all.
> > 
> 

Like this;
Let the vendor's cpu setup code be responsible for getting the
feature flag correct:

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 10a2d91..daea6a9 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -244,22 +244,12 @@ int acpi_processor_resume(struct acpi_device * device)
 #if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
 static void tsc_check_state(int state)
 {
-       switch (boot_cpu_data.x86_vendor) {
-       case X86_VENDOR_AMD:
-       case X86_VENDOR_INTEL:
-               /*
-                * AMD Fam10h TSC will tick in all
-                * C/P/S0/S1 states when this bit is set.
-                */
-               if (boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
-                       return;
+       if (boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
+               return;

-               /*FALL THROUGH*/
-       default:
-               /* TSC could halt in idle, so notify users */
-               if (state > ACPI_STATE_C1)
-                       mark_tsc_unstable("TSC halts in idle");
-       }
+       /* TSC could halt in idle, so notify users */
+       if (state > ACPI_STATE_C1)
+               mark_tsc_unstable("TSC halts in idle");
 }
 #else
 static void tsc_check_state(int state) { return; }

Mike
