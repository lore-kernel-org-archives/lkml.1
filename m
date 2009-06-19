Return-Path: <linux-kernel-owner+w=401wt.eu-S1755347AbZFSJHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbZFSJHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 05:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbZFSJG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 05:06:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54850 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbZFSJG4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 05:06:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 05/17] Blackfin: convert to generic checksum code
Date: Fri, 19 Jun 2009 11:05:37 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Michal Simek <monstr@monstr.eu>, Paul Mundt <lethal@linux-sh.org>
References: <1244980878-2124-1-git-send-email-vapier@gentoo.org> <200906151304.16416.arnd@arndb.de> <8bd0f97a0906181819u25df402fxfd535030fd180e87@mail.gmail.com>
In-Reply-To: <8bd0f97a0906181819u25df402fxfd535030fd180e87@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <200906191105.37732.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19jk/rdJyrdXNGOj4fC89of0acGMFTKfXymjKU
 qgzGYQ5vGf7K+Z6k0UGW3Hp0xfUQsizRD5tgQWSKahQOVB4vac
 mN37odhKpka/jD8Ayb+Ww==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 June 2009, Mike Frysinger wrote:
> On Mon, Jun 15, 2009 at 07:04, Arnd Bergmann wrote:
> > On Sunday 14 June 2009, Mike Frysinger wrote:
> >> The Blackfin port only implemented an optimized version of the
> >> csum_tcpudp_nofold function, so convert everything else to the new
> >> generic code.
> >>
> >> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> >
> > Have you tested this one well? I was as careful as possible with the
> > version I added, but it was basically only tested on microblaze, which
> > has a different endianess from blackfin. Some areas of the code may be
> > sensitive to this.
> 
> i did some tests and it looks like do_csum() is broken :(

Thanks for testing. Indeed it turns out to be an endian-problem with
the handling of the last byte:

> here's the input:
> do_csum({ 0xff 0xfb 0x01 }, 3)
> 
> and here's the output:
> Blackfin: 0xfc00
> generic: 0xfcff
>
> if i run the two funcs on my x86, i see similar behavior.  the
> attached csum-test.c contains the csum code from lib/checksum.c and
> arch/blackfin/lib/checksum.c and shows the problem.

x86 and blackfin are both little-endian, so your variant is correct
there. They add the 0x01 to the low byte of the 16-bit word, while
on big-endian machines, you have to add it to the high byte.

> -mike
> csum-test.c
>   #include <stdio.h>
> 
> static inline unsigned short gen_from32to16(unsigned long x)
> {
>         /* add up 16-bit and 16-bit for 16+c bit */
>         x = (x & 0xffff) + (x >> 16);
>         /* add up carry.. */
>         x = (x & 0xffff) + (x >> 16);
>         return x;
> }
> 
> static unsigned int gen_do_csum(const unsigned char *buff, int len)
> {
> ...
>         if (len & 1)
>                 result += (*buff << 8);

On little-endian, this needs to be

	if (len & 1)
		result += *buff;

> static unsigned short bf_do_csum(const unsigned char *buff, int len)
> {
> ...
>         if (len > 0)
>                 sum += *buff;

Same problem, on big-endian this would need to be
	if (len > 0)
		sum += (*buff << 8);

The bug potentially also exists in arch/sh/lib64/c-checksum.c, which only
works on little-endian machines, while the sh architecture code appears
dual-endian. Paul, is your lib64/c-checksum.c implementation potentially
run on big-endian machines, or is sh64 guaranteed to be little-endian?

I've committed the patch below now.

	Arnd <><

---
>From e01fed86629737809c46dcb8b807347e84640b70 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 19 Jun 2009 10:41:19 +0200
Subject: [PATCH] lib/checksum.c: fix endianess bug

The new generic checksum code has a small dependency on endianess and
worked only on big-endian systems. I could not find a nice efficient
way to express this, so I added an #ifdef. Using
'result += le16_to_cpu(*buff);' would have worked as well, but
would be slightly less efficient on big-endian systems and IMHO
would not be clearer.

Also fix a bug that prevents this from working on 64-bit machines.
If you have a 64-bit CPU and want to use the generic checksum
code, you should probably do some more optimizations anyway, but
at least the code should not break.

Reported-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 lib/checksum.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/lib/checksum.c b/lib/checksum.c
index 12e5a1c..4a1c84a 100644
--- a/lib/checksum.c
+++ b/lib/checksum.c
@@ -71,7 +71,7 @@ static unsigned int do_csum(const unsigned char *buff, int len)
 		if (count) {
 			unsigned long carry = 0;
 			do {
-				unsigned long w = *(unsigned long *) buff;
+				unsigned long w = *(unsigned int *) buff;
 				count--;
 				buff += 4;
 				result += carry;
@@ -87,7 +87,11 @@ static unsigned int do_csum(const unsigned char *buff, int len)
 		}
 	}
 	if (len & 1)
+#ifdef __LITTLE_ENDIAN
+		result += *buff;
+#else
 		result += (*buff << 8);
+#endif
 	result = from32to16(result);
 	if (odd)
 		result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);
-- 
1.6.3.1

