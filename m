Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587AbXJITpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbXJITpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 15:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755812AbXJITpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 15:45:32 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:50509 "EHLO
	outbound3-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755474AbXJITp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 15:45:28 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
From: "Mark Langsdorf" <mark.langsdorf@amd.com>
To: cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [PATCH] architectural pstate driver for powernow-k8
Date: Tue, 9 Oct 2007 14:46:38 -0500
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Message-ID: <200710091446.38432.mark.langsdorf@amd.com>
X-OriginalArrivalTime: 09 Oct 2007 19:44:56.0629 (UTC)
 FILETIME=[DEA86650:01C80AAC]
X-WSS-ID: 6B1505C113S1522350-01-01
Content-Type: multipart/mixed;
 boundary="Boundary-00=_eq9CH8zLUV7vAQt"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Boundary-00=_eq9CH8zLUV7vAQt
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

This patch should apply cleanly to the 2.6.22.6 kernel. =A0It changes the
powernow-k8 driver code that deals with 3rd generation Opteron, Phenom,
and later processors to match the architectual pstate driver described
in the AMD64 Architecture Programmer's Manual Volume 2 Chapter 18.  The
initial implementation of the hardware pstate driver for PowerNow!
used some processor-version specific features, and would not be
maintainable in the long term as the processor features changed.
This architectural driver should work on all future AMD processors.

=2DMark Langsdorf
Operating System Research Center
AMD

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
Acked-by: Andreas Herrmann <andreas.herrmann3@amd.com>


diff -urpN -X linux-2.6.22.6-vanilla/Documentation/dontdiff linux-2.6.22.6-=
vanilla/arch/i386/kernel/cpu/cpufreq/powernow-k8.c linux-2.6.22.6/arch/i386=
/kernel/cpu/cpufreq/powernow-k8.c
=2D-- linux-2.6.22.6-vanilla/arch/i386/kernel/cpu/cpufreq/powernow-k8.c	200=
7-08-31 01:21:01.000000000 -0500
+++ linux-2.6.22.6/arch/i386/kernel/cpu/cpufreq/powernow-k8.c	2007-09-07 14=
:15:17.000000000 -0500
@@ -46,7 +46,7 @@
=20
 #define PFX "powernow-k8: "
 #define BFX PFX "BIOS error: "
=2D#define VERSION "version 2.00.00"
+#define VERSION "version 2.20.00"
 #include "powernow-k8.h"
=20
 /* serialize freq changes  */
@@ -73,29 +73,9 @@ static u32 find_khz_freq_from_fid(u32 fi
 	return 1000 * find_freq_from_fid(fid);
 }
=20
=2D/* Return a frequency in MHz, given an input fid and did */
=2Dstatic u32 find_freq_from_fiddid(u32 fid, u32 did)
+static u32 find_khz_freq_from_pstate(struct cpufreq_frequency_table *data,=
 u32 pstate)
 {
=2D	return 100 * (fid + 0x10) >> did;
=2D}
=2D
=2Dstatic u32 find_khz_freq_from_fiddid(u32 fid, u32 did)
=2D{
=2D	return 1000 * find_freq_from_fiddid(fid, did);
=2D}
=2D
=2Dstatic u32 find_fid_from_pstate(u32 pstate)
=2D{
=2D	u32 hi, lo;
=2D	rdmsr(MSR_PSTATE_DEF_BASE + pstate, lo, hi);
=2D	return lo & HW_PSTATE_FID_MASK;
=2D}
=2D
=2Dstatic u32 find_did_from_pstate(u32 pstate)
=2D{
=2D	u32 hi, lo;
=2D	rdmsr(MSR_PSTATE_DEF_BASE + pstate, lo, hi);
=2D	return (lo & HW_PSTATE_DID_MASK) >> HW_PSTATE_DID_SHIFT;
+	return data[pstate].frequency;
 }
=20
 /* Return the vco fid for an input fid
@@ -139,9 +119,7 @@ static int query_current_values_with_pen
 	if (cpu_family =3D=3D CPU_HW_PSTATE) {
 		rdmsr(MSR_PSTATE_STATUS, lo, hi);
 		i =3D lo & HW_PSTATE_MASK;
=2D		rdmsr(MSR_PSTATE_DEF_BASE + i, lo, hi);
=2D		data->currfid =3D lo & HW_PSTATE_FID_MASK;
=2D		data->currdid =3D (lo & HW_PSTATE_DID_MASK) >> HW_PSTATE_DID_SHIFT;
+		data->currpstate =3D i;
 		return 0;
 	}
 	do {
@@ -292,7 +270,7 @@ static int decrease_vid_code_by_step(str
 static int transition_pstate(struct powernow_k8_data *data, u32 pstate)
 {
 	wrmsr(MSR_PSTATE_CTRL, pstate, 0);
=2D	data->currfid =3D find_fid_from_pstate(pstate);
+	data->currpstate =3D pstate;
 	return 0;
 }
=20
@@ -839,17 +817,20 @@ err_out:
 static int fill_powernow_table_pstate(struct powernow_k8_data *data, struc=
t cpufreq_frequency_table *powernow_table)
 {
 	int i;
+	u32 hi =3D 0, lo =3D 0;
+	rdmsr(MSR_PSTATE_CUR_LIMIT, hi, lo);
+	data->max_hw_pstate =3D (hi & HW_PSTATE_MAX_MASK) >> HW_PSTATE_MAX_SHIFT;
=20
 	for (i =3D 0; i < data->acpi_data.state_count; i++) {
 		u32 index;
 		u32 hi =3D 0, lo =3D 0;
=2D		u32 fid;
=2D		u32 did;
=20
 		index =3D data->acpi_data.states[i].control & HW_PSTATE_MASK;
=2D		if (index > MAX_HW_PSTATE) {
+		if (index > data->max_hw_pstate) {
 			printk(KERN_ERR PFX "invalid pstate %d - bad value %d.\n", i, index);
 			printk(KERN_ERR PFX "Please report to BIOS manufacturer\n");
+			powernow_table[i].frequency =3D CPUFREQ_ENTRY_INVALID;
+			continue;
 		}
 		rdmsr(MSR_PSTATE_DEF_BASE + index, lo, hi);
 		if (!(hi & HW_PSTATE_VALID_MASK)) {
@@ -858,22 +839,9 @@ static int fill_powernow_table_pstate(st
 			continue;
 		}
=20
=2D		fid =3D lo & HW_PSTATE_FID_MASK;
=2D		did =3D (lo & HW_PSTATE_DID_MASK) >> HW_PSTATE_DID_SHIFT;
+		powernow_table[i].index =3D index;
=20
=2D		dprintk("   %d : fid 0x%x, did 0x%x\n", index, fid, did);
=2D
=2D		powernow_table[i].index =3D index | (fid << HW_FID_INDEX_SHIFT) | (did=
 << HW_DID_INDEX_SHIFT);
=2D
=2D		powernow_table[i].frequency =3D find_khz_freq_from_fiddid(fid, did);
=2D
=2D		if (powernow_table[i].frequency !=3D (data->acpi_data.states[i].core_f=
requency * 1000)) {
=2D			printk(KERN_INFO PFX "invalid freq entries %u kHz vs. %u kHz\n",
=2D				powernow_table[i].frequency,
=2D				(unsigned int) (data->acpi_data.states[i].core_frequency * 1000));
=2D			powernow_table[i].frequency =3D CPUFREQ_ENTRY_INVALID;
=2D			continue;
=2D		}
+		powernow_table[i].frequency =3D data->acpi_data.states[i].core_frequency=
 * 1000;
 	}
 	return 0;
 }
@@ -1014,8 +982,6 @@ static int transition_frequency_fidvid(s
 /* Take a frequency, and issue the hardware pstate transition command */
 static int transition_frequency_pstate(struct powernow_k8_data *data, unsi=
gned int index)
 {
=2D	u32 fid =3D 0;
=2D	u32 did =3D 0;
 	u32 pstate =3D 0;
 	int res, i;
 	struct cpufreq_freqs freqs;
@@ -1024,12 +990,10 @@ static int transition_frequency_pstate(s
=20
 	/* get fid did for hardware pstate transition */
 	pstate =3D index & HW_PSTATE_MASK;
=2D	if (pstate > MAX_HW_PSTATE)
+	if (pstate > data->max_hw_pstate);
 		return 0;
=2D	fid =3D (index & HW_FID_INDEX_MASK) >> HW_FID_INDEX_SHIFT;
=2D	did =3D (index & HW_DID_INDEX_MASK) >> HW_DID_INDEX_SHIFT;
=2D	freqs.old =3D find_khz_freq_from_fiddid(data->currfid, data->currdid);
=2D	freqs.new =3D find_khz_freq_from_fiddid(fid, did);
+	freqs.old =3D find_khz_freq_from_pstate(data->powernow_table, data->currp=
state);
+	freqs.new =3D find_khz_freq_from_pstate(data->powernow_table, pstate);
=20
 	for_each_cpu_mask(i, *(data->available_cores)) {
 		freqs.cpu =3D i;
@@ -1037,9 +1001,7 @@ static int transition_frequency_pstate(s
 	}
=20
 	res =3D transition_pstate(data, pstate);
=2D	data->currfid =3D find_fid_from_pstate(pstate);
=2D	data->currdid =3D find_did_from_pstate(pstate);
=2D	freqs.new =3D find_khz_freq_from_fiddid(data->currfid, data->currdid);
+	freqs.new =3D find_khz_freq_from_pstate(data->powernow_table, pstate);
=20
 	for_each_cpu_mask(i, *(data->available_cores)) {
 		freqs.cpu =3D i;
@@ -1118,7 +1080,7 @@ static int powernowk8_target(struct cpuf
 	mutex_unlock(&fidvid_mutex);
=20
 	if (cpu_family =3D=3D CPU_HW_PSTATE)
=2D		pol->cur =3D find_khz_freq_from_fiddid(data->currfid, data->currdid);
+		pol->cur =3D find_khz_freq_from_pstate(data->powernow_table, newstate);
 	else
 		pol->cur =3D find_khz_freq_from_fid(data->currfid);
 	ret =3D 0;
@@ -1218,7 +1180,7 @@ static int __cpuinit powernowk8_cpu_init
 	    + (3 * (1 << data->irt) * 10)) * 1000;
=20
 	if (cpu_family =3D=3D CPU_HW_PSTATE)
=2D		pol->cur =3D find_khz_freq_from_fiddid(data->currfid, data->currdid);
+		pol->cur =3D find_khz_freq_from_pstate(data->powernow_table, data->currp=
state);
 	else
 		pol->cur =3D find_khz_freq_from_fid(data->currfid);
 	dprintk("policy current frequency %d kHz\n", pol->cur);
@@ -1235,8 +1197,7 @@ static int __cpuinit powernowk8_cpu_init
 	cpufreq_frequency_table_get_attr(data->powernow_table, pol->cpu);
=20
 	if (cpu_family =3D=3D CPU_HW_PSTATE)
=2D		dprintk("cpu_init done, current fid 0x%x, did 0x%x\n",
=2D			data->currfid, data->currdid);
+		dprintk("cpu_init done, current pstate 0x%x\n", data->currpstate);
 	else
 		dprintk("cpu_init done, current fid 0x%x, vid 0x%x\n",
 			data->currfid, data->currvid);
@@ -1292,7 +1253,7 @@ static unsigned int powernowk8_get (unsi
 		goto out;
=20
 	if (cpu_family =3D=3D CPU_HW_PSTATE)
=2D		khz =3D find_khz_freq_from_fiddid(data->currfid, data->currdid);
+		khz =3D find_khz_freq_from_pstate(data->powernow_table, data->currpstate=
);
 	else
 		khz =3D find_khz_freq_from_fid(data->currfid);
=20
diff -urpN -X linux-2.6.22.6-vanilla/Documentation/dontdiff linux-2.6.22.6-=
vanilla/arch/i386/kernel/cpu/cpufreq/powernow-k8.h linux-2.6.22.6/arch/i386=
/kernel/cpu/cpufreq/powernow-k8.h
=2D-- linux-2.6.22.6-vanilla/arch/i386/kernel/cpu/cpufreq/powernow-k8.h	200=
7-08-31 01:21:01.000000000 -0500
+++ linux-2.6.22.6/arch/i386/kernel/cpu/cpufreq/powernow-k8.h	2007-09-07 14=
:14:53.000000000 -0500
@@ -10,6 +10,7 @@ struct powernow_k8_data {
=20
 	u32 numps;  /* number of p-states */
 	u32 batps;  /* number of p-states supported on battery */
+	u32 max_hw_pstate; /* maximum legal hardware pstate */
=20
 	/* these values are constant when the PSB is used to determine
 	 * vid/fid pairings, but are modified during the ->target() call
@@ -21,8 +22,8 @@ struct powernow_k8_data {
 	u32 plllock; /* pll lock time, units 1 us */
         u32 exttype; /* extended interface =3D 1 */
=20
=2D	/* keep track of the current fid / vid or did */
=2D	u32 currvid, currfid, currdid;
+	/* keep track of the current fid / vid or pstate */
+	u32 currvid, currfid, currpstate;
=20
 	/* the powernow_table includes all frequency and vid/fid pairings:
 	 * fid are the lower 8 bits of the index, vid are the upper 8 bits.
@@ -87,23 +88,14 @@ struct powernow_k8_data {
=20
 /* Hardware Pstate _PSS and MSR definitions */
 #define USE_HW_PSTATE		0x00000080
=2D#define HW_PSTATE_FID_MASK 	0x0000003f
=2D#define HW_PSTATE_DID_MASK 	0x000001c0
=2D#define HW_PSTATE_DID_SHIFT 	6
 #define HW_PSTATE_MASK 		0x00000007
 #define HW_PSTATE_VALID_MASK 	0x80000000
=2D#define HW_FID_INDEX_SHIFT	8
=2D#define HW_FID_INDEX_MASK	0x0000ff00
=2D#define HW_DID_INDEX_SHIFT	16
=2D#define HW_DID_INDEX_MASK	0x00ff0000
=2D#define HW_WATTS_MASK		0xff
=2D#define HW_PWR_DVR_MASK		0x300
=2D#define HW_PWR_DVR_SHIFT	8
=2D#define HW_PWR_MAX_MULT		3
=2D#define MAX_HW_PSTATE		8	/* hw pstate supports up to 8 */
+#define HW_PSTATE_MAX_MASK	0x000000f0
+#define HW_PSTATE_MAX_SHIFT	4
 #define MSR_PSTATE_DEF_BASE 	0xc0010064 /* base of Pstate MSRs */
 #define MSR_PSTATE_STATUS 	0xc0010063 /* Pstate Status MSR */
 #define MSR_PSTATE_CTRL 	0xc0010062 /* Pstate control MSR */
+#define MSR_PSTATE_CUR_LIMIT	0xc0010061 /* pstate current limit MSR */
=20
 /* define the two driver architectures */
 #define CPU_OPTERON 0





=2D------------------------------------------------------

--Boundary-00=_eq9CH8zLUV7vAQt
Content-Type: text/plain;
 charset=iso-8859-1;
 name=powernow_architectural_pstate-v2.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=powernow_architectural_pstate-v2.patch

diff -urpN -X linux-2.6.22.6-vanilla/Documentation/dontdiff linux-2.6.22.6-vanilla/arch/i386/kernel/cpu/cpufreq/powernow-k8.c linux-2.6.22.6/arch/i386/kernel/cpu/cpufreq/powernow-k8.c
--- linux-2.6.22.6-vanilla/arch/i386/kernel/cpu/cpufreq/powernow-k8.c	2007-08-31 01:21:01.000000000 -0500
+++ linux-2.6.22.6/arch/i386/kernel/cpu/cpufreq/powernow-k8.c	2007-09-07 14:15:17.000000000 -0500
@@ -46,7 +46,7 @@
 
 #define PFX "powernow-k8: "
 #define BFX PFX "BIOS error: "
-#define VERSION "version 2.00.00"
+#define VERSION "version 2.20.00"
 #include "powernow-k8.h"
 
 /* serialize freq changes  */
@@ -73,29 +73,9 @@ static u32 find_khz_freq_from_fid(u32 fi
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
@@ -139,9 +119,7 @@ static int query_current_values_with_pen
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
@@ -292,7 +270,7 @@ static int decrease_vid_code_by_step(str
 static int transition_pstate(struct powernow_k8_data *data, u32 pstate)
 {
 	wrmsr(MSR_PSTATE_CTRL, pstate, 0);
-	data->currfid = find_fid_from_pstate(pstate);
+	data->currpstate = pstate;
 	return 0;
 }
 
@@ -839,17 +817,20 @@ err_out:
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
@@ -858,22 +839,9 @@ static int fill_powernow_table_pstate(st
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
@@ -1014,8 +982,6 @@ static int transition_frequency_fidvid(s
 /* Take a frequency, and issue the hardware pstate transition command */
 static int transition_frequency_pstate(struct powernow_k8_data *data, unsigned int index)
 {
-	u32 fid = 0;
-	u32 did = 0;
 	u32 pstate = 0;
 	int res, i;
 	struct cpufreq_freqs freqs;
@@ -1024,12 +990,10 @@ static int transition_frequency_pstate(s
 
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
@@ -1037,9 +1001,7 @@ static int transition_frequency_pstate(s
 	}
 
 	res = transition_pstate(data, pstate);
-	data->currfid = find_fid_from_pstate(pstate);
-	data->currdid = find_did_from_pstate(pstate);
-	freqs.new = find_khz_freq_from_fiddid(data->currfid, data->currdid);
+	freqs.new = find_khz_freq_from_pstate(data->powernow_table, pstate);
 
 	for_each_cpu_mask(i, *(data->available_cores)) {
 		freqs.cpu = i;
@@ -1118,7 +1080,7 @@ static int powernowk8_target(struct cpuf
 	mutex_unlock(&fidvid_mutex);
 
 	if (cpu_family == CPU_HW_PSTATE)
-		pol->cur = find_khz_freq_from_fiddid(data->currfid, data->currdid);
+		pol->cur = find_khz_freq_from_pstate(data->powernow_table, newstate);
 	else
 		pol->cur = find_khz_freq_from_fid(data->currfid);
 	ret = 0;
@@ -1218,7 +1180,7 @@ static int __cpuinit powernowk8_cpu_init
 	    + (3 * (1 << data->irt) * 10)) * 1000;
 
 	if (cpu_family == CPU_HW_PSTATE)
-		pol->cur = find_khz_freq_from_fiddid(data->currfid, data->currdid);
+		pol->cur = find_khz_freq_from_pstate(data->powernow_table, data->currpstate);
 	else
 		pol->cur = find_khz_freq_from_fid(data->currfid);
 	dprintk("policy current frequency %d kHz\n", pol->cur);
@@ -1235,8 +1197,7 @@ static int __cpuinit powernowk8_cpu_init
 	cpufreq_frequency_table_get_attr(data->powernow_table, pol->cpu);
 
 	if (cpu_family == CPU_HW_PSTATE)
-		dprintk("cpu_init done, current fid 0x%x, did 0x%x\n",
-			data->currfid, data->currdid);
+		dprintk("cpu_init done, current pstate 0x%x\n", data->currpstate);
 	else
 		dprintk("cpu_init done, current fid 0x%x, vid 0x%x\n",
 			data->currfid, data->currvid);
@@ -1292,7 +1253,7 @@ static unsigned int powernowk8_get (unsi
 		goto out;
 
 	if (cpu_family == CPU_HW_PSTATE)
-		khz = find_khz_freq_from_fiddid(data->currfid, data->currdid);
+		khz = find_khz_freq_from_pstate(data->powernow_table, data->currpstate);
 	else
 		khz = find_khz_freq_from_fid(data->currfid);
 
diff -urpN -X linux-2.6.22.6-vanilla/Documentation/dontdiff linux-2.6.22.6-vanilla/arch/i386/kernel/cpu/cpufreq/powernow-k8.h linux-2.6.22.6/arch/i386/kernel/cpu/cpufreq/powernow-k8.h
--- linux-2.6.22.6-vanilla/arch/i386/kernel/cpu/cpufreq/powernow-k8.h	2007-08-31 01:21:01.000000000 -0500
+++ linux-2.6.22.6/arch/i386/kernel/cpu/cpufreq/powernow-k8.h	2007-09-07 14:14:53.000000000 -0500
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

--Boundary-00=_eq9CH8zLUV7vAQt--


