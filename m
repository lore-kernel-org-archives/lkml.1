Return-Path: <linux-kernel-owner+w=401wt.eu-S1751971AbYIVEST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbYIVEST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 00:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbYIVESK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 00:18:10 -0400
Received: from 1wt.eu ([62.212.114.60]:4427 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbYIVESJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 00:18:09 -0400
Date: Mon, 22 Sep 2008 06:18:04 +0200
From: Willy Tarreau <w@1wt.eu>
To: David W Studeman <avionicsdv@aim.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Keyboard Jammed error patch 2.4.35-pre4
Message-ID: <20080922041804.GC24654@1wt.eu>
References: <g6jqud$t5e$1@ger.gmane.org> <20080729051558.GH29189@1wt.eu> <489016AB.6050309@aim.com> <20080730075101.GA31668@1wt.eu> <489044C8.7090006@aim.com> <20080730123839.GA2397@1wt.eu> <gb5gi2$l36$1@ger.gmane.org> <20080921144053.GB24654@1wt.eu> <48D7114E.3070500@aim.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D7114E.3070500@aim.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2008 at 08:30:22PM -0700, David W Studeman wrote:
> Willy Tarreau wrote:
> >Hello David,
> >
> >first, please always take care of keeping persons in CC when replying to
> >LKML, otherwise you risk your mail being missed.
> >
> >On Sun, Sep 21, 2008 at 06:00:50AM -0700, David W Studeman wrote:
> >>Ok, I finally applied the patch manually to 2.4.36.7 and then made my own
> >>diff from that. Your patch would likely have applied if I increased the
> >>fuzz factor as it was merely off by a number of lines. When trying to
> >>compile with no keyboard or VT support, I still get this error:
> >>
> >>arch/i386/kernel/kernel.o(.text.init+0x33e6): In function
> >>`disable_console_keyboard':
> >>: undefined reference to `keyboard_controller_present'
> >>make: *** [vmlinux] Error 1
> >
> >I know what causes this. The fix is merged into 2.4.37-rc1. I've been
> >using it for a long time without even noticing that it was still not
> >merged. The fix is trivial as it simply removes the 
> >disable_console_keyboard
> >function when CONFIG_VT is not set. This is needed because the variable
> >keyboard_controller_present is only defined when CONFIG_VT is set.
> >
> >Here's the patch if it can help you.
> >
> >Also, next time you encounter problems, please post your config. It's
> >very hard to troubleshoot build bugs without a config. I would have
> >immediately spotted this missing patch on the first time had I got
> >that config.
> >
> >Regards,
> >Willy
> >
> >----
> >From 90e228888a59d630c8094d5d1b273b00a2c76cc0 Mon Sep 17 00:00:00 2001
> >From: Willy Tarreau <w@1wt.eu>
> >Date: Sun, 7 Sep 2008 12:37:51 +0200
> >Subject: x86 would not build without CONFIG_VT
> >
> >I've been using this patch for a while without noticing it never
> >went into mainline. It is required to build i386 without CONFIG_VT.
> >
> >Signed-off-by: Willy Tarreau <w@1wt.eu>
> >---
> > arch/i386/kernel/dmi_scan.c |    6 +++++-
> > 1 files changed, 5 insertions(+), 1 deletions(-)
> >
> >diff --git a/arch/i386/kernel/dmi_scan.c b/arch/i386/kernel/dmi_scan.c
> >index 07c6d94..9c27ca2 100644
> >--- a/arch/i386/kernel/dmi_scan.c
> >+++ b/arch/i386/kernel/dmi_scan.c
> >@@ -524,6 +524,7 @@ static __init int disable_acpi_pci(struct 
> >dmi_blacklist *d)
> >  */
> >  
> > 
> >+#ifdef CONFIG_VT
> > /*      IBM bladeservers have a USB console switch. The keyboard type is 
> > USB
> >  *      and the hardware does not have a console keyboard. We disable the
> >  *      console keyboard so the kernel does not try to initialize one and
> >@@ -538,6 +539,7 @@ static __init int disable_console_keyboard(struct 
> >dmi_blacklist *d)
> >         keyboard_controller_present = 0;
> >         return 0;
> > }
> >+#endif
> > 
> > /*
> >  *	This will be expanded over time to force things like the APM 
> >@@ -825,7 +827,8 @@ static __initdata struct dmi_blacklist 
> >dmi_blacklist[]={
> > 			MATCH(DMI_SYS_VENDOR, "IBM"),
> > 			NO_MATCH, NO_MATCH, NO_MATCH
> > 			} },
> >- /*
> >+#ifdef CONFIG_VT
> >+        /*
> >          *      IBM Bladeservers
> >          */
> > 
> >@@ -834,6 +837,7 @@ static __initdata struct dmi_blacklist 
> >dmi_blacklist[]={
> >                         MATCH(DMI_BOARD_NAME, "Server Blade"),
> >                         NO_MATCH, NO_MATCH
> >                         } },
> >+#endif
> > 
> > #ifdef	CONFIG_ACPI_BOOT
> > 	/*
> 
> 
> Ok, Thanks Willy! The changes to the dmi_scan.c as you gave above from 
> 2.4.37rc1 fixed the remaining problem. I have a 2.4.36.7 Cobalt patched 
> kernel running in a Raq550 as I type this and it compiled with no 
> keyboard or VT support cleanly with your dmi_scan and pc_keybd patch so 
> I no longer am using the old regression patch I made previously.

fine, it will be merged into 2.4.36.8 too.

Willy

