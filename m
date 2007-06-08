Return-Path: <linux-kernel-owner+w=401wt.eu-S1760893AbXFHGCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760893AbXFHGCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 02:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbXFHGCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 02:02:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:54850 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751725AbXFHGCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 02:02:46 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX18pr2kTs38pL81+UH3RLp8o0or0E5oSxTxMBJqSL+
	CSELujje0Mmmfj
Date: Fri, 8 Jun 2007 08:02:44 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ak@suse.de
Subject: [PATCH] Fix interchanged parameters to release_{evntsel,perfctr}_nmi
Message-ID: <20070608060244.GA2369@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	"Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
	Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	ak@suse.de
References: <465C2225.2000100@googlemail.com> <20070603150246.5151dda6@laptop.hypervisor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070603150246.5151dda6@laptop.hypervisor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.03 15:02:46 +0200, Udo A. Steinberg wrote:
> On Tue, 29 May 2007 14:52:53 +0200 Michal Piotrowski (MP) wrote:
> 
> MP> Here is a list of some known regressions in 2.6.22-rc3.
> MP> 
> MP> Feel free to add new regressions/remove fixed etc.
> MP> http://kernelnewbies.org/known_regressions
> 
> Here's another 2.6.22-rc3 regression. It was ok on 2.6.21. I believe it
> triggered during: echo 0 > /proc/sys/kernel/nmi_watchdog
> 
> 
> ------------[ cut here ]------------
> kernel BUG at arch/i386/kernel/cpu/perfctr-watchdog.c:126!
> invalid opcode: 0000 [#1]
> PREEMPT 
> Modules linked in:
> CPU:    0
> EIP:    0060:[<c010cae5>]    Not tainted VLI
> EFLAGS: 00010286   (2.6.22-rc3 #2)
> EIP is at release_evntsel_nmi+0x16/0x22
> eax: 000000c1   ebx: 080f7408   ecx: c04296e0   edx: ffffff3b
> esi: 00000001   edi: f69d4240   ebp: 00000002   esp: f6962f30
> ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
> Process rc.M (pid: 1281, ti=f6962000 task=f706c030 task.ti=f6962000)
> Stack: c010cb60 c010cda3 c0110abe 080f7408 f6962f64 f6962fa0 c042ab68 ffffffff 
>        c01853a8 080f7408 f6962f64 f6962fa0 080f7408 00000002 c042a774 f69d4240 
>        080f7408 c0185339 00000002 c0156d33 f6962fa0 f7fcccb4 f69d4240 fffffff7 
> Call Trace:
>  [<c010cb60>] single_msr_unreserve+0xd/0x1a
>  [<c010cda3>] disable_lapic_nmi_watchdog+0x2b/0x39
>  [<c0110abe>] proc_nmi_enabled+0xa0/0xbd
>  [<c01853a8>] proc_sys_write+0x6f/0x8c
>  [<c0185339>] proc_sys_write+0x0/0x8c
>  [<c0156d33>] vfs_write+0x8a/0x10c
>  [<c01571ef>] sys_write+0x41/0x67
>  [<c0103c30>] syscall_call+0x7/0xb
>  =======================
> Code: 00 c7 04 24 f6 5d 3c c0 e8 7d e0 00 00 83 ca ff 89 d0 5a 59 c3 8b 0d 28
> 6e 48 c0 31 d2 85 c9 74 0e 89 c2 2b 51 18 83 fa 42 76 04 <0f> 0b eb fe 0f b3 15
> 38 6e 48 c0 c3 8b 0d 28 6e 48 c0 31 d2 85 EIP: [<c010cae5>]
> release_evntsel_nmi+0x16/0x22 SS:ESP 0068:f6962f30

The culprit seems to be 09198e68501a7e34737cd9264d266f42429abcdc:
[PATCH] i386: Clean up NMI watchdog code

In two places, the parameters to release_{evntsel,perfctr}_nmi
got interchanged during the cleanup. Unfortunately, the NMI watchdog
doesn't want to be enabled on my T43 at all (or I just have no idea what
magic is required to make it happy), so this patch untested. Could you
give it a spin?

Thanks,
Björn


From: Björn Steinbrink <B.Steinbrink@gmx.de>

Fix interchanged parameters to release_{evntsel,perfctr}_nmi.

Signed-off-by: Björn Steinbrink <B.Steinbrink@gmx.de>
---
diff --git a/arch/i386/kernel/cpu/perfctr-watchdog.c b/arch/i386/kernel/cpu/perfctr-watchdog.c
index 2b04c8f..e490ac2 100644
--- a/arch/i386/kernel/cpu/perfctr-watchdog.c
+++ b/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -276,8 +276,8 @@ static int single_msr_reserve(void)
 
 static void single_msr_unreserve(void)
 {
-	release_evntsel_nmi(wd_ops->perfctr);
-	release_perfctr_nmi(wd_ops->evntsel);
+	release_evntsel_nmi(wd_ops->evntsel);
+	release_perfctr_nmi(wd_ops->perfctr);
 }
 
 static void single_msr_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
@@ -475,10 +475,10 @@ static void p4_unreserve(void)
 {
 #ifdef CONFIG_SMP
 	if (smp_num_siblings > 1)
-		release_evntsel_nmi(MSR_P4_IQ_PERFCTR1);
+		release_perfctr_nmi(MSR_P4_IQ_PERFCTR1);
 #endif
-	release_evntsel_nmi(MSR_P4_IQ_PERFCTR0);
-	release_perfctr_nmi(MSR_P4_CRU_ESCR0);
+	release_evntsel_nmi(MSR_P4_CRU_ESCR0);
+	release_perfctr_nmi(MSR_P4_IQ_PERFCTR0);
 }
 
 static void p4_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
