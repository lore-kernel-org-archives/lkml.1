Return-Path: <linux-kernel-owner+w=401wt.eu-S1760981AbZCWT0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760981AbZCWT0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 15:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758843AbZCWT0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 15:26:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56833 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758352AbZCWT0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 15:26:14 -0400
Date: Mon, 23 Mar 2009 15:25:49 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: torvalds@linux-foundation.org
Cc: roland@redhat.com, aoliva@redhat.com, sam@ravnborg.org,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: [PATCH] Build with -fno-dwarf2-cfi-asm
Message-ID: <20090323192549.GA19208@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

With a sufficiently new compiler and binutils, code which wasn't
previously generating .eh_frame sections has begun to. Certain architectures
(powerpc, in this case) may generate unexpected relocation formats in
response to this, preventing modules from loading.

While the new relocation types should probably be handled, revert to
the previous behaviour with regards to generation of .eh_frame sections.

(This was reported against Fedora, which appears to be the only distro
doing any building against gcc-4.4 at present: RH bz#486545.)

Signed-off-by: Kyle McMartin <kyle@redhat.com>
Cc: roland@redhat.com
Cc: aoliva@redhat.com
Cc: sam@ravnborg.org
---

As near as I can tell, the only case previously was for the vdso images,
which are explicitly built with -fasynchronous-unwind-tables, and
annotated with cfi directives.

Everyone else either unwinds their stack manually, or has a custom
unwind format like parisc or ia64.

Hopefully this is a somewhat better description than the last time.

cheers, Kyle

diff --git a/Makefile b/Makefile
index a2c2efe..057230a 100644
--- a/Makefile
+++ b/Makefile
@@ -569,6 +569,9 @@ KBUILD_CFLAGS += $(call cc-option,-Wno-pointer-sign,)
 # disable invalid "can't wrap" optimzations for signed / pointers
 KBUILD_CFLAGS	+= $(call cc-option,-fwrapv)
 
+# revert to pre-gcc-4.4 behaviour of .eh_frame
+KBUILD_CFLAGS	+= $(call cc-option,-fno-dwarf2-cfi-asm)
+
 # Add user supplied CPPFLAGS, AFLAGS and CFLAGS as the last assignments
 # But warn user when we do so
 warn-assign = \
