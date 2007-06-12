Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbXFLBI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbXFLBI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 21:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbXFLBIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 21:08:51 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:34234 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbXFLBIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 21:08:50 -0400
Date: Mon, 11 Jun 2007 18:07:35 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>, Stable Team <stable@kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: [stable] [PATCH] ACPI: Move timer broadcast and pmtimer access
	before C3 arbiter shutdown
Message-ID: <20070612010735.GL3723@sequoia.sous-sol.org>
References: <1181122673.4404.200.camel@chaos> <20070606183857.caa243d4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606183857.caa243d4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> hm, this needs a bit of help to get it to work against Len's current tree.

Here's some help, compile tested only.  Udo/Thomas, was this found to
be root cause of a real bug?  I didn't want this to get lost if it's
still meant to be relevant for -stable.

thanks,
-chris
--

Subject: ACPI: Move timer broadcast and pmtimer access before C3 arbiter shutdown

From: Udo A. Steinberg <us15@os.inf.tu-dresden.de>

The chip set doc for IHC4 says:

1.In general, software should not attempt any non-posted accesses during
arbiter disable except to the ICH4's power management registers. This
implies that interrupt handlers for any unmasked hardware interrupts and
SMI/NMI should check ARB_DIS status before reading from ICH devices.

So it's not a good idea to access ICH devices after arbiter shut down. 

Signed-off-by: Udo A. Steinberg <us15@os.inf.tu-dresden.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[chrisw: rebase against Len's changes in -mm]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---

 drivers/acpi/processor_idle.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 2c6a3cb..15db3e8 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -978,6 +978,11 @@ static int acpi_idle_enter_c3(struct cpuidle_device *dev,
 		return 0;
 	}
 
+	/* Get start time (ticks) */
+	t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
+	acpi_state_timer_broadcast(pr, cx, 1);
+	acpi_idle_do_entry(cx);
+
 	/* disable bus master */
 	if (pr->flags.bm_check) {
 		spin_lock(&c3_lock);
@@ -995,10 +1000,6 @@ static int acpi_idle_enter_c3(struct cpuidle_device *dev,
 		ACPI_FLUSH_CPU_CACHE();
 	}
 
-	/* Get start time (ticks) */
-	t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
-	acpi_state_timer_broadcast(pr, cx, 1);
-	acpi_idle_do_entry(cx);
 	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
 
 	if (pr->flags.bm_check) {
