Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbYGLSXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbYGLSXA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 14:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbYGLSWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 14:22:51 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33519 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751233AbYGLSWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 14:22:50 -0400
Subject: [PATCH] simple dprobe like markers for the kernel
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Theodore Tso <tytso@mit.edu>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
In-Reply-To: <20080710153017.GB25939@mit.edu>
References: <1215638551.3444.39.camel__22002.9595810503$1215638656$gmane$org@localhost.localdomain>
	 <y0m1w22qxoj.fsf@ton.toronto.redhat.com>
	 <1215697794.3353.5.camel@localhost.localdomain>
	 <20080710142208.GC1213@redhat.com>
	 <1215700996.3353.30.camel@localhost.localdomain>
	 <20080710153017.GB25939@mit.edu>
Content-Type: text/plain
Date: Sat, 12 Jul 2008 13:22:45 -0500
Message-Id: <1215886965.3360.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just an incremental update based on feedback.  The most
significant was that making the marker a compiler barrier will free the
inserter from worrying about the mark sliding around changes to named
variables (and thus having to worry about this in placement) at
practically zero optimisation cost.  I also updated the code to drop and
asm section instead of using the static variable scheme.  I also added
documentation and made the module loader ignore them (since modules
don't go through the vmlinux.lds transformations).

I also added a simple versioning scheme (basically tack the version on
to the end of the section name).  It can be used simply and even
provides backwards compatibility (just emit the old and the new
sections).

If everyone's happy with this, I'll follow it up with the systemtap
changes to make use of them ... they've been incredibly helpful
debugging some of the CDROM problems for me so far.

James

---
>From 4916bf71aa808622503f9fa87e03ce577a65d6ac Mon Sep 17 00:00:00 2001
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Wed, 9 Jul 2008 16:18:16 -0500
Subject: [PATCH] add simple marker trace point infrastructure

his patch adds incredibly simple markers which are designed to be used
via kprobes.  All it does is add an extra section to the kernel (and
modules) which annotates the location in source file/line of the marker
and a description of the variables of interest.  Tools like systemtap
can then use the kernel dwarf2 debugging information to transform this
to a precise probe point that gives access to the named variables.

The beauty of this scheme is that it has zero cost in the unactivated
case (the extra section is discardable if you're not interested in the
information, and nothing is actually added into the routine being
marked).  The disadvantage is that it's really unusable for rolling your
own marker probes because it relies on the dwarf2 information to locate
the probe point for kprobes and unravel the local variables of interest,
so you need an external tool like systemtap to help you.

The scheme uses a printk format like string to describe the variables of
interest, so if those variables disappear, the compile breaks (even in
the unmarked case) which should help us keep the marked probe points
current.

For instance, this is what SCSI would look like with a probe point added
just before the command goes to the low level device

                trace_simple(queuecommand, "Command being queued %p Done function %p", cmd, scsi_done);
                rtn = host->hostt->queuecommand(cmd, scsi_done);
                trace_simple(queuecommand_return, "Command returning %p Return value %d", cmd, rtn);

Here you can see that each trace point describes two variables whose
values can be viewed at that point by the relevant tools.  The format
strings and variables can be used by a tool to perform dtrace -l like
functionality:

MODULE    FUNCTION         NAME                DESCRIPTION
scsi_mod  scsi_dispatch_io queuecommand        Command being queued $sdev; Done function $scsi_done
scsi_mod  scsi_dispatch_io queuecommand_return Command being queued $sdev; Return value $ret

So the trace points recommend to the user what variables to use and
briefly what they mean.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 Documentation/simple_markers.txt  |   61 +++++++++++++++++++++++++++++++++++++
 include/asm-generic/vmlinux.lds.h |    2 +
 include/linux/simple_marker.h     |   46 ++++++++++++++++++++++++++++
 kernel/module.c                   |    6 ++++
 4 files changed, 115 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/simple_markers.txt
 create mode 100644 include/linux/simple_marker.h

diff --git a/Documentation/simple_markers.txt b/Documentation/simple_markers.txt
new file mode 100644
index 0000000..e4c159a
--- /dev/null
+++ b/Documentation/simple_markers.txt
@@ -0,0 +1,61 @@
+			 Using Simple Markers
+			 ====================
+
+     James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
+
+This document describes the purpose and use of simple markers in the
+kernel.  These are designed to be used as lightweight zero passive
+impact markers in critical path subsystems (such as I/O).  They differ
+from conventional markers in that there is no actual instruction
+deposited for them into the stream of the object files (hence zero
+impact when not activated).
+
+Using Simple Markers
+--------------------
+
+All simple markers do is add an extra (unloaded) section to the kernel
+and modules which identifies the trace points by name file, line and
+interesting variables if CONFIG_KERNEL_INFO (enable debugging
+information) is set.
+
+The data in the section can only be used by debugging tools (like
+systemtap) in concert with the dwarf debugging information.  The way
+it works is that you use the marker in the section to translate the
+marker position to an exact file and line number which the dwarf
+information can then be used to locate in the program (and add probe
+points via kprobes).  The listed variables of interest can also be
+accessed via the dwarf debugging information within the kprobe
+(although again you need a tool to do this).
+
+Inserting Simple Markers
+------------------------
+
+Simple markers are very easy to use.  You simply
+
+#include <linux/simple_marker.h>
+
+And then insert a trace point with
+
+trace_simple(<name>, <variables description>, <variables of interest>);
+
+The <name> should be globally unique.  It is recommended that you
+break it up into <subsystem>:<component> (and even subdivide
+<component> with extra ':') it will be the name used to attach to the
+trace point.
+
+The <variables description> is a printf string format for each of the
+variables of interest, so say in SCSI we have two variables of
+interest at the trace point: the SCSI command (struct scsi_command
+*cmd) and the return value (int rtn) then the <variables description>
+is "SCSI Command %p Return value %d" and <variables of interest>
+becomes cmd, rtn.
+
+A tool parsing the sections can pick out the trace point name and
+variables and description, so it will list the variables as
+
+variables:
+	SCSI Command $cmd
+	Return value $rtn
+
+(The actual variables are displayed in the format the debugger makes
+use of them).
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index f054778..e686f55 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -299,6 +299,8 @@
 		.debug_funcnames 0 : { *(.debug_funcnames) }		\
 		.debug_typenames 0 : { *(.debug_typenames) }		\
 		.debug_varnames  0 : { *(.debug_varnames) }		\
+		/* simple markers (depends on dwarf2 debugging info) */	\
+		__simple_marker.1 (INFO) : { *(__simple_marker.1) }	\
 
 		/* Stabs debugging sections.  */
 #define STABS_DEBUG							\
diff --git a/include/linux/simple_marker.h b/include/linux/simple_marker.h
new file mode 100644
index 0000000..af8bb1e
--- /dev/null
+++ b/include/linux/simple_marker.h
@@ -0,0 +1,46 @@
+#ifndef __LINUX_SIMPLE_MARKER_H
+#define __LINUX_SIMPLE_MARKER_H
+
+#include <linux/compiler.h>
+#include <linux/stringify.h>
+
+/* Note: If you change the format, increase the version
+ * and change the section name by appending the version.  That
+ * way backwards compatibility is simple to maintain.  You must
+ * also update asm-generic/vmlinux.lds.h to modify the build
+ * rule to include the updated section(s) */
+
+#define SIMPLE_MARKER_VERSION	1
+#define SIMPLE_MARKER_SECTION		"__simple_marker"
+#define SIMPLE_MARKER_SECTION_NAME \
+	SIMPLE_MARKER_SECTION "." __stringify(SIMPLE_MARKER_VERSION)
+
+/* To be used for string format validity checking with gcc */
+static inline void __printf(1, 2)
+__trace_simple_check_format(const char *fmt, ...)
+{
+}
+
+#ifdef CONFIG_DEBUG_INFO
+#define trace_simple(name, format, args...)				\
+	do {								\
+		barrier();						\
+		asm (".pushsection " SIMPLE_MARKER_SECTION_NAME "\n"	\
+		     ".string \"" #name "\"\n"				\
+		     ".string \"" __FILE__ "\"\n"			\
+		     ".string \"" __stringify(__LINE__) "\"\n"		\
+		     ".string \"" format "\"\n"				\
+		     ".string \"" #args "\"\n"				\
+		     ".popsection\n");					\
+		if (0)							\
+			__trace_simple_check_format(format, ## args);	\
+	} while(0)
+#else
+#define trace_simple(name, format, args...)				\
+	do {								\
+		if (0)							\
+			__trace_simple_check_format(format, ## args);	\
+	 } while(0)
+#endif
+
+#endif
diff --git a/kernel/module.c b/kernel/module.c
index 5f80478..a1d1d85 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -40,6 +40,7 @@
 #include <linux/stop_machine.h>
 #include <linux/device.h>
 #include <linux/string.h>
+#include <linux/simple_marker.h>
 #include <linux/mutex.h>
 #include <linux/unwind.h>
 #include <asm/uaccess.h>
@@ -1828,6 +1829,11 @@ static struct module *load_module(void __user *umod,
 		if (strncmp(secstrings+sechdrs[i].sh_name, ".exit", 5) == 0)
 			sechdrs[i].sh_flags &= ~(unsigned long)SHF_ALLOC;
 #endif
+		/* Don't load any marker sections */
+		if (strncmp(secstrings+sechdrs[i].sh_name,
+			    SIMPLE_MARKER_SECTION "." ,
+			    sizeof(SIMPLE_MARKER_SECTION) + 1) == 0)
+			sechdrs[i].sh_flags &= ~(unsigned long)SHF_ALLOC;
 	}
 
 	modindex = find_sec(hdr, sechdrs, secstrings,
-- 
1.5.6




