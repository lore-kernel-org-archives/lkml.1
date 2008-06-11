Return-Path: <linux-kernel-owner+w=401wt.eu-S1758121AbYFKPGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbYFKPGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 11:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbYFKPF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 11:05:58 -0400
Received: from mail-sin.bigfish.com ([207.46.51.74]:17259 "EHLO
	mail83-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbYFKPF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 11:05:57 -0400
X-BigFish: VPS-21(zz1432R98dR7efV1805M3117Kzz10d3izz3198u327anz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0K2B0KK-01-W01-01
Date: Wed, 11 Jun 2008 17:05:07 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rene Herman <rene.herman@keyaccess.nl>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Dave Jones <davej@redhat.com>
Subject: [PATCH] x86: enable PAT on (almost) all CPUs that advertise it
Message-ID: <20080611150507.GD5170@alberich.amd.com>
References: <20080610140518.GF5024@alberich.amd.com> <484F065B.2050002@keyaccess.nl> <484F0F5D.8010507@zytor.com> <20080611094730.GB5889@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080611094730.GB5889@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 11 Jun 2008 15:05:08.0659 (UTC) FILETIME=[89DDF830:01C8CBD4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 11:47:30AM +0200, Andreas Herrmann wrote:
> There seem to be other Intel CPUs that advertise PAT support.
> See cpuinfo output at http://gentoo-wiki.com/Safe_Cflags
> E.g. Pentium M (model 13), Celeron (model 6), Pentium III (model 8).
> (Not sure how correct this information is, though)
> 
> Turn the white- into a blacklist for those remaining CPUs until they
> are verified?

How about the attached patch.
This one should replace patches 1 and 2 that I've sent before.


Regards,

Andreas
--

x86: PAT: enable PAT on (almost) all CPUs that advertise it

Dave Jones recently added Centaur and Transmeta CPUs to the
PAT whitelist. See this thread
http://marc.info/?l=linux-kernel&m=121125666327279

I've checked that for AMD CPUs there are no known errata regarding PAT
-- if the CPU advertises it it should work.

I am not aware of other CPUs which claim to support PAT and are not
verified (besides some older Intel CPU models).

So it's time to enable PAT on CPUs that claim to support it.

I just kept the "whitelist" for Intel CPUs. It is similar to what was
submitted by Venkatesh in the first place.
See pat_known_cpu() in commit 2e5d9c857d4e6c9e7b7d8c8c86a68a7842d213d6
(x86: PAT infrastructure patch).

CC: Dave Jones <davej@redhat.com>
CC: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/addon_cpuid_features.c |   19 +++++--------------
 1 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index d8b3e4a..3a66ef4 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -53,22 +53,13 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 #ifdef CONFIG_X86_PAT
 void __cpuinit validate_pat_support(struct cpuinfo_x86 *c)
 {
-	switch (c->x86_vendor) {
-	case X86_VENDOR_AMD:
-		if (c->x86 >= 0xf && c->x86 <= 0x11)
-			return;
-		break;
-	case X86_VENDOR_INTEL:
-		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
-			return;
-		break;
-	case X86_VENDOR_CENTAUR:
-	case X86_VENDOR_TRANSMETA:
+	if (!cpu_has_pat) {
+		pat_disable("PAT not supported by CPU.");
 		return;
 	}
 
-	pat_disable(cpu_has_pat ?
-		    "PAT disabled. Not yet verified on this CPU type." :
-		    "PAT not supported by CPU.");
+	if ((c->x86_vendor == X86_VENDOR_INTEL) &&
+	    !(c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15)))
+		pat_disable("PAT disabled. Not yet verified on this CPU type.");
 }
 #endif
-- 
1.5.5.3



