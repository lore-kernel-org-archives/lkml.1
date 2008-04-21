Return-Path: <linux-kernel-owner+w=401wt.eu-S1755884AbYDUVUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbYDUVUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbYDUVT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:19:56 -0400
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:53421 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752338AbYDUVTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:19:55 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: PCI MSI breaks when booting with nosmp
Date: Mon, 21 Apr 2008 14:14:44 -0700
User-Agent: KMail/1.9.9
Cc: Jean Delvare <jdelvare@suse.de>, linux-pci@atrey.karlin.mff.cuni.cz,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Tejun Heo <htejun@gmail.com>, Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Jeff Garzik <jgarzik@pobox.com>
References: <200804172140.02311.jdelvare@suse.de> <200804212248.02986.jdelvare@suse.de> <20080421210909.GC21028@one.firstfloor.org>
In-Reply-To: <20080421210909.GC21028@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804211414.45629.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 21, 2008 2:09 pm Andi Kleen wrote:
> > Both call disable_ioapic_setup(), so how can they not be the same?
>
> See Jesse's explanation. Basically there is special code in the smp
> boot up to handle 0 CPUs and it disables all APICs.
>
> This is very old and crufty and somewhat obsolete logic,
> but it is like that.

This might be closer to a real fix.  Can you confirm that this works for you 
Jean?

Thanks,
Jesse

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index e6abe8a..7cdf930 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1138,14 +1138,10 @@ static int __init smp_sanity_check(unsigned max_cpus)
 				 "forcing use of dummy APIC emulation.\n");
 		smpboot_clear_io_apic();
 #ifdef CONFIG_X86_32
-		if (nmi_watchdog == NMI_LOCAL_APIC) {
-			printk(KERN_INFO "activating minimal APIC for"
-					 "NMI watchdog use.\n");
-			connect_bsp_APIC();
-			setup_local_APIC();
-			end_local_APIC_setup();
-		}
+		connect_bsp_APIC();
 #endif
+		setup_local_APIC();
+		end_local_APIC_setup();
 		return -1;
 	}
 

