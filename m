Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbXLaSVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbXLaSVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 13:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbXLaSVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 13:21:07 -0500
Received: from cvs.mpc-ogw.co.uk ([81.2.99.171]:8402 "EHLO
	molson.mpc-data.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752225AbXLaSVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 13:21:05 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C84BD9.E44304A0"
Subject: RE: [PATCH] sh: sh7712 clock support
Date: Mon, 31 Dec 2007 18:20:58 -0000
Message-ID: <0C997DD87CC88A4F86C897F52650B52B820E90@MOLSON.mpc-data.co.uk>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] sh: sh7712 clock support
Thread-Index: AchLzTuBXmotET3sThOezujnCrlqHQADDoRA
From: "Andrew Murray" <amurray@mpc-data.co.uk>
To: "Paul Mundt" <lethal@linux-sh.org>
Cc: <linux-sh@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C84BD9.E44304A0
Content-Type: text/plain;
	charset="windows-1250"
Content-Transfer-Encoding: quoted-printable

Hello,

Yes you are correct. Here is an updated patch. Happy New Year.

---
From: Andrew Murray <amurray@mpc-data.co.uk>

This patch provides specific clock support for the SH7712. (This is my =
first ever patch, so apologies if I've not followed the procedure =
correctly!)

Signed-off-by: Andrew Murray <amurray@mpc-data.co.uk>
---
diff -uprN -x sh-2.6/Documentation/dontdiff =
sh-2.6/arch/sh/kernel/cpu/sh3/clock-sh7712.c =
sh-2.6-devel/arch/sh/kernel/cpu/sh3/clock-sh7712.c
--- sh-2.6/arch/sh/kernel/cpu/sh3/clock-sh7712.c	1970-01-01 =
01:00:00.000000000 +0100
+++ sh-2.6-devel/arch/sh/kernel/cpu/sh3/clock-sh7712.c	2007-12-31 =
15:04:51.000000000 +0000
@@ -0,0 +1,71 @@
+/*
+ * arch/sh/kernel/cpu/sh3/clock-sh7712.c
+ *
+ * SH7712 support for the clock framework
+ *
+ *  Copyright (C) 2007  Andrew Murray <amurray@mpc-data.co.uk>
+ *
+ * Based on arch/sh/kernel/cpu/sh3/clock-sh3.c
+ *  Copyright (C) 2005  Paul Mundt
+ *
+ * This file is subject to the terms and conditions of the GNU General =
Public
+ * License.  See the file "COPYING" in the main directory of this =
archive
+ * for more details.
+ */
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <asm/clock.h>
+#include <asm/freq.h>
+#include <asm/io.h>
+
+static int multipliers[] =3D { 1, 2, 3 };
+static int divisors[]    =3D { 1, 2, 3, 4, 6 };
+
+static void master_clk_init(struct clk *clk)
+{
+	int frqcr =3D ctrl_inw(FRQCR);
+	int idx =3D (frqcr & 0x0300) >> 8;
+
+	clk->rate *=3D multipliers[idx];
+}
+
+static struct clk_ops sh7712_master_clk_ops =3D {
+	.init		=3D master_clk_init,
+};
+
+static void module_clk_recalc(struct clk *clk)
+{
+	int frqcr =3D ctrl_inw(FRQCR);
+	int idx =3D frqcr & 0x0007;
+
+	clk->rate =3D clk->parent->rate / divisors[idx];
+}
+
+static struct clk_ops sh7712_module_clk_ops =3D {
+	.recalc		=3D module_clk_recalc,
+};
+
+static void cpu_clk_recalc(struct clk *clk)
+{
+	int frqcr =3D ctrl_inw(FRQCR);
+	int idx =3D (frqcr & 0x0030) >> 4;
+
+	clk->rate =3D clk->parent->rate / divisors[idx];
+}
+
+static struct clk_ops sh7712_cpu_clk_ops =3D {
+	.recalc		=3D cpu_clk_recalc,
+};
+
+static struct clk_ops *sh7712_clk_ops[] =3D {
+	&sh7712_master_clk_ops,
+	&sh7712_module_clk_ops,
+	&sh7712_cpu_clk_ops,
+};
+
+void __init arch_init_clk_ops(struct clk_ops **ops, int idx)
+{
+	if (idx < ARRAY_SIZE(sh7712_clk_ops))
+		*ops =3D sh7712_clk_ops[idx];
+}
+
diff -uprN -x sh-2.6/Documentation/dontdiff =
sh-2.6/arch/sh/kernel/cpu/sh3/Makefile =
sh-2.6-devel/arch/sh/kernel/cpu/sh3/Makefile
--- sh-2.6/arch/sh/kernel/cpu/sh3/Makefile	2007-12-31 14:47:32.000000000 =
+0000
+++ sh-2.6-devel/arch/sh/kernel/cpu/sh3/Makefile	2007-12-31 =
15:01:15.000000000 +0000
@@ -22,5 +22,6 @@ clock-$(CONFIG_CPU_SUBTYPE_SH7706)	:=3D cl
 clock-$(CONFIG_CPU_SUBTYPE_SH7709)	:=3D clock-sh7709.o
 clock-$(CONFIG_CPU_SUBTYPE_SH7710)	:=3D clock-sh7710.o
 clock-$(CONFIG_CPU_SUBTYPE_SH7720)	:=3D clock-sh7710.o
+clock-$(CONFIG_CPU_SUBTYPE_SH7712)	:=3D clock-sh7712.o
=20
 obj-y	+=3D $(clock-y)
diff -uprN -x sh-2.6/Documentation/dontdiff =
sh-2.6/include/asm-sh/cpu-sh3/freq.h =
sh-2.6-devel/include/asm-sh/cpu-sh3/freq.h
--- sh-2.6/include/asm-sh/cpu-sh3/freq.h	2007-12-31 14:47:47.000000000 =
+0000
+++ sh-2.6-devel/include/asm-sh/cpu-sh3/freq.h	2007-12-31 =
15:02:30.000000000 +0000
@@ -10,7 +10,12 @@
 #ifndef __ASM_CPU_SH3_FREQ_H
 #define __ASM_CPU_SH3_FREQ_H
=20
+#ifdef CONFIG_CPU_SUBTYPE_SH7712
+#define FRQCR			0xA415FF80
+#else
 #define FRQCR			0xffffff80
+#endif
+
 #define MIN_DIVISOR_NR		0
 #define MAX_DIVISOR_NR		4


-----Original Message-----
From: Paul Mundt [mailto:lethal@linux-sh.org]=20
Sent: 31 December 2007 16:50
To: Andrew Murray
Cc: linux-sh@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sh: sh7712 clock support

On Mon, Dec 31, 2007 at 04:32:25PM -0000, Andrew Murray wrote:
> +static void bus_clk_init(struct clk *clk)
> +{
> +	clk->rate =3D CONFIG_SH_PCLK_FREQ;
> +}
> +
> +static struct clk_ops sh7712_bus_clk_ops =3D {
> +	.init		=3D bus_clk_init,
> +};
> +
This shouldn't be necessary, the bus clk already references the master
clk as its parent, and inherits the rate from there. If you have no
recalc work to do, then you should be able to just leave this out
altogether. If you actually need this dummy init, then something is
broken with the upper layer, which we should fix ;-)

Patch looks fine otherwise. Tidy this up and I'll apply it.


Internal Virus Database is out-of-date.
Checked by AVG Free Edition.=20
Version: 7.5.516 / Virus Database: 269.17.8 - Release Date: 24/12/2007 =
00:00
=20

Internal Virus Database is out-of-date.
Checked by AVG Free Edition.=20
Version: 7.5.516 / Virus Database: 269.17.8 - Release Date: 24/12/2007 =
00:00
=20
 =20

------_=_NextPart_001_01C84BD9.E44304A0
Content-Type: application/octet-stream;
	name="sh7712clocksupportpatch2"
Content-Transfer-Encoding: base64
Content-Description: sh7712clocksupportpatch2
Content-Disposition: attachment;
	filename="sh7712clocksupportpatch2"

ZGlmZiAtdXByTiAteCBzaC0yLjYvRG9jdW1lbnRhdGlvbi9kb250ZGlmZiBzaC0yLjYvYXJjaC9z
aC9rZXJuZWwvY3B1L3NoMy9jbG9jay1zaDc3MTIuYyBzaC0yLjYtZGV2ZWwvYXJjaC9zaC9rZXJu
ZWwvY3B1L3NoMy9jbG9jay1zaDc3MTIuYwotLS0gc2gtMi42L2FyY2gvc2gva2VybmVsL2NwdS9z
aDMvY2xvY2stc2g3NzEyLmMJMTk3MC0wMS0wMSAwMTowMDowMC4wMDAwMDAwMDAgKzAxMDAKKysr
IHNoLTIuNi1kZXZlbC9hcmNoL3NoL2tlcm5lbC9jcHUvc2gzL2Nsb2NrLXNoNzcxMi5jCTIwMDct
MTItMzEgMTU6MDQ6NTEuMDAwMDAwMDAwICswMDAwCkBAIC0wLDAgKzEsNzEgQEAKKy8qCisgKiBh
cmNoL3NoL2tlcm5lbC9jcHUvc2gzL2Nsb2NrLXNoNzcxMi5jCisgKgorICogU0g3NzEyIHN1cHBv
cnQgZm9yIHRoZSBjbG9jayBmcmFtZXdvcmsKKyAqCisgKiAgQ29weXJpZ2h0IChDKSAyMDA3ICBB
bmRyZXcgTXVycmF5IDxhbXVycmF5QG1wYy1kYXRhLmNvLnVrPgorICoKKyAqIEJhc2VkIG9uIGFy
Y2gvc2gva2VybmVsL2NwdS9zaDMvY2xvY2stc2gzLmMKKyAqICBDb3B5cmlnaHQgKEMpIDIwMDUg
IFBhdWwgTXVuZHQKKyAqCisgKiBUaGlzIGZpbGUgaXMgc3ViamVjdCB0byB0aGUgdGVybXMgYW5k
IGNvbmRpdGlvbnMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYworICogTGljZW5zZS4gIFNlZSB0
aGUgZmlsZSAiQ09QWUlORyIgaW4gdGhlIG1haW4gZGlyZWN0b3J5IG9mIHRoaXMgYXJjaGl2ZQor
ICogZm9yIG1vcmUgZGV0YWlscy4KKyAqLworI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4KKyNpbmNs
dWRlIDxsaW51eC9rZXJuZWwuaD4KKyNpbmNsdWRlIDxhc20vY2xvY2suaD4KKyNpbmNsdWRlIDxh
c20vZnJlcS5oPgorI2luY2x1ZGUgPGFzbS9pby5oPgorCitzdGF0aWMgaW50IG11bHRpcGxpZXJz
W10gPSB7IDEsIDIsIDMgfTsKK3N0YXRpYyBpbnQgZGl2aXNvcnNbXSAgICA9IHsgMSwgMiwgMywg
NCwgNiB9OworCitzdGF0aWMgdm9pZCBtYXN0ZXJfY2xrX2luaXQoc3RydWN0IGNsayAqY2xrKQor
eworCWludCBmcnFjciA9IGN0cmxfaW53KEZSUUNSKTsKKwlpbnQgaWR4ID0gKGZycWNyICYgMHgw
MzAwKSA+PiA4OworCisJY2xrLT5yYXRlICo9IG11bHRpcGxpZXJzW2lkeF07Cit9CisKK3N0YXRp
YyBzdHJ1Y3QgY2xrX29wcyBzaDc3MTJfbWFzdGVyX2Nsa19vcHMgPSB7CisJLmluaXQJCT0gbWFz
dGVyX2Nsa19pbml0LAorfTsKKworc3RhdGljIHZvaWQgbW9kdWxlX2Nsa19yZWNhbGMoc3RydWN0
IGNsayAqY2xrKQoreworCWludCBmcnFjciA9IGN0cmxfaW53KEZSUUNSKTsKKwlpbnQgaWR4ID0g
ZnJxY3IgJiAweDAwMDc7CisKKwljbGstPnJhdGUgPSBjbGstPnBhcmVudC0+cmF0ZSAvIGRpdmlz
b3JzW2lkeF07Cit9CisKK3N0YXRpYyBzdHJ1Y3QgY2xrX29wcyBzaDc3MTJfbW9kdWxlX2Nsa19v
cHMgPSB7CisJLnJlY2FsYwkJPSBtb2R1bGVfY2xrX3JlY2FsYywKK307CisKK3N0YXRpYyB2b2lk
IGNwdV9jbGtfcmVjYWxjKHN0cnVjdCBjbGsgKmNsaykKK3sKKwlpbnQgZnJxY3IgPSBjdHJsX2lu
dyhGUlFDUik7CisJaW50IGlkeCA9IChmcnFjciAmIDB4MDAzMCkgPj4gNDsKKworCWNsay0+cmF0
ZSA9IGNsay0+cGFyZW50LT5yYXRlIC8gZGl2aXNvcnNbaWR4XTsKK30KKworc3RhdGljIHN0cnVj
dCBjbGtfb3BzIHNoNzcxMl9jcHVfY2xrX29wcyA9IHsKKwkucmVjYWxjCQk9IGNwdV9jbGtfcmVj
YWxjLAorfTsKKworc3RhdGljIHN0cnVjdCBjbGtfb3BzICpzaDc3MTJfY2xrX29wc1tdID0gewor
CSZzaDc3MTJfbWFzdGVyX2Nsa19vcHMsCisJJnNoNzcxMl9tb2R1bGVfY2xrX29wcywKKwkmc2g3
NzEyX2NwdV9jbGtfb3BzLAorfTsKKwordm9pZCBfX2luaXQgYXJjaF9pbml0X2Nsa19vcHMoc3Ry
dWN0IGNsa19vcHMgKipvcHMsIGludCBpZHgpCit7CisJaWYgKGlkeCA8IEFSUkFZX1NJWkUoc2g3
NzEyX2Nsa19vcHMpKQorCQkqb3BzID0gc2g3NzEyX2Nsa19vcHNbaWR4XTsKK30KKwpkaWZmIC11
cHJOIC14IHNoLTIuNi9Eb2N1bWVudGF0aW9uL2RvbnRkaWZmIHNoLTIuNi9hcmNoL3NoL2tlcm5l
bC9jcHUvc2gzL01ha2VmaWxlIHNoLTIuNi1kZXZlbC9hcmNoL3NoL2tlcm5lbC9jcHUvc2gzL01h
a2VmaWxlCi0tLSBzaC0yLjYvYXJjaC9zaC9rZXJuZWwvY3B1L3NoMy9NYWtlZmlsZQkyMDA3LTEy
LTMxIDE0OjQ3OjMyLjAwMDAwMDAwMCArMDAwMAorKysgc2gtMi42LWRldmVsL2FyY2gvc2gva2Vy
bmVsL2NwdS9zaDMvTWFrZWZpbGUJMjAwNy0xMi0zMSAxNTowMToxNS4wMDAwMDAwMDAgKzAwMDAK
QEAgLTIyLDUgKzIyLDYgQEAgY2xvY2stJChDT05GSUdfQ1BVX1NVQlRZUEVfU0g3NzA2KQk6PSBj
bAogY2xvY2stJChDT05GSUdfQ1BVX1NVQlRZUEVfU0g3NzA5KQk6PSBjbG9jay1zaDc3MDkubwog
Y2xvY2stJChDT05GSUdfQ1BVX1NVQlRZUEVfU0g3NzEwKQk6PSBjbG9jay1zaDc3MTAubwogY2xv
Y2stJChDT05GSUdfQ1BVX1NVQlRZUEVfU0g3NzIwKQk6PSBjbG9jay1zaDc3MTAubworY2xvY2st
JChDT05GSUdfQ1BVX1NVQlRZUEVfU0g3NzEyKQk6PSBjbG9jay1zaDc3MTIubwogCiBvYmoteQkr
PSAkKGNsb2NrLXkpCmRpZmYgLXVwck4gLXggc2gtMi42L0RvY3VtZW50YXRpb24vZG9udGRpZmYg
c2gtMi42L2luY2x1ZGUvYXNtLXNoL2NwdS1zaDMvZnJlcS5oIHNoLTIuNi1kZXZlbC9pbmNsdWRl
L2FzbS1zaC9jcHUtc2gzL2ZyZXEuaAotLS0gc2gtMi42L2luY2x1ZGUvYXNtLXNoL2NwdS1zaDMv
ZnJlcS5oCTIwMDctMTItMzEgMTQ6NDc6NDcuMDAwMDAwMDAwICswMDAwCisrKyBzaC0yLjYtZGV2
ZWwvaW5jbHVkZS9hc20tc2gvY3B1LXNoMy9mcmVxLmgJMjAwNy0xMi0zMSAxNTowMjozMC4wMDAw
MDAwMDAgKzAwMDAKQEAgLTEwLDcgKzEwLDEyIEBACiAjaWZuZGVmIF9fQVNNX0NQVV9TSDNfRlJF
UV9ICiAjZGVmaW5lIF9fQVNNX0NQVV9TSDNfRlJFUV9ICiAKKyNpZmRlZiBDT05GSUdfQ1BVX1NV
QlRZUEVfU0g3NzEyCisjZGVmaW5lIEZSUUNSCQkJMHhBNDE1RkY4MAorI2Vsc2UKICNkZWZpbmUg
RlJRQ1IJCQkweGZmZmZmZjgwCisjZW5kaWYKKwogI2RlZmluZSBNSU5fRElWSVNPUl9OUgkJMAog
I2RlZmluZSBNQVhfRElWSVNPUl9OUgkJNAogCg==

------_=_NextPart_001_01C84BD9.E44304A0--
