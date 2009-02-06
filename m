Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbZBFU1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbZBFU1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 15:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbZBFU1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 15:27:38 -0500
Received: from mail.candelatech.com ([208.74.158.172]:34543 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbZBFU1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 15:27:38 -0500
Message-ID: <498C9D1C.2060302@candelatech.com>
Date: Fri, 06 Feb 2009 12:27:08 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, len.brown@intel.com
Subject: Re: PATCH:  (v3) Allow over-ride of smp_found_cfg with kernel cmd-line
 option.
References: <498B421D.9090609@candelatech.com> <20090205195832.GD3129@elte.hu> <498C8DB7.3000005@candelatech.com> <498C8FE8.8090608@oracle.com> <498C90D5.9030400@kernel.org>
In-Reply-To: <498C90D5.9030400@kernel.org>
Content-Type: multipart/mixed;
 boundary="------------070605070704090004050700"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070605070704090004050700
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Yinghai Lu wrote:

>>> +                "WARNING: No ACPI-table found in the MADT\n");
>> 		                APIC table
>>
> 
> APIC-table == MADT
> 
> could just use
> 
> WARNING: No APIC-table found

Ok, here's another attempt.  NOTE:  With another patch that Len sent me,
this work-around seems no longer required for *my* system.  This patch may
still help others, however...


An updated patch is attached.  It's also inline below, but I'm sure the
inline version is white-space corrupted.

Do not disable mptable parsing just because there is no ACPI table
in the MADT table.  This effectively backs out changeset
7b37b5fd9ba32c0c5afc3537eed7e7466f2173e2

Signed-Off-By:  Ben Greear<greearb@candelatech.com>

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index d37593c..6940fb2 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1379,12 +1379,14 @@ static void __init acpi_process_madt(void)
   		 * ACPI found no MADT, and so ACPI wants UP PIC mode.
   		 * In the event an MPS table was found, forget it.
   		 * Boot with "acpi=off" to use MPS on such a system.
+		 *
+		 * NOTE:  This assumption seems wrong in at least some cases, perhaps
+		 *  when ACPI is off in the BIOS.  Changing to a warning without
+		 *  setting smp_found_config to zero.
   		 */
-		if (smp_found_config) {
+		if (smp_found_config)
  			printk(KERN_WARNING PREFIX
-				"No APIC-table, disabling MPS\n");
-			smp_found_config = 0;
-		}
+			       "WARNING: No APIC-table found.\n");
  	}

  	/*


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


--------------070605070704090004050700
Content-Type: text/plain;
 name="madt_patch2.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="madt_patch2.txt"

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index d37593c..6940fb2 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1379,12 +1379,14 @@ static void __init acpi_process_madt(void)
  		 * ACPI found no MADT, and so ACPI wants UP PIC mode.
  		 * In the event an MPS table was found, forget it.
  		 * Boot with "acpi=off" to use MPS on such a system.
+		 *
+		 * NOTE:  This assumption seems wrong in at least some cases, perhaps
+		 *  when ACPI is off in the BIOS.  Changing to a warning without
+		 *  setting smp_found_config to zero.
  		 */
-		if (smp_found_config) {
+		if (smp_found_config)
 			printk(KERN_WARNING PREFIX
-				"No APIC-table, disabling MPS\n");
-			smp_found_config = 0;
-		}
+			       "WARNING: No APIC-table found.\n");
 	}
 
 	/*

--------------070605070704090004050700--
