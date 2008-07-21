Return-Path: <linux-kernel-owner+w=401wt.eu-S1759011AbYGULsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759011AbYGULsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 07:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbYGULsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 07:48:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32922 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862AbYGULsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 07:48:06 -0400
Date: Mon, 21 Jul 2008 13:47:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael C. de Almeida" <almeidaraf@gmail.com>
Cc: Samuel Sieb <samuel@sieb.net>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: kernel won't boot on a Cyrix MediaGXm (Geode )
Message-ID: <20080721114752.GE23095@elte.hu>
References: <48841A92.4020301@sieb.net> <48842E71.9070503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48842E71.9070503@gmail.com>
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


* Rafael C. de Almeida <almeidaraf@gmail.com> wrote:

> Samuel Sieb wrote:
> > I have a computer here with a CPU that the BIOS identifies as:
> > Cyrix MediaGXm/Cx5530 Unicorn Revision 1.19.3B
> > 
> > kernel 2.6.14 identifies it as:
> > vendor_id    : Geode by NSC
> > cpu family    : 5
> > model        : 9
> > model name    : Geode(TM) Integrated Processor by National Semi
> > stepping    : 1
> > 
> > I can't boot any kernel later than 2.6.22 on it.  Anything later either
> > hangs or gives random kernel panics while booting.  I tracked down the
> > problem to a specific commit:
> > 
> > commit f25f64ed5bd3c2932493681bdfdb483ea707da0a
> > Author: Juergen Beisert <juergen@kreuzholzen.de>
> > Date:   Sun Jul 22 11:12:38 2007 +0200
> > 
> >     x86: Replace NSC/Cyrix specific chipset access macros by inlined
> > functions.
> > 
> > Reversing the patch (compensating for kernel changes) let me boot a
> > 2.6.25 kernel.  I realize the patch is supposed to fix something that
> > didn't work right, but I didn't have a problem before and I do now. :-)

does the debug patch below (ontop of v2.6.26 or later kernels) make the 
system bootable again? Commit f25f64ed5 changed the meaning of that 
line. This patch switches back to the old behavior (which essentially 
did nothing, due to macro side-effect bugs).

(if this makes a difference we can figure out a proper way for a DMI or 
CPU ID based quirk or something like that.)

	Ingo

------------------>
commit d92d27891c37c58830e58e3277f1918465ceaee9
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Jul 21 13:45:19 2008 +0200

    debug patch
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/cyrix.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index 3fd7a67..85700c3 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -162,7 +162,7 @@ static void __cpuinit geode_configure(void)
 	local_irq_save(flags);
 
 	/* Suspend on halt power saving and enable #SUSP pin */
-	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
+	/* setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88); */
 
 	ccr3 = getCx86(CX86_CCR3);
 	setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10);	/* enable MAPEN */

