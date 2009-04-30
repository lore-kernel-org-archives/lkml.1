Return-Path: <linux-kernel-owner+w=401wt.eu-S1762374AbZD3Jye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762374AbZD3Jye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 05:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbZD3JyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 05:54:24 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55798 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbZD3JyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 05:54:22 -0400
Date: Thu, 30 Apr 2009 10:54:14 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Thomas Renninger <trenn@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2] acpi: Fix regression where _PPC is not read at boot
	even when ignore_ppc=0
Message-ID: <20090430095414.GA19462@srcf.ucam.org>
References: <20090415225348.GW8311@plum> <20090416002712.GX8311@plum> <200904161201.13409.trenn@suse.de> <20090416174217.GY8311@plum> <20090416224507.GA31984@srcf.ucam.org> <20090428193303.GC6968@plum> <20090428195348.GA8376@srcf.ucam.org> <20090429213930.GE6968@plum> <20090429220037.GA8604@srcf.ucam.org> <20090430072556.GD16737@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430072556.GD16737@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 09:25:56AM +0200, Ingo Molnar wrote:

> OTOH, if you rely on me figuring out which patch to revert and what 
> to do, it will take an indeterminate amount of time - together with 
> all the other items in my 'would be nice to hack on, given a bit of 
> free time' queue :)

Here's Darrick's patch:

Earlier, Ingo Molnar posted a patch to make it so that the kernel would avoid
reading _PPC on his broken T60.  Unfortunately, it seems that with Thomas
Renninger's patch last July to eliminate _PPC evaluations when the processor
driver loads, the kernel never actually reads _PPC at all!  This is problematic
if you happen to boot your non-T60 computer in a state where the BIOS _wants_
_PPC to be something other than zero.

So, put the _PPC evaluation back into acpi_processor_get_performance_info if
ignore_ppc isn't 1.

This second version restores the correct function call, which simplifies
the patch.  I apologize for the churn and the poor eyesight.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/acpi/processor_perflib.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)


diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index cafb410..85af717 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -348,7 +348,11 @@ static int acpi_processor_get_performance_info(struct acpi_processor *pr)
 	if (result)
 		goto update_bios;
 
-	return 0;
+	/* We need to call _PPC once when cpufreq starts */
+	if (ignore_ppc != 1)
+		result = acpi_processor_get_platform_limit(pr);
+
+	return result;
 
 	/*
 	 * Having _PPC but missing frequencies (_PSS, _PCT) is a very good hint that

-- 
Matthew Garrett | mjg59@srcf.ucam.org
