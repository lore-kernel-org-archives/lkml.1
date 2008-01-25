Return-Path: <linux-kernel-owner+w=401wt.eu-S1758212AbYAYWFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbYAYWFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 17:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYAYWFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 17:05:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51495 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbYAYWFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 17:05:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native format.
Date: Fri, 25 Jan 2008 23:02:50 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ian Campbell <ijc@hellion.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Mika =?iso-8859-1?q?Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <1201167544.30671.64.camel@cthulhu.hellion.org.uk> <47992D0E.2070700@zytor.com> <20080125074910.GD4134@ucw.cz>
In-Reply-To: <20080125074910.GD4134@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801252302.52164.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 25 of January 2008, Pavel Machek wrote:
> On Thu 2008-01-24 16:27:58, H. Peter Anvin wrote:
> > Pavel Machek wrote:
> > >>>
> > >>I just looked at the ACPI suspend code, and it looks 
> > >>like it hacks its own identity map at runtime.  Pavel, 
> > >>am I reading that code right?
> > >
> > >Yes, I think so, I believe we do it on both 32 and 64 
> > >bit now.
> > >
> > 
> > So the background to this... we need an identity map to 
> > trampoline at early boot, obviously, but we'd like it to 
> > not stick around more than necessary.  We have 
> > zap_low_mappings() now but it's not really sufficient.
> > 
> > Secondary SMP processors need these mappings during 
> > trampolining -- presumably including CPU hotplug -- and 
> > I'm suspecting it might simply make sense to use a 
> > separate set of page tables (with both the identity and 
> > the kernel map) for trampolining and just keep them 
> > around.  That way they would be usable for ACPI as well.
> 
> That would enable some cleanups, yes.

Speaking of cleanups, the following one is applicable IMO.

Greetings,
Rafael

---
 arch/x86/mm/init_32.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c
+++ linux-2.6/arch/x86/mm/init_32.c
@@ -444,23 +444,23 @@ static void __init pagetable_init (void)
 	paravirt_pagetable_setup_done(pgd_base);
 }
 
-#if defined(CONFIG_HIBERNATION) || defined(CONFIG_ACPI)
+#ifdef CONFIG_SUSPEND
 /*
  * Swap suspend & friends need this for resume because things like the intel-agp
  * driver might have split up a kernel 4MB mapping.
  */
-char __nosavedata swsusp_pg_dir[PAGE_SIZE]
+char swsusp_pg_dir[PAGE_SIZE]
 	__attribute__ ((aligned (PAGE_SIZE)));
 
 static inline void save_pg_dir(void)
 {
 	memcpy(swsusp_pg_dir, swapper_pg_dir, PAGE_SIZE);
 }
-#else
+#else /* !CONFIG_SUSPEND */
 static inline void save_pg_dir(void)
 {
 }
-#endif
+#endif /* !CONFIG_SUSPEND */
 
 void zap_low_mappings (void)
 {
