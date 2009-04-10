Return-Path: <linux-kernel-owner+w=401wt.eu-S936792AbZDJUru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936792AbZDJUru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 16:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932317AbZDJUrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 16:47:33 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:40923 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937107AbZDJUrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 16:47:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=oRyh7lq24Ph/VOHvjn8+mNqxYK+CWEwSJyb0oNmFW0gBlgnx+oNqPXgPdQ3zC6YNiY
         CzyqkFDr+0gf86YogDR+/+uAXOwVbxULa1taEuOH+XbW1t9Dtk7+3ChdDCumYDipAnne
         l1/4jIVDyjbYHVJxrAaZj+kH8jdgJPhxi7YXg=
Message-ID: <49DFB055.6070405@gmail.com>
Date: Fri, 10 Apr 2009 22:47:17 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix wrong section of pat_disable & make it static
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pat_disable cannot be __cpuinit anymore because it's called from pat_init
and the callchain looks like this:
pat_disable [cpuinit] <- pat_init <- generic_set_all <-
 ipi_handler <- set_mtrr <- (other non init/cpuinit functions)

WARNING: arch/x86/mm/built-in.o(.text+0x449e): Section mismatch in reference
from the function pat_init() to the function .cpuinit.text:pat_disable()
The function pat_init() references
the function __cpuinit pat_disable().
This is often because pat_init lacks a __cpuinit
annotation or the annotation of pat_disable is wrong.

Non CONFIG_X86_PAT version of pat_disable is static inline, so this version
can be static too (and there are no callers outside of this file).

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/mm/pat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 640339e..c009a24 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -31,7 +31,7 @@
 #ifdef CONFIG_X86_PAT
 int __read_mostly pat_enabled = 1;
 
-void __cpuinit pat_disable(const char *reason)
+static inline void pat_disable(const char *reason)
 {
 	pat_enabled = 0;
 	printk(KERN_INFO "%s\n", reason);
-- 
1.6.0.6


