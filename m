Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbXGaTKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbXGaTKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 15:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbXGaTKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 15:10:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:44017 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbXGaTKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 15:10:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,204,1183359600"; 
   d="scan'208";a="256998833"
Date: Tue, 31 Jul 2007 12:04:31 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Eric Sesterhenn / Snakebyte <snakebyte@gmx.de>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-acpi@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Time Problems with 2.6.23-rc1-gf695baf2
Message-ID: <20070731190431.GA24577@linux-os.sc.intel.com>
References: <20070731145456.GB25175@alice> <653FFBB4508B9042B5D43DC9E18836F5013588F6@scsmsx415.amr.corp.intel.com> <20070731153808.GC25175@alice>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731153808.GC25175@alice>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 05:38:08PM +0200, Eric Sesterhenn / Snakebyte wrote:
> * Pallipadi, Venkatesh (venkatesh.pallipadi@intel.com) wrote:
> > This means things should work fine with processor.max_cstate=2 boot
> > option
> > as well. Can you please double check that.
> 
> yes, system boots fine with this kernel parameter
> 
> > Also, please send in the acpidump from your system.
> 
> here we go, if you need some parameters to acpidump, just say so.
> 

Eric,

Can you check the test patch below (over latest git) and let me know whether it
resolves the issue.

Thanks,
Venki


Enable C3 without bm control only for CST based C3.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6/drivers/acpi/processor_idle.c
===================================================================
--- linux-2.6.orig/drivers/acpi/processor_idle.c	2007-07-31 04:29:26.000000000 -0700
+++ linux-2.6/drivers/acpi/processor_idle.c	2007-07-31 04:52:50.000000000 -0700
@@ -969,11 +969,17 @@
 	}
 
 	if (pr->flags.bm_check) {
-		/* bus mastering control is necessary */
 		if (!pr->flags.bm_control) {
-			/* In this case we enter C3 without bus mastering */
-			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-				"C3 support without bus mastering control\n"));
+			if (pr->flags.has_cst != 1) {
+				/* bus mastering control is necessary */
+				ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+					"C3 support requires BM control\n"));
+				return;
+			} else {
+				/* Here we enter C3 without bus mastering */
+				ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+					"C3 support without BM control\n"));
+			}
 		}
 	} else {
 		/*
