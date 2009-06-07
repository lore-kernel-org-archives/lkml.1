Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbZFGKFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbZFGKFw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 06:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbZFGKFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 06:05:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54464 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275AbZFGKFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 06:05:45 -0400
Date: Sun, 7 Jun 2009 12:05:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Thomas Renninger <trenn@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2] acpi: Fix regression where _PPC is not read at boot
	even when ignore_ppc=0
Message-ID: <20090607100541.GJ31286@elte.hu>
References: <20090428193303.GC6968@plum> <20090428195348.GA8376@srcf.ucam.org> <20090429213930.GE6968@plum> <20090429220037.GA8604@srcf.ucam.org> <20090430072556.GD16737@elte.hu> <20090430095414.GA19462@srcf.ucam.org> <20090430111042.GA12809@elte.hu> <20090430111338.GA21297@srcf.ucam.org> <20090515191219.GH6968@plum> <20090602232108.GG7917@plum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602232108.GG7917@plum>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Darrick J. Wong <djwong@us.ibm.com> wrote:

> On Fri, May 15, 2009 at 12:12:19PM -0700, Darrick J. Wong wrote:
> > On Thu, Apr 30, 2009 at 12:13:38PM +0100, Matthew Garrett wrote:
> > > On Thu, Apr 30, 2009 at 01:10:42PM +0200, Ingo Molnar wrote:
> > > 
> > > > thanks - i've applied this and started testing it. I suspect 1-2 
> > > > days of test-time should be enough to see if it breaks this box in 
> > > > any way.
> > > 
> > > My recollection was that you'd see the machine limited to 1GHz on every 
> > > boot?
> > 
> > That seems accurate based on my reading of the old thread.
> > 
> > It's been a couple of weeks; has anyone seen any problems?
> 
> Now it's been thirty days since I last heard from anyone.  Has the 
> problem been fixed by some other means?

I see no problems on that system here, with the patch below applied. 
So, as i indicated above, feel free to pursue this angle, there's no 
objection from me.

Thanks,

	Ingo

------------->
>From 244b66ac1fbbe25262a9bcc28179e50930290de8 Mon Sep 17 00:00:00 2001
From: Matthew Garrett <mjg59@srcf.ucam.org>
Date: Thu, 30 Apr 2009 10:54:14 +0100
Subject: [PATCH] acpi: Fix regression where _PPC is not read at boot even when ignore_ppc=0

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
Cc: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Thomas Renninger <trenn@suse.de>
LKML-Reference: <20090430095414.GA19462@srcf.ucam.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
