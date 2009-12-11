Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbZLKNX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbZLKNX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 08:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755750AbZLKNXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 08:23:52 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:10969 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbZLKNXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 08:23:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TmyNWT9JRZdJ7mNUQrMxIBlNV8OnbqKDgfT7RuVjfk0TN8WbAztqC0yW1cUJai9IFj
         HFhg3Hi96ELLKAN5vaJV1cXxPue0fqGN0+tgx0/hEdmOf75xGBCtLPbL0UNl0hy8xx0F
         M3fMxcd6SJQc3Z3yH2GbnTUzNNCUhKU2ypNt4=
Date: Fri, 11 Dec 2009 14:23:54 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH v2] x86, amd: Make check_c1e_idle explicit
Message-ID: <20091211132354.GA30604@alberich.amd.com>
References: <20091210133232.GA5471@alberich.amd.com>
 <4B219A6F.1060801@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B219A6F.1060801@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With current code c1e_idle() will try to access MSR 0xc0010055 for all
future AMD CPUs. But that MSR is not architectural. So it's wrong to
access the MSR unconditionally.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/process.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ea54ce8..1bf98b1 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -494,21 +494,19 @@ static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
 }
 
 /*
- * Check for AMD CPUs, which have potentially C1E support
+ * Check for AMD CPUs, which potentially use SMI or hardware initiated C1E
  */
 static int __cpuinit check_c1e_idle(const struct cpuinfo_x86 *c)
 {
 	if (c->x86_vendor != X86_VENDOR_AMD)
 		return 0;
 
-	if (c->x86 < 0x0F)
-		return 0;
-
-	/* Family 0x0f models < rev F do not have C1E */
-	if (c->x86 == 0x0f && c->x86_model < 0x40)
-		return 0;
+	if ((c->x86 == 0x0F && c->x86_model >= 0x40) ||
+	    (c->x86 == 0x10) ||
+	    (c->x86 == 0x11))
+		return 1;
 
-	return 1;
+	return 0;
 }
 
 static cpumask_var_t c1e_mask;
-- 
1.6.4.2

