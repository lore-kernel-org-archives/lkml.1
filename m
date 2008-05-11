Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbYEKP5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbYEKP5e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 11:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbYEKP5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 11:57:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:29082 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbYEKP5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 11:57:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=fduvO7mw/iq2XEBZ4dig4H9kdh9yQ67kr87iuveb7srrCXp3C6uTraOkZNj64k9GqNDlLMAH5E/YTKpVcF+tjtGcGamf8gIQ696Q8WWphetbdrVl/fMu0+SXiLrLtN8/MwyNaE8xP4fAAXEcNyEG9CJ9xv9T7IvDayVvhzLI4Gg=
Date: Sun, 11 May 2008 19:44:11 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Mikael Pettersson <mikpe@it.uu.se>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc1 on x86: ld: warning: dot moved backwards before
	`.text'
Message-ID: <20080511154411.GB6942@cvg>
References: <18470.787.498329.144701@harpo.it.uu.se> <482604D1.7020804@zytor.com> <20080510211602.GA32339@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080510211602.GA32339@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sam Ravnborg - Sat, May 10, 2008 at 11:16:02PM +0200]
| On Sat, May 10, 2008 at 01:25:53PM -0700, H. Peter Anvin wrote:
| > Mikael Pettersson wrote:
| > >
| > >The resulting kernel hasn't broken on me yet, however.
| > >
| > >A search through the LKML archives showed that this was reported
| > >for 2.6.25-rc3-mm1, but I couldn't find any discussion about it
| > >after that:
| > >
| > ><http://marc.info/?l=linux-kernel&m=120470303728010&w=2>
| > >
| > >The .config causing this warning is available in
| > ><http://user.it.uu.se/~mikpe/linux/ale/config-2.6.26-rc1>
| > >
| > 
| > This is because the organization of the file was changed, and the linker 
| > script wasn't changed to match:
| > 
| > SECTIONS
| > {
| >         . = HEADER_OFFSET;
| >         .header : {
| >                  *(.header)
| >         }
| > 
| >         . = 0;
| >         .text : {
| >                  *(.text*)
| >         }
| > 
| > This is crap; the sections should be listed *in order* so the linker can 
| > warn properly when something bad happens.
| > 
| > The code should be correct; reorganizing the linker script correctly 
| > should fix the problem.
| 
| I need Pavel to comment on this.
| Why we start with . equal 0x3f00 and then later as . equals 0x0000
| I dunno.
| I did not look into this part of the code back then - but I should anyway
| have seen this flaw in the linker script :-(
| 
| 	Sam

Should not it be something like
---

diff --git a/arch/x86/kernel/acpi/realmode/wakeup.lds.S b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
index 22fab6c..cccf62d 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.lds.S
+++ b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
@@ -12,11 +12,6 @@ ENTRY(_start)
 
 SECTIONS
 {
-	. = HEADER_OFFSET;
-	.header : {
-		 *(.header)
-	}
-
 	. = 0;
 	.text : {
 		 *(.text*)
@@ -53,6 +48,11 @@ SECTIONS
 	. = ALIGN(16);
 	_end = .;
 
+	. = HEADER_OFFSET;
+	.header : {
+		 *(.header)
+	}
+
 	/DISCARD/ : {
 		*(.note*)
 	}
---
		- Cyrill -
