Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbYI3L3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbYI3L3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 07:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbYI3L3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 07:29:48 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:53774 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752545AbYI3L3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 07:29:47 -0400
Date: Tue, 30 Sep 2008 13:29:44 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Jan Beulich <jbeulich@novell.com>, Andy Whitcroft <apw@shadowen.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] checkpatch: Check for %L for all integer formats (was: Re:
 [PATCH] fix printk format compiler warnings)
In-Reply-To: <48C13CE0.76E4.0078.0@novell.com>
Message-ID: <Pine.LNX.4.64.0809301314270.6954@vixen.sonytel.be>
References: <48C13CE0.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1569103459-1222773675=:6954"
Content-ID: <Pine.LNX.4.64.0809301323240.6954@vixen.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1569103459-1222773675=:6954
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0809301323241.6954@vixen.sonytel.be>

On Fri, 5 Sep 2008, Jan Beulich wrote:
> %llx and the like cannot be used on u64-derived data types - they must
> be cast to long long explicitly for arch-es where u64 is a typedef of
> unsigned long (ia64 is where I observed the problem).

> -		printk(KERN_INFO "PCI: bridge %s io port: [%llx, %llx]\n", pci_name(dev), res->start, res->end);
> +		printk(KERN_INFO "PCI: bridge %s io port: [%Lx, %Lx]\n",

> -		printk(KERN_INFO "PCI: bridge %s 32bit mmio: [%llx, %llx]\n", pci_name(dev), res->start, res->end);
> +		printk(KERN_INFO "PCI: bridge %s 32bit mmio: [%Lx, %Lx]\n",

> -		printk(KERN_INFO "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n", pci_name(dev), (res->flags & PCI_PREF_RANGE_TYPE_64)?"64":"32",res->start, res->end);
> +		printk(KERN_INFO "PCI: bridge %s %dbit mmio pref: [%Lx, %Lx]\n",

> -		printk(KERN_INFO "bus: %02x index %x %s: [%llx, %llx]\n", bus->number, i, (res->flags & IORESOURCE_IO)? "io port":"mmio", res->start, res->end);
> +		printk(KERN_INFO "bus: %02x index %x %s: [%Lx, %Lx]\n",

Why did you replace `%ll' by `%L'?

While `L' is used as an internal flag in Linux' vsnprintf() implementation and
is still supported because of historical (pre-C99) reasons, the `L' conversion
qualifier is meant for the `long double' floating point type, as per C99.
The recommended conversion qualifier for the `long long' integer type is `ll'.

Perhaps checkpatch should check for this? Ah, it already does for some of the
integer formats. The patch below adds checks for the missing ones.

Subject: [PATCH] checkpatch: Check for %L for all integer formats

Checkpatch checks for the use of the non-standard `L' conversion qualifier for
some (`u', `d', and `i') of the 6 integers formats.  Add the missing ones
(`o', `x', and `X'), and keep the list sorted.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bc67793..92cbf5e 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2277,12 +2277,12 @@ sub process {
 			WARN("usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc\n" . $herecurr);
 		}
 
-# check for %L{u,d,i} in strings
+# check for %L{d,i,o,u,x,X} in strings
 		my $string;
 		while ($line =~ /(?:^|")([X\t]*)(?:"|$)/g) {
 			$string = substr($rawline, $-[1], $+[1] - $-[1]);
-			if ($string =~ /(?<!%)%L[udi]/) {
-				WARN("\%Ld/%Lu are not-standard C, use %lld/%llu\n" . $herecurr);
+			if ($string =~ /(?<!%)%L[diouxX]/) {
+				WARN("\%L[diouxX] are not-standard C, use %ll[diouxX]\n" . $herecurr);
 				last;
 			}
 		}


With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-1569103459-1222773675=:6954--
