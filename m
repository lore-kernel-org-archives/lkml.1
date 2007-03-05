Return-Path: <linux-kernel-owner+w=401wt.eu-S933589AbXCEQoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933589AbXCEQoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 11:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933585AbXCEQoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 11:44:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50537 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933556AbXCEQoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 11:44:18 -0500
Date: Mon, 5 Mar 2007 17:41:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Michael S. Tsirkin" <mst@mellanox.co.il>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>, Len Brown <lenb@kernel.org>,
       git@vger.kernel.org
Subject: Re: 2.6.21-rc1: known regressions (part 2)
Message-ID: <20070305164133.GA2441@elte.hu>
References: <20070227103407.GA17819@elte.hu> <20070227105922.GD2250@kernel.dk> <20070227111515.GA4271@kernel.dk> <20070301093450.GA8508@elte.hu> <20070301104117.GA22788@elte.hu> <20070301145204.GA25304@elte.hu> <Pine.LNX.4.64.0703011536450.12485@woody.linux-foundation.org> <20070302072100.GB30634@elte.hu> <20070302080441.GA12785@elte.hu> <20070305161450.GA4972@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305161450.GA4972@mellanox.co.il>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael S. Tsirkin <mst@mellanox.co.il> wrote:

> > Quoting Ingo Molnar <mingo@elte.hu>:
> >  git-bisect good      0539771d7236b425f285652f6f297cc7939c8f9a
> > 
> >  81450b73dde07f473a4a7208b209b4c8b7251d90 is first bad commit
> 
> I have confirmed these two on my system.

you could probably get quite a bit further in bisecting the other 
breakage, by using the following method:

manully apply the patch below to 81450b73dde and retest. It will most 
likely work. Then FIRST unapply the patch and mark the tree via 
'git-bisect good' and continue the bisection. Then try to apply the 
patch again. If it's already included - ignore the rejected patch. 
Whenever git-bisect offers you a new commit, just try to apply the 
patch. Ok? This way you'll be able to avoid the known ACPI breakage, and 
zoom in on the unknown breakage.

	Ingo

---------------->
commit f3ccb06f3b8e0cf42b579db21f3ca7f17fcc3f38
Author: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
Date:   Tue Feb 13 02:35:50 2007 -0500

    ACPI: Disable wake GPEs only once.
    
    fixes Suspend/Resume regressions due to recent ACPICA update.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

diff --git a/drivers/acpi/events/evgpe.c b/drivers/acpi/events/evgpe.c
index dfac3ec..635ba44 100644
--- a/drivers/acpi/events/evgpe.c
+++ b/drivers/acpi/events/evgpe.c
@@ -636,17 +636,6 @@ acpi_ev_gpe_dispatch(struct acpi_gpe_event_info *gpe_event_info, u32 gpe_number)
 		}
 	}
 
-	if (!acpi_gbl_system_awake_and_running) {
-		/*
-		 * We just woke up because of a wake GPE. Disable any further GPEs
-		 * until we are fully up and running (Only wake GPEs should be enabled
-		 * at this time, but we just brute-force disable them all.)
-		 * 1) We must disable this particular wake GPE so it won't fire again
-		 * 2) We want to disable all wake GPEs, since we are now awake
-		 */
-		(void)acpi_hw_disable_all_gpes();
-	}
-
 	/*
 	 * Dispatch the GPE to either an installed handler, or the control method
 	 * associated with this GPE (_Lxx or _Exx). If a handler exists, we invoke
