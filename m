Return-Path: <linux-kernel-owner+w=401wt.eu-S1753052Ab0A0I3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab0A0I3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 03:29:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768Ab0A0I20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 03:28:26 -0500
Received: from mail-iw0-f186.google.com ([209.85.223.186]:38170 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab0A0I2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 03:28:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AxtAQI+Pzn4hySz8Ivwq+4WI3TQsHcewJnNEkQ3LOtyUTlynbpKlby1+z5QtD8sz/s
         /qhq/wqz0PBr/XEBc9NvBpbRT2taT9Un4bWSLKrXpvTkPGf08bbgwSfZZBzbcKH5630m
         o/y0luGhZHaGwYvd064kGjDCVqvScw5GD8n+s=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com
Subject: [PATCH 11/12] perf trace/scripting: make the syscall map available as a Perl hash
Date: Wed, 27 Jan 2010 02:28:02 -0600
Message-Id: <1264580883-15324-12-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1264580883-15324-1-git-send-email-tzanussi@gmail.com>
References: <1264580883-15324-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a Perl extension that makes the perf syscall map into a
Perl hash.

New instances of the syscall hash can be retrieved at any time by by
calling the Perl function get_syscall_names().  This is a hash
reference, so use hash reference syntax to access its contents.

Also adds a new utility function that makes uses of the syscall name
dict:

syscall_name($syscall_nr);

which returns a syscall name given a syscall_nr, or the number itself
if the syscall wasn't found in the map (or 'undefined' if the value
passed in was bogus).

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/scripts/perl/Perf-Trace-Util/Context.c  |   46 +++++++++++++++++++-
 tools/perf/scripts/perl/Perf-Trace-Util/Context.xs |   24 ++++++++++
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Context.pm |    2 +-
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm    |   22 +++++++++-
 tools/perf/scripts/perl/failed-syscalls.pl         |   15 ++++++-
 5 files changed, 105 insertions(+), 4 deletions(-)

diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Context.c b/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
index 01a64ad..ae2279d 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
@@ -34,11 +34,32 @@
 #include "../../../perf.h"
 #include "../../../util/trace-event.h"
 
+static HV *get_syscall_names(void)
+{
+	const struct syscall_metadata *meta;
+	char buf[8];
+	HV *hash;
+	int i;
+
+	hash = (HV *)sv_2mortal((SV *)newHV());
+	if (!hash)
+		return NULL;
+
+	for (i = 0; i < nr_syscalls(); i++) {
+		meta  = syscall_at_idx(i);
+		sprintf(buf, "%d", meta->nr);
+		(void) hv_store(hash, buf, strlen(buf),
+		       newSVpv(meta->name, 0), 0);
+	}
+
+	return hash;
+}
+
 #ifndef PERL_UNUSED_VAR
 #  define PERL_UNUSED_VAR(var) if (0) var = var
 #endif
 
-#line 42 "Context.c"
+#line 63 "Context.c"
 
 XS(XS_Perf__Trace__Context_common_pc); /* prototype to pass -Wmissing-prototypes */
 XS(XS_Perf__Trace__Context_common_pc)
@@ -108,6 +129,28 @@ XS(XS_Perf__Trace__Context_common_lock_depth)
     XSRETURN(1);
 }
 
+
+XS(XS_Perf__Trace__Context_get_syscall_names); /* prototype to pass -Wmissing-prototypes */
+XS(XS_Perf__Trace__Context_get_syscall_names)
+{
+#ifdef dVAR
+    dVAR; dXSARGS;
+#else
+    dXSARGS;
+#endif
+    if (items != 0)
+       Perl_croak(aTHX_ "Usage: %s(%s)", "Perf::Trace::Context::get_syscall_names", "");
+    PERL_UNUSED_VAR(cv); /* -W */
+    {
+	HV *	RETVAL;
+
+	RETVAL = get_syscall_names();
+	ST(0) = newRV((SV*)RETVAL);
+	sv_2mortal(ST(0));
+    }
+    XSRETURN(1);
+}
+
 #ifdef __cplusplus
 extern "C"
 #endif
@@ -128,6 +171,7 @@ XS(boot_Perf__Trace__Context)
         newXSproto("Perf::Trace::Context::common_pc", XS_Perf__Trace__Context_common_pc, file, "$");
         newXSproto("Perf::Trace::Context::common_flags", XS_Perf__Trace__Context_common_flags, file, "$");
         newXSproto("Perf::Trace::Context::common_lock_depth", XS_Perf__Trace__Context_common_lock_depth, file, "$");
+        newXSproto("Perf::Trace::Context::get_syscall_names", XS_Perf__Trace__Context_get_syscall_names, file, "");
     if (PL_unitcheckav)
          call_list(PL_scopestack_ix, PL_unitcheckav);
     XSRETURN_YES;
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs b/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
index 549cf04..d016473 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
@@ -25,6 +25,27 @@
 #include "../../../perf.h"
 #include "../../../util/trace-event.h"
 
+static HV *get_syscall_names(void)
+{
+	const struct syscall_metadata *meta;
+	char buf[8];
+	HV *hash;
+	int i;
+
+	hash = (HV *)sv_2mortal((SV *)newHV());
+	if (!hash)
+		return NULL;
+
+	for (i = 0; i < nr_syscalls(); i++) {
+		meta  = syscall_at_idx(i);
+		sprintf(buf, "%d", meta->nr);
+		(void) hv_store(hash, buf, strlen(buf),
+		       newSVpv(meta->name, 0), 0);
+	}
+
+	return hash;
+}
+
 MODULE = Perf::Trace::Context		PACKAGE = Perf::Trace::Context
 PROTOTYPES: ENABLE
 
@@ -40,3 +61,6 @@ int
 common_lock_depth(context)
 	struct scripting_context * context
 
+HV *
+get_syscall_names()
+
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Context.pm b/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Context.pm
index 6c7f365..dc2231e 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Context.pm
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Context.pm
@@ -14,7 +14,7 @@ our %EXPORT_TAGS = ( 'all' => [ qw(
 our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
 
 our @EXPORT = qw(
-	common_pc common_flags common_lock_depth
+	common_pc common_flags common_lock_depth get_syscall_names
 );
 
 our $VERSION = '0.01';
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm b/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm
index f869c48..d62314b 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm
@@ -4,6 +4,9 @@ use 5.010000;
 use strict;
 use warnings;
 
+use Perf::Trace::Core;
+use Perf::Trace::Context;
+
 require Exporter;
 
 our @ISA = qw(Exporter);
@@ -14,7 +17,7 @@ our %EXPORT_TAGS = ( 'all' => [ qw(
 our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
 
 our @EXPORT = qw(
-avg nsecs nsecs_secs nsecs_nsecs nsecs_usecs print_nsecs
+avg nsecs nsecs_secs nsecs_nsecs nsecs_usecs print_nsecs syscall_name
 );
 
 our $VERSION = '0.01';
@@ -55,6 +58,23 @@ sub nsecs_str {
     return $str;
 }
 
+my $syscall_name_map = get_syscall_names();
+
+sub syscall_name
+{
+	my ($id) = @_;
+
+	if ($id == -1) {
+	    return "undefined"
+	}
+
+	if ($syscall_name_map->{$id}) {
+	    return $syscall_name_map->{$id};
+	} else {
+	    return $id;
+	}
+}
+
 1;
 __END__
 =head1 NAME
diff --git a/tools/perf/scripts/perl/failed-syscalls.pl b/tools/perf/scripts/perl/failed-syscalls.pl
index c18e7e2..eeaaa28 100644
--- a/tools/perf/scripts/perl/failed-syscalls.pl
+++ b/tools/perf/scripts/perl/failed-syscalls.pl
@@ -12,6 +12,7 @@ use Perf::Trace::Context;
 use Perf::Trace::Util;
 
 my %failed_syscalls;
+my %failed_syscall_ids;
 
 sub raw_syscalls::sys_exit
 {
@@ -21,12 +22,13 @@ sub raw_syscalls::sys_exit
 
 	if ($ret < 0) {
 	    $failed_syscalls{$common_comm}++;
+	    $failed_syscall_ids{$id}++;
 	}
 }
 
 sub trace_end
 {
-    printf("\nfailed syscalls by comm:\n\n");
+    printf("\nfailed syscalls, by comm:\n\n");
 
     printf("%-20s  %10s\n", "comm", "# errors");
     printf("%-20s  %6s  %10s\n", "--------------------", "----------");
@@ -35,4 +37,15 @@ sub trace_end
 		      keys %failed_syscalls) {
 	    printf("%-20s  %10s\n", $comm, $failed_syscalls{$comm});
     }
+
+    printf("\n\nfailed syscalls, by syscall:\n\n");
+
+    printf("%-30s  %10s\n", "syscall", "# errors");
+    printf("%-30s  %6s  %10s\n", "------------------------------",
+	   "----------");
+
+    foreach my $id (sort {$failed_syscall_ids{$b} <=> $failed_syscall_ids{$a}}
+		    keys %failed_syscall_ids) {
+	printf("%-30s  %10d\n", syscall_name($id), $failed_syscall_ids{$id});
+    }
 }
-- 
1.6.4.GIT

