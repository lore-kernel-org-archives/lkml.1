Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbYDHPFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbYDHPFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 11:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYDHPFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 11:05:41 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:51878 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbYDHPFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 11:05:40 -0400
Subject: [PATCH] introduce HAVE_EFFICIENT_UNALIGNED_ACCESS Kconfig symbol
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, sam <sam@ravnborg.org>
Content-Type: text/plain
Date: Tue, 08 Apr 2008 17:05:27 +0200
Message-Id: <1207667127.14253.42.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In many cases, especially in networking, it can be beneficial to
know at compile time whether the architecture can do unaligned
accesses efficiently. This patch introduces a new Kconfig symbol
	HAVE_EFFICIENT_UNALIGNED_ACCESS
for that purpose and adds it to the powerpc and x86 architectures.
Also add some documentation about alignment and networking, and
especially one intended use of this symbol.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Ingo Molnar <mingo@elte.hu> [x86 architecture part]
---
v5: rename to HAVE_EFFICIENT_UNALIGNED_ACCESS

I have opted to not introduce any symbol associated with the cost
of unaligned accesses, David Woodhouse once suggested that such a
cost should be combined with a probability of (un-)alignment even
in the get_unaligned/put_unaligned macros and I think this should
be combined with a patch introducing a global cost constant.

Also, this would require architecture changes because if some code
knew the likelyhood of unaligned accesses was small enough over
the cost of them, architectures that complain in the trap handle
would still complain in that unlikely case although the code
explicitly made a trade-off based on the cost/probability.

 Documentation/unaligned-memory-access.txt |   32 +++++++++++++++++++++++++++---
 arch/Kconfig                              |   19 +++++++++++++++++
 arch/powerpc/Kconfig                      |    1 
 arch/x86/Kconfig                          |    1 
 4 files changed, 50 insertions(+), 3 deletions(-)

--- everything.orig/Documentation/unaligned-memory-access.txt	2008-04-04 23:42:50.000000000 +0200
+++ everything/Documentation/unaligned-memory-access.txt	2008-04-04 23:52:15.000000000 +0200
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
+made depend on CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS like so:
+
+#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
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
 
--- everything.orig/arch/powerpc/Kconfig	2008-04-04 23:42:53.000000000 +0200
+++ everything/arch/powerpc/Kconfig	2008-04-04 23:52:15.000000000 +0200
@@ -103,6 +103,7 @@ config PPC
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
+	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 
 config EARLY_PRINTK
 	bool
--- everything.orig/arch/x86/Kconfig	2008-04-04 23:42:50.000000000 +0200
+++ everything/arch/x86/Kconfig	2008-04-04 23:52:15.000000000 +0200
@@ -23,6 +23,7 @@ config X86
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
+	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 
 
 config GENERIC_LOCKBREAK
--- everything.orig/arch/Kconfig	2008-04-04 23:42:50.000000000 +0200
+++ everything/arch/Kconfig	2008-04-04 23:52:15.000000000 +0200
@@ -36,3 +36,22 @@ config HAVE_KPROBES
 
 config HAVE_KRETPROBES
 	def_bool n
+
+config HAVE_EFFICIENT_UNALIGNED_ACCESS
+	def_bool n
+	help
+	  Some architectures are unable to perform unaligned accesses
+	  without the use of get_unaligned/put_unaligned. Others are
+	  unable to perform such accesses efficiently (e.g. trap on
+	  unaligned access and require fixing it up in the exception
+	  handler.)
+
+	  This symbol should be selected by an architecture if it can
+	  perform unaligned accesses efficiently to allow different
+	  code paths to be selected for these cases. Some network
+	  drivers, for example, could opt to not fix up alignment
+	  problems with received packets if doing so would not help
+	  much.
+
+	  See Documentation/unaligned-memory-access.txt for more
+	  information on the topic of unaligned memory accesses.


