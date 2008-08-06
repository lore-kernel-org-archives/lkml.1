Return-Path: <linux-kernel-owner+w=401wt.eu-S1758952AbYHFGe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952AbYHFGe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 02:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbYHFGes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 02:34:48 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42739 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbYHFGer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 02:34:47 -0400
Date: Wed, 6 Aug 2008 07:34:41 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Yves-Alexis Perez <corsac@debian.org>, airlied@linux.ie,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] Add Intel ACPI IGD OpRegion support
Message-ID: <20080806063441.GA14455@srcf.ucam.org>
References: <20080805183725.GA4468@srcf.ucam.org> <1217965470.5449.4.camel@hidalgo> <1217972874.4540.3.camel@hidalgo> <20080806001301.GA10630@srcf.ucam.org> <20080806023247.GA4665@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806023247.GA4665@khazad-dum.debian.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 11:32:48PM -0300, Henrique de Moraes Holschuh wrote:
> On Wed, 06 Aug 2008, Matthew Garrett wrote:
> > The 750ms delay is from thinkpad-acpi. I sent a patch to Henrique which 
> > makes it go away, but I'm not entirely sure what the ACPI method 
> > concerned is supposed to be doing. The opregion code won't currently run 
> > until X is started because the drm layer requires X to be the foreground 
> > vt before handling IRQs.
> 
> Well, for what is it worth, thinkpad-acpi has a knob (brightness_mode) which
> can be used.  Set it to CMOS mode (see docs).  From what I recall, it should
> do what your patch does.

It doesn't seem to, no. I should have been clearer - the delay is in the 
DSDT (not thinkpad-acpi itself), but there's a Thinkpad-specific ACPI 
call that seems to be needed in order to delay it. Here's the patch 
again.

diff --git a/drivers/misc/thinkpad_acpi.c b/drivers/misc/thinkpad_acpi.c
index b596929..bbc45c8 100644
--- a/drivers/misc/thinkpad_acpi.c
+++ b/drivers/misc/thinkpad_acpi.c
@@ -899,6 +899,9 @@ static int __init tpacpi_check_std_acpi_brightness_support(void)
 
 	if (ACPI_SUCCESS(status) && bcl_levels > 2) {
 		tp_features.bright_acpimode = 1;
+		/* Set ACPI mode */
+		if (!acpi_evalf(hkey_handle, NULL, "PWMS", "vd", 0))
+			printk(TPACPI_INFO "Failed to claim backlight\n");
 		return (bcl_levels - 2);
 	}

-- 
Matthew Garrett | mjg59@srcf.ucam.org
