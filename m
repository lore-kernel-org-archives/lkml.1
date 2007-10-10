Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbXJJQhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbXJJQhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 12:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756914AbXJJQfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 12:35:46 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:14165 "EHLO
	outbound1-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756893AbXJJQfo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 12:35:44 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
Date: Wed, 10 Oct 2007 18:35:18 +0200
From: "Andreas Herrmann3" <andreas.herrmann3@amd.com>
To: "Dave Jones" <davej@redhat.com>, "Mark Langsdorf" <mark.langsdorf@amd.com>,
       "Andi Kleen" <andi@firstfloor.org>, cpufreq@lists.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][try 2] architectural pstate driver for powernow-k8
Message-ID: <20071010163518.GB6443@alberich.amd.com>
References: <200710091446.38432.mark.langsdorf@amd.com>
 <p73fy0k3ve8.fsf@bingen.suse.de>
 <200710091543.21350.mark.langsdorf@amd.com>
 <20071009234125.GB6879@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20071009234125.GB6879@redhat.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 10 Oct 2007 16:35:18.0626 (UTC)
 FILETIME=[8B40AC20:01C80B5B]
X-WSS-ID: 6B1220C32ZC1579800-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 07:41:25PM -0400, Dave Jones wrote:
> On Tue, Oct 09, 2007 at 03:43:20PM -0500, Mark Langsdorf wrote:
>  > This patch should apply cleanly to the 2.6.23-rc8-mm2 kernel.  It changes 
>  > the powernow-k8 driver code that deals with 3rd generation Opteron, Phenom,
>  > and later processors to match the architectual pstate driver described
>  > in the AMD64 Architecture Programmer's Manual Volume 2 Chapter 18.  The
>  > initial implementation of the hardware pstate driver for PowerNow!
>  > used some processor-version specific features, and would not be
>  > maintainable in the long term as the processor features changed.
>  > This architectural driver should work on all future AMD processors.
>  
> Has this been tested on older implementations of powernow yet?
> I'm happy to merge this and give it some time in -mm, before it
> goes to mainline, but if no-one is testing on those older
> opterons/turions etc then we're not going to know we regressed
> until its too late.   If it hasn't been tested yet, any chance
> you can scrounge some up at AMD and give it a spin just to be sure?


I'd like to see this driver in the next kernel release.

So I have done some tests with this code - based on kernel version 2.6.23.
I have tested it on Athlon 64 X2, Athlon 64, Turion X2 and some other parts
(e.g.family 0x10) and with different cpufreq governors.
I did not observe any problems with this driver update.
Behaviour is the same as before.

I just had to fix one minor compile error.

So please consider to add the attached patch for 2.6.24.
Patch is against current Linus' git tree. This means the patch
"[CPUFREQ] Support different families in fid/did to frequency conversion"
which is contained in the cpufreq.git should be ommitted. The issue
fixed with that patch is solved with this driver update, too.

If you need a patch against the x86 tree I can provide one as well.


Thanks and Regards,

Andreas
--

[PATCH] architectural pstate driver for powernow-k8

This changes the powernow-k8 driver code that deals with 3rd
generation Opteron, Phenom, and later processors to match the
architectual pstate driver described in the AMD64 Architecture
Programmer's Manual Volume 2 Chapter The initial implementation of the
hardware pstate driver for PowerNow!  used some processor-version
specific features, and would not be maintainable in the long term as
the processor features changed.  This architectural driver should work
on all future AMD processors.

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
Signed-off-by: Andreas Herrmann3 <aherrma3@alberich.amd.com>
---
 arch/i386/kernel/cpu/cpufreq/powernow-k8.c |   85 ++++++++--------------------
 arch/i386/kernel/cpu/cpufreq/powernow-k8.h |   20 ++-----
 2 files changed, 29 insertions(+), 76 deletions(-)

diff --git a/arch/i386/kernel/cpu/cpufreq/powernow-k8.c b/arch/i386/kernel/cpu/cpufreq/powernow-k8.c
index 34ed53a..ef8be4a 100644
--- a/arch/i386/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/i386/kernel/cpu/cpufreq/powernow-k8.c
@@ -46,7 +46,7 @@
 
 #define PFX "powernow-k8: "
 #define BFX PFX "BIOS error: "
-#define VERSION "version 2.00.00"
+#define VERSION "version 2.20.00"
 #include "powernow-k8.h"
 
 /* serialize freq changes  */
@@ -73,29 +73,9 @@ static u32 find_khz_freq_from_fid(u32 fid)
 	return 1000 * find_freq_from_fid(fid);
 }
 
-/* Return a frequency in MHz, given an input fid and did */
-static u32 find_freq_from_fiddid(u32 fid, u32 did)
+static u32 find_khz_freq_from_pstate(struct cpufreq_frequency_table *data, u32 pstate)
 {
-	return 100 * (fid + 0x10) >> did;
-}
-
-static u32 find_khz_freq_from_fiddid(u32 fid, u32 did)
-{
-	return 1000 * find_freq_from_fiddid(fid, did);
-}
-
-static u32 find_fid_from_pstate(u32 pstate)
-{
-	u32 hi, lo;
-	rdmsr(MSR_PSTATE_DEF_BASE + pstate, lo, hi);
-	return lo & HW_PSTATE_FID_MASK;
-}
-
-static u32 find_did_from_pstate(u32 pstate)
-{
-	u32 hi, lo;
-	rdmsr(MSR_PSTATE_DEF_BASE + pstate, lo, hi);
-	return (lo & HW_PSTATE_DID_MASK) >> HW_PSTATE_DID_SHIFT;
+	return data[pstate].frequency;
 }
 
 /* Return the vco fid for an input fid
@@ -139,9 +119,7 @@ static int query_current_values_with_pending_wait(struct powernow_k8_data *data)
 	if (cpu_family == CPU_HW_PSTATE) {
 		rdmsr(MSR_PSTATE_STATUS, lo, hi);
 		i = lo & HW_PSTATE_MASK;
-		rdmsr(MSR_PSTATE_DEF_BASE + i, lo, hi);
-		data->currfid = lo & HW_PSTATE_FID_MASK;
-		data->currdid = (lo & HW_PSTATE_DID_MASK) >> HW_PSTATE_DID_SHIFT;
+		data->currpstate = i;
 		return 0;
 	}
 	do {
@@ -292,7 +270,7 @@ static int decrease_vid_code_by_step(struct powernow_k8_data *data, u32 reqvid,
 static int transition_pstate(struct powernow_k8_data *data, u32 pstate)
 {
 	wrmsr(MSR_PSTATE_CTRL, pstate, 0);
-	data->currfid = find_fid_from_pstate(pstate);
+	data->currpstate = pstate;
 	return 0;
 }
 
@@ -842,17 +820,20 @@ err_out:
 static int fill_powernow_table_pstate(struct powernow_k8_data *data, struct cpufreq_frequency_table *powernow_table)
 {
 	int i;
+	u32 hi = 0, lo = 0;
+	rdmsr(MSR_PSTATE_CUR_LIMIT, hi, lo);
+	data->max_hw_pstate = (hi & HW_PSTATE_MAX_MASK) >> HW_PSTATE_MAX_SHIFT;
 
 	for (i = 0; i < data->acpi_data.state_count; i++) {
 		u32 index;
 		u32 hi = 0, lo = 0;
-		u32 fid;
-		u32 did;
 
 		index = data->acpi_data.states[i].control & HW_PSTATE_MASK;
-		if (index > MAX_HW_PSTATE) {
+		if (index > data->max_hw_pstate) {
 			printk(KERN_ERR PFX "invalid pstate %d - bad value %d.\n", i, index);
 			printk(KERN_ERR PFX "Please report to BIOS manufacturer\n");
+			powernow_table[i].frequency = CPUFREQ_ENTRY_INVALID;
+			continue;
 		}
 		rdmsr(MSR_PSTATE_DEF_BASE + index, lo, hi);
 		if (!(hi & HW_PSTATE_VALID_MASK)) {
@@ -861,22 +842,9 @@ static int fill_powernow_table_pstate(struct powernow_k8_data *data, struct cpuf
 			continue;
 		}
 
-		fid = lo & HW_PSTATE_FID_MASK;
-		did = (lo & HW_PSTATE_DID_MASK) >> HW_PSTATE_DID_SHIFT;
+		powernow_table[i].index = index;
 
-		dprintk("   %d : fid 0x%x, did 0x%x\n", index, fid, did);
-
-		powernow_table[i].index = index | (fid << HW_FID_INDEX_SHIFT) | (did << HW_DID_INDEX_SHIFT);
-
-		powernow_table[i].frequency = find_khz_freq_from_fiddid(fid, did);
-
-		if (powernow_table[i].frequency != (data->acpi_data.states[i].core_frequency * 1000)) {
-			printk(KERN_INFO PFX "invalid freq entries %u kHz vs. %u kHz\n",
-				powernow_table[i].frequency,
-				(unsigned int) (data->acpi_data.states[i].core_frequency * 1000));
-			powernow_table[i].frequency = CPUFREQ_ENTRY_INVALID;
-			continue;
-		}
+		powernow_table[i].frequency = data->acpi_data.states[i].core_frequency * 1000;
 	}
 	return 0;
 }
@@ -1017,8 +985,6 @@ static int transition_frequency_fidvid(struct powernow_k8_data *data, unsigned i
 /* Take a frequency, and issue the hardware pstate transition command */
 static int transition_frequency_pstate(struct powernow_k8_data *data, unsigned int index)
 {
-	u32 fid = 0;
-	u32 did = 0;
 	u32 pstate = 0;
 	int res, i;
 	struct cpufreq_freqs freqs;
@@ -1027,12 +993,10 @@ static int transition_frequency_pstate(struct powernow_k8_data *data, unsigned i
 
 	/* get fid did for hardware pstate transition */
 	pstate = index & HW_PSTATE_MASK;
-	if (pstate > MAX_HW_PSTATE)
+	if (pstate > data->max_hw_pstate);
 		return 0;
-	fid = (index & HW_FID_INDEX_MASK) >> HW_FID_INDEX_SHIFT;
-	did = (index & HW_DID_INDEX_MASK) >> HW_DID_INDEX_SHIFT;
-	freqs.old = find_khz_freq_from_fiddid(data->currfid, data->currdid);
-	freqs.new = find_khz_freq_from_fiddid(fid, did);
+	freqs.old = find_khz_freq_from_pstate(data->powernow_table, data->currpstate);
+	freqs.new = find_khz_freq_from_pstate(data->powernow_table, pstate);
 
 	for_each_cpu_mask(i, *(data->available_cores)) {
 		freqs.cpu = i;
@@ -1040,9 +1004,7 @@ static int transition_frequency_pstate(struct powernow_k8_data *data, unsigned i
 	}
 
 	res = transition_pstate(data, pstate);
-	data->currfid = find_fid_from_pstate(pstate);
-	data->currdid = find_did_from_pstate(pstate);
-	freqs.new = find_khz_freq_from_fiddid(data->currfid, data->currdid);
+	freqs.new = find_khz_freq_from_pstate(data->powernow_table, pstate);
 
 	for_each_cpu_mask(i, *(data->available_cores)) {
 		freqs.cpu = i;
@@ -1088,8 +1050,8 @@ static int powernowk8_target(struct cpufreq_policy *pol, unsigned targfreq, unsi
 		goto err_out;
 
 	if (cpu_family == CPU_HW_PSTATE)
-		dprintk("targ: curr fid 0x%x, did 0x%x\n",
-			data->currfid, data->currdid);
+		dprintk("cpu_init done, current pstate 0x%x\n",
+			data->currpstate);
 	else {
 		dprintk("targ: curr fid 0x%x, vid 0x%x\n",
 		data->currfid, data->currvid);
@@ -1121,7 +1083,7 @@ static int powernowk8_target(struct cpufreq_policy *pol, unsigned targfreq, unsi
 	mutex_unlock(&fidvid_mutex);
 
 	if (cpu_family == CPU_HW_PSTATE)
-		pol->cur = find_khz_freq_from_fiddid(data->currfid, data->currdid);
+		pol->cur = find_khz_freq_from_pstate(data->powernow_table, newstate);
 	else
 		pol->cur = find_khz_freq_from_fid(data->currfid);
 	ret = 0;
@@ -1221,7 +1183,7 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 	    + (3 * (1 << data->irt) * 10)) * 1000;
 
 	if (cpu_family == CPU_HW_PSTATE)
-		pol->cur = find_khz_freq_from_fiddid(data->currfid, data->currdid);
+		pol->cur = find_khz_freq_from_pstate(data->powernow_table, data->currpstate);
 	else
 		pol->cur = find_khz_freq_from_fid(data->currfid);
 	dprintk("policy current frequency %d kHz\n", pol->cur);
@@ -1238,8 +1200,7 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 	cpufreq_frequency_table_get_attr(data->powernow_table, pol->cpu);
 
 	if (cpu_family == CPU_HW_PSTATE)
-		dprintk("cpu_init done, current fid 0x%x, did 0x%x\n",
-			data->currfid, data->currdid);
+		dprintk("cpu_init done, current pstate 0x%x\n", data->currpstate);
 	else
 		dprintk("cpu_init done, current fid 0x%x, vid 0x%x\n",
 			data->currfid, data->currvid);
@@ -1295,7 +1256,7 @@ static unsigned int powernowk8_get (unsigned int cpu)
 		goto out;
 
 	if (cpu_family == CPU_HW_PSTATE)
-		khz = find_khz_freq_from_fiddid(data->currfid, data->currdid);
+		khz = find_khz_freq_from_pstate(data->powernow_table, data->currpstate);
 	else
 		khz = find_khz_freq_from_fid(data->currfid);
 
diff --git a/arch/i386/kernel/cpu/cpufreq/powernow-k8.h b/arch/i386/kernel/cpu/cpufreq/powernow-k8.h
index b06c812..8ae88f1 100644
--- a/arch/i386/kernel/cpu/cpufreq/powernow-k8.h
+++ b/arch/i386/kernel/cpu/cpufreq/powernow-k8.h
@@ -10,6 +10,7 @@ struct powernow_k8_data {
 
 	u32 numps;  /* number of p-states */
 	u32 batps;  /* number of p-states supported on battery */
+	u32 max_hw_pstate; /* maximum legal hardware pstate */
 
 	/* these values are constant when the PSB is used to determine
 	 * vid/fid pairings, but are modified during the ->target() call
@@ -21,8 +22,8 @@ struct powernow_k8_data {
 	u32 plllock; /* pll lock time, units 1 us */
         u32 exttype; /* extended interface = 1 */
 
-	/* keep track of the current fid / vid or did */
-	u32 currvid, currfid, currdid;
+	/* keep track of the current fid / vid or pstate */
+	u32 currvid, currfid, currpstate;
 
 	/* the powernow_table includes all frequency and vid/fid pairings:
 	 * fid are the lower 8 bits of the index, vid are the upper 8 bits.
@@ -87,23 +88,14 @@ struct powernow_k8_data {
 
 /* Hardware Pstate _PSS and MSR definitions */
 #define USE_HW_PSTATE		0x00000080
-#define HW_PSTATE_FID_MASK 	0x0000003f
-#define HW_PSTATE_DID_MASK 	0x000001c0
-#define HW_PSTATE_DID_SHIFT 	6
 #define HW_PSTATE_MASK 		0x00000007
 #define HW_PSTATE_VALID_MASK 	0x80000000
-#define HW_FID_INDEX_SHIFT	8
-#define HW_FID_INDEX_MASK	0x0000ff00
-#define HW_DID_INDEX_SHIFT	16
-#define HW_DID_INDEX_MASK	0x00ff0000
-#define HW_WATTS_MASK		0xff
-#define HW_PWR_DVR_MASK		0x300
-#define HW_PWR_DVR_SHIFT	8
-#define HW_PWR_MAX_MULT		3
-#define MAX_HW_PSTATE		8	/* hw pstate supports up to 8 */
+#define HW_PSTATE_MAX_MASK	0x000000f0
+#define HW_PSTATE_MAX_SHIFT	4
 #define MSR_PSTATE_DEF_BASE 	0xc0010064 /* base of Pstate MSRs */
 #define MSR_PSTATE_STATUS 	0xc0010063 /* Pstate Status MSR */
 #define MSR_PSTATE_CTRL 	0xc0010062 /* Pstate control MSR */
+#define MSR_PSTATE_CUR_LIMIT	0xc0010061 /* pstate current limit MSR */
 
 /* define the two driver architectures */
 #define CPU_OPTERON 0
-- 
1.5.3.4




