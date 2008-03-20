Return-Path: <linux-kernel-owner+w=401wt.eu-S1758501AbYCTSkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501AbYCTSkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 14:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758171AbYCTSjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 14:39:54 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:49108 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758083AbYCTSjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 14:39:52 -0400
Subject: [PATCH/RFC v2] introduce ARCH_CAN_UNALIGNED_ACCESS Kconfig symbol
From: Johannes Berg <johannes@sipsolutions.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Daniel Drake <dsd@gentoo.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
In-Reply-To: <20080320181310.GA17884@uranus.ravnborg.org>
References: <1206023695.16475.137.camel@johannes.berg>
	 <20080320181310.GA17884@uranus.ravnborg.org>
Content-Type: text/plain
Date: Thu, 20 Mar 2008 19:39:33 +0100
Message-Id: <1206038373.16475.150.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In many cases, especially in networking, it can be beneficial to
know at compile time whether the architecture can do unaligned
accesses. This patch introduces a new Kconfig symbol
	ARCH_CAN_UNALIGNED_ACCESS
for that purpose and adds it to the powerpc and x86 architectures.
Also add some documentation about alignment and networking, and
especially one intended use of this symbol.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Fixes thanks to Sam and Will.

 Documentation/unaligned-memory-access.txt |   32 +++++++++++++++++++++++++++---
 arch/Kconfig                              |    3 ++
 arch/powerpc/Kconfig                      |    1 
 arch/x86/Kconfig                          |    1 
 4 files changed, 34 insertions(+), 3 deletions(-)

--- everything.orig/Documentation/unaligned-memory-access.txt	2008-03-20 15:30:38.000000000 +0100
+++ everything/Documentation/unaligned-memory-access.txt	2008-03-20 19:38:30.000000000 +0100
@@ -218,9 +218,35 @@ If use of such macros is not convenient,
 where the source or destination (or both) are of type u8* or unsigned char*.
 Due to the byte-wise nature of this operation, unaligned accesses are avoided.
 
+
+Alignment vs. Networking
+========================
+
+On architectures that require aligned loads, networking requires that the IP
+header is aligned on a four-byte boundary to optimise the IP stack. For
+regular ethernet hardware, the constant NET_IP_ALIGN is used, on most
+architectures this constant has the value 2 because the normal ethernet
+header is 14 bytes long, so in order to get proper alignment one needs to
+DMA to an address that is can be expressed as 4*n + 2. One notable exception
+here is powerpc which defines NET_IP_ALIGN to 0 because DMA to unaligned
+addresses can be very expensive and dwarf the cost of unaligned loads.
+
+For some ethernet hardware that cannot DMA to unaligned addresses like
+4*n+2 or non-ethernet hardware, this can be a problem, and it is then
+required to copy the incoming frame into an aligned buffer. Because this is
+unnecessary on architectures that can do unaligned accesses, the code can be
+made depend on CONFIG_HAVE_UNALIGNED_ACCESS_SUPPORT like so:
+
+#ifdef CONFIG_HAVE_UNALIGNED_ACCESS_SUPPORT
+	skb = original skb
+#else
+	skb = copy skb
+#endif
+
 --
-Author: Daniel Drake <dsd@gentoo.org>
+Authors: Daniel Drake <dsd@gentoo.org>,
+         Johannes Berg <johannes@sipsolutions.net>
 With help from: Alan Cox, Avuton Olrich, Heikki Orsila, Jan Engelhardt,
-Johannes Berg, Kyle McMartin, Kyle Moffett, Randy Dunlap, Robert Hancock,
-Uli Kunitz, Vadim Lobanov
+Kyle McMartin, Kyle Moffett, Randy Dunlap, Robert Hancock, Uli Kunitz,
+Vadim Lobanov
 
--- everything.orig/arch/powerpc/Kconfig	2008-03-20 15:30:38.000000000 +0100
+++ everything/arch/powerpc/Kconfig	2008-03-20 19:37:22.000000000 +0100
@@ -91,6 +91,7 @@ config PPC
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
+	select HAVE_UNALIGNED_ACCESS_SUPPORT
 
 config EARLY_PRINTK
 	bool
--- everything.orig/arch/x86/Kconfig	2008-03-20 15:30:38.000000000 +0100
+++ everything/arch/x86/Kconfig	2008-03-20 19:38:08.000000000 +0100
@@ -23,6 +23,7 @@ config X86
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
+	select HAVE_UNALIGNED_ACCESS_SUPPORT
 
 
 config GENERIC_LOCKBREAK
--- everything.orig/arch/Kconfig	2008-03-20 19:37:26.000000000 +0100
+++ everything/arch/Kconfig	2008-03-20 19:37:34.000000000 +0100
@@ -36,3 +36,6 @@ config HAVE_KPROBES
 
 config HAVE_KRETPROBES
 	def_bool n
+
+config HAVE_UNALIGNED_ACCESS_SUPPORT
+	def_bool n


