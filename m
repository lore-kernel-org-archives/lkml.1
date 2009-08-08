Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227AbZHHUPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbZHHUPJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 16:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbZHHUPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 16:15:08 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:50184 "EHLO
	relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbZHHUPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 16:15:07 -0400
X-Greylist: delayed 9359 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Aug 2009 16:15:07 EDT
Date: Sat, 8 Aug 2009 13:15:00 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: [PATCH] xen: xen_init_cpuid_mask: Zero cx before calling xen_cpuid
Message-ID: <20090808201500.GA21828@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-TUID: 072517c3027b4590
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPUID function 1 doesn't use cx, but xen_cpuid doesn't know that,
resulting in this warning:

arch/x86/xen/enlighten.c: In function ‘xen_start_kernel’:
arch/x86/xen/enlighten.c:192: warning: ‘cx’ may be used uninitialized in this function
arch/x86/xen/enlighten.c:205: note: ‘cx’ was declared here

Set cx = 0 to avoid this warning.  This seems preferable to implementing
a xen_cpuid_nocount without the input constraint for cx, and either of
those seem preferable to just ignoring the warning.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

Build-tested only.

 arch/x86/xen/enlighten.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 0a1700a..6ee2ef8 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -215,6 +215,7 @@ static __init void xen_init_cpuid_mask(void)
 			  (1 << X86_FEATURE_ACPI));  /* disable ACPI */
 
 	ax = 1;
+	cx = 0;
 	xen_cpuid(&ax, &bx, &cx, &dx);
 
 	/* cpuid claims we support xsave; try enabling it to see what happens */
-- 
1.5.6.5

