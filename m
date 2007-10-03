Return-Path: <linux-kernel-owner+w=401wt.eu-S1757642AbXJCW15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642AbXJCW15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 18:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbXJCW1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 18:27:49 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54751 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbXJCW1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 18:27:47 -0400
Date: Wed, 3 Oct 2007 17:27:46 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Andrew Morgan <morgan@kernel.org>,
       linux-security-module@vger.kernel.org
Subject: [PATCH 1/2 -mm] capabilities: define CONFIG_COMMONCAP
Message-ID: <20071003222746.GA1562@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 54c70ca7671750fe8986451fae91d42107d0ca90 Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Fri, 28 Sep 2007 10:33:33 -0500
Subject: [PATCH 1/2 -mm] capabilities: define CONFIG_COMMONCAP

currently the compilation of commoncap.c is determined
through Makefile logic.  So there is no single CONFIG
variable which can be relied upon to know whether it
will be compiled.

Define CONFIG_COMMONCAP to be true when lsm is not
compiled in, or when the capability or rootplug modules
are compiled.  These are the cases when commoncap is
currently compiled.  Use this variable in security/Makefile
to determine commoncap.c's compilation.

Apart from being a logic cleanup, this is needed by the
upcoming cap_bset patch so that prctl can know whether
PR_SET_BSET should be allowed.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 security/Kconfig  |    4 ++++
 security/Makefile |    9 +++------
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/security/Kconfig b/security/Kconfig
index 8086e61..02b33fa 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -103,6 +103,10 @@ config SECURITY_ROOTPLUG
 	  
 	  If you are unsure how to answer this question, answer N.
 
+config COMMONCAP
+	bool
+	default !SECURITY || SECURITY_CAPABILITIES || SECURITY_ROOTPLUG
+
 source security/selinux/Kconfig
 
 endmenu
diff --git a/security/Makefile b/security/Makefile
index ef87df2..7cccc81 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -5,14 +5,11 @@
 obj-$(CONFIG_KEYS)			+= keys/
 subdir-$(CONFIG_SECURITY_SELINUX)	+= selinux
 
-# if we don't select a security model, use the default capabilities
-ifneq ($(CONFIG_SECURITY),y)
-obj-y		+= commoncap.o
-endif
+obj-$(CONFIG_COMMONCAP)			+= commoncap.o
 
 # Object file lists
 obj-$(CONFIG_SECURITY)			+= security.o dummy.o inode.o
 # Must precede capability.o in order to stack properly.
 obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
-obj-$(CONFIG_SECURITY_CAPABILITIES)	+= commoncap.o capability.o
-obj-$(CONFIG_SECURITY_ROOTPLUG)		+= commoncap.o root_plug.o
+obj-$(CONFIG_SECURITY_CAPABILITIES)	+= capability.o
+obj-$(CONFIG_SECURITY_ROOTPLUG)		+= root_plug.o
-- 
1.5.1.1.GIT

