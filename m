Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbYHSISD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbYHSISD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 04:18:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbYHSIRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 04:17:46 -0400
Received: from p01c12o148.mxlogic.net ([208.65.145.71]:58729 "EHLO
	p01c12o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbYHSIRo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 04:17:44 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Linux 2.6.26 edac errors and ASUS P5W DH Deluxe motherboard
Date: Tue, 19 Aug 2008 09:17:41 +0100
Message-ID: <0F10A59FDFFDFD4E9BEBD7365DE672550214F0B1@uk-email.terastack.bluearc.com>
In-Reply-To: <99716.17944.qm@web50106.mail.re2.yahoo.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Linux 2.6.26 edac errors and ASUS P5W DH Deluxe motherboard
Thread-Index: AckBawTIF6M1CXTESdybYCFhrEHKvAAY6nOg
References: <0F10A59FDFFDFD4E9BEBD7365DE672550214F027@uk-email.terastack.bluearc.com> <99716.17944.qm@web50106.mail.re2.yahoo.com>
From: "Andy Chittenden" <andyc@bluearc.com>
To: "Doug Thompson" <norsk5@yahoo.com>, <linux-kernel@vger.kernel.org>
X-Spam: [F=0.1000000000; S=0.100(2008081101)]
X-MAIL-FROM: <andyc@bluearc.com>
X-SOURCE-IP: [62.190.48.218]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug

> I don't know which version of the  source code was used in the 25 or 
> the 26 versions of the debian package, but it might be that the later 
> one is really finding errors as I remember there was some patches 
> against the i82975x module.

I've done a diff between 2.6.25 and 2.6.26 source code of the
i82975x_edac module. As you can see, there's not much difference:

# diff -u linux-2.6.2[56]/drivers/edac/i82975x_edac.c 
--- linux-2.6.25/drivers/edac/i82975x_edac.c    2008-04-17
03:49:44.000000000 +0100
+++ linux-2.6.26/drivers/edac/i82975x_edac.c    2008-07-13
22:51:29.000000000 +0100
@@ -14,7 +14,7 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
-
+#include <linux/edac.h>
 #include "edac_core.h"
 
 #define I82975X_REVISION       " Ver: 1.0.0 " __DATE__
@@ -611,6 +611,9 @@
 
        debugf3("%s()\n", __func__);
 
+       /* Ensure that the OPSTATE is set correctly for POLL or NMI */
+       opstate_init();
+
        pci_rc = pci_register_driver(&i82975x_driver);
        if (pci_rc < 0)
                goto fail0;
@@ -664,3 +667,6 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Arvind R. <arvind@acarlab.com>");
 MODULE_DESCRIPTION("MC support for Intel 82975 memory hub
controllers");
+
+module_param(edac_op_state, int, 0444);
+MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state:
0=Poll,1=NMI");


> Are they ALL the same row, or are they different rows? If different, 
> they could be legit. The same row there might be an issue.

Hmm, they're different. On another m/c, I've managed to find the logged
info when it booted up 2.6.26:

/var/log/kern.log.1.gz:Aug  4 11:38:15 diesel kernel: [    9.079151]
EDAC MC0: UE page 0x7fe0b, offset 0x0, grain 128, row 1, labels ":":
i82975x UE
/var/log/kern.log.1.gz:Aug  4 11:38:15 diesel kernel: [   10.104762]
EDAC MC0: UE page 0x7e451, offset 0x0, grain 128, row 1, labels ":":
i82975x UE
/var/log/kern.log.1.gz:Aug  4 11:38:15 diesel kernel: [   11.110256]
EDAC MC0: UE page 0x7e7ae, offset 0x0, grain 128, row 1, labels ":":
i82975x UE
...
/var/log/kern.log.1.gz:Aug  4 11:52:05 diesel kernel: [   11.636753]
EDAC MC0: UE page 0x60000, offset 0x0, grain 128, row 1, labels ":":
i82975x UE
/var/log/kern.log.1.gz:Aug  4 11:52:05 diesel kernel: [   12.641616]
EDAC MC0: UE page 0xde771, offset 0x0, grain 128, row 3, labels ":":
i82975x UE
/var/log/kern.log.1.gz:Aug  4 11:52:05 diesel kernel: [   13.734052]
EDAC MC0: UE page 0xde771, offset 0x0, grain 128, row 3, labels ":":
i82975x UE
/var/log/kern.log.1.gz:Aug  4 11:52:05 diesel kernel: [   14.743449]
EDAC MC0: UE page 0xde771, offset 0x0, grain 128, row 3, labels ":":
i82975x UE

> When properly set by edac-utils
(http://sourceforge.net/projects/edac-utils/) ...

Thanks for the pointer. I've now installed edac-utils on the offending
motherboards. It seems that the motherboard is half known about:

# edac-ctl --mainboard
edac-ctl: mainboard: ASUSTEK COMPUTER INC P5W DH Deluxe
# edac-ctl --print-labels
No dimm labels for ASUSTEK COMPUTER INC P5W DH Deluxe

dmidecode gives some memory module info:

Handle 0x0009, DMI type 6, 12 bytes
Memory Module Information
        Socket Designation: DIMM0
        Bank Connections: 9 11
        Current Speed: 30 ns
        Type: Unknown FPM Parity ECC SDRAM
        Installed Size: 2048 MB (Double-bank Connection)
        Enabled Size: 2048 MB (Double-bank Connection)
        Error Status: OK

Handle 0x000A, DMI type 6, 12 bytes
Memory Module Information
        Socket Designation: DIMM1
        Bank Connections: 9 11
        Current Speed: 30 ns
        Type: Unknown FPM Parity ECC SDRAM
        Installed Size: 2048 MB (Double-bank Connection)
        Enabled Size: 2048 MB (Double-bank Connection)
        Error Status: OK

Handle 0x000B, DMI type 6, 12 bytes
Memory Module Information
        Socket Designation: DIMM2
        Bank Connections: 9 11
        Current Speed: 30 ns
        Type: Unknown FPM Parity ECC SDRAM
        Installed Size: 2048 MB (Double-bank Connection)
        Enabled Size: 2048 MB (Double-bank Connection)
        Error Status: OK

Handle 0x000C, DMI type 6, 12 bytes
Memory Module Information
        Socket Designation: DIMM3
        Bank Connections: 9 11
        Current Speed: 30 ns
        Type: Unknown FPM Parity ECC SDRAM
        Installed Size: 2048 MB (Double-bank Connection)
        Enabled Size: 2048 MB (Double-bank Connection)
        Error Status: OK

> Since I don't have one of these chipsets, is it possible I could
access to one or more of these
machines to take a look around?

Unfortunately not. If there's any commands you'd like me to run, then
please let me know.

If you could let me know what I need to put in /etc/edac/labels.db, that
would be appreciated too.

-- 
Andy, BlueArc Engineering
