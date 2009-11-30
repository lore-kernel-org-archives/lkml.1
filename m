Return-Path: <linux-kernel-owner+w=401wt.eu-S1753741AbZK3IXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbZK3IXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 03:23:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbZK3IXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 03:23:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:37805 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362AbZK3IXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 03:23:06 -0500
Date: Mon, 30 Nov 2009 08:22:44 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1259133352-23685-6-git-send-email-tzanussi@gmail.com>
References: <1259133352-23685-6-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/scripting] perf trace: Add interface to access perf data from Perl handlers
Message-ID: <tip-d1b93772be78486397693fc39d3ddea3fda90105@git.kernel.org>
Git-Commit-ID: d1b93772be78486397693fc39d3ddea3fda90105
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d1b93772be78486397693fc39d3ddea3fda90105
Gitweb:     http://git.kernel.org/tip/d1b93772be78486397693fc39d3ddea3fda90105
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Wed, 25 Nov 2009 01:15:50 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 28 Nov 2009 10:04:27 +0100

perf trace: Add interface to access perf data from Perl handlers

The Perl scripting support for perf trace allows most of a trace
event's data to be accessed directly as handler arguments, but
not all of it e.g. the less common fields aren't passed in.  To
give scripts access to the other fields and/or any other data or
metadata in the main perf executable that might be useful, a way
to access the C data in perf from Perl is needed; this patch
uses the Perl XS facility to do it for the common_xxx event
fields not passed to handler functions.

Context.pm exports three functions to Perl scripts that access
fields for the current event by calling back into perf:
common_pc(), common_flags() and common_lock_depth().  Support
for common_flags() field values was added to Core.pm and a
script used to sanity check these and other basic scripting
features, check-perf-trace.pl, was also added.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: fweisbec@gmail.com
Cc: rostedt@goodmis.org
Cc: anton@samba.org
Cc: hch@infradead.org
LKML-Reference: <1259133352-23685-6-git-send-email-tzanussi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile                                |    6 +-
 tools/perf/scripts/perl/Perf-Trace-Util/Context.c  |  134 ++++++++++++++++++++
 tools/perf/scripts/perl/Perf-Trace-Util/Context.xs |   41 ++++++
 .../perf/scripts/perl/Perf-Trace-Util/Makefile.PL  |   11 ++-
 tools/perf/scripts/perl/Perf-Trace-Util/README     |   34 +++++-
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Context.pm |   55 ++++++++
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Core.pm    |   35 +++++
 tools/perf/scripts/perl/Perf-Trace-Util/typemap    |    1 +
 tools/perf/scripts/perl/check-perf-trace.pl        |  106 ++++++++++++++++
 tools/perf/util/trace-event-parse.c                |    6 +-
 tools/perf/util/trace-event-perl.c                 |   46 +++++++-
 tools/perf/util/trace-event-perl.h                 |    9 ++
 tools/perf/util/trace-event.h                      |    3 +
 13 files changed, 474 insertions(+), 13 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index efbc0e8..8ad57b5 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -497,6 +497,7 @@ ifneq ($(shell sh -c "(echo '\#include <EXTERN.h>'; echo '\#include <perl.h>'; e
 	BASIC_CFLAGS += -DNO_LIBPERL
 else
 	ALL_LDFLAGS += $(PERL_EMBED_LDOPTS)
+	LIB_OBJS += scripts/perl/Perf-Trace-Util/Context.o
 endif
 
 ifdef NO_DEMANGLE
@@ -873,6 +874,9 @@ util/find_next_bit.o: ../../lib/find_next_bit.c PERF-CFLAGS
 util/trace-event-perl.o: util/trace-event-perl.c PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o util/trace-event-perl.o -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes  -Wno-unused-parameter $<
 
+scripts/perl/Perf-Trace-Util/Context.o: scripts/perl/Perf-Trace-Util/Context.c PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o scripts/perl/Perf-Trace-Util/Context.o -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs $<
+
 perf-%$X: %.o $(PERFLIBS)
 	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) -o $@ $(ALL_LDFLAGS) $(filter %.o,$^) $(LIBS)
 
@@ -1072,7 +1076,7 @@ distclean: clean
 #	$(RM) configure
 
 clean:
-	$(RM) *.o */*.o $(LIB_FILE)
+	$(RM) *.o */*.o */*/*.o */*/*/*.o $(LIB_FILE)
 	$(RM) $(ALL_PROGRAMS) $(BUILT_INS) perf$X
 	$(RM) $(TEST_PROGRAMS)
 	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo common-cmds.h TAGS tags cscope*
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Context.c b/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
new file mode 100644
index 0000000..3ba3ffc
--- /dev/null
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
@@ -0,0 +1,134 @@
+/*
+ * This file was generated automatically by ExtUtils::ParseXS version 2.18_02 from the
+ * contents of Context.xs. Do not edit this file, edit Context.xs instead.
+ *
+ *	ANY CHANGES MADE HERE WILL BE LOST! 
+ *
+ */
+
+#line 1 "Context.xs"
+/*
+ * Context.xs.  XS interfaces for perf trace.
+ *
+ * Copyright (C) 2009 Tom Zanussi <tzanussi@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include "EXTERN.h"
+#include "perl.h"
+#include "XSUB.h"
+#include "../../../util/trace-event-perl.h"
+
+#ifndef PERL_UNUSED_VAR
+#  define PERL_UNUSED_VAR(var) if (0) var = var
+#endif
+
+#line 41 "Context.c"
+
+XS(XS_Perf__Trace__Context_get_common_pc); /* prototype to pass -Wmissing-prototypes */
+XS(XS_Perf__Trace__Context_get_common_pc)
+{
+#ifdef dVAR
+    dVAR; dXSARGS;
+#else
+    dXSARGS;
+#endif
+    if (items != 1)
+       Perl_croak(aTHX_ "Usage: %s(%s)", "Perf::Trace::Context::get_common_pc", "context");
+    PERL_UNUSED_VAR(cv); /* -W */
+    {
+	struct scripting_context *	context = INT2PTR(struct scripting_context *,SvIV(ST(0)));
+	int	RETVAL;
+	dXSTARG;
+
+	RETVAL = get_common_pc(context);
+	XSprePUSH; PUSHi((IV)RETVAL);
+    }
+    XSRETURN(1);
+}
+
+
+XS(XS_Perf__Trace__Context_get_common_flags); /* prototype to pass -Wmissing-prototypes */
+XS(XS_Perf__Trace__Context_get_common_flags)
+{
+#ifdef dVAR
+    dVAR; dXSARGS;
+#else
+    dXSARGS;
+#endif
+    if (items != 1)
+       Perl_croak(aTHX_ "Usage: %s(%s)", "Perf::Trace::Context::get_common_flags", "context");
+    PERL_UNUSED_VAR(cv); /* -W */
+    {
+	struct scripting_context *	context = INT2PTR(struct scripting_context *,SvIV(ST(0)));
+	int	RETVAL;
+	dXSTARG;
+
+	RETVAL = get_common_flags(context);
+	XSprePUSH; PUSHi((IV)RETVAL);
+    }
+    XSRETURN(1);
+}
+
+
+XS(XS_Perf__Trace__Context_get_common_lock_depth); /* prototype to pass -Wmissing-prototypes */
+XS(XS_Perf__Trace__Context_get_common_lock_depth)
+{
+#ifdef dVAR
+    dVAR; dXSARGS;
+#else
+    dXSARGS;
+#endif
+    if (items != 1)
+       Perl_croak(aTHX_ "Usage: %s(%s)", "Perf::Trace::Context::get_common_lock_depth", "context");
+    PERL_UNUSED_VAR(cv); /* -W */
+    {
+	struct scripting_context *	context = INT2PTR(struct scripting_context *,SvIV(ST(0)));
+	int	RETVAL;
+	dXSTARG;
+
+	RETVAL = get_common_lock_depth(context);
+	XSprePUSH; PUSHi((IV)RETVAL);
+    }
+    XSRETURN(1);
+}
+
+#ifdef __cplusplus
+extern "C"
+#endif
+XS(boot_Perf__Trace__Context); /* prototype to pass -Wmissing-prototypes */
+XS(boot_Perf__Trace__Context)
+{
+#ifdef dVAR
+    dVAR; dXSARGS;
+#else
+    dXSARGS;
+#endif
+    const char* file = __FILE__;
+
+    PERL_UNUSED_VAR(cv); /* -W */
+    PERL_UNUSED_VAR(items); /* -W */
+    XS_VERSION_BOOTCHECK ;
+
+        newXSproto("Perf::Trace::Context::get_common_pc", XS_Perf__Trace__Context_get_common_pc, file, "$");
+        newXSproto("Perf::Trace::Context::get_common_flags", XS_Perf__Trace__Context_get_common_flags, file, "$");
+        newXSproto("Perf::Trace::Context::get_common_lock_depth", XS_Perf__Trace__Context_get_common_lock_depth, file, "$");
+    if (PL_unitcheckav)
+         call_list(PL_scopestack_ix, PL_unitcheckav);
+    XSRETURN_YES;
+}
+
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs b/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
new file mode 100644
index 0000000..24facb3
--- /dev/null
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
@@ -0,0 +1,41 @@
+/*
+ * Context.xs.  XS interfaces for perf trace.
+ *
+ * Copyright (C) 2009 Tom Zanussi <tzanussi@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include "EXTERN.h"
+#include "perl.h"
+#include "XSUB.h"
+#include "../../../util/trace-event-perl.h"
+
+MODULE = Perf::Trace::Context		PACKAGE = Perf::Trace::Context
+PROTOTYPES: ENABLE
+
+int
+get_common_pc(context)
+	struct scripting_context * context
+
+int
+get_common_flags(context)
+	struct scripting_context * context
+
+int
+get_common_lock_depth(context)
+	struct scripting_context * context
+
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Makefile.PL b/tools/perf/scripts/perl/Perf-Trace-Util/Makefile.PL
index b0de02e..decdeb0 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/Makefile.PL
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/Makefile.PL
@@ -3,10 +3,15 @@ use ExtUtils::MakeMaker;
 # See lib/ExtUtils/MakeMaker.pm for details of how to influence
 # the contents of the Makefile that is written.
 WriteMakefile(
-    NAME              => 'Perf::Trace::Util',
-    VERSION_FROM      => 'lib/Perf/Trace/Util.pm', # finds $VERSION
+    NAME              => 'Perf::Trace::Context',
+    VERSION_FROM      => 'lib/Perf/Trace/Context.pm', # finds $VERSION
     PREREQ_PM         => {}, # e.g., Module::Name => 1.1
     ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
-      (ABSTRACT_FROM  => 'lib/Perf/Trace/Util.pm', # retrieve abstract from module
+      (ABSTRACT_FROM  => 'lib/Perf/Trace/Context.pm', # retrieve abstract from module
        AUTHOR         => 'Tom Zanussi <tzanussi@gmail.com>') : ()),
+    LIBS              => [''], # e.g., '-lm'
+    DEFINE            => '-I ../..', # e.g., '-DHAVE_SOMETHING'
+    INC               => '-I.', # e.g., '-I. -I/usr/include/other'
+	# Un-comment this if you add C files to link with later:
+    OBJECT            => 'Context.o', # link all the C files too
 );
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/README b/tools/perf/scripts/perl/Perf-Trace-Util/README
index 0a58378..adb99aa 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/README
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/README
@@ -3,6 +3,34 @@ Perf-Trace-Util version 0.01
 
 This module contains utility functions for use with perf trace.
 
+Core.pm and Util.pm are pure Perl modules; Core.pm contains routines
+that the core perf support for Perl calls on and should always be
+'used', while Util.pm contains useful but optional utility functions
+that scripts may want to use.  Context.pm contains the Perl->C
+interface that allows scripts to access data in the embedding perf
+executable; scripts wishing to do that should 'use Context.pm'.
+
+The Perl->C perf interface is completely driven by Context.xs.  If you
+want to add new Perl functions that end up accessing C data in the
+perf executable, you add desciptions of the new functions here.
+scripting_context is a pointer to the perf data in the perf executable
+that you want to access - it's passed as the second parameter,
+$context, to all handler functions.
+
+After you do that:
+
+  perl Makefile.PL   # to create a Makefile for the next step
+  make               # to create Context.c
+
+  edit Context.c to add const to the char* file = __FILE__ line in
+  XS(boot_Perf__Trace__Context) to silence a warning/error.
+
+  You can delete the Makefile, object files and anything else that was
+  generated e.g. blib and shared library, etc, except for of course
+  Context.c
+
+  You should then be able to run the normal perf make as usual.
+
 INSTALLATION
 
 Building perf with perf trace Perl scripting should install this
@@ -15,12 +43,10 @@ DEPENDENCIES
 
 This module requires these other modules and libraries:
 
-  blah blah blah
+  None
 
 COPYRIGHT AND LICENCE
 
-Put the correct copyright and licence information here.
-
 Copyright (C) 2009 by Tom Zanussi <tzanussi@gmail.com>
 
 This library is free software; you can redistribute it and/or modify
@@ -31,5 +57,3 @@ Alternatively, this software may be distributed under the terms of the
 GNU General Public License ("GPL") version 2 as published by the Free
 Software Foundation.
 
-
-
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Context.pm b/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Context.pm
new file mode 100644
index 0000000..6c7f365
--- /dev/null
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Context.pm
@@ -0,0 +1,55 @@
+package Perf::Trace::Context;
+
+use 5.010000;
+use strict;
+use warnings;
+
+require Exporter;
+
+our @ISA = qw(Exporter);
+
+our %EXPORT_TAGS = ( 'all' => [ qw(
+) ] );
+
+our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
+
+our @EXPORT = qw(
+	common_pc common_flags common_lock_depth
+);
+
+our $VERSION = '0.01';
+
+require XSLoader;
+XSLoader::load('Perf::Trace::Context', $VERSION);
+
+1;
+__END__
+=head1 NAME
+
+Perf::Trace::Context - Perl extension for accessing functions in perf.
+
+=head1 SYNOPSIS
+
+  use Perf::Trace::Context;
+
+=head1 SEE ALSO
+
+Perf (trace) documentation
+
+=head1 AUTHOR
+
+Tom Zanussi, E<lt>tzanussi@gmail.com<gt>
+
+=head1 COPYRIGHT AND LICENSE
+
+Copyright (C) 2009 by Tom Zanussi
+
+This library is free software; you can redistribute it and/or modify
+it under the same terms as Perl itself, either Perl version 5.10.0 or,
+at your option, any later version of Perl 5 you may have available.
+
+Alternatively, this software may be distributed under the terms of the
+GNU General Public License ("GPL") version 2 as published by the Free
+Software Foundation.
+
+=cut
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Core.pm b/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Core.pm
index fd250fb..9df376a 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Core.pm
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Core.pm
@@ -16,10 +16,45 @@ our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
 our @EXPORT = qw(
 define_flag_field define_flag_value flag_str dump_flag_fields
 define_symbolic_field define_symbolic_value symbol_str dump_symbolic_fields
+trace_flag_str
 );
 
 our $VERSION = '0.01';
 
+my %trace_flags = (0x00 => "NONE",
+		   0x01 => "IRQS_OFF",
+		   0x02 => "IRQS_NOSUPPORT",
+		   0x04 => "NEED_RESCHED",
+		   0x08 => "HARDIRQ",
+		   0x10 => "SOFTIRQ");
+
+sub trace_flag_str
+{
+    my ($value) = @_;
+
+    my $string;
+
+    my $print_delim = 0;
+
+    foreach my $idx (sort {$a <=> $b} keys %trace_flags) {
+	if (!$value && !$idx) {
+	    $string .= "NONE";
+	    last;
+	}
+
+	if ($idx && ($value & $idx) == $idx) {
+	    if ($print_delim) {
+		$string .= " | ";
+	    }
+	    $string .= "$trace_flags{$idx}";
+	    $print_delim = 1;
+	    $value &= ~$idx;
+	}
+    }
+
+    return $string;
+}
+
 my %flag_fields;
 my %symbolic_fields;
 
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/typemap b/tools/perf/scripts/perl/Perf-Trace-Util/typemap
new file mode 100644
index 0000000..8408368
--- /dev/null
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/typemap
@@ -0,0 +1 @@
+struct scripting_context * T_PTR
diff --git a/tools/perf/scripts/perl/check-perf-trace.pl b/tools/perf/scripts/perl/check-perf-trace.pl
new file mode 100644
index 0000000..4e7dc0a
--- /dev/null
+++ b/tools/perf/scripts/perl/check-perf-trace.pl
@@ -0,0 +1,106 @@
+# perf trace event handlers, generated by perf trace -g perl
+# (c) 2009, Tom Zanussi <tzanussi@gmail.com>
+# Licensed under the terms of the GNU GPL License version 2
+
+# This script tests basic functionality such as flag and symbol
+# strings, common_xxx() calls back into perf, begin, end, unhandled
+# events, etc.  Basically, if this script runs successfully and
+# displays expected results, perl scripting support should be ok.
+
+use lib "$ENV{'PERF_EXEC_PATH'}/scripts/perl/Perf-Trace-Util/lib";
+use lib "./Perf-Trace-Util/lib";
+use Perf::Trace::Core;
+use Perf::Trace::Context;
+use Perf::Trace::Util;
+
+sub trace_begin
+{
+    print "trace_begin\n";
+}
+
+sub trace_end
+{
+    print "trace_end\n";
+
+    print_unhandled();
+}
+
+sub irq::softirq_entry
+{
+	my ($event_name, $context, $common_cpu, $common_secs, $common_nsecs,
+	    $common_pid, $common_comm,
+	    $vec) = @_;
+
+	print_header($event_name, $common_cpu, $common_secs, $common_nsecs,
+		     $common_pid, $common_comm);
+
+	print_uncommon($context);
+
+	printf("vec=%s\n",
+	       symbol_str("irq::softirq_entry", "vec", $vec));
+}
+
+sub kmem::kmalloc
+{
+	my ($event_name, $context, $common_cpu, $common_secs, $common_nsecs,
+	    $common_pid, $common_comm,
+	    $call_site, $ptr, $bytes_req, $bytes_alloc,
+	    $gfp_flags) = @_;
+
+	print_header($event_name, $common_cpu, $common_secs, $common_nsecs,
+		     $common_pid, $common_comm);
+
+	print_uncommon($context);
+
+	printf("call_site=%p, ptr=%p, bytes_req=%u, bytes_alloc=%u, ".
+	       "gfp_flags=%s\n",
+	       $call_site, $ptr, $bytes_req, $bytes_alloc,
+
+	       flag_str("kmem::kmalloc", "gfp_flags", $gfp_flags));
+}
+
+# print trace fields not included in handler args
+sub print_uncommon
+{
+    my ($context) = @_;
+
+    printf("common_preempt_count=%d, common_flags=%s, common_lock_depth=%d, ",
+	   common_pc($context), trace_flag_str(common_flags($context)),
+	   common_lock_depth($context));
+
+}
+
+my %unhandled;
+
+sub print_unhandled
+{
+    if ((scalar keys %unhandled) == 0) {
+	return;
+    }
+
+    print "\nunhandled events:\n\n";
+
+    printf("%-40s  %10s\n", "event", "count");
+    printf("%-40s  %10s\n", "----------------------------------------",
+	   "-----------");
+
+    foreach my $event_name (keys %unhandled) {
+	printf("%-40s  %10d\n", $event_name, $unhandled{$event_name});
+    }
+}
+
+sub trace_unhandled
+{
+    my ($event_name, $context, $common_cpu, $common_secs, $common_nsecs,
+	$common_pid, $common_comm) = @_;
+
+    $unhandled{$event_name}++;
+}
+
+sub print_header
+{
+	my ($event_name, $cpu, $secs, $nsecs, $pid, $comm) = @_;
+
+	printf("%-20s %5u %05u.%09u %8u %-20s ",
+	       $event_name, $cpu, $secs, $nsecs, $pid, $comm);
+}
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 1f16495..0302405 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1982,7 +1982,7 @@ int trace_parse_common_pid(void *data)
 			      "common_pid");
 }
 
-static int parse_common_pc(void *data)
+int parse_common_pc(void *data)
 {
 	static int pc_offset;
 	static int pc_size;
@@ -1991,7 +1991,7 @@ static int parse_common_pc(void *data)
 			      "common_preempt_count");
 }
 
-static int parse_common_flags(void *data)
+int parse_common_flags(void *data)
 {
 	static int flags_offset;
 	static int flags_size;
@@ -2000,7 +2000,7 @@ static int parse_common_flags(void *data)
 			      "common_flags");
 }
 
-static int parse_common_lock_depth(void *data)
+int parse_common_lock_depth(void *data)
 {
 	static int ld_offset;
 	static int ld_size;
diff --git a/tools/perf/util/trace-event-perl.c b/tools/perf/util/trace-event-perl.c
index c56b08d..d179ade 100644
--- a/tools/perf/util/trace-event-perl.c
+++ b/tools/perf/util/trace-event-perl.c
@@ -30,6 +30,21 @@
 #include "trace-event.h"
 #include "trace-event-perl.h"
 
+void xs_init(pTHX);
+
+void boot_Perf__Trace__Context(pTHX_ CV *cv);
+void boot_DynaLoader(pTHX_ CV *cv);
+
+void xs_init(pTHX)
+{
+	const char *file = __FILE__;
+	dXSUB_SYS;
+
+	newXS("Perf::Trace::Context::bootstrap", boot_Perf__Trace__Context,
+	      file);
+	newXS("DynaLoader::boot_DynaLoader", boot_DynaLoader, file);
+}
+
 INTERP my_perl;
 
 #define FTRACE_MAX_EVENT				\
@@ -227,6 +242,33 @@ static inline struct event *find_cache_event(int type)
 	return event;
 }
 
+int get_common_pc(struct scripting_context *context)
+{
+	int pc;
+
+	pc = parse_common_pc(context->event_data);
+
+	return pc;
+}
+
+int get_common_flags(struct scripting_context *context)
+{
+	int flags;
+
+	flags = parse_common_flags(context->event_data);
+
+	return flags;
+}
+
+int get_common_lock_depth(struct scripting_context *context)
+{
+	int lock_depth;
+
+	lock_depth = parse_common_lock_depth(context->event_data);
+
+	return lock_depth;
+}
+
 static void perl_process_event(int cpu, void *data,
 			       int size __attribute((unused)),
 			       unsigned long long nsecs, char *comm)
@@ -290,6 +332,7 @@ static void perl_process_event(int cpu, void *data,
 	}
 
 	PUTBACK;
+
 	if (get_cv(handler, 0))
 		call_pv(handler, G_SCALAR);
 	else if (get_cv("main::trace_unhandled", 0)) {
@@ -328,7 +371,8 @@ static int perl_start_script(const char *script)
 	my_perl = perl_alloc();
 	perl_construct(my_perl);
 
-	if (perl_parse(my_perl, NULL, 2, (char **)command_line, (char **)NULL))
+	if (perl_parse(my_perl, xs_init, 2, (char **)command_line,
+		       (char **)NULL))
 		return -1;
 
 	perl_run(my_perl);
diff --git a/tools/perf/util/trace-event-perl.h b/tools/perf/util/trace-event-perl.h
index 6c94fa9..666a864 100644
--- a/tools/perf/util/trace-event-perl.h
+++ b/tools/perf/util/trace-event-perl.h
@@ -29,6 +29,11 @@ typedef int INTERP;
 #define perl_run(a)		(0)
 #define perl_destruct(a)	(0)
 #define perl_free(a)		(0)
+#define pTHX			void
+#define CV			void
+#define dXSUB_SYS
+#define pTHX_
+static inline void newXS(const char *a, void *b, const char *c) {}
 #else
 #include <EXTERN.h>
 #include <perl.h>
@@ -39,4 +44,8 @@ struct scripting_context {
 	void *event_data;
 };
 
+int get_common_pc(struct scripting_context *context);
+int get_common_flags(struct scripting_context *context);
+int get_common_lock_depth(struct scripting_context *context);
+
 #endif /* __PERF_TRACE_EVENT_PERL_H */
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index b1e58d3..81698d5 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -246,6 +246,9 @@ extern int latency_format;
 int parse_header_page(char *buf, unsigned long size);
 int trace_parse_common_type(void *data);
 int trace_parse_common_pid(void *data);
+int parse_common_pc(void *data);
+int parse_common_flags(void *data);
+int parse_common_lock_depth(void *data);
 struct event *trace_find_event(int id);
 struct event *trace_find_next_event(struct event *event);
 unsigned long long read_size(void *ptr, int size);
