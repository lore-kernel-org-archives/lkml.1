Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbZETKMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbZETKMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 06:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755783AbZETKMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 06:12:30 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:65177 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419AbZETKM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 06:12:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=kaylY8po9CEDy/UbOmwfKy9eAcVuZYAV0U1lsli1/2LBC7MEVAju2f/pvAS61b0vvt
         CDqVzLQp+lKiUoVTlzEjLwPfIEKaJ3HOk3OKfc0wDUA3vBsnIm3q7CpJvVkQCmaqMoZY
         f6my4qFGurJfsAdQF/Rc3g2JG9pMNRFII/bu0=
MIME-Version: 1.0
Date: Wed, 20 May 2009 19:12:29 +0900
Message-ID: <d50492d40905200312r729608a3nf244b153892ac257@mail.gmail.com>
Subject: can't flush tlb on e500
From: Saito Hideo <hsaito.ppc@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that the code for powerpc with e500 on linux-2.6.29 has an
regression, because I can't execute hackbench on my platform. I
apologize if already reported.

For example, following message was asserted, however the command is
done successfully if the number given to hackbench is small.

% ./hackbench 20
SERVER: read (error: Bad file descriptor)

% ./hackbench 4
%

I think that the tlb should be cleared before mm->context.id is set
MMU_NO_CONTEXT.

--- arch/powerpc/mm/mmu_context_nohash.c.orig	2009-03-24
08:12:14.000000000 +0900
+++ arch/powerpc/mm/mmu_context_nohash.c	2009-05-20 18:33:53.000000000 +0900
@@ -122,22 +122,22 @@ static unsigned int steal_context_up(uns
 	struct mm_struct *mm;
 	int cpu = smp_processor_id();

 	/* Pick up the victim mm */
 	mm = context_mm[id];

 	pr_debug("[%d] steal context %d from mm @%p\n", cpu, id, mm);

-	/* Mark this mm has having no context anymore */
-	mm->context.id = MMU_NO_CONTEXT;
-
 	/* Flush the TLB for that context */
 	local_flush_tlb_mm(mm);

+	/* Mark this mm has having no context anymore */
+	mm->context.id = MMU_NO_CONTEXT;
+
 	/* XXX This clear should ultimately be part of local_flush_tlb_mm */
 	__clear_bit(id, stale_map[cpu]);

 	return id;
 }

 #ifdef DEBUG_MAP_CONSISTENCY
 static void context_check_map(void)
