Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbZFSMfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbZFSMfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 08:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbZFSMfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 08:35:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:64420 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbZFSMe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 08:34:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 05/17] Blackfin: convert to generic checksum code
Date: Fri, 19 Jun 2009 14:33:33 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Michal Simek <monstr@monstr.eu>, Paul Mundt <lethal@linux-sh.org>
References: <1244980878-2124-1-git-send-email-vapier@gentoo.org> <200906191105.37732.arnd@arndb.de> <8bd0f97a0906190342s4261e85di9aa746058cbef9be@mail.gmail.com>
In-Reply-To: <8bd0f97a0906190342s4261e85di9aa746058cbef9be@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200906191433.34608.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+++dskiKoZqH0Ll3cCTzs9uUPYhYxBmdS8uiH
 eOTZnZP0pbgCp1WSTLXVLgnf3AKXgjtPqrMaPnsHURHjgOQXIL
 g3vX3EBjKBhNrdjqo0DdeChQ9VIV3og
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 June 2009, Mike Frysinger wrote:
> On Fri, Jun 19, 2009 at 05:05, Arnd Bergmann wrote:
> > x86 and blackfin are both little-endian, so your variant is correct
> > there. They add the 0x01 to the low byte of the 16-bit word, while
> > on big-endian machines, you have to add it to the high byte.
> 
> can we think of enough simple examples to through together an optional
> boot-time self test ?

sounds like a good idea.

> > I've committed the patch below now.
> 
> closer, but not quite just yet ...
> do_csum: mismatch 0x1700 != 0xa0d len:2
> do_csum: {  0xd, 0xa }

I've compared the code again with Paul's sh version and found another
difference in the handling of unaligned data.

> when do_csum does return correct values, csum_partial sometimes does not:
> csum_partial: mismatch 0x1101eefe != 0xffff len:32
> csum_partial: {  0x92, 0x3b, 0x0, 0x17, 0xcf, 0xc1, 0x90, 0xec, 0x1c,
> 0x3f, 0xff, 0x99, 0x80, 0x10, 0x0, 0x5c, 0x22, 0xfa, 0x0, 0x0, 0x1,
> 0x1, 0x8, 0xa, 0x6, 0x83, 0xdd, 0x50, 0xff, 0xfe, 0xdf, 0x58 }

That looks like it's both valid output. csum_partial returns a 32 bit
value that always needs to get passed to csum_fold in order to get
checked. 0x1101eefe and 0xffff both evaluate to 0xffff in csum_fold,
so this would just be an implementation detail, not a bug.

> btw, would it make sense to change do_csum like so:
> -static unsigned int do_csum(const unsigned char *buff, int len)
> +__weak unsigned int do_csum(const unsigned char *buff, int len)
> 
> after all, it looks like that's really the function most arches would
> want to hand optimize.  all the rest are simple standard wrappers are
> do_csum().  forcing an arch to copy & paste all the other functions
> just so they can implement an optimized do_csum() seems pretty
> unfriendly.  plus, it isnt like being static here makes any optimized
> difference -- it isnt going to get inlined anywhere in this file.

Agreed, this should be overridable by the architecture, I'll submit a patch
once we found out what caused the bugs.

> or rather than weaks (in case some toolchains force indirect pointer
> loading all the time), use the same interface as the rest of the
> generic checksum code:
> #ifndef do_csum
> static inline unsigned short from32to16(unsigned long x)
> {
>     ...
> }
> static unsigned int do_csum(const unsigned char *buff, int len)
> {
>     ...
> }
> #endif

I'd prefer the second version, I've done it that way all over
include/asm-generic, and weak functions tend to cause more trouble.

---
lib/checksum.c: Fix another endianess bug

will fold this patch into the previous one.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
--- a/lib/checksum.c
+++ b/lib/checksum.c
@@ -55,7 +55,11 @@ static unsigned int do_csum(const unsigned char *buff, int len)
 		goto out;
 	odd = 1 & (unsigned long) buff;
 	if (odd) {
+#ifdef __LITTLE_ENDIAN
 		result = *buff;
+#else
+		result += (*buff << 8);
+#endif
 		len--;
 		buff++;
 	}
