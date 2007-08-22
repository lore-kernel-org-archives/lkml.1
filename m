Return-Path: <linux-kernel-owner+w=401wt.eu-S933189AbXHVUai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189AbXHVUai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932578AbXHVUaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:30:19 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:15557 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439AbXHVUaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:30:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=O6QjjyQNetxs5ig7op7qGwuSLiF8hv0KofdxKU2ycfOIVi2Ycx28dZpUVYVzt1+2dVW3Tw5wxgNO/r1DyoKioRCQULONjIi4tY8iAu/Awme/yaAiIUFoqCH+7d2+7xEyLcfHB10Xok9YTbwSiu3OnIUX7Mxb2Djbs89oe9VZylo=
Date: Wed, 22 Aug 2007 22:25:51 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org
Subject: [-mm patch] enforce noreplace-smp in alternative_instructions()
Message-ID: <20070822202551.GB31846@slug>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070822020648.5ea3a612.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 02:06:48AM -0700, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
> 
Hi Jeremy,

arch/i386/kernel/alternative.c:alternative_instructions() doesn't
check for noreplace-smp before setting capability bits and freeing the
__smp_locks section.

Every call to alternatives_smp_unlock() checks for noreplace-smp
beforehand, so remove the check from there.

Boot tested on i386 with UP+noreplace-smp (lguest) and SMP (real hardware)

Regards,
Frederik

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>

diff --git a/arch/i386/kernel/alternative.c b/arch/i386/kernel/alternative.c
index 9f4ac8b..7c5af80 100644
--- a/arch/i386/kernel/alternative.c
+++ b/arch/i386/kernel/alternative.c
@@ -221,9 +221,6 @@ static void alternatives_smp_unlock(u8 **start, u8 **end, u8 *text, u8 *text_end
 	u8 **ptr;
 	char insn[1];
 
-	if (noreplace_smp)
-		return;
-
 	add_nops(insn, 1);
 	for (ptr = start; ptr < end; ptr++) {
 		if (*ptr < text)
@@ -406,7 +403,7 @@ void __init alternative_instructions(void)
 #endif
 
 #ifdef CONFIG_SMP
-	if (smp_alt_once) {
+	if (smp_alt_once && !noreplace_smp) {
 		if (1 == num_possible_cpus()) {
 			printk(KERN_INFO "SMP alternatives: switching to UP code\n");
 			set_bit(X86_FEATURE_UP, boot_cpu_data.x86_capability);
