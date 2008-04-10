Return-Path: <linux-kernel-owner+w=401wt.eu-S1759503AbYDJPMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503AbYDJPMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758125AbYDJPLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:11:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758059AbYDJPLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:11:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/5] FRV: Make NOMMU-mode work with base addresses other than
	0xC0000000 [try #2]
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Thu, 10 Apr 2008 16:11:00 +0100
Message-ID: <20080410151100.3764.46530.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080410151044.3764.47511.stgit@warthog.procyon.org.uk>
References: <20080410151044.3764.47511.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Make NOMMU-mode work with base addresses other than 0xC0000000 by:

 (1) Giving the code that sets up the protection registers the right address
     in __sdram_base.  Rather than being hard coded to 0xC0000000, the value
     of __page_offset is obtained from the linker script.

 (2) Eliminate the check in __switch_to() that verifies the current thread
     info is in the 0xCxxxxxxx region.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/kernel/head.inc    |    2 +-
 arch/frv/kernel/switch_to.S |    7 -------
 2 files changed, 1 insertions(+), 8 deletions(-)


diff --git a/arch/frv/kernel/head.inc b/arch/frv/kernel/head.inc
index d424cd2..bff6662 100644
--- a/arch/frv/kernel/head.inc
+++ b/arch/frv/kernel/head.inc
@@ -46,5 +46,5 @@
 #ifdef CONFIG_MMU
 __sdram_base = 0x00000000		/* base address to which SDRAM relocated */
 #else
-__sdram_base = 0xc0000000		/* base address to which SDRAM relocated */
+__sdram_base = __page_offset		/* base address to which SDRAM relocated */
 #endif
diff --git a/arch/frv/kernel/switch_to.S b/arch/frv/kernel/switch_to.S
index b5275fa..b066686 100644
--- a/arch/frv/kernel/switch_to.S
+++ b/arch/frv/kernel/switch_to.S
@@ -102,13 +102,6 @@ __switch_to:
 	movgs		gr14,lr
 	bar
 
-	srli		gr15,#28,gr5
-	subicc		gr5,#0xc,gr0,icc0
-	beq		icc0,#0,111f
-	break
-	nop
-111:
-
 	# jump to __switch_back or ret_from_fork as appropriate
 	# - move prev to GR8
 	movgs		gr4,psr

