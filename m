Return-Path: <linux-kernel-owner+w=401wt.eu-S933263AbYCDS7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263AbYCDS7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 13:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760787AbYCDS7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 13:59:30 -0500
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:12467 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759867AbYCDS73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 13:59:29 -0500
Date: Tue, 4 Mar 2008 19:57:42 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       Mark McLoughlin <markmc@redhat.com>, Ian Campbell <ijc@hellion.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] reserve end-of-conventional-memory to 1MB, 32-bit, use paravirt_enabled
Message-ID: <20080304185742.GA12193@mailshack.com>
References: <1204232996.28798.8.camel@cthulhu.hellion.org.uk> <20080229114943.GA1909@mailshack.com> <1204305247.2037.2.camel@muff> <1204310323.24514.1239870063@webmail.messagingengine.com> <1204322819.6299.1.camel@muff> <20080301160911.GA13271@mailshack.com> <1204631082.16613.7.camel@muff> <47CD6858.9070603@goop.org> <1204649476.5048.1240509149@webmail.messagingengine.com> <47CD82C5.8060605@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CD82C5.8060605@goop.org>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Tue, 04 Mar 2008 19:58:27 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.73; VDF: 7.0.2.231; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge pointed out that looking at the boot_params
struct to determine if the system is running in a paravirtual
environment is not reliable for the Xen case, currently. He also
points out that there already exists a function to determine if
the system is running in a paravirtual environment. So let's use
that instead. This gets rid of the preprocessor test too.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---

On Tue, Mar 04, 2008 at 09:11:33AM -0800, Jeremy Fitzhardinge wrote:
> Alexander van Heukelum wrote:
> >On Tue, 04 Mar 2008 07:18:48 -0800, "Jeremy Fitzhardinge"
> ><jeremy@goop.org> said:
> >>Yes, is_paravirt() already exists for this purpose.
> >
> >Hi,
> >
> >If it exists, it is well-hidden. A grep for is_paravirt on the testing
> >tree turns up nothing. Did you get the name right?
> >  
> 
> Nope.  paravirt_enabled().

Duh, I should have been able to find that :-/. Thanks for the pointer.

> Just because something is paravirtualized and uses a non-PC 
> hardware_subarch doesn't mean this stuff isn't present.  Even the 
> paravirt_enabled() test isn't accurate, because the environment may 
> still choose to emulate these things (or in the Xen dom0 case, it may 
> directly expose the real hardware).

paravirt_enabled() returns 0 if CONFIG_PARAVIRT is not set, or if a
paravirt-enabled kernel is run on bare hardware: dom0. If that is right,
then it is exactly what is needed.

Greetings,
	Alexander

diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index 20e537b..f595d7b 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -64,6 +64,7 @@
 #include <setup_arch.h>
 #include <bios_ebda.h>
 #include <asm/cacheflush.h>
+#include <asm/processor.h>
 
 /* This value is set up by the early boot code to point to the value
    immediately after the boot time page tables.  It contains a *physical*
@@ -408,12 +409,8 @@ static void __init reserve_ebda_region(void)
 	/* that area is absent. We'll just have to assume */
 	/* that the paravirt case can handle memory setup */
 	/* correctly, without our help. */
-#ifdef CONFIG_PARAVIRT
-	if ((boot_params.hdr.version >= 0x207) &&
-			(boot_params.hdr.hardware_subarch != 0)) {
+	if (paravirt_enabled())
 		return;
-	}
-#endif
 
 	/* end of low (conventional) memory */
 	lowmem = *(unsigned short *)__va(BIOS_LOWMEM_KILOBYTES);

