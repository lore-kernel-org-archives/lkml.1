Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbXLHLeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbXLHLeX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 06:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbXLHLeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 06:34:15 -0500
Received: from smtp110.plus.mail.re1.yahoo.com ([69.147.102.73]:35076 "HELO
	smtp110.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752098AbXLHLeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 06:34:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=qLXNmThn7hxKL+MjnzL+71NgdJO2H6n8wcxtOPme4irPa5w2OwSk1TU4LEov3FzXz8bDz/+MjD9b3YrchDmKudctmH6MBjuZyEe+taO2rWxF17xWN1sSa14n86/1ddlqUaWZAsf8vNq5s37eUyeVkXp93Um5uULfAyGv4uMAtTk=  ;
X-YMail-OSG: NLCttNIVM1l5qxcVNe27v0qx_IrBAsVPRFWFGLt5gpDQWWVQmsVYFnjU_dsM9K85Zi7Q3_Pg7w--
Date: Sat, 8 Dec 2007 12:33:06 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] swap image signature check upon resume
Message-ID: <20071208113306.GA7573@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
References: <20071206211335.GA4923@gollum.tnic> <200712062246.49422.rjw@sisk.pl> <20071207071236.GB4923@gollum.tnic> <200712072119.09836.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200712072119.09836.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2007 at 09:19:09PM +0100, Rafael J. Wysocki wrote:

...

> > > Well, there's a patchset in the current mainline that allows you to use
> > > arbitrary (sufficiently new) kernel to load the image and then restore the
> > > image kernel.  So, you can hibernate 2.6.24-rc3 and use 2.6.24-rc2 to restore
> > > it, for example.
> > > 
> > > I'm going to do that for i386 too.
> > right, this is d307c4a8e826c44f9633bd3f7e60d0491e7d885a (Hibernation: Arbitrary
> > boot kernel support - generic code), i should've seen that. What's the status of
> > those bits, from a quick scan it seems they need some rewiring (Kconfig, e.g.
> > CONFIG_ARCH_HIBERNATION_HEADER etc..) and arch-specific save and restore
> > functions?
> 
> No, this code is fully functional. :-)
> 
> The arch save and restore functions are in arch/x86/kernel/suspend_64.c .
> 
> As I said, i386 is not yet supported.

nice, holler if you need a tester when you have some prototypes ready. By the way,
what do you do when the suspend image header mismatches and it is unsafe to continue booting?
Also, there's a freakishly long comment in suspend_64.c, might wanna shorten it:

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

diff --git a/arch/x86/kernel/suspend_64.c b/arch/x86/kernel/suspend_64.c
index db284ef..0a23e5f 100644
--- a/arch/x86/kernel/suspend_64.c
+++ b/arch/x86/kernel/suspend_64.c
@@ -118,7 +118,12 @@ void fix_processor_context(void)
 	int cpu = smp_processor_id();
 	struct tss_struct *t = &per_cpu(init_tss, cpu);
 
-	set_tss_desc(cpu,t);	/* This just modifies memory; should not be necessary. But... This is necessary, because 386 hardware has concept of busy TSS or some similar stupidity. */
+	/*
+	 * This just modifies memory; should not be necessary. But... This
+	 * is necessary, because 386 hardware has concept of busy TSS or some
+	 * similar stupidity.
+	 */
+	set_tss_desc(cpu,t);
 
 	cpu_gdt(cpu)[GDT_ENTRY_TSS].type = 9;
 
@@ -138,7 +143,6 @@ void fix_processor_context(void)
                 loaddebug(&current->thread, 6);
                 loaddebug(&current->thread, 7);
 	}
-
 }
 
 #ifdef CONFIG_HIBERNATION

-- 
Regards/Gruﬂ,
    Boris.
