Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377AbYKDTBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbYKDTBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 14:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbYKDTBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 14:01:12 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:64420 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbYKDTBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 14:01:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=YaoMxVIHpWYgyZFdQ1uWxcgrrefUGgGXv1Q8/CmFdfZtpk6YWDHCTs6MaS3kfOJArg
         npCx7bv/pGZm4IF8ryvnYMqKYCYDlvZM+svlOgakmsEZFouNr3KoGJF/gt694sDkUTNZ
         SatDI3XPe/cWk3yLZrfohcCUZ2ZmMeE977w9I=
Date: Tue, 4 Nov 2008 22:01:08 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86: Don't allow nr_irqs > NR_IRQS
Message-ID: <20081104190108.GH21470@localhost>
References: <1225819102.3074.15.camel@achroite> <20081104180012.GG21470@localhost> <1225823807.3074.24.camel@achroite>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1225823807.3074.24.camel@achroite>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ben Hutchings - Tue, Nov 04, 2008 at 06:36:47PM +0000]
| On Tue, 2008-11-04 at 21:00 +0300, Cyrill Gorcunov wrote:
| [...]
| > | I hit this when running net-next-2.6 (close to 2.6.28-rc3) on a
| > | Supermicro dual Xeon system.  NR_IRQS is 224 but probe_nr_irqs() detects
| > | 5 IOAPICs (!) and returns 240.  Here are the log messages:
| > | 
| > | Tue Nov  4 16:53:47 2008 ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
| > | Tue Nov  4 16:53:47 2008 IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
| > | Tue Nov  4 16:53:47 2008 ACPI: IOAPIC (id[0x02] address[0xfec81000] gsi_base[24])
| > | Tue Nov  4 16:53:47 2008 IOAPIC[1]: apic_id 2, version 32, address 0xfec81000, GSI 24-47
| > | Tue Nov  4 16:53:47 2008 ACPI: IOAPIC (id[0x03] address[0xfec81400] gsi_base[48])
| > | Tue Nov  4 16:53:47 2008 IOAPIC[2]: apic_id 3, version 32, address 0xfec81400, GSI 48-71
| > | Tue Nov  4 16:53:47 2008 ACPI: IOAPIC (id[0x04] address[0xfec82000] gsi_base[72])
| > | Tue Nov  4 16:53:47 2008 IOAPIC[3]: apic_id 4, version 32, address 0xfec82000, GSI 72-95
| > | Tue Nov  4 16:53:47 2008 ACPI: IOAPIC (id[0x05] address[0xfec82400] gsi_base[96])
| > | Tue Nov  4 16:53:47 2008 IOAPIC[4]: apic_id 5, version 32, address 0xfec82400, GSI 96-119
| > | Tue Nov  4 16:53:47 2008 ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
| > | Tue Nov  4 16:53:47 2008 ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
| > | Tue Nov  4 16:53:47 2008 Enabling APIC mode:  Flat.  Using 5 I/O APICs
| > | 
| > | ﻿I think this has become possible since:
| > | 
| > | commit d6c88a507ef0b6afdb013cba4e7804ba7324d99a
| > | Author: Thomas Gleixner <tglx@linutronix.de>
| > | Date:   Wed Oct 15 15:27:23 2008 +0200
| > | 
| > |     genirq: revert dynarray
| > | 
| > |     Revert the dynarray changes. They need more thought and polishing.
| > | 
| > |     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
| [...]
| > Hi Ben,
| > 
| > I don't think that is because of Thomas' commit. If we've got
| > number of pins larger then we expect it means something wrong
| > with our NR_IRQS. Is it possible to get your .config?
| 
| Well there must have been an earlier change that resulted in detecting 5
| IOAPICs instead of just 1, but that presumably would work as long as the
| irq_desc array was dynamically allocated.  This reversion breaks that.

Hmm... wich means the problem in area of detecting IOAPICs but this number
we got from ACPI... have to check.

| 
| You don't really need to see the config; NR_IRQS is *always* 224 on
| normal x86-32 systems.

Ben, how could I know that you're using 32bit version, unfortunately
I don't recite in my mind "NR_IRQS is 224 on x86-32" every minute :)

| 
| Ben.
| 
| -- 
| Ben Hutchings, Senior Software Engineer, Solarflare Communications
| Not speaking for my employer; that's the marketing department's job.
| They asked us to note that Solarflare product names are trademarked.
| 
		- Cyrill -
