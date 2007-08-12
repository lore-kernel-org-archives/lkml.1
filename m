Return-Path: <linux-kernel-owner+w=401wt.eu-S1757866AbXHLINL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866AbXHLINL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 04:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761256AbXHLIM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 04:12:56 -0400
Received: from vana.vc.cvut.cz ([147.32.240.58]:50887 "EHLO vana.vc.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756277AbXHLIMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 04:12:54 -0400
Date: Sun, 12 Aug 2007 10:12:52 +0200
From: Petr Vandrovec <petr@vandrovec.name>
To: ak@suse.de
Cc: discuss@x86-64.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: [PATCH] Fix triplefault on x86-64 bootup
Message-ID: <20070812081252.GA23309@vana.vc.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
  after I upgraded kernel on my box to current git, only thing it did 
was rebooting in a loop.  After some digging I found that it is silly 
to apply alternative to memcpy by using that every same memcpy... 
Sorry if it is known bug, I do not see it reported in my LKML mailbox...
							Petr

From: Petr Vandrovec <petr@vandrovec.name>

Do not replace whole memcpy in apply alternatives

apply_alternatives uses memcpy() to apply alternatives.  Which has
unfortunate effect that while applying memcpy alternative memcpy itself
it tries to overwrite itself with nops - which causes #UD fault as it 
overwrites half of instruction in copy loop, and from this point on only
possible outcome is triplefault and reboot.  So let's overwrite only
first two instructions of memcpy - as long as main memcpy loop is
not in first two bytes it will work fine.

Signed-off-by: Petr Vandrovec <petr@vandrovec.name>

---
commit 7c6f7d582f301e16899a43fd6c775ed103e8a8d2
tree 112d7320e8a21120e4e43f1ac91918ca0352ff56
parent f81e9b8cc6301f6328eafaa553ef35441874b1a4
author Petr Vandrovec <petr@vandrovec.name> Sun, 12 Aug 2007 01:05:11 -0700
committer Petr Vandrovec <petr@vandrovec.name> Sun, 12 Aug 2007 01:05:11 -0700

 arch/x86_64/lib/memcpy.S |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86_64/lib/memcpy.S b/arch/x86_64/lib/memcpy.S
index 0ea0ddc..c22981f 100644
--- a/arch/x86_64/lib/memcpy.S
+++ b/arch/x86_64/lib/memcpy.S
@@ -124,6 +124,8 @@ ENDPROC(__memcpy)
 	.quad memcpy
 	.quad 1b
 	.byte X86_FEATURE_REP_GOOD
-	.byte .Lfinal - memcpy
+	/* Replace only beginning, memcpy is used to apply alternatives, so it
+	 * is silly to overwrite itself with nops - reboot is only outcome... */
+	.byte 2b - 1b
 	.byte 2b - 1b
 	.previous
