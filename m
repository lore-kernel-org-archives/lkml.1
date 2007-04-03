Return-Path: <linux-kernel-owner+w=401wt.eu-S1030197AbXDCOQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030197AbXDCOQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 10:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030241AbXDCOQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 10:16:34 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:49944 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030197AbXDCOQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 10:16:33 -0400
Date: Tue, 3 Apr 2007 15:55:32 +0200 (CEST)
From: Bernhard Kaindl <bk@suse.de>
To: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <ak@suse.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jan Beulich <jbeulich@novell.com>
Subject: [PATCH 0/4] Fix MTRR suspend support for specific machines (some
 AMD64, maybe others also)
In-Reply-To: <200703291525.59116.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0703301702320.21293@jbgna.fhfr.qr>
References: <Pine.LNX.4.64.0703211730140.2519@jbgna.fhfr.qr>
 <200703272213.51947.ak@suse.de> <Pine.LNX.4.64.0703281155490.17746@jbgna.fhfr.qr>
 <200703291525.59116.ak@suse.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-2092444738-1175270197=:21293"
Content-ID: <Pine.LNX.4.64.0704031551280.7626@jbgna.fhfr.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-2092444738-1175270197=:21293
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <Pine.LNX.4.64.0703301851551.21293@jbgna.fhfr.qr>

Hi,

With at least 3 of the following 4 patches, s2ram and s2disk are
fixed on at least the Acer Ferrari 1000 notebooks and at least
s2disk on the Acer Ferrari 5000 notebooks.

The Acer Ferrari 1000 is a 12" Turion 64 X2 notebook with only 1.7 kg weight
while the Ferrari 5000 is a 14" AMD Turion notebook and a bit older but
still not quite old.

Introduction:
-------------

The memory interface of AMD K8 CPUs supports "Extended fixed-range MTRR
Type-Field Encodings" which allow to specify whether accesses to certain
address ranges are executed by accessing RAM thru the AMD Direct Connect
Architecture or by executing memory-mapped I/O. The associated CPU feature
is called IORR's or I/O Range Registers. This allows e.g. to implement
Shadow RAM by copying ROM contents into RAM.

The BIOS of these Acer AMD Turion 64 notebooks makes use of fixed-range
IORRs to implement shadow RAM and other configurations, and it does
this while it transitions the system into ACPI mode, but Linux is not
prepared for that and breaks the IORRs/MTRRs while suspending, resulting
in errors which look like hardware errors. Symptoms vary from from instant
resets and power-offs to SATA link failures.

References:
http://en.wikipedia.org/wiki/MTRR
http://en.wikipedia.org/wiki/Direct_Connect_Architecture
http://en.wikipedia.org/wiki/Memory-mapped_IO
http://en.wikipedia.org/wiki/Random_access_memory#Shadow_RAM

In-depth problem description:
-----------------------------

AMD introduced this MTRR extension with the AMD64 CPUs which have integrated
memory controllers. In part (fixed-range IORRs for addresses below 1MB), AMD
uses the fixed-range MTRR registers which already configure the address range
below 1MB to implement corresponding IORR bits and calls the resulting
memory access methods in combination with the original Intel-style MTRR
bits "Extended fixed-range MTRR Type-Field Encodings". They are documented
in section 7.8.1 of the "AMD64 Architecture Programmer's Manual Volume 2:
System Programming", starting with page 234:
http://amd.com/us-en/assets/content_type/white_papers_and_tech_docs/24593.pdf

The extended fixed-range type-field encodings are enabled using two
bits in the AMD64-specific SYSCFG MSR (described in detail on page 59).

When the extended fixed-range type-field encodings are enabled, all
fixed-range MTRR fields are defined this way:

  7      5          4                3         2                   0
+--------------------------------------------------------------------+
| reserved | IORR RdMem bit | IORR WrMem bit | Intel-style MTRR bits |
+--------------------------------------------------------------------+

Linux MTRR code does not yet support that the BIOS may change fixed-range
MTRRs and when suspending, this leads Linux MTRR code to clear the IORR bits
for some memory regions. The resulting combination of IORR and Intel-style
MTRR bits is not allowed and causes undefined and unpredictable behaviour
(see the last paragraph before table 7-10).

A possible workaround is to detect the Acer Ferraris through DMI and
don't change the fixed-range MTTRs on them. Linux MTRR code has no
external interface to change fixed-range MTRRs, so no functionality
and no syncronisation (it's broken on the Ferrari 1000 after ACPI
is enabled if no real fix is applied) is lost by this patch:

--- linux/arch/i386/kernel/cpu/mtrr/generic.c
+++ linux/arch/i386/kernel/cpu/mtrr/generic.c
@@ -3,6 +3,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
+#include <linux/dmi.h>
 #include <asm/io.h>
 #include <asm/mtrr.h>
 #include <asm/msr.h>
@@ -149,6 +150,13 @@ static int set_fixed_ranges(mtrr_type *
 	int changed = FALSE;
 	int i;
 	unsigned int lo, hi;
+	char *vendor  = dmi_get_system_info(DMI_SYS_VENDOR);
+	char *product = dmi_get_system_info(DMI_PRODUCT_NAME);
+
+	if (vendor && product && !strncmp(vendor, "Acer", 4) &&
+	    (!strncmp(product, "Ferrari 1000", 12) ||
+	     !strncmp(product, "Ferrari 5000", 12)))
+		return FALSE;

 	rdmsr(MTRRfix64K_00000_MSR, lo, hi);
 	if (p[0] != lo || p[1] != hi) {

As DMI is defined "y" on i386 and x86_64 and x86_64 is the only $ARCH
which includes $TOPDIR/arch/i386/kernel/cpu/mtrr, DMI checks can be
done without #ifdef CONFIG_DMI. It's a possible hack for older kernels.

But do we want that workaround also for upstream?

The changes which fix the issues themselfes (and properly work around the
lazyness or "limits" of the BIOS) are a bit more complicated, and need
at least 3 of the following 4 patches. Linux MTRR code is well-trained
in correcting broken BIOS MTRR settings, so from that history, I think
it is good routine to continue that tradition. In this case, most of
what the BIOS does is not broken by design, but just not supported
by Linux yet. The only bug is that the BIOS does not initialize the
2nd core with the same MTRRs that the Boot CPU has after it has enabled
ACPI mode. Linux MTRR code has already mechanisms in place to fix such
BIOS issues, they just need to be extended to also work in circumstances
like those found on the Ferraris.

State of Linux fixed-range MTRR code and changes done by the patches
--------------------------------------------------------------------

Currently, we only get the state of fixed-range MTRRs eary at boot,
before ACPI is enabled. This information is outdated later after
ACPI mode has been activated in the Ferraris.

At least when we suspend the system, we need to have our backup of
the fixed-range MTRRs in sync with the fixed-range MTRRs which are
currently in force.

The first patch provides a function (mtrr_save_fixed_ranges) to
save the current state of the fixed-range MTRRs.

The second patch calls mtrr_save_fixed_ranges() before the non-boot
CPUs are booted. At these times, ACPI is already initialized and the
Ferrari BIOSes changed the MTRRs already, so the new CPUs are then
always initialized with the current fixed-range MTRR of the boot CPU.

Alternatively, or in addition, it might be a good idea to save
the current state of the fixed-range MTRRs of the boot CPU before
suspending to capture any change of the fixed-range MTRRs which
may potentially have occurred after the last secondary CPU has
been booted. That is what the third patch does.

The fourth patch is AMD64-specific and adds support for keeping
the fixed-range MTRRS in sync across CPUs if some fixed-range IORR
bits are set on the boot CPU. If no fixed-range IORR bit is set,
there is no need to enable the support for "Extended fixed-range
type-field encodings" because the access mode only changes if
these bits are set, otherwise, we do not need to enable them.

Best Regards,
Bernhard Kaindl

PS: I attached a program which uses msr.ko (CONFIG_X86_MSR) from
 Processor type and features
     -> [M/*] /dev/cpu/*/msr - Model-specific register support
to dump the contents of the fixed-range MTTRs to stdout.

On a two-CPU system, the output format looks like this:

MSR 0x250: 1e1e1e1e1e1e1e1e | 0606060606060606 |
MSR 0x258: 1e1e1e1e1e1e1e1e | 0606060606060606 |
MSR 0x259: 0000000000000000 | 0000000000000000 |
MSR 0x268: 1515151515151515 | 0505050505050505 |
MSR 0x269: 1515151515151515 | 0505050505050505 |
MSR 0x26a: 0000000000000000 | 0000000000000000 |
MSR 0x26b: 0000000000000000 | 0000000000000000 |
MSR 0x26c: 1515151500000000 | 0505050500000000 |
MSR 0x26d: 1515151515151515 | 0505050505050505 |
MSR 0x26e: 1515151515151515 | 0505050505050505 |
MSR 0x26f: 1515151515151515 | 0505050505050505 |

This dump comes from the Ferrari 1000, where the 2nd core uses the
same Intel-style MTRR values as the 1st core, but the 1st core has
the AMD64 IORR bits set in many places.

On suspend, 2.6.20 sets all of them to 0, making the dump look like
the dump of the second core, and shortly afterwards, the problems
start. To have a sane MTRR setup the MTRRs of the CPUs should always
match, but this has so far not lead to problems, it seems. However,
Intel and AMD manuals tell us to keep MTRRs in sync for good reasons.
--168427776-2092444738-1175270197=:21293
Content-Type: TEXT/X-CSRC; CHARSET=US-ASCII; NAME=print_fixed_range_mttrs.c
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0703301756370.21293@jbgna.fhfr.qr>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME=print_fixed_range_mttrs.c

LyoNDQogKiBUZXN0IHByb2dyYW0gZm9yIHJlYWRpbmcgY3VycmVudCBNVFJS
IHZhbHVlcw0NCiAqDQ0KICoJKEMpIDIwMDcgQmVybmhhcmQgS2FpbmRsDQ0K
ICoJKEMpIDIwMDAgRGF2ZSBKb25lcywgQXJqYW4gdmFuIGRlIFZlbi4NDQog
Ki8NDQoNDQojaW5jbHVkZSA8c3RkaW8uaD4NDQojaW5jbHVkZSA8dW5pc3Rk
Lmg+DQ0KDQ0KLyogIHJkbXNyIC0gcmVhZCBNU1IsIHRha2VuIGZyb20gUG93
ZXJ0d2VhayBMaW51eA0NCiAqCShDKSAyMDAwIERhdmUgSm9uZXMsIEFyamFu
IHZhbiBkZSBWZW4uDQ0KICogCUxpY2Vuc2VkIHVuZGVyIHRoZSB0ZXJtcyBv
ZiB0aGUgR05VIEdQTCBMaWNlbnNlIHZlcnNpb24gMi4NDQogKi8NDQppbnQg
cmRtc3IoaW50IGNwdSwgdW5zaWduZWQgbG9uZyBtc3JpbmRleCwgdW5zaWdu
ZWQgbG9uZyBsb25nICp2YWwpDQ0Kew0NCgljaGFyIGNwdW5hbWVbMzZdOw0N
CglpbnQgZmgsIHJldDsNDQoNDQoJc25wcmludGYgKGNwdW5hbWUsMTUsICIv
ZGV2L2NwdS8lZC9tc3IiLCBjcHUpOw0NCg0NCglmaCA9IG9wZW4gKGNwdW5h
bWUsIDApOw0NCg0NCglpZiAoZmg9PS0xKQ0NCgkJcmV0ID0gLTE7DQ0KCWVs
c2Ugew0NCgkJbHNlZWsgKGZoLCBtc3JpbmRleCwgU0VFS19TRVQpOw0NCgkJ
cmV0ID0gKHJlYWQgKGZoLCB2YWwsIDgpID09IDgpOw0NCgkJY2xvc2UgKGZo
KTsNDQoJfQ0NCglyZXR1cm4gcmV0Ow0NCn0NDQoNDQppbnQgcHJpbnRfbXNy
X2NwdShpbnQgY3B1LCBpbnQgcmVnKQ0NCnsNDQoJdW5zaWduZWQgbG9uZyBs
b25nIHZhbDsNDQoJaW50IHJldDsNDQoNDQoJaWYgKChyZXQgPSByZG1zcihj
cHUsIHJlZywgJnZhbCkpID4gMCkNDQoJCXByaW50ZigiJTAxNmxseCIsIHZh
bCk7DQ0KCXJldHVybiByZXQ7DQ0KfQ0NCg0NCnByaW50X21zcihpbnQgcmVn
KQ0NCnsNDQoJaW50IGkgPSAxLCBjcHUgPSAwOw0NCglwcmludGYoIk1TUiAw
eCUwM3g6ICIsIHJlZyk7DQ0KDQ0KCWlmIChwcmludF9tc3JfY3B1KGNwdSsr
LCByZWcpIDw9IDApDQ0KCQlwcmludGYoInJlYWQgZXJyb3IgLSBJcyBtc3Iu
a28gbG9hZGVkIGFuZCBhcmUgdGhlIGRldmljZXMgY3JlYXRlZD9cbiIpOw0N
Cg0NCgl3aGlsZSAoY3B1IDwgMTYpIHsNDQoJCXByaW50ZigiIHwgIik7DQ0K
CQlpZiAocHJpbnRfbXNyX2NwdShjcHUrKywgcmVnKSA8PSAwKQ0NCgkJCWJy
ZWFrOw0NCgl9DQ0KDQ0KCXByaW50ZigiXG4iKTsNDQp9DQ0KDQ0KbWFpbigp
IHsNDQoJaW50IGk7DQ0KDQ0KCXByaW50X21zcigweDI1MCk7DQ0KCXByaW50
X21zcigweDI1OCk7DQ0KCXByaW50X21zcigweDI1OSk7DQ0KCWZvciAoaT0w
eDI2ODsgaTwweDI3MDsgaSsrKQ0NCgkJcHJpbnRfbXNyKGkpOw0NCn0NDQo=

--168427776-2092444738-1175270197=:21293--
