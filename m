Return-Path: <linux-kernel-owner+w=401wt.eu-S1754332AbZIOOWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbZIOOWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 10:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbZIOOWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 10:22:48 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:37387 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbZIOOWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 10:22:47 -0400
X-SpamScore: -5
X-BigFish: VPS-5(zz98dNzz1202hzzz32i6bh203h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KQ0NXQ-02-6VT-02
X-M-MSG: 
Date: Tue, 15 Sep 2009 16:22:33 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Tejun Heo <tj@kernel.org>
CC: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yinghai@kernel.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [Patch] x86: export cpu_llc_id for edac drivers
Message-ID: <20090915142233.GA21670@alberich.amd.com>
References: <20090915082005.4701.86110.sendpatchset@localhost.localdomain>
 <4AAF4F6A.5070901@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4AAF4F6A.5070901@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 15 Sep 2009 14:22:33.0794 (UTC) FILETIME=[F77B4220:01CA360F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 05:25:14PM +0900, Tejun Heo wrote:
> Heh.. was about to send out the same patch.

Maybe a better fix would be to provide a wrapper for this.
See attached patch.

Regards,
Andreas

---
x86, edac: Provide function to return NodeId for CPU

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index e08ea04..42a3f93 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -1020,4 +1020,6 @@ extern void start_thread(struct pt_regs *regs, unsigned long new_ip,
 extern int get_tsc_mode(unsigned long adr);
 extern int set_tsc_mode(unsigned int val);
 
+extern int amd_get_nb_id(int cpu);
+
 #endif /* _ASM_X86_PROCESSOR_H */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 22a47c8..f32fa71 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -333,6 +333,16 @@ static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 #endif
 }
 
+int amd_get_nb_id(int cpu)
+{
+	int id = 0;
+#ifdef CONFIG_SMP
+	id = per_cpu(cpu_llc_id, cpu);
+#endif
+	return id;
+}
+EXPORT_SYMBOL_GPL(amd_get_nb_id);
+
 static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 {
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index c8ca713..0c21c37 100644
--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -405,7 +405,7 @@ void decode_mce(struct mce *m)
 		regs.nbsh  = (u32)(m->status >> 32);
 		regs.nbeal = (u32) m->addr;
 		regs.nbeah = (u32)(m->addr >> 32);
-		node       = per_cpu(cpu_llc_id, m->extcpu);
+		node       = amd_get_nb_id(m->extcpu);
 
 		amd_decode_nb_mce(node, &regs, 1);
 		break;


