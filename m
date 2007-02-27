Return-Path: <linux-kernel-owner+w=401wt.eu-S1161452AbXB0AHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161452AbXB0AHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 19:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161453AbXB0AHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 19:07:05 -0500
Received: from nz-out-0506.google.com ([64.233.162.224]:58312 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161452AbXB0AHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 19:07:04 -0500
Message-ID: <45E37617.6050107@codemonkey.ws>
Date: Mon, 26 Feb 2007 18:06:47 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: linux-kernel@vger.kernel.org
Subject: [RFC] Use para_fill instead of vmi_get_function for APIC ops
Content-Type: multipart/mixed;
 boundary="------------010601080501050001030002"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010601080501050001030002
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Zach,

It seems to me that the APIC paravirt_ops should be filled by 
para_fill() instead of vmi_get_function().  vmi_get_function() returns a 
nop when the relocation type is NONE.  para_fill() leaves the native 
code in place.

The native version of the apic write ops is more or less *(APIC_BASE + 
reg) = value.  APIC_BASE is unknown to the ROM so it's impossible to 
simulate this in the ROM.

This means that a ROM has no choice but to do APIC emulation (or jump 
through seriously hairy loops to get the APIC mapped in it's address 
space).  Was this the intention?

N.B. attached patch is just to illustrate the point.  Has not even been 
compile tested.

Regards,

Anthony Liguori

--------------010601080501050001030002
Content-Type: text/x-patch;
 name="vmi-apic-ops.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vmi-apic-ops.diff"

--- linux-2.6.21-rc1/arch/i386/kernel/vmi.c~	2007-02-20 22:32:30.000000000 -0600
+++ linux-2.6.21-rc1/arch/i386/kernel/vmi.c	2007-02-26 17:58:18.000000000 -0600
@@ -852,9 +852,9 @@
 #endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
-	paravirt_ops.apic_read = vmi_get_function(VMI_CALL_APICRead);
-	paravirt_ops.apic_write = vmi_get_function(VMI_CALL_APICWrite);
-	paravirt_ops.apic_write_atomic = vmi_get_function(VMI_CALL_APICWrite);
+	para_fill(apic_read, APICRead);
+	para_fill(apic_write, APICWrite);
+	para_fill(apic_write_atomic, APICWrite);
 #endif
 
 	/*

--------------010601080501050001030002--
