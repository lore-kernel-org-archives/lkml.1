Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbXKMOah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbXKMOah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 09:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbXKMO3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 09:29:48 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:34109 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbXKMO3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 09:29:46 -0500
Message-Id: <20071113142934.707089895@polymtl.ca>
References: <20071113142609.103579906@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 13 Nov 2007 09:26:10 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [patch 1/4] Create arch/Kconfig
Content-Disposition: inline; filename=add-kconfig-to-arch.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 13 Nov 2007 14:29:38 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Puts the content of arch/Kconfig in the "General setup" menu.

Linus:

> Should it come with a re-duplication of it's content into each
> architecture, which was the case previously ? The oprofile and kprobes
> menu entries were litteraly cut and pasted from one architecture to
> another. Should we put its content in init/Kconfig then ?

I don't think it's a good idea to go back to making it per-architecture,
although that extensive "depends on <list-of-archiectures-here>" might
indicate that there certainly is room for cleanup there.

And I don't think it's wrong keeping it in kernel/Kconfig.xyz per se, I
just think it's wrong to (a) lump the code together when it really doesn't
necessarily need to and (b) show it to users as some kind of choice that
is tied together (whether it then has common code or not).

On the per-architecture side, I do think it would be better to *not* have
internal architecture knowledge in a generic file, and as such a line like

        depends on X86_32 || IA64 || PPC || S390 || SPARC64 || X86_64 || AVR32

really shouldn't exist in a file like kernel/Kconfig.instrumentation.

It would be much better to do

        depends on ARCH_SUPPORTS_KPROBES

in that generic file, and then architectures that do support it would just
have a

        bool ARCH_SUPPORTS_KPROBES
                default y

in *their* architecture files. That would seem to be much more logical,
and is readable both for arch maintainers *and* for people who have no
clue - and don't care - about which architecture is supposed to support
which interface...
                   

Sam Ravnborg:

Stuff it into a new file: arch/Kconfig
We can then extend this file to include all the 'trailing'
Kconfig things that are anyway equal for all ARCHs.

But it should be kept clean - so if we introduce such a file
then we should use ARCH_HAS_whatever in the arch specific Kconfig
files to enable stuff that is not shared.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Sam Ravnborg <sam@ravnborg.org>
---
 arch/Kconfig |    3 +++
 init/Kconfig |    2 ++
 2 files changed, 5 insertions(+)

Index: linux-2.6-lttng/init/Kconfig
===================================================================
--- linux-2.6-lttng.orig/init/Kconfig	2007-11-02 13:20:51.000000000 -0400
+++ linux-2.6-lttng/init/Kconfig	2007-11-02 13:20:52.000000000 -0400
@@ -644,6 +644,8 @@ config SLOB
 
 endchoice
 
+source "arch/Kconfig"
+
 endmenu		# General setup
 
 config RT_MUTEXES
Index: linux-2.6-lttng/arch/Kconfig
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/arch/Kconfig	2007-11-02 13:20:52.000000000 -0400
@@ -0,0 +1,3 @@
+#
+# General architecture dependent options
+#

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
