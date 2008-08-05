Return-Path: <linux-kernel-owner+w=401wt.eu-S1764770AbYHEUSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764770AbYHEUSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763634AbYHEUOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:14:39 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:48090 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763618AbYHEUOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:14:38 -0400
Date: Tue, 5 Aug 2008 16:14:10 -0400
From: Jeff Dike <jdike@addtoit.com>
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 13/14] UML - Fix boot crash
Message-ID: <20080805201410.GA11796@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7c1fed03b9fa32d4323d5caa6a9c7dcdd7eba767

My copying of linux/init.h didn't go far enough.  The definition of
__used singled out gcc minor version 3, but didn't care what the major
version was.  This broke when unit-at-a-time was added and gcc started
throwing out initcalls.

This results in an early boot crash when ptrace tries to initialize a
process with an empty, uninitialized register set.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/um/include/init.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/um/include/init.h b/arch/um/include/init.h
index b00a957..37dd097 100644
--- a/arch/um/include/init.h
+++ b/arch/um/include/init.h
@@ -45,6 +45,8 @@ typedef void (*exitcall_t)(void);
 # define __section(S) __attribute__ ((__section__(#S)))
 #endif
 
+#if __GNUC__ == 3
+
 #if __GNUC_MINOR__ >= 3
 # define __used			__attribute__((__used__))
 #else
@@ -52,6 +54,12 @@ typedef void (*exitcall_t)(void);
 #endif
 
 #else
+#if __GNUC__ == 4
+# define __used			__attribute__((__used__))
+#endif
+#endif
+
+#else
 #include <linux/compiler.h>
 #endif
 /* These are for everybody (although not all archs will actually
-- 
1.5.5.1

