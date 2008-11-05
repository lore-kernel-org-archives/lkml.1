Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbYKETLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbYKETLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 14:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbYKETLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:11:31 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:60712 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbYKETLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:11:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jMoKYwuvE+yArIYKMmmw+xTgAH6k23FIx20gTV3ZENQHJiOUQW49l7W+l0uYd3tsk8
         5YMkBww6+QsHPY4fTNmOSCzja2MxzZK0PbHeZ4dfaGfOp1QQp/l5H4mRYkDREO1QIslu
         curOjItfqdXDiLVIUbb5AZpTUP+ir8rTQ3Eo4=
Date: Wed, 5 Nov 2008 22:11:26 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2] x86: Don't allow nr_irqs > NR_IRQS
Message-ID: <20081105191126.GA23548@localhost>
References: <1225819102.3074.15.camel@achroite> <1225886687.3074.59.camel@achroite>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225886687.3074.59.camel@achroite>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ben Hutchings - Wed, Nov 05, 2008 at 12:04:46PM +0000]
| On some systems probe_nr_irqs() can return a value larger than
| NR_IRQS.  This will lead to probe_irq_on() overrunning the irq_desc
| array.
| 
| Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
| ---
|  arch/x86/kernel/io_apic.c |    2 ++
|  1 files changed, 2 insertions(+), 0 deletions(-)
| 
| I hit this when running net-next-2.6 (close to 2.6.28-rc3) on a
| Supermicro dual Xeon system.  NR_IRQS is 224 but probe_nr_irqs() detects
| 5 IOAPICs and returns 240.  Here are the log messages:
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
| I have added a WARN_ON() as suggested by Yinghai Lu.
| 
| Ben.
| 
| diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
| --- a/arch/x86/kernel/io_apic.c
| +++ b/arch/x86/kernel/io_apic.c
| @@ -3611,6 +3611,8 @@ int __init probe_nr_irqs(void)
|  	/* something wrong ? */
|  	if (nr < nr_min)
|  		nr = nr_min;
| +	if (WARN_ON(nr > NR_IRQS))
| +		nr = NR_IRQS;
|  
|  	return nr;
|  }
| 
| -- 
| Ben Hutchings, Senior Software Engineer, Solarflare Communications
| Not speaking for my employer; that's the marketing department's job.
| They asked us to note that Solarflare product names are trademarked.
| 

My Ack if you need it, Ingo CC'ed
Acked-by: Cyrill Gorcunov <gorcunov@gmail.com>

---

Ben I didn't manage to get a look over ACPI related changes
(ie to find the reason why the kernel is able to reveal 5 IO-APICs
 now but this patch is needed anyway as Yinghai already mentioned
 and should solve your problem. FWIW, I don't see neither apics on
 my laptop by lspci except that ICH is notified so I suspect the
 ACPI parsing is right)

		- Cyrill -
