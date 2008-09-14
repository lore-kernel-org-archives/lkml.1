Return-Path: <linux-kernel-owner+w=401wt.eu-S1754457AbYINMzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbYINMzn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 08:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbYINMze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 08:55:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42045 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237AbYINMzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 08:55:33 -0400
Date: Sun, 14 Sep 2008 14:55:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Peter Oruba <peter.oruba@amd.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [x86-tip, patch] rework of the microcode splitup
Message-ID: <20080914125513.GA22281@elte.hu>
References: <1221383648.6184.28.camel@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221383648.6184.28.camel@earth>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> Ingo, Peter,
> 
> 
> this version is slightly different from the current one in -tip (added 
> missing vfree()).

i've added the delta patch below. I removed the #if 0's as they are 
ugly. (and editing the file to enable debug printouts is easy anyway)

regarding this FIXME:

+       /* FIXME! dimm: Why not by means of get_totalsize(hdr)? */
        total_size = (unsigned long) (hdr[4] + (hdr[5] << 8));

please just use get_totalsize(hdr) and get rid of the fixme that way :)

	Ingo

------------------>
>From a1c75cc5018f17ff6d80ce45a13435b1536f76db Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 14 Sep 2008 14:50:26 +0200
Subject: [PATCH] x86, microcode rework, v2, fix

based on patch from Dmitry Adamushko.

- add missing vfree()
- update debug printks

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/microcode.c       |    4 +---
 arch/x86/kernel/microcode_amd.c   |    6 ++++--
 arch/x86/kernel/microcode_intel.c |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
index 902dada..0c2634f 100644
--- a/arch/x86/kernel/microcode.c
+++ b/arch/x86/kernel/microcode.c
@@ -70,8 +70,6 @@
  *		Fix sigmatch() macro to handle old CPUs with pf == 0.
  *		Thanks to Stuart Swales for pointing out this bug.
  */
-
-/* #define DEBUG pr_debug */
 #include <linux/capability.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -396,7 +394,7 @@ static int mc_sysdev_resume(struct sys_device *dev)
 
 	if (!cpu_online(cpu))
 		return 0;
-	pr_debug("microcode: CPU%d resumed\n", cpu);
+
 	/* only CPU 0 will apply ucode here */
 	microcode_update_cpu(0);
 	return 0;
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 6815837..48aec9f 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -92,7 +92,7 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
 	unsigned int i = 0;
 
 	/*
-	 * dimm: do we need this? Why an update via /dev/... is different
+	 * FIXME! dimm: do we need this? Why an update via /dev/... is different
 	 * from the one via firmware?
 	 *
 	 * This is a tricky part. We might be called from a write operation
@@ -246,7 +246,7 @@ static void * get_next_ucode(u8 *buf, unsigned int size,
 		return NULL;
 	}
 
-	/* Why not by means of get_totalsize(hdr)? */
+	/* FIXME! dimm: Why not by means of get_totalsize(hdr)? */
 	total_size = (unsigned long) (hdr[4] + (hdr[5] << 8));
 
 	printk(KERN_INFO "microcode: size %u, total_size %u\n",
@@ -342,6 +342,8 @@ static int generic_load_microcode(int cpu, void *data, size_t size,
 
 		mc_header = (struct microcode_header_amd *)mc;
 		if (get_matching_microcode(cpu, mc, new_rev)) {
+			if (new_mc)
+				vfree(new_mc);
 			new_rev = mc_header->patch_id;
 			new_mc  = mc;
 		} else 
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index f4930b5..48ed3ce 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -70,8 +70,6 @@
  *		Fix sigmatch() macro to handle old CPUs with pf == 0.
  *		Thanks to Stuart Swales for pointing out this bug.
  */
-
-/* #define DEBUG */ /* pr_debug */
 #include <linux/capability.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -356,6 +354,8 @@ static int generic_load_microcode(int cpu, void *data, size_t size,
 		}
 
 		if (get_matching_microcode(&uci->cpu_sig, mc, new_rev)) {
+			if (new_mc)
+				vfree(new_mc);
 			new_rev = mc_header.rev;
 			new_mc  = mc;
 		} else
