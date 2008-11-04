Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbYKDSaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbYKDSaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 13:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbYKDSaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 13:30:10 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:60586 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbYKDSaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 13:30:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=W+aHv/19DFniyC+MkUoPmofSxaHvyE/dmUHuieb331/v1xhp6juDN5JdP5J29Nq7um
         kYz2UFnf1z/vjbgVgFSJjy2gFxzBbVU8V309gVuiijLCEASySdx/K9pAySts5wo757+8
         9vgbwfIbrzRnNPcrixblSF8uWy0t1sAM2mU1w=
Date: Tue, 4 Nov 2008 21:00:12 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86: Don't allow nr_irqs > NR_IRQS
Message-ID: <20081104180012.GG21470@localhost>
References: <1225819102.3074.15.camel@achroite>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1225819102.3074.15.camel@achroite>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ben Hutchings - Tue, Nov 04, 2008 at 05:18:22PM +0000]
| On some systems probe_nr_irqs() can return a value larger than
| NR_IRQS.  This will lead to probe_irq_on() overrunning the irq_desc
| array.
| 
| Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
| ---
|  arch/x86/kernel/io_apic.c |    2 ++
|  1 files changed, 2 insertions(+), 0 deletions(-)
| ﻿
| I hit this when running net-next-2.6 (close to 2.6.28-rc3) on a
| Supermicro dual Xeon system.  NR_IRQS is 224 but probe_nr_irqs() detects
| 5 IOAPICs (!) and returns 240.  Here are the log messages:
| 
| Tue Nov  4 16:53:47 2008 ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
| Tue Nov  4 16:53:47 2008 IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
| Tue Nov  4 16:53:47 2008 ACPI: IOAPIC (id[0x02] address[0xfec81000] gsi_base[24])
| Tue Nov  4 16:53:47 2008 IOAPIC[1]: apic_id 2, version 32, address 0xfec81000, GSI 24-47
| Tue Nov  4 16:53:47 2008 ACPI: IOAPIC (id[0x03] address[0xfec81400] gsi_base[48])
| Tue Nov  4 16:53:47 2008 IOAPIC[2]: apic_id 3, version 32, address 0xfec81400, GSI 48-71
| Tue Nov  4 16:53:47 2008 ACPI: IOAPIC (id[0x04] address[0xfec82000] gsi_base[72])
| Tue Nov  4 16:53:47 2008 IOAPIC[3]: apic_id 4, version 32, address 0xfec82000, GSI 72-95
| Tue Nov  4 16:53:47 2008 ACPI: IOAPIC (id[0x05] address[0xfec82400] gsi_base[96])
| Tue Nov  4 16:53:47 2008 IOAPIC[4]: apic_id 5, version 32, address 0xfec82400, GSI 96-119
| Tue Nov  4 16:53:47 2008 ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
| Tue Nov  4 16:53:47 2008 ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
| Tue Nov  4 16:53:47 2008 Enabling APIC mode:  Flat.  Using 5 I/O APICs
| 
| ﻿I think this has become possible since:
| 
| commit d6c88a507ef0b6afdb013cba4e7804ba7324d99a
| Author: Thomas Gleixner <tglx@linutronix.de>
| Date:   Wed Oct 15 15:27:23 2008 +0200
| 
|     genirq: revert dynarray
| 
|     Revert the dynarray changes. They need more thought and polishing.
| 
|     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
| 
| Ben.
| 
| diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
| index b764d74..c8482fb 100644
| --- a/arch/x86/kernel/io_apic.c
| +++ b/arch/x86/kernel/io_apic.c
| @@ -3611,6 +3611,8 @@ int __init probe_nr_irqs(void)
|  	/* something wrong ? */
|  	if (nr < nr_min)
|  		nr = nr_min;
| +	if (nr > NR_IRQS)
| +		nr = NR_IRQS;
|  
|  	return nr;
|  }
|

Hi Ben,

I don't think that is because of Thomas' commit. If we've got
number of pins larger then we expect it means something wrong
with our NR_IRQS. Is it possible to get your .config?
 
		- Cyrill -
