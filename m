Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbZBQQ4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbZBQQ4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 11:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbZBQQ4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 11:56:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35637 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbZBQQ4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 11:56:25 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/3] Make it possible for the linker to discard local symbols
	from vmlinux
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Date: Tue, 17 Feb 2009 16:55:53 +0000
Message-ID: <20090217165552.17657.90940.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it possible for the linker to discard local symbols from vmlinux as they
cause vmlinux to balloon when CONFIG_KALLSYMS=y and they cause dump_stack() and
get_wchan() to produce useless information under some circumstances.

With this we add a config option (CONFIG_STRIP_ASM_SYMS) that will cause the
build to supply -X to the linker to tell it to strip temporary local symbols.

This doesn't seem to cause gdb any problems.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Makefile     |    4 ++++
 init/Kconfig |    8 ++++++++
 2 files changed, 12 insertions(+), 0 deletions(-)


diff --git a/Makefile b/Makefile
index 22d7584..359470f 100644
--- a/Makefile
+++ b/Makefile
@@ -589,6 +589,10 @@ LDFLAGS_BUILD_ID = $(patsubst -Wl$(comma)%,%,\
 LDFLAGS_MODULE += $(LDFLAGS_BUILD_ID)
 LDFLAGS_vmlinux += $(LDFLAGS_BUILD_ID)
 
+ifeq ($(CONFIG_STRIP_ASM_SYMS),y)
+LDFLAGS_vmlinux	+= -X
+endif
+
 # Default kernel image to build when no specific target is given.
 # KBUILD_IMAGE may be overruled on the command line or
 # set in the environment
diff --git a/init/Kconfig b/init/Kconfig
index f068071..50c267a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -737,6 +737,14 @@ config KALLSYMS_EXTRA_PASS
 	   you wait for kallsyms to be fixed.
 
 
+config STRIP_ASM_SYMS
+	bool "Strip assembler-generated symbols during link"
+	default n
+	help
+	  Strip internal assembler-generated symbols during a link (symbols
+	  that look like '.Lxxx') so they don't pollute the output of
+	  get_wchan() and suchlike.
+
 config HOTPLUG
 	bool "Support for hot-pluggable devices" if EMBEDDED
 	default y

