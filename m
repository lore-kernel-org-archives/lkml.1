Return-Path: <linux-kernel-owner+w=401wt.eu-S1759432AbYA3V1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432AbYA3V1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbYA3V04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:26:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54339 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbYA3V0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:26:54 -0500
Date: Wed, 30 Jan 2008 22:25:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Olof Johansson <olof@lixom.net>, Paul Mackerras <paulus@samba.org>,
       anton@samba.org, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, sparclinux@vger.kernel.org,
       linux-ia64@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [powerpc changes] Re: x86/non-x86: percpu, node ids, apic ids
	x86.git fixup
Message-ID: <20080130212558.GA12409@elte.hu>
References: <200801301414.m0UEEgCC006371@hera.kernel.org> <Pine.LNX.4.64.0801301622460.11859@vixen.sonytel.be> <47A09F8A.3000309@sgi.com> <20080130161036.GA12293@elte.hu> <1FE6DD409037234FAB833C420AA843EC757C72@orsmsx424.amr.corp.intel.com> <20080130180623.GA24881@elte.hu> <1FE6DD409037234FAB833C420AA843EC757DEA@orsmsx424.amr.corp.intel.com> <20080130184920.GA32212@elte.hu> <20080130191302.GA20008@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130191302.GA20008@lixom.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Olof Johansson <olof@lixom.net> wrote:

> > could you try the full patchset that Travis has just sent and which 
> > i've put into x86.git, you can pull it from:
> 
> Looks ok for powerpc so far, I haven't gotten through all defconfigs 
> yet but the first ones that failed before build now. pasemi_defconfig 
> boots as well.

could the PowerPC maintainers please Ack the following patch (attached 
below):

  Subject: POWERPC: use generic per cpu
  From: travis@sgi.com

so that we can push this fix upstream ASAP?

	Ingo

--------------->
Subject: POWERPC: use generic per cpu
From: travis@sgi.com

Powerpc has a way to determine the address of the per cpu area of the
currently executing processor via the paca and the array of per cpu
offsets is avoided by looking up the per cpu area from the remote
paca's (copying x86_64).

Cc: Paul Mackerras <paulus@samba.org>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-powerpc/percpu.h |   22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

Index: linux-x86.q/include/asm-powerpc/percpu.h
===================================================================
--- linux-x86.q.orig/include/asm-powerpc/percpu.h
+++ linux-x86.q/include/asm-powerpc/percpu.h
@@ -13,28 +13,12 @@
 #include <asm/paca.h>
 
 #define __per_cpu_offset(cpu) (paca[cpu].data_offset)
-#define __my_cpu_offset() get_paca()->data_offset
+#define __my_cpu_offset get_paca()->data_offset
 #define per_cpu_offset(x) (__per_cpu_offset(x))
 
-/* var is in discarded region: offset to particular copy we want */
-#define per_cpu(var, cpu) (*RELOC_HIDE(&per_cpu__##var, __per_cpu_offset(cpu)))
-#define __get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __my_cpu_offset()))
-#define __raw_get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, local_paca->data_offset))
+#endif /* CONFIG_SMP */
+#endif /* __powerpc64__ */
 
-extern void setup_per_cpu_areas(void);
-
-#else /* ! SMP */
-
-#define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu__##var))
-#define __get_cpu_var(var)			per_cpu__##var
-#define __raw_get_cpu_var(var)			per_cpu__##var
-
-#endif	/* SMP */
-
-#define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
-
-#else
 #include <asm-generic/percpu.h>
-#endif
 
 #endif /* _ASM_POWERPC_PERCPU_H_ */
