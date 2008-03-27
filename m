Return-Path: <linux-kernel-owner+w=401wt.eu-S1758420AbYC0PWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420AbYC0PWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 11:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbYC0PWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 11:22:18 -0400
Received: from www.tglx.de ([62.245.132.106]:35036 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754534AbYC0PWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 11:22:17 -0400
Date: Thu, 27 Mar 2008 16:20:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Markus Rehbach <markus.rehbach@gmx.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc6: BUG: unable to handle kernel NULL pointer
 dereference
In-Reply-To: <20080325233357.17d6ac41.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0803271615470.3781@apollo.tec.linutronix.de>
References: <alpine.DEB.1.00.0803252358340.22105@sheep.housecafe.de> <20080325233357.17d6ac41.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008, Andrew Morton wrote:
> > Code: 53 c0 e8 20 08 fc ff c1 e3 02 8b 14 33 89 54 24 20 8b 44 24 20 85 c0 75 10 eb 51 8b 12 89 54 24 20 8b 44 24 20 85 c0 74 43 8b 02 <0f> 18 00 90 8d 5a d8 39 6b 34 75 e4 8b 7c 24 0c 39 7b 30 75 db 

It faults in a prefetch.

> Markus reported what looks to be the same thing here:
> http://lkml.org/lkml/2008/3/21/202 and it's already in the regresison list.

Same here. And both are AMD X2 early stepping machines.
 
> I guess you've confirmed that this wasn't a mystery
> once-off-on-that-machine.
> 
> I can't think what we did to cause this.

I had a lengthy bug decoding session with Ingo and we found the root
cause:

A dropped workaround for the prefetch bug in early X2s and
Opterons. Patch below.

Thanks,

	tglx

--------------->
Subject: x86: fix prefetch workaround
From: Ingo Molnar <mingo@elte.hu>
Date: Thu Mar 27 15:58:28 CET 2008

some early Athlon XP's and Opterons generate bogus faults on prefetch
instructions. The workaround for this regressed over .24 - reinstate it.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/mm/fault.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-x86.q/arch/x86/mm/fault.c
===================================================================
--- linux-x86.q.orig/arch/x86/mm/fault.c
+++ linux-x86.q/arch/x86/mm/fault.c
@@ -104,7 +104,8 @@ static int is_prefetch(struct pt_regs *r
 	unsigned char *max_instr;
 
 #ifdef CONFIG_X86_32
-	if (!(__supported_pte_mask & _PAGE_NX))
+	/* Catch an obscure case of prefetch inside an NX page: */
+	if ((__supported_pte_mask & _PAGE_NX) && (error_code & 16))
 		return 0;
 #endif
 


