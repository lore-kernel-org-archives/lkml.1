Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbYBYJSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbYBYJSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 04:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbYBYJSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 04:18:30 -0500
Received: from aun.it.uu.se ([130.238.12.36]:43657 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbYBYJS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 04:18:29 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18370.34734.3562.258384@harpo.it.uu.se>
Date: Mon, 25 Feb 2008 10:17:33 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Mikael Pettersson <mikpe@it.uu.se>,
       linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de
Subject: Re: [BUG] 2.6.25-rc2-git8 fails to boot on 486 due to TSC breakage
In-Reply-To: <20080225082634.GB12715@elte.hu>
References: <200802241107.m1OB7bHb022801@harpo.it.uu.se>
	<20080224135720.GA5323@elte.hu>
	<18369.35401.678391.183329@harpo.it.uu.se>
	<18369.43239.964660.62249@harpo.it.uu.se>
	<47C21284.7040607@zytor.com>
	<20080225082634.GB12715@elte.hu>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:
 > 
 > * H. Peter Anvin <hpa@zytor.com> wrote:
 > 
 > > Please fix it in both places.  Using XOR instead of AND-NOT is a bug, 
 > > plain and simple.
 > 
 > yes, i already fixed that when i added Mikael's patch and it's all 
 > queued up.

Ok. For reference and for LKML viewers, this is what
the final patch should be:

diff -rupN linux-2.6.25-rc3/arch/x86/kernel/cpu/common.c linux-2.6.25-rc3.x86-apply-cleared_cpu_caps-correctly/arch/x86/kernel/cpu/common.c
--- linux-2.6.25-rc3/arch/x86/kernel/cpu/common.c	2008-02-25 09:29:03.000000000 +0100
+++ linux-2.6.25-rc3.x86-apply-cleared_cpu_caps-correctly/arch/x86/kernel/cpu/common.c	2008-02-25 09:44:11.000000000 +0100
@@ -504,7 +504,7 @@ void __cpuinit identify_cpu(struct cpuin
 
 	/* Clear all flags overriden by options */
 	for (i = 0; i < NCAPINTS; i++)
-		c->x86_capability[i] ^= cleared_cpu_caps[i];
+		c->x86_capability[i] &= ~cleared_cpu_caps[i];
 
 	/* Init Machine Check Exception if available. */
 	mcheck_init(c);
diff -rupN linux-2.6.25-rc3/arch/x86/kernel/setup_64.c linux-2.6.25-rc3.x86-apply-cleared_cpu_caps-correctly/arch/x86/kernel/setup_64.c
--- linux-2.6.25-rc3/arch/x86/kernel/setup_64.c	2008-02-25 09:29:03.000000000 +0100
+++ linux-2.6.25-rc3.x86-apply-cleared_cpu_caps-correctly/arch/x86/kernel/setup_64.c	2008-02-25 09:44:57.000000000 +0100
@@ -1021,7 +1021,7 @@ void __cpuinit identify_cpu(struct cpuin
 
 	/* Clear all flags overriden by options */
 	for (i = 0; i < NCAPINTS; i++)
-		c->x86_capability[i] ^= cleared_cpu_caps[i];
+		c->x86_capability[i] &= ~cleared_cpu_caps[i];
 
 #ifdef CONFIG_X86_MCE
 	mcheck_init(c);
