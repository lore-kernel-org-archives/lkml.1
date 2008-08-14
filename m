Return-Path: <linux-kernel-owner+w=401wt.eu-S1758343AbYHNNMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343AbYHNNMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 09:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbYHNNL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 09:11:58 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:25990 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbYHNNL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 09:11:57 -0400
Message-ID: <48A42F1A.6080903@hp.com>
Date: Thu, 14 Aug 2008 07:11:54 -0600
From: Rocky Craig <rocky.craig@hp.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org
Cc: paulus@samba.org, benh@kernel.crashing.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2.6.27] [POWERPC] Invalidate all TLB entries in a specified
 range
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rocky Craig <rocky.craig@hp.com>

The apparent intent of "flush_tlbs" is to invalidate TLB entries that
might match in the address range 0 to 0x00400000.  A loop counter is 
set up at the high value and decremented by page size.  However, the 
loop is only done once as the sense of the conditional branch at the
loop end does not match the setup/decrement.

Signed-off-by: Rocky Craig <rocky.craig@hp.com>
---

Source is from 2.6.27 development, but the bug appears as far back as 2.4.0.
The small user-space program below demonstrates the loop behavior.  It was
compiled via crosstool gcc 3.4.5 / glibc 2.3.6 for an MPC8347 target.

int main()
{
	long endval;				// 16(r31)

	__asm__ __volatile__(
		"	lis 10,0x40\n"
		"1:	addic. 10,10,-0x1000\n"
		"	bgt 1b\n"
		"	stw 10,16(31)\n");	// endval

	printf("end value = 0x%08lx\n", endval);
}

This might win the prize for "Smallest actual code patch ever".

--- a/arch/powerpc/kernel/head_32.S.orig	2008-07-24 19:25:09.000000000 -0600
+++ a/arch/powerpc/kernel/head_32.S	2008-07-24 19:25:22.000000000 -0600
@@ -1155,7 +1155,7 @@ flush_tlbs:
 	lis	r10, 0x40
 1:	addic.	r10, r10, -0x1000
 	tlbie	r10
-	blt	1b
+	bgt	1b
 	sync
 	blr
 



