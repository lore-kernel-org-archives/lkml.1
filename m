Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab0BRS2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:28:43 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:46990 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab0BRS2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:28:39 -0500
Date: Thu, 18 Feb 2010 10:28:20 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Len Brown <lenb@kernel.org>
Cc: Matthew Garrett <mjg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       davej@redhat.com, Thomas Renninger <trenn@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2] acpi: Fix regression where _PPC is not read at boot
	even when ignore_ppc=0
Message-ID: <20100218182820.GQ29569@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20090430095414.GA19462@srcf.ucam.org> <20090430111042.GA12809@elte.hu> <20090430111338.GA21297@srcf.ucam.org> <20090515191219.GH6968@plum> <20090602232108.GG7917@plum> <20090607100541.GJ31286@elte.hu> <20090715003207.GA5111@plum> <20100216220707.GA5966@srcf.ucam.org> <20100216222611.GP29569@tux1.beaverton.ibm.com> <alpine.LFD.2.00.1002180401360.4135@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002180401360.4135@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 04:02:39AM -0500, Len Brown wrote:
> > On Tue, Feb 16, 2010 at 10:07:07PM +0000, Matthew Garrett wrote:
> > > Did this ever get picked up?
> > 
> > Nope.  I vaguely recall asking a few times if there were any objections left,
> > but there weren't any, and I think Len or someone said it looked good back at
> > LPC last summer.  Does not appear in 2.6.33-rc8 though.
> 
> does it have a bugzilla entry? (as regressions tend to, thanks to rafael)
> I don't see this in my mailbox anymore.

Nope, no bugzilla entry.  Do I need to create one now?  A patch resend follows.

--D

---
Earlier, Ingo Molnar posted a patch to make it so that the kernel would avoid
reading _PPC on his broken T60.  Unfortunately, it seems that with Thomas
Renninger's patch last July to eliminate _PPC evaluations when the processor
driver loads, the kernel never actually reads _PPC at all!  This is problematic
if you happen to boot your non-T60 computer in a state where the BIOS _wants_
_PPC to be something other than zero.

So, put the _PPC evaluation back into acpi_processor_get_performance_info if
ignore_ppc isn't 1.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/acpi/processor_perflib.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)


diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index 2cabadc..a959f6a 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -413,7 +413,11 @@ static int acpi_processor_get_performance_info(struct acpi_processor *pr)
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
