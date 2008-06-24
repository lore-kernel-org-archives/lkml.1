Return-Path: <linux-kernel-owner+w=401wt.eu-S1759766AbYFXLmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759766AbYFXLmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 07:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbYFXLmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 07:42:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57069 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbYFXLmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 07:42:10 -0400
Date: Tue, 24 Jun 2008 13:41:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Zhao Yakui <yakui.zhao@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH] ACPI: don't walk tables if ACPI was disabled
Message-ID: <20080624114139.GC21890@elte.hu>
References: <20080620135639.GA5073@damson.getinternet.no> <alpine.LFD.1.10.0806201458500.3027@localhost.localdomain> <19f34abd0806201340t502ce471n578dd2498a5f1992@mail.gmail.com> <19f34abd0806201427h740ca3e7gc2f01c7e34616fd4@mail.gmail.com> <19f34abd0806210119o64a1c9ban78710651a01530cf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0806210119o64a1c9ban78710651a01530cf@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> On Fri, Jun 20, 2008 at 11:27 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > So I guess this function, pnpbios_init() needs the check as well. In
> > fact, it has this:
> >
> > #ifdef CONFIG_PNPACPI
> >        if (!acpi_disabled && !pnpacpi_disabled) {
> >                pnpbios_disabled = 1;
> >                printk(KERN_INFO "PnPBIOS: Disabled by ACPI PNP\n");
> >                return -ENODEV;
> >        }
> > #endif                          /* CONFIG_ACPI */
> >
> > ...I guess that should be changed to say if (acpi_disabled ||
> > pnpacpi_disabled)? Or... I don't understand the purpose of the
> > original test. But it seems to be there since the beginning of time
> > (or, well, v2.6.12-rc2).
> 
> Nope. I found the introduction of the change in the historical git repository:
> 
> commit 4723ebe898a32262ed49fe677897ccea47e72ff4
> Author: Adam Belay <ambx1@neo.rr.com>
> Date:   Sun Oct 24 15:07:32 2004 -0400
> 
>     [PNPBIOS] disable if ACPI is active
> 
>     As further ACPI pnp functionaility is implemented it is no longer
>     safe to run ACPI and PNPBIOS concurrently.
> 
>     We therefore take the following approach:
>     - attempt to enable ACPI support
>     - if ACPI fails (blacklist etc.) enable pnpbios support
>     - if ACPI support is not compiled in the kernel enable pnpbios support
> 
>     Signed-off-by: Adam Belay <ambx1@neo.rr.com>
> 
> and now I understand the purpose of the check; pnpbios does not depend 
> on ACPI; ACPI/pnpacpi is incompatible with pnpbios.

wow, rather old bug - i guess lockdep made it more visible.

> Yet it remains a fact that pnpbios will discover devices which then 
> ACPI code uses erroneously. Which means that my original fix for Ingo 
> probably is the right one after all. Should I submit another patch 
> which does the right thing for everything under drivers/acpi/, or can 
> you do it on your own? :-)

i havent seen the warning reappear with your fix after thousands of 
bootups - so i guess we can consider it fixed.

Len, please consider the patch below. (it's in tip/out-of-tree)

	Ingo

----------------->
commit acc85833791a5d8f84b8df601afc1cc44568dd18
Author: Vegard Nossum <vegard.nossum@gmail.com>
Date:   Fri Jun 20 15:56:40 2008 +0200

    ACPI: don't walk tables if ACPI was disabled
    
    Ingo Molnar wrote:
    > -tip auto-testing started triggering this spinlock corruption message
    > yesterday:
    >
    > [    3.976213] calling  acpi_rtc_init+0x0/0xd3
    > [    3.980213] ACPI Exception (utmutex-0263): AE_BAD_PARAMETER, Thread F7C50000 could not acquire Mutex [3] [20080321]
    > [    3.992213] BUG: spinlock bad magic on CPU#0, swapper/1
    > [    3.992213]  lock: c2508dc4, .magic: 00000000, .owner: swapper/1, .owner_cpu: 0
    
    This is apparently because some parts of ACPI, including mutexes, are not
    initialized when acpi=off is passed to the kernel.
    
    Reported-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
    Cc: Len Brown <lenb@kernel.org>
    Cc: Zhao Yakui <yakui.zhao@intel.com>
    Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
    Cc: Alexey Starikovskiy <astarikovskiy@suse.de>
    Cc: Yinghai Lu <yhlu.kernel@gmail.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index b4d4ce0..c3e1eeb 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -334,6 +334,9 @@ static int __init acpi_rtc_init(void)
 {
 	struct device *dev = get_rtc_dev();
 
+	if (acpi_disabled)
+		return 0;
+
 	if (dev) {
 		rtc_wake_setup();
 		rtc_info.wake_on = rtc_wake_on;
diff --git a/drivers/acpi/namespace/nsxfeval.c b/drivers/acpi/namespace/nsxfeval.c
index a8d5491..c274d1d 100644
--- a/drivers/acpi/namespace/nsxfeval.c
+++ b/drivers/acpi/namespace/nsxfeval.c
@@ -391,6 +391,9 @@ acpi_walk_namespace(acpi_object_type type,
 
 	ACPI_FUNCTION_TRACE(acpi_walk_namespace);
 
+	if (acpi_disabled)
+		return_ACPI_STATUS(AE_NO_NAMESPACE);
+
 	/* Parameter validation */
 
 	if ((type > ACPI_TYPE_LOCAL_MAX) || (!max_depth) || (!user_function)) {
