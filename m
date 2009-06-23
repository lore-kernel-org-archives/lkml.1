Return-Path: <linux-kernel-owner+w=401wt.eu-S1757696AbZFWVQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696AbZFWVQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757722AbZFWVP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:15:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54363 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757349AbZFWVPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:15:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 05/17] Blackfin: convert to generic checksum code
Date: Tue, 23 Jun 2009 23:14:17 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Michal Simek <monstr@monstr.eu>, Paul Mundt <lethal@linux-sh.org>
References: <1244980878-2124-1-git-send-email-vapier@gentoo.org> <200906191433.34608.arnd@arndb.de> <8bd0f97a0906190612n687cdbbt1e752997acb68e49@mail.gmail.com>
In-Reply-To: <8bd0f97a0906190612n687cdbbt1e752997acb68e49@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200906232314.18261.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18J8VtA/imNlcrUPWDomtGHpeXaVVjEUXfwJo3
 Q0915/yso1KhjMi/pje/AtyMzhe6AVaI2CaYDJZ3LjlDUkeW0z
 D9dAkj8P0omadWuWXwliw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I missed your mail last week and only now stumbled over it after Linus
has pulled my tree.

On Friday 19 June 2009, Mike Frysinger wrote:
> >
> > sounds like a good idea.
> 
> how about the attached

Mostly good, but needs some improvements. At least it helped me
track down the last problem.

> > lib/checksum.c: Fix another endianess bug
> 
> hrm, still not quite :/
> 
> the attached test code shows failures in every case

When I tried running it on x86-64, it only showed failures for
numbers 1, 2 and 4. I fixed them with this patch:
---
lib/checksum: fix one more thinko

When do_csum gets unaligned data, we really need to treat
the first byte as an even byte, not an odd byte, because
we swap the two halves later.

Found by Mike's checksum-selftest module.

Reported-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/lib/checksum.c b/lib/checksum.c
index b08c2d0..0975087 100644
--- a/lib/checksum.c
+++ b/lib/checksum.c
@@ -57,9 +57,9 @@ static unsigned int do_csum(const unsigned char *buff, int len)
 	odd = 1 & (unsigned long) buff;
 	if (odd) {
 #ifdef __LITTLE_ENDIAN
-		result = *buff;
-#else
 		result += (*buff << 8);
+#else
+		result = *buff;
 #endif
 		len--;
 		buff++;
---

>extern unsigned short do_csum(const unsigned char *buff, int len);
>

do_csum is really an internal function. IMHO we should better check
csum_partial(), ip_fast_csum(), csum_fold(), csum_tcpudp_magic()
and ip_compute_csum(), or at least a subset of them.

>static unsigned char __initdata do_csum_data2[] = {
>        0x0d, 0x0a,
>};
>static unsigned char __initdata do_csum_data3[] = {
>        0xff, 0xfb, 0x01,
>};
> ...
>static struct do_csum_data __initdata do_csum_data[] = {
>        DO_CSUM_DATA(1, 0x0020),
>        DO_CSUM_DATA(2, 0xfc00),
>        DO_CSUM_DATA(3, 0x0a0d),
>        DO_CSUM_DATA(5, 0x7fc4),
>        DO_CSUM_DATA(7, 0x7597),
>        DO_CSUM_DATA(255, 0x4f96),
>};

You mixed up do_csum_data2 and do_csum_data3, so they will always
show up as incorrect. Also, the expected checksum is endian-dependent.
The test module should either be modified to expect 0xffff to be
returned in every case, or should use le16_to_cpu(0x0020) etc.

	Arnd <><
