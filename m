Return-Path: <linux-kernel-owner+w=401wt.eu-S932512AbZKFWbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512AbZKFWbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932543AbZKFWXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:23:16 -0500
Received: from kroah.org ([198.145.64.141]:56981 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932501AbZKFWXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:13 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:47 2009
Message-Id: <20091106221547.180631669@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [61/99] xen: mask extended topology info in cpuid
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=xen-mask-extended-topology-info-in-cpuid.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

commit 82d6469916c6fcfa345636a49004c9d1753905d1 upstream.

A Xen guest never needs to know about extended topology, and knowing
would just confuse it.

This patch just zeros ebx in leaf 0xb which indicates no topology info,
preventing a crash under Xen on cpus which support this leaf.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

---
 arch/x86/xen/enlighten.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -178,6 +178,7 @@ static __read_mostly unsigned int cpuid_
 static void xen_cpuid(unsigned int *ax, unsigned int *bx,
 		      unsigned int *cx, unsigned int *dx)
 {
+	unsigned maskebx = ~0;
 	unsigned maskecx = ~0;
 	unsigned maskedx = ~0;
 
@@ -185,9 +186,16 @@ static void xen_cpuid(unsigned int *ax, 
 	 * Mask out inconvenient features, to try and disable as many
 	 * unsupported kernel subsystems as possible.
 	 */
-	if (*ax == 1) {
+	switch (*ax) {
+	case 1:
 		maskecx = cpuid_leaf1_ecx_mask;
 		maskedx = cpuid_leaf1_edx_mask;
+		break;
+
+	case 0xb:
+		/* Suppress extended topology stuff */
+		maskebx = 0;
+		break;
 	}
 
 	asm(XEN_EMULATE_PREFIX "cpuid"
@@ -197,6 +205,7 @@ static void xen_cpuid(unsigned int *ax, 
 		  "=d" (*dx)
 		: "0" (*ax), "2" (*cx));
 
+	*bx &= maskebx;
 	*cx &= maskecx;
 	*dx &= maskedx;
 }


