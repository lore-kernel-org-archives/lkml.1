Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbYITQFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbYITQFd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 12:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbYITQFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 12:05:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52391 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbYITQFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 12:05:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: I need some serious help to debug suspend to ram problem
Date: Sat, 20 Sep 2008 18:10:44 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>
References: <48D4E685.8030801@gmail.com>
In-Reply-To: <48D4E685.8030801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809201810.45057.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 20 of September 2008, Maxim Levitsky wrote:
> Hi,
> 
> I hit a dead end when trying to understand 
> why my notebook can't resume from suspend to ram
> if this is done two times a row.
> 
> Single suspend/resume cycle works almost perfectly 
> (beep that goes through the sound card is muted... 
> no morse code for me... :-(
> 
> )
> 
> I compiled a minimal kernel (absolutely nothing but disk drivers, all experimental option like nohz
> turned off)
> 
> But I had to turn SMP, since without it system won't resume first time I suspend it.
> (How could this affect suspend?)

It could if the system is 64-bit.  In which case please have a look at
http://bugzilla.kernel.org/show_bug.cgi?id=11237

> With SMP and minimal kernel (of course  no closed drivers), I get same behavior,
> first resume works second hangs.
> 
> I then added some debug code to real mode wakeup code, I put there in first
> place instructions, that will save some magic value to rtc (to alarm
> registers that I know are preserved during boot cycle), and I discovered   
> sad thing that first time bios does pass control to linux, but second time
> (when it hangs), it doesn't. 
> 
> 
> I tried to update bios, and I got same results.
> 
> Of course it does work with that @#$%^& OS

So we're doing something wrong.  Please try the appended patch.

> I then proceeded to test recently posted low memory corruption patch, and
> it did show that that @#$%^& BIOS does corrupt low memory 
> I then reserved all low memory, but system began to hand after first suspend,
> in exactly same way, but as expected I soon discovered, that that forces real
> mode page to be above 1M, ok, then I reserved almost all low memory except
> 100K window in the middle, so low allocations will work, but be placed in
> region bios less likely to corrupt, and still that didn't help, still same hang.   
>  
> You did face lot of such situations, so maybe you know about anything I can do.
> 

Actually, I didn't, but some people did.  Again,
http://bugzilla.kernel.org/show_bug.cgi?id=11237 is the place to look at.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>

ACPI suspend: Always use the 32-bit waking vector

According to the ACPI specification 2.0c and later, the 64-bit waking vector
should be cleared and the 32-bit waking vector should be used, unless we want
the wake-up code to be called by the BIOS in Protected Mode.  Moreover, some
systems (for example HP dv5-1004nr) are known to fail to resume if the 64-bit
waking vector is used.  Therefore, modify the code to clear the 64-bit waking
vector, for FACS version 1 or greater, and set the 32-bit one before suspend.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/hardware/hwsleep.c |   37 +++++++++++--------------------------
 1 file changed, 11 insertions(+), 26 deletions(-)

Index: linux-2.6/drivers/acpi/hardware/hwsleep.c
===================================================================
--- linux-2.6.orig/drivers/acpi/hardware/hwsleep.c
+++ linux-2.6/drivers/acpi/hardware/hwsleep.c
@@ -78,19 +78,17 @@ acpi_set_firmware_waking_vector(acpi_phy
 		return_ACPI_STATUS(status);
 	}
 
-	/* Set the vector */
+	/*
+	 * According to the ACPI specification 2.0c and later, the 64-bit
+	 * waking vector should be cleared and the 32-bit waking vector should
+	 * be used, unless we want the wake-up code to be called by the BIOS in
+	 * Protected Mode.  Some systems (for example HP dv5-1004nr) are known
+	 * to fail to resume if the 64-bit vector is used.
+	 */
+	if (facs->version >= 1)
+		facs->xfirmware_waking_vector = 0;
 
-	if ((facs->length < 32) || (!(facs->xfirmware_waking_vector))) {
-		/*
-		 * ACPI 1.0 FACS or short table or optional X_ field is zero
-		 */
-		facs->firmware_waking_vector = (u32) physical_address;
-	} else {
-		/*
-		 * ACPI 2.0 FACS with valid X_ field
-		 */
-		facs->xfirmware_waking_vector = physical_address;
-	}
+	facs->firmware_waking_vector = (u32)physical_address;
 
 	return_ACPI_STATUS(AE_OK);
 }
@@ -134,20 +132,7 @@ acpi_get_firmware_waking_vector(acpi_phy
 	}
 
 	/* Get the vector */
-
-	if ((facs->length < 32) || (!(facs->xfirmware_waking_vector))) {
-		/*
-		 * ACPI 1.0 FACS or short table or optional X_ field is zero
-		 */
-		*physical_address =
-		    (acpi_physical_address) facs->firmware_waking_vector;
-	} else {
-		/*
-		 * ACPI 2.0 FACS with valid X_ field
-		 */
-		*physical_address =
-		    (acpi_physical_address) facs->xfirmware_waking_vector;
-	}
+	*physical_address = (acpi_physical_address)facs->firmware_waking_vector;
 
 	return_ACPI_STATUS(AE_OK);
 }
