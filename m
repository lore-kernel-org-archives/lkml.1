Return-Path: <linux-kernel-owner+w=401wt.eu-S933321AbYCFRnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933321AbYCFRnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 12:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbYCFRnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 12:43:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39455 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362AbYCFRne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 12:43:34 -0500
Date: Thu, 6 Mar 2008 18:43:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Miguel Boton <mboton.lkml@gmail.com>
Subject: Re: mach_reboot_fixups()
Message-ID: <20080306174311.GA23029@elte.hu>
References: <47D031CD.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D031CD.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> Ingo,
> 
> was it intentional to remove the call to mach_reboot_fixups() during 
> the merge of reboot_{32,64}.c? If so, it seems odd that 
> reboot_fixups_32.c was left in the tree (and there was even stuff 
> added to it). But it would rather seem that those machines dealt with 
> in that file would not reboot properly anymore (for one of my boxes I 
> added an entry in that table to make it boot properly, which is why I 
> noticed the code not being called anymore)...

good catch Jan! The patch below should fix it.

Can you see any other material difference due to the unification? 
reboot_mode is now written to 0x472 unconditionally, but we can consider 
that a bugfix. Otherwise the mode and ordering of reboot sequences seems 
to be equivalent to me.

	Ingo

------------------->
Subject: x86: re-add reboot fixups
From: Ingo Molnar <mingo@elte.hu>
Date: Thu Mar 06 18:29:43 CET 2008

Jan Beulich noticed that the reboot fixups went missing during
reboot.c unification.

(commit 4d022e35fd7e07c522c7863fee6f07e53cf3fc14)

Geode and a few other rare boards with special reboot quirks are
affected.

Reported-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/reboot.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-x86.q/arch/x86/kernel/reboot.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/reboot.c
+++ linux-x86.q/arch/x86/kernel/reboot.c
@@ -335,6 +335,10 @@ static inline void kb_wait(void)
 	}
 }
 
+void __attribute__((weak)) mach_reboot_fixups(void)
+{
+}
+
 void native_machine_emergency_restart(void)
 {
 	int i;
@@ -342,6 +346,8 @@ void native_machine_emergency_restart(vo
 	/* Tell the BIOS if we want cold or warm reboot */
 	*((unsigned short *)__va(0x472)) = reboot_mode;
 
+	mach_reboot_fixups(); /* for board specific fixups */
+
 	for (;;) {
 		/* Could also try the reset bit in the Hammer NB */
 		switch (reboot_type) {
