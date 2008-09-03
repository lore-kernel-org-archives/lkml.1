Return-Path: <linux-kernel-owner+w=401wt.eu-S1758755AbYICRs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755AbYICRs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755699AbYICRsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:48:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:58230 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033AbYICRso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:48:44 -0400
Date: Wed, 3 Sep 2008 10:32:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 01/16] x86: work around MTRR mask setting
Message-ID: <20080903173240.GB10429@suse.de>
References: <20080903172849.927077124@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-work-around-mtrr-mask-setting.patch"
In-Reply-To: <20080903173218.GA10429@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yinghai Lu <yhlu.kernel@gmail.com>

commit 38cc1c3df77c1bb739a4766788eb9fa49f16ffdf upstream

Joshua Hoblitt reported that only 3 GB of his 16 GB of RAM is
usable. Booting with mtrr_show showed us the BIOS-initialized
MTRR settings - which are all wrong.

So the root cause is that the BIOS has not set the mask correctly:

>               [    0.429971]  MSR00000200: 00000000d0000000
>               [    0.433305]  MSR00000201: 0000000ff0000800
> should be ==> [    0.433305]  MSR00000201: 0000003ff0000800
>
>               [    0.436638]  MSR00000202: 00000000e0000000
>               [    0.439971]  MSR00000203: 0000000fe0000800
> should be ==> [    0.439971]  MSR00000203: 0000003fe0000800
>
>               [    0.443304]  MSR00000204: 0000000000000006
>               [    0.446637]  MSR00000205: 0000000c00000800
> should be ==> [    0.446637]  MSR00000205: 0000003c00000800
>
>               [    0.449970]  MSR00000206: 0000000400000006
>               [    0.453303]  MSR00000207: 0000000fe0000800
> should be ==> [    0.453303]  MSR00000207: 0000003fe0000800
>
>               [    0.456636]  MSR00000208: 0000000420000006
>               [    0.459970]  MSR00000209: 0000000ff0000800
> should be ==> [    0.459970]  MSR00000209: 0000003ff0000800

So detect this borkage and add the prefix 111.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/mtrr/generic.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -229,6 +229,7 @@ static void generic_get_mtrr(unsigned in
 			     unsigned long *size, mtrr_type *type)
 {
 	unsigned int mask_lo, mask_hi, base_lo, base_hi;
+	unsigned int tmp, hi;
 
 	rdmsr(MTRRphysMask_MSR(reg), mask_lo, mask_hi);
 	if ((mask_lo & 0x800) == 0) {
@@ -242,8 +243,18 @@ static void generic_get_mtrr(unsigned in
 	rdmsr(MTRRphysBase_MSR(reg), base_lo, base_hi);
 
 	/* Work out the shifted address mask. */
-	mask_lo = size_or_mask | mask_hi << (32 - PAGE_SHIFT)
-	    | mask_lo >> PAGE_SHIFT;
+	tmp = mask_hi << (32 - PAGE_SHIFT) | mask_lo >> PAGE_SHIFT;
+	mask_lo = size_or_mask | tmp;
+	/* Expand tmp with high bits to all 1s*/
+	hi = fls(tmp);
+	if (hi > 0) {
+		tmp |= ~((1<<(hi - 1)) - 1);
+
+		if (tmp != mask_lo) {
+			WARN_ON("mtrr: your BIOS has set up an incorrect mask, fixing it up.\n");
+			mask_lo = tmp;
+		}
+	}
 
 	/* This works correctly if size is a power of two, i.e. a
 	   contiguous range. */

-- 
