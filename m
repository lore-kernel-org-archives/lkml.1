Return-Path: <linux-kernel-owner+w=401wt.eu-S1757255AbZHNWst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbZHNWst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 18:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756271AbZHNWss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 18:48:48 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:50809 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755968AbZHNWss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 18:48:48 -0400
Subject: [PATCH] kmemleak: Ignore the aperture memory hole on x86_64
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1250289913.5085.17.camel@pc1117.cambridge.arm.com>
References: <20090812205215.GA21451@elte.hu>
	 <1250289913.5085.17.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 14 Aug 2009 23:48:38 +0100
Message-Id: <1250290118.5085.21.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Aug 2009 22:48:39.0199 (UTC) FILETIME=[5D745AF0:01CA1D31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This block is allocated with alloc_bootmem() and scanned by kmemleak but
the kernel direct mapping may no longer exist. This patch tells kmemleak
to ignore this memory hole.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/aperture_64.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 676debf..cb690b3 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -94,6 +94,11 @@ static u32 __init allocate_aperture(void)
 	 * code for safe
 	 */
 	p = __alloc_bootmem_nopanic(aper_size, aper_size, 512ULL<<20);
+	/*
+	 * Kmemleak should not scan this block as it may not be mapped via the
+	 * kernel direct mapping.
+	 */
+	kmemleak_ignore(p);
 	if (!p || __pa(p)+aper_size > 0xffffffff) {
 		printk(KERN_ERR
 			"Cannot allocate aperture memory hole (%p,%uK)\n",


