Return-Path: <linux-kernel-owner+w=401wt.eu-S938114AbXFHKXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938114AbXFHKXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 06:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937768AbXFHKW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 06:22:59 -0400
Received: from iona.labri.fr ([147.210.8.143]:57631 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937766AbXFHKW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 06:22:58 -0400
Date: Fri, 8 Jun 2007 18:22:50 +0800
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org, akpm@google.com
Subject: [PATCH] Oddity in mxcsr_feature_mask_init()
Message-ID: <20070608102250.GE4943@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org, akpm@google.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In arch/i386/kernel/i387.c:mxcsr_feature_mask_init(), one can read:

	asm volatile("fxsave %0" : : "m" (current->thread.i387.fxsave)); 

But I would rather have written:

	asm("fxsave %0" : "=m" (current->thread.i387.fxsave)); 

Considering the code around, it doesn't do much difference, but it makes
more sense (i.e. we just fill fxsave).

Samuel

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

--- linux-2.6.21-orig/arch/i386/kernel/i387.c.orig	2007-06-08 18:18:10.000000000 +0800
+++ linux-2.6.21-orig/arch/i386/kernel/i387.c	2007-06-08 18:18:22.000000000 +0800
@@ -32,7 +32,7 @@
 	clts();
 	if (cpu_has_fxsr) {
 		memset(&current->thread.i387.fxsave, 0, sizeof(struct i387_fxsave_struct));
-		asm volatile("fxsave %0" : : "m" (current->thread.i387.fxsave)); 
+		asm("fxsave %0" : "=m" (current->thread.i387.fxsave)); 
 		mask = current->thread.i387.fxsave.mxcsr_mask;
 		if (mask == 0) mask = 0x0000ffbf;
 	} 
