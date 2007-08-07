Return-Path: <linux-kernel-owner+w=401wt.eu-S935811AbXHGUxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935811AbXHGUxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935412AbXHGUsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:48:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56094 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935409AbXHGUsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:48:38 -0400
Date: Tue, 7 Aug 2007 13:44:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Mark Fortescue <mark@mtfhpc.demon.co.uk>,
       "David S. Miller" <davem@davemloft.net>
Subject: [2.6.22.2 review 18/84] Fix sparc32 udelay() rounding errors.
Message-ID: <20070807204414.GS23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-sparc32-udelay-rounding-errors.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Mark Fortescue <mark@mtfhpc.demon.co.uk>

[SPARC32]: Fix rounding errors in ndelay/udelay implementation.

__ndelay and __udelay have not been delayung >= specified time.
The problem with __ndelay has been tacked down to the rounding of the
multiplier constant. By changing this, delays > app 18us are correctly
calculated.
The problem with __udelay has also been tracked down to rounding issues.
Changing the multiplier constant (to match that used in sparc64) corrects
for large delays and adding in a rounding constant corrects for trunctaion
errors in the claculations.
Many short delays will return without looping. This is not an error as there
is the fixed delay of doing all the maths to calculate the loop count.

Signed-off-by: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc/kernel/entry.S |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/arch/sparc/kernel/entry.S
+++ b/arch/sparc/kernel/entry.S
@@ -1749,8 +1749,8 @@ fpload:
 __ndelay:
 	save	%sp, -STACKFRAME_SZ, %sp
 	mov	%i0, %o0
-	call	.umul
-	 mov	0x1ad, %o1		! 2**32 / (1 000 000 000 / HZ)
+	call	.umul			! round multiplier up so large ns ok
+	 mov	0x1ae, %o1		! 2**32 / (1 000 000 000 / HZ)
 	call	.umul
 	 mov	%i1, %o1		! udelay_val
 	ba	delay_continue
@@ -1760,11 +1760,17 @@ __ndelay:
 __udelay:
 	save	%sp, -STACKFRAME_SZ, %sp
 	mov	%i0, %o0
-	sethi	%hi(0x10c6), %o1
+	sethi	%hi(0x10c7), %o1	! round multiplier up so large us ok
 	call	.umul
-	 or	%o1, %lo(0x10c6), %o1	! 2**32 / 1 000 000
+	 or	%o1, %lo(0x10c7), %o1	! 2**32 / 1 000 000
 	call	.umul
 	 mov	%i1, %o1		! udelay_val
+	sethi	%hi(0x028f4b62), %l0	! Add in rounding constant * 2**32,
+	or	%g0, %lo(0x028f4b62), %l0
+	addcc	%o0, %l0, %o0		! 2**32 * 0.009 999
+	bcs,a	3f
+	 add	%o1, 0x01, %o1
+3:
 	call	.umul
 	 mov	HZ, %o0			! >>32 earlier for wider range
 

-- 
