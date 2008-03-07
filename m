Return-Path: <linux-kernel-owner+w=401wt.eu-S1760553AbYCGH6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760553AbYCGH6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 02:58:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756143AbYCGH61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 02:58:27 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:5726
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756003AbYCGH60 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 02:58:26 -0500
Message-Id: <47D103D0.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 Beta 
Date: Fri, 07 Mar 2008 07:58:56 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Miguel Boton" <mboton.lkml@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: mach_reboot_fixups()
References: <47D031CD.76E4.0078.0@novell.com>
 <20080306174311.GA23029@elte.hu>
In-Reply-To: <20080306174311.GA23029@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 06.03.08 18:43 >>>
>
>* Jan Beulich <jbeulich@novell.com> wrote:
>
>> Ingo,
>> 
>> was it intentional to remove the call to mach_reboot_fixups() during 
>> the merge of reboot_{32,64}.c? If so, it seems odd that 
>> reboot_fixups_32.c was left in the tree (and there was even stuff 
>> added to it). But it would rather seem that those machines dealt with 
>> in that file would not reboot properly anymore (for one of my boxes I 
>> added an entry in that table to make it boot properly, which is why I 
>> noticed the code not being called anymore)...
>
>good catch Jan! The patch below should fix it.
>
>Can you see any other material difference due to the unification? 
>reboot_mode is now written to 0x472 unconditionally, but we can consider 
>that a bugfix. Otherwise the mode and ordering of reboot sequences seems 
>to be equivalent to me.

Not exactly - when rebooting through EFI or BIOS, the old code didn't
go through mach_reboot_fixups(), and I think that is the correct
behavior (albeit, when the EFI path fell back to the triple fault
mechanism, it should have honored the fixup logic, and I think it is
more correct that the new code tries the keyboard method first).
Perhaps the most reasonable way to go is to honor all reboot=
settings without using the override code first:

--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -329,6 +329,10 @@ static inline void kb_wait(void)
 	}
 }
 
+void __attribute__((weak)) mach_reboot_fixups(void)
+{
+}
+
 static void native_machine_emergency_restart(void)
 {
 	int i;
@@ -337,9 +341,11 @@ static void native_machine_emergency_res
 	*((unsigned short *)__va(0x472)) = reboot_mode;
 
 	for (;;) {
+
 		/* Could also try the reset bit in the Hammer NB */
 		switch (reboot_type) {
 		case BOOT_KBD:
+			mach_reboot_fixups(); /* for board specific fixups */
 			for (i = 0; i < 10; i++) {
 				kb_wait();
 				udelay(50);

(with the exception that reboot=keyboard will still have the effect
of honoring the fixups, but I think this is better than further
complicating the logic).

In case you want to take this,
Signed-off-by: Jan Beulich <jbeulich@novell.com>

Jan

