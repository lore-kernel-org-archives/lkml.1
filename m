Return-Path: <linux-kernel-owner+w=401wt.eu-S1754927AbYICRe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbYICRe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755535AbYICReU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:34:20 -0400
Received: from ns1.suse.de ([195.135.220.2]:50455 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001AbYICReQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:34:16 -0400
Date: Wed, 3 Sep 2008 10:25:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@elte.hu>
Subject: [patch 08/42] x86: fix "kernel wont boot on a Cyrix MediaGXm
	(Geode)"
Message-ID: <20080903172531.GI7731@suse.de>
References: <20080903171927.534216229@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-fix-kernel-won-t-boot-on-a-cyrix-mediagxm.patch"
In-Reply-To: <20080903172447.GA7731@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Samuel Sieb <samuel@sieb.net>

commit c6744955d0ec0cb485c28c51eeb7185e260f6172 upstream

Cyrix MediaGXm/Cx5530 Unicorn Revision 1.19.3B has stopped
booting starting at v2.6.22.

The reason is this commit:

> commit f25f64ed5bd3c2932493681bdfdb483ea707da0a
> Author: Juergen Beisert <juergen@kreuzholzen.de>
> Date:   Sun Jul 22 11:12:38 2007 +0200
>
>     x86: Replace NSC/Cyrix specific chipset access macros by inlined functions.

this commit activated a macro which was dormant before due to (buggy)
macro side-effects.

I've looked through various datasheets and found that the GXm and GXLV
Geode processors don't have an incrementor.

Remove the incrementor setup entirely.  As the incrementor value
differs according to clock speed and we would hope that the BIOS
configures it correctly, it is probably the right solution.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/cyrix.c |   18 ------------------
 1 file changed, 18 deletions(-)

--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -134,23 +134,6 @@ static void __cpuinit set_cx86_memwb(voi
 	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x14);
 }
 
-static void __cpuinit set_cx86_inc(void)
-{
-	unsigned char ccr3;
-
-	printk(KERN_INFO "Enable Incrementor on Cyrix/NSC processor.\n");
-
-	ccr3 = getCx86(CX86_CCR3);
-	setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10); /* enable MAPEN */
-	/* PCR1 -- Performance Control */
-	/* Incrementor on, whatever that is */
-	setCx86(CX86_PCR1, getCx86(CX86_PCR1) | 0x02);
-	/* PCR0 -- Performance Control */
-	/* Incrementor Margin 10 */
-	setCx86(CX86_PCR0, getCx86(CX86_PCR0) | 0x04);
-	setCx86(CX86_CCR3, ccr3);	/* disable MAPEN */
-}
-
 /*
  *	Configure later MediaGX and/or Geode processor.
  */
@@ -174,7 +157,6 @@ static void __cpuinit geode_configure(vo
 
 	set_cx86_memwb();
 	set_cx86_reorder();
-	set_cx86_inc();
 
 	local_irq_restore(flags);
 }

-- 
