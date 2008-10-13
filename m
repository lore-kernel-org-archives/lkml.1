Return-Path: <linux-kernel-owner+w=401wt.eu-S1760446AbYJMSgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760446AbYJMSgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 14:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759231AbYJMSgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 14:36:23 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:32342 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758823AbYJMSgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 14:36:21 -0400
X-BigFish: VPS-50(z5edJz62a3L1432R98dR936eQ4015M1805M936fO12b6izzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K8OX03-01-NGZ-01
Date: Mon, 13 Oct 2008 20:35:56 +0200
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Please pull arch perfmon update
Message-ID: <20081013183556.GD23557@erda.amd.com>
References: <20080929235253.GA31074@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080929235253.GA31074@one.firstfloor.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 13 Oct 2008 18:36:09.0736 (UTC) FILETIME=[8FAE0080:01C92D62]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.09.08 01:52:53, Andi Kleen wrote:
> Robert,
> 
> Here are the arch perfmon changes ported to your latest oprofile tree.
> I didn't include the forcepmu=... change yet, that will come later.
> Right now the force option is just removed. Please pull.
> 
> Thanks,
> -Andi
> 
> The following changes since commit 22d87103484983035cf46891428819573ec7508d:
>   Robert Richter (1):
>         Merge branch 'oprofile/powerpc-for-paul' into oprofile/master
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc-2.6.git arch-perfmon2
> 
> Andi Kleen (4):
>       oprofile: drop const in num counters field
>       oprofile: Don't report Nehalem as core_2
>       oprofile: Implement Intel architectural perfmon support
>       oprofile: discover counters for op ppro too

Thanks Andi,

I applied your patches to the x86-oprofile-for-tip branch of
git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git

I added a follow on patch (446223f) on branch arch-perfmon that
changes the initialization so that it uses the init function in
op_x86_model_spec (see below). Please give it a try, it is compile
tested only. If it works for you, I will add it to the tip branch too.

There is one question to patch "oprofile: discover counters for op
ppro too". arch_perfmon_setup_counters() is actually never called for
ppro, so there is no code that changes the numbers in
op_ppro_spec. The patch as it is has no effect (except then loading
additional module code).

Thanks,

-Robert

commit 446223f8d1454e647b54160584c5dec8f83fdddc
Author: Robert Richter <robert.richter@amd.com>
Date:   Sun Oct 12 15:12:34 2008 -0400

    x86/oprofile: moving arch perfmon counter setup to op_x86_model_spec.init
    
    Cc: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Robert Richter <robert.richter@amd.com>

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 12d6f85..fd902b8 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -435,7 +435,6 @@ static int __init arch_perfmon_init(char **cpu_type)
                return 0;
        *cpu_type = "i386/arch_perfmon";
        model = &op_arch_perfmon_spec;
-       arch_perfmon_setup_counters();
        return 1;
 }
 
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index f5a2268..3266795 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -220,7 +220,7 @@ struct op_x86_model_spec op_ppro_spec = {
  * the specific CPU.
  */
 
-void arch_perfmon_setup_counters(void)
+static int arch_perfmon_setup_counters(struct oprofile_operations *ignore)
 {
        union cpuid10_eax eax;
 
@@ -240,9 +240,12 @@ void arch_perfmon_setup_counters(void)
        op_arch_perfmon_spec.num_controls = num_counters;
        op_ppro_spec.num_counters = num_counters;
        op_ppro_spec.num_controls = num_counters;
+
+       return 0;
 }
 
 struct op_x86_model_spec op_arch_perfmon_spec = {
+       .init = &arch_perfmon_setup_counters,
        /* num_counters/num_controls filled in at runtime */
        .fill_in_addresses = &ppro_fill_in_addresses,
        /* user space does the cpuid check for available events */
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index 596de7a..418c2d0 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -51,6 +51,4 @@ extern struct op_x86_model_spec const op_p4_ht2_spec;
 extern struct op_x86_model_spec const op_amd_spec;
 extern struct op_x86_model_spec op_arch_perfmon_spec;
 
-extern void arch_perfmon_setup_counters(void);
-
 #endif /* OP_X86_MODEL_H */


-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

