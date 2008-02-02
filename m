Return-Path: <linux-kernel-owner+w=401wt.eu-S934714AbYBBUNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934714AbYBBUNR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 15:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761275AbYBBUM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 15:12:56 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:44594 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764148AbYBBUMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:12:55 -0500
Message-Id: <20080202201159.962025643@polymtl.ca>
References: <20080202201031.860344390@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sat, 02 Feb 2008 15:10:33 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Sam Ravnborg <sam@ravnborg.org>, Jeff Dike <jdike@addtoit.com>,
       David Howells <dhowells@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: [patch 2/5] Create arch/Kconfig
Content-Disposition: inline; filename=create-arch-kconfig.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sat,  2 Feb 2008 20:12:00 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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

[...]

The above suggestion is actually not exactly the best way to do it...
First the naming..
A quick grep shows following usage today (in Kconfig files)
ARCH_HAS        51
ARCH_SUPPORTS   4
HAVE_ARCH       7

ARCH_HAS is the clear winner.


In the common Kconfig file do:

config FOO
        depends on ARCH_HAS_FOO
        bool "bla bla"

config ARCH_HAS_FOO
        def_bool n


In the arch specific Kconfig file in a suitable place do:

config SUITABLE_OPTION
        select ARCH_HAS_FOO


The naming of ARCH_HAS_ is fixed and shall be:
ARCH_HAS_<config option it will enable>


Only a single line added pr. architecture.
And we will end up with a (maybe even commented) list of trivial selects.

- Yet another update :

Moving to HAVE_* now.


Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 arch/Kconfig |    3 +++
 init/Kconfig |    2 ++
 2 files changed, 5 insertions(+)

Index: linux-2.6-lttng/init/Kconfig
===================================================================
--- linux-2.6-lttng.orig/init/Kconfig	2008-01-29 15:04:23.000000000 -0500
+++ linux-2.6-lttng/init/Kconfig	2008-01-29 15:22:47.000000000 -0500
@@ -665,6 +665,8 @@ config SLOB
 
 endchoice
 
+source "arch/Kconfig"
+
 endmenu		# General setup
 
 config SLABINFO
Index: linux-2.6-lttng/arch/Kconfig
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/arch/Kconfig	2008-01-29 15:22:47.000000000 -0500
@@ -0,0 +1,3 @@
+#
+# General architecture dependent options
+#

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
