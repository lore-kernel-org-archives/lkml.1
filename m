Return-Path: <linux-kernel-owner+w=401wt.eu-S1760733AbYBKXUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760733AbYBKXUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 18:20:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759252AbYBKXUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 18:20:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:26052 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324AbYBKXU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 18:20:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,335,1199692800"; 
   d="scan'208";a="338348097"
Date: Mon, 11 Feb 2008 15:20:27 -0800
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: "Carlos R. Mafra" <crmafra@gmail.com>,
       Calvin Walton <calvin.walton@gmail.com>, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       rjw@sisk.pl
Subject: Re: [2.6.25-rc1 regression] Suspend to RAM (bisected)
Message-ID: <20080211232027.GA8206@linux-os.sc.intel.com>
References: <47AFDC4D.4070400@gmail.com> <1202708864.5206.0.camel@zem> <924EFEDD5F540B4284297C4DC59F3DEE8608D3@orsmsx423.amr.corp.intel.com> <47B0A3E0.4050908@gmail.com> <20080211200650.GA8287@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211200650.GA8287@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 12:06:50PM -0800, Venki Pallipadi wrote:
> On Mon, Feb 11, 2008 at 05:37:04PM -0200, Carlos R. Mafra wrote:
> > Pallipadi, Venkatesh wrote:
> > > 
> > > Can you send me the output of acpidump and full dmesg to me. Looks like
> > > it is a platform issue due to which we cannot use C1 mwait idle during
> > > suspend resume, something similar to issue we had with using C2/C3 state
> > > during idle.
> > 
> > Full dmesg and acpidump outputs are attached.
> 
> Above acpidump doesnt have all info, as it is loading some SSDT at run time.
> Can you get the output of
> 
> # acpidump --addr 0x7F6D8709 --length 0x000004B7
> # acpidump --addr 0x7F6D8BC0 --length 0x00000092
> 

Thanks for sending the dumps Carlos.

The patch below (on top of rc1) should fix the problem. Can you please
check it.

Thanks,
Venki


Earlier patch (bc71bec91f9875ef825d12104acf3bf4ca215fa4) broke
suspend resume on many laptops. The problem was reported by
Carlos R. Mafra and Calvin Walton, who bisected the issue to above patch.

The problem was because, C2 and C3 code were calling acpi_idle_enter_c1
directly, with C2 or C3 as state parameter, while suspend/resume was in
progress. The patch bc71bec started making use of that state information,
assuming that it would always be referring to C1 state. This caused the
problem with suspend-resume as we ended up using C2/C3 state indirectly.

Fix this by adding acpi_idle_suspend check in enter_c1.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.25-rc1/drivers/acpi/processor_idle.c
===================================================================
--- linux-2.6.25-rc1.orig/drivers/acpi/processor_idle.c
+++ linux-2.6.25-rc1/drivers/acpi/processor_idle.c
@@ -1420,6 +1420,14 @@ static int acpi_idle_enter_c1(struct cpu
 		return 0;
 
 	local_irq_disable();
+
+	/* Do not access any ACPI IO ports in suspend path */
+	if (acpi_idle_suspend) {
+		acpi_safe_halt();
+		local_irq_enable();
+		return 0;
+	}
+
 	if (pr->flags.bm_check)
 		acpi_idle_update_bm_rld(pr, cx);
 
