Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbZJFGLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbZJFGLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 02:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756468AbZJFGLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 02:11:13 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:62403 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbZJFGKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 02:10:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=enBquoMoxlTL2h4A1jboW4GAtGRMt5/eUJe8oZFc0kkW4KpOvI5DDg4DxRHR1f61c1
         0YuOsgXsZ9woRjPk1/ASOScNLVCupjKKIkzyV8jSXUJ8uydpV285SzRvVvmwBrf39LSG
         JpxV3j8OLwEFmLTtlbFsDjY2NmsYvNrnmVyaU=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, hch@infradead.org
Subject: [RFC][PATCH 8/9] perf trace: Add perf trace scripting support modules for Perl
Date: Tue,  6 Oct 2009 01:09:57 -0500
Message-Id: <1254809398-8078-9-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1254809398-8078-1-git-send-email-tzanussi@gmail.com>
References: <1254809398-8078-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Perf-Trace-Util support module and example scripts that use it.
Also adds some makefile bits to install them in
libexec/perf-core/scripts/perl (or wherever perfexec_instdir points).

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/Makefile                                |   12 ++
 tools/perf/scripts/perl/Perf-Trace-Util/Changes    |    6 +
 tools/perf/scripts/perl/Perf-Trace-Util/MANIFEST   |    6 +
 .../perf/scripts/perl/Perf-Trace-Util/Makefile.PL  |   12 ++
 tools/perf/scripts/perl/Perf-Trace-Util/README     |   30 ++++
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Core.pm    |  165 ++++++++++++++++++++
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm    |   97 ++++++++++++
 .../perl/Perf-Trace-Util/t/Perf-Trace-Util.t       |   15 ++
 tools/perf/scripts/perl/rw-by-file.pl              |   95 +++++++++++
 tools/perf/scripts/perl/rw-by-pid.pl               |  151 ++++++++++++++++++
 tools/perf/scripts/perl/wakeup-latency.pl          |   94 +++++++++++
 tools/perf/scripts/perl/workqueue-stats.pl         |  121 ++++++++++++++
 12 files changed, 804 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/Changes
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/MANIFEST
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/Makefile.PL
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/README
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Core.pm
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/t/Perf-Trace-Util.t
 create mode 100644 tools/perf/scripts/perl/rw-by-file.pl
 create mode 100644 tools/perf/scripts/perl/rw-by-pid.pl
 create mode 100644 tools/perf/scripts/perl/wakeup-latency.pl
 create mode 100644 tools/perf/scripts/perl/workqueue-stats.pl

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a443bd3..50b8f64 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -901,6 +901,18 @@ export perfexec_instdir
 install: all
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'
 	$(INSTALL) perf$X '$(DESTDIR_SQ)$(bindir_SQ)'
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/t'
+	$(INSTALL) scripts/perl/Perf-Trace-Util/lib/Perf/Trace/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
+	$(INSTALL) scripts/perl/Perf-Trace-Util/t/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/t'
+	$(INSTALL) scripts/perl/Perf-Trace-Util/Changes -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util'
+	$(INSTALL) scripts/perl/Perf-Trace-Util/Makefile.PL -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util'
+	$(INSTALL) scripts/perl/Perf-Trace-Util/MANIFEST -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util'
+	$(INSTALL) scripts/perl/Perf-Trace-Util/README -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util'
+	$(INSTALL) scripts/perl/wakeup-latency.pl -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl'
+	$(INSTALL) scripts/perl/workqueue-stats.pl -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl'
+	$(INSTALL) scripts/perl/rw-by-pid.pl -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl'
+	$(INSTALL) scripts/perl/rw-by-file.pl -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl'
 ifdef BUILT_INS
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 	$(INSTALL) $(BUILT_INS) '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Changes b/tools/perf/scripts/perl/Perf-Trace-Util/Changes
new file mode 100644
index 0000000..3deccab
--- /dev/null
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/Changes
@@ -0,0 +1,6 @@
+Revision history for Perl extension Perf::Trace::Util.
+
+0.01  Fri Sep 25 12:08:40 2009
+	- original version; created by h2xs 1.23 with options
+		-AXn Perf::Trace::Util
+
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/MANIFEST b/tools/perf/scripts/perl/Perf-Trace-Util/MANIFEST
new file mode 100644
index 0000000..09379e1
--- /dev/null
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/MANIFEST
@@ -0,0 +1,6 @@
+Changes
+Makefile.PL
+MANIFEST
+README
+t/Perf-Trace-Util.t
+lib/Perf/Trace/Util.pm
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Makefile.PL b/tools/perf/scripts/perl/Perf-Trace-Util/Makefile.PL
new file mode 100644
index 0000000..b0de02e
--- /dev/null
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/Makefile.PL
@@ -0,0 +1,12 @@
+use 5.010000;
+use ExtUtils::MakeMaker;
+# See lib/ExtUtils/MakeMaker.pm for details of how to influence
+# the contents of the Makefile that is written.
+WriteMakefile(
+    NAME              => 'Perf::Trace::Util',
+    VERSION_FROM      => 'lib/Perf/Trace/Util.pm', # finds $VERSION
+    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
+    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
+      (ABSTRACT_FROM  => 'lib/Perf/Trace/Util.pm', # retrieve abstract from module
+       AUTHOR         => 'Tom Zanussi <tzanussi@gmail.com>') : ()),
+);
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/README b/tools/perf/scripts/perl/Perf-Trace-Util/README
new file mode 100644
index 0000000..af1078c
--- /dev/null
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/README
@@ -0,0 +1,30 @@
+Perf-Trace-Util version 0.01
+============================
+
+This module contains utility functions for use with perf trace.
+
+INSTALLATION
+
+Building perf with perf trace Perl scripting should install this
+module in the right place.
+
+You should make sure libperl is installed first e.g. apt-get install
+libperl-dev.
+
+DEPENDENCIES
+
+This module requires these other modules and libraries:
+
+  blah blah blah
+
+COPYRIGHT AND LICENCE
+
+Put the correct copyright and licence information here.
+
+Copyright (C) 2009 by Tom Zanussi <tzanussi@gmail.com>
+
+This library is free software; you can redistribute it and/or modify
+it under the same terms as Perl itself, either Perl version 5.10.0 or,
+at your option, any later version of Perl 5 you may have available.
+
+
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Core.pm b/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Core.pm
new file mode 100644
index 0000000..37b52d3
--- /dev/null
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Core.pm
@@ -0,0 +1,165 @@
+package Perf::Trace::Core;
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
+define_flag_field define_flag_value flag_str dump_flag_fields
+define_symbolic_field define_symbolic_value symbol_str dump_symbolic_fields
+);
+
+our $VERSION = '0.01';
+
+my %flag_fields;
+my %symbolic_fields;
+
+sub flag_str
+{
+    my ($event_name, $field_name, $value) = @_;
+
+    my $string;
+
+    if ($flag_fields{$event_name}{$field_name}) {
+	my $print_delim = 0;
+	foreach my $idx (sort {$a <=> $b} keys %{$flag_fields{$event_name}{$field_name}{"values"}}) {
+	    if (!$value && !$idx) {
+		$string .= "$flag_fields{$event_name}{$field_name}{'values'}{$idx}";
+		last;
+	    }
+	    if ($idx && ($value & $idx) == $idx) {
+		if ($print_delim && $flag_fields{$event_name}{$field_name}{'delim'}) {
+		    $string .= " $flag_fields{$event_name}{$field_name}{'delim'} ";
+		}
+		$string .= "$flag_fields{$event_name}{$field_name}{'values'}{$idx}";
+		$print_delim = 1;
+		$value &= ~$idx;
+	    }
+	}
+    }
+
+    return $string;
+}
+
+sub define_flag_field
+{
+    my ($event_name, $field_name, $delim) = @_;
+
+    $flag_fields{$event_name}{$field_name}{"delim"} = $delim;
+}
+
+sub define_flag_value
+{
+    my ($event_name, $field_name, $value, $field_str) = @_;
+
+    $flag_fields{$event_name}{$field_name}{"values"}{$value} = $field_str;
+}
+
+sub dump_flag_fields
+{
+    for my $event (keys %flag_fields) {
+	print "event $event:\n";
+	for my $field (keys %{$flag_fields{$event}}) {
+	    print "    field: $field:\n";
+	    print "        delim: $flag_fields{$event}{$field}{'delim'}\n";
+	    foreach my $idx (sort {$a <=> $b} keys %{$flag_fields{$event}{$field}{"values"}}) {
+		print "        value $idx: $flag_fields{$event}{$field}{'values'}{$idx}\n";
+	    }
+	}
+    }
+}
+
+sub symbol_str
+{
+    my ($event_name, $field_name, $value) = @_;
+
+    if ($symbolic_fields{$event_name}{$field_name}) {
+	foreach my $idx (sort {$a <=> $b} keys %{$symbolic_fields{$event_name}{$field_name}{"values"}}) {
+	    if (!$value && !$idx) {
+		return "$symbolic_fields{$event_name}{$field_name}{'values'}{$idx}";
+		last;
+	    }
+	    if ($value == $idx) {
+		return "$symbolic_fields{$event_name}{$field_name}{'values'}{$idx}";
+	    }
+	}
+    }
+
+    return undef;
+}
+
+sub define_symbolic_field
+{
+    my ($event_name, $field_name) = @_;
+
+    # nothing to do, really
+}
+
+sub define_symbolic_value
+{
+    my ($event_name, $field_name, $value, $field_str) = @_;
+
+    $symbolic_fields{$event_name}{$field_name}{"values"}{$value} = $field_str;
+}
+
+sub dump_symbolic_fields
+{
+    for my $event (keys %symbolic_fields) {
+	print "event $event:\n";
+	for my $field (keys %{$symbolic_fields{$event}}) {
+	    print "    field: $field:\n";
+	    foreach my $idx (sort {$a <=> $b} keys %{$symbolic_fields{$event}{$field}{"values"}}) {
+		print "        value $idx: $symbolic_fields{$event}{$field}{'values'}{$idx}\n";
+	    }
+	}
+    }
+}
+
+1;
+__END__
+=head1 NAME
+
+Perf::Trace::Core - Perl extension for perf trace
+
+=head1 SYNOPSIS
+
+  use Perf::Trace::Core
+
+=head1 DESCRIPTION
+
+Core functions for use with perf trace.  The define_* functions are
+called by the event-processing loop and shouldn't be called by users.
+All others are user-callable.
+
+=head2 EXPORT
+
+  flag_str - return a string with the string represention of a flag field
+  symbolic_str - return a string with the string represention of a symbol field
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
+
+=cut
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm b/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm
new file mode 100644
index 0000000..b3037fe
--- /dev/null
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm
@@ -0,0 +1,97 @@
+package Perf::Trace::Util;
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
+avg nsecs nsecs_secs nsecs_nsecs nsecs_usecs print_nsecs
+);
+
+our $VERSION = '0.01';
+
+sub avg
+{
+    my ($total, $n) = @_;
+
+    return $total / $n;
+}
+
+my $NSECS_PER_SEC    = 1000000000;
+
+sub nsecs
+{
+    my ($secs, $nsecs) = @_;
+
+    return $secs * $NSECS_PER_SEC + $nsecs;
+}
+
+sub nsecs_secs {
+    my ($nsecs) = @_;
+
+    return $nsecs / $NSECS_PER_SEC;
+}
+
+sub nsecs_nsecs {
+    my ($nsecs) = @_;
+
+    return $nsecs - nsecs_secs($nsecs);
+}
+
+sub nsecs_str {
+    my ($nsecs) = @_;
+
+    my $str = sprintf("%5u.%09u", nsecs_secs($nsecs), nsecs_nsecs($nsecs));
+
+    return $str;
+}
+
+1;
+__END__
+=head1 NAME
+
+Perf::Trace::Util - Perl extension for perf trace
+
+=head1 SYNOPSIS
+
+  use Perf::Trace::Util;
+
+=head1 DESCRIPTION
+
+Utility functions for use with perf trace.
+
+=head2 EXPORT
+
+  nsecs - return total nsecs given secs/nsecs pair
+  nsecs_secs - return whole secs portion given nsecs
+  nsecs_nsecs - return nsecs remainder given nsecs
+  nsecs_str - return printable string in the form secs.nsecs
+  avg - return average given a sum and a total number of values
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
+
+=cut
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/t/Perf-Trace-Util.t b/tools/perf/scripts/perl/Perf-Trace-Util/t/Perf-Trace-Util.t
new file mode 100644
index 0000000..8166a8c
--- /dev/null
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/t/Perf-Trace-Util.t
@@ -0,0 +1,15 @@
+# Before `make install' is performed this script should be runnable with
+# `make test'. After `make install' it should work as `perl Perf-Trace-Util.t'
+
+#########################
+
+# change 'tests => 1' to 'tests => last_test_to_print';
+
+use Test::More tests => 1;
+BEGIN { use_ok('Perf::Trace::Util') };
+
+#########################
+
+# Insert your test code below, the Test::More module is use()ed here so read
+# its man page ( perldoc Test::More ) for help writing this test script.
+
diff --git a/tools/perf/scripts/perl/rw-by-file.pl b/tools/perf/scripts/perl/rw-by-file.pl
new file mode 100644
index 0000000..2bf0d0d
--- /dev/null
+++ b/tools/perf/scripts/perl/rw-by-file.pl
@@ -0,0 +1,95 @@
+# Display r/w activity for files read/written to for a given program
+
+# The common_* event handler fields are the most useful fields common to
+# all events.  They don't necessarily correspond to the 'common_*' fields
+# in the status files.  Those fields not available as handler params can
+# be retrieved via script functions of the form get_common_*().
+
+use lib "$ENV{'PERF_EXEC_PATH'}/scripts/perl/Perf-Trace-Util/lib";
+use lib "./Perf-Trace-Util/lib";
+use Perf::Trace::Core;
+use Perf::Trace::Util;
+
+# change this to the comm of the program you're interested in
+my $for_comm = "perf";
+
+my %reads;
+my %writes;
+
+sub syscalls::sys_enter_read
+{
+    my ($event_name, $common_cpu, $common_secs, $common_nsecs,
+	$common_pid, $common_comm, $nr, $fd, $buf, $count) = @_;
+
+    if ($common_comm == $for_comm) {
+	$reads{$fd}{bytes_requested} += $count;
+	$reads{$fd}{total_reads}++;
+    }
+}
+
+sub syscalls::sys_enter_write
+{
+    my ($event_name, $common_cpu, $common_secs, $common_nsecs,
+	$common_pid, $common_comm, $nr, $fd, $buf, $count) = @_;
+
+    if ($common_comm == $for_comm) {
+	$writes{$fd}{bytes_written} += $count;
+	$writes{$fd}{total_writes}++;
+    }
+}
+
+sub trace_end
+{
+    printf("file read counts for $for_comm:\n\n");
+
+    printf("%6s  %10s  %10s\n", "fd", "# reads", "bytes_requested");
+    printf("%6s  %10s  %10s\n", "------", "----------", "-----------");
+
+    foreach my $fd (sort {$reads{$b}{bytes_requested} <=> $reads{$a}{bytes_requested}} keys %reads) {
+	my $total_reads = $reads{$fd}{total_reads};
+	my $bytes_requested = $reads{$fd}{bytes_requested};
+	printf("%6u  %10u  %10u\n", $fd, $total_reads, $bytes_requested);
+    }
+
+    printf("\nfile write counts for $for_comm:\n\n");
+
+    printf("%6s  %10s  %10s\n", "fd", "# writes", "bytes_written");
+    printf("%6s  %10s  %10s\n", "------", "----------", "-----------");
+
+    foreach my $fd (sort {$writes{$b}{bytes_written} <=> $writes{$a}{bytes_written}} keys %writes) {
+	my $total_writes = $writes{$fd}{total_writes};
+	my $bytes_written = $writes{$fd}{bytes_written};
+	printf("%6u  %10u  %10u\n", $fd, $total_writes, $bytes_written);
+    }
+
+    print_unhandled();
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
+    my ($event_name, $common_cpu, $common_secs, $common_nsecs, $common_pid,
+	$common_comm) = @_;
+
+    $unhandled{$event_name}++;
+}
+
+
diff --git a/tools/perf/scripts/perl/rw-by-pid.pl b/tools/perf/scripts/perl/rw-by-pid.pl
new file mode 100644
index 0000000..ea7afe8
--- /dev/null
+++ b/tools/perf/scripts/perl/rw-by-pid.pl
@@ -0,0 +1,151 @@
+# Display r/w activity for all processes
+
+# The common_* event handler fields are the most useful fields common to
+# all events.  They don't necessarily correspond to the 'common_*' fields
+# in the status files.  Those fields not available as handler params can
+# be retrieved via script functions of the form get_common_*().
+
+use lib "$ENV{'PERF_EXEC_PATH'}/scripts/perl/Perf-Trace-Util/lib";
+use lib "./Perf-Trace-Util/lib";
+use Perf::Trace::Core;
+use Perf::Trace::Util;
+
+my %reads;
+my %writes;
+
+sub syscalls::sys_exit_read
+{
+    my ($event_name, $common_cpu, $common_secs, $common_nsecs, $common_pid, $common_comm,
+        $nr, $ret) = @_;
+
+    if ($ret > 0) {
+	$reads{$common_pid}{bytes_read} += $ret;
+    } else {
+	$reads{$common_pid}{errors}{$ret}++;
+    }
+}
+
+sub syscalls::sys_enter_read
+{
+    my ($event_name, $common_cpu, $common_secs, $common_nsecs, $common_pid, $common_comm,
+        $nr, $fd, $buf, $count) = @_;
+
+    $reads{$common_pid}{bytes_requested} += $count;
+    $reads{$common_pid}{total_reads}++;
+    $reads{$common_pid}{comm} = $common_comm;
+}
+
+sub syscalls::sys_exit_write
+{
+    my ($event_name, $common_cpu, $common_secs, $common_nsecs, $common_pid, $common_comm,
+        $nr, $ret) = @_;
+
+    if ($ret <= 0) {
+	$writes{$common_pid}{errors}{$ret}++;
+    }
+}
+
+sub syscalls::sys_enter_write
+{
+    my ($event_name, $common_cpu, $common_secs, $common_nsecs, $common_pid, $common_comm,
+        $nr, $fd, $buf, $count) = @_;
+
+    $writes{$common_pid}{bytes_written} += $count;
+    $writes{$common_pid}{total_writes}++;
+    $writes{$common_pid}{comm} = $common_comm;
+}
+
+sub trace_end
+{
+    printf("read counts by pid:\n\n");
+
+    printf("%6s  %20s  %10s  %10s  %10s\n", "pid", "comm",
+	   "# reads", "bytes_requested", "bytes_read");
+    printf("%6s  %-20s  %10s  %10s  %10s\n", "------", "--------------------",
+	   "-----------", "----------", "----------");
+
+    foreach my $pid (sort {$reads{$b}{bytes_read} <=> $reads{$a}{bytes_read}} keys %reads) {
+	my $comm = $reads{$pid}{comm};
+	my $total_reads = $reads{$pid}{total_reads};
+	my $bytes_requested = $reads{$pid}{bytes_requested};
+	my $bytes_read = $reads{$pid}{bytes_read};
+
+	printf("%6s  %-20s  %10s  %10s  %10s\n", $pid, $comm,
+	       $total_reads, $bytes_requested, $bytes_read);
+    }
+
+    printf("\nfailed reads by pid:\n\n");
+
+    printf("%6s  %20s  %6s  %10s\n", "pid", "comm", "error #", "# errors");
+    printf("%6s  %20s  %6s  %10s\n", "------", "--------------------",
+	   "------", "----------");
+
+    foreach my $pid (keys %reads) {
+	my $comm = $reads{$pid}{comm};
+	foreach my $err (sort {$reads{$b}{comm} cmp $reads{$a}{comm}} keys %{$reads{$pid}{errors}}) {
+	    my $errors = $reads{$pid}{errors}{$err};
+
+	    printf("%6d  %-20s  %6d  %10s\n", $pid, $comm, $err, $errors);
+	}
+    }
+
+    printf("\nwrite counts by pid:\n\n");
+
+    printf("%6s  %20s  %10s  %10s  %10s\n", "pid", "comm",
+	   "# writes", "bytes_written");
+    printf("%6s  %-20s  %10s  %10s  %10s\n", "------", "--------------------",
+	   "-----------", "----------");
+
+    foreach my $pid (sort {$writes{$b}{bytes_written} <=> $writes{$a}{bytes_written}} keys %writes) {
+	my $comm = $writes{$pid}{comm};
+	my $total_writes = $writes{$pid}{total_writes};
+	my $bytes_written = $writes{$pid}{bytes_written};
+
+	printf("%6s  %-20s  %10s  %10s\n", $pid, $comm,
+	       $total_writes, $bytes_written);
+    }
+
+    printf("\nfailed writes by pid:\n\n");
+
+    printf("%6s  %20s  %6s  %10s\n", "pid", "comm", "error #", "# errors");
+    printf("%6s  %20s  %6s  %10s\n", "------", "--------------------",
+	   "------", "----------");
+
+    foreach my $pid (keys %writes) {
+	my $comm = $writes{$pid}{comm};
+	foreach my $err (sort {$writes{$b}{comm} cmp $writes{$a}{comm}} keys %{$writes{$pid}{errors}}) {
+	    my $errors = $writes{$pid}{errors}{$err};
+
+	    printf("%6d  %-20s  %6d  %10s\n", $pid, $comm, $err, $errors);
+	}
+    }
+
+    print_unhandled();
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
+    my ($event_name, $common_cpu, $common_secs, $common_nsecs, $common_pid,
+	$common_comm) = @_;
+
+    $unhandled{$event_name}++;
+}
diff --git a/tools/perf/scripts/perl/wakeup-latency.pl b/tools/perf/scripts/perl/wakeup-latency.pl
new file mode 100644
index 0000000..34011ff
--- /dev/null
+++ b/tools/perf/scripts/perl/wakeup-latency.pl
@@ -0,0 +1,94 @@
+# Display avg/min/max wakeup latency
+
+# The common_* event handler fields are the most useful fields common to
+# all events.  They don't necessarily correspond to the 'common_*' fields
+# in the status files.  Those fields not available as handler params can
+# be retrieved via script functions of the form get_common_*().
+
+use lib "$ENV{'PERF_EXEC_PATH'}/scripts/perl/Perf-Trace-Util/lib";
+use lib "./Perf-Trace-Util/lib";
+use Perf::Trace::Core;
+use Perf::Trace::Util;
+
+my %last_wakeup;
+
+my $max_wakeup_latency;
+my $min_wakeup_latency;
+my $total_wakeup_latency;
+my $total_wakeups;
+
+sub sched::sched_switch
+{
+    my ($event_name, $common_cpu, $common_secs, $common_nsecs, $common_pid,
+	$common_comm,
+	$prev_comm, $prev_pid, $prev_prio, $prev_state, $next_comm, $next_pid,
+	$next_prio) = @_;
+
+    my $wakeup_ts = $last_wakeup{$common_cpu}{ts};
+    if ($wakeup_ts) {
+	my $switch_ts = nsecs($common_secs, $common_nsecs);
+	my $wakeup_latency = $switch_ts - $wakeup_ts;
+	if ($wakeup_latency > $max_wakeup_latency) {
+	    $max_wakeup_latency = $wakeup_latency;
+	}
+	if ($wakeup_latency < $min_wakeup_latency) {
+	    $min_wakeup_latency = $wakeup_latency;
+	}
+	$total_wakeup_latency += $wakeup_latency;
+	$total_wakeups++;
+    }
+    $last_wakeup{$common_cpu}{ts} = 0;
+}
+
+sub sched::sched_wakeup
+{
+    my ($event_name, $common_cpu, $common_secs, $common_nsecs, $common_pid,
+	$common_comm,
+        $comm, $pid, $prio, $success, $cpu) = @_;
+
+    $last_wakeup{$cpu}{ts} = nsecs($common_secs, $common_nsecs);
+}
+
+sub trace_begin
+{
+    $min_wakeup_latency = 1000000000;
+}
+
+sub trace_end
+{
+    printf("wakeup_latency stats:\n\n");
+    print "total_wakeups: $total_wakeups\n";
+    printf("avg_wakeup_latency (ns): %u\n",
+	   avg($total_wakeup_latency, $total_wakeups));
+    printf("min_wakeup_latency (ns): %u\n", $min_wakeup_latency);
+    printf("max_wakeup_latency (ns): %u\n", $max_wakeup_latency);
+
+    print_unhandled();
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
+    my ($event_name, $common_cpu, $common_secs, $common_nsecs, $common_pid,
+	$common_comm) = @_;
+
+    $unhandled{$event_name}++;
+}
diff --git a/tools/perf/scripts/perl/workqueue-stats.pl b/tools/perf/scripts/perl/workqueue-stats.pl
new file mode 100644
index 0000000..45e7a26
--- /dev/null
+++ b/tools/perf/scripts/perl/workqueue-stats.pl
@@ -0,0 +1,121 @@
+# Displays workqueue stats
+#
+# Usage:
+#
+#   perf record -c 1 -f -a -R -e workqueue:workqueue_creation -e
+#     workqueue:workqueue_destruction -e workqueue:workqueue_execution
+#     -e workqueue:workqueue_insertion
+#
+#   perf trace -p -s tools/perf/scripts/perl/workqueue-stats.pl
+
+use lib "$ENV{'PERF_EXEC_PATH'}/scripts/perl/Perf-Trace-Util/lib";
+use lib "./Perf-Trace-Util/lib";
+use Perf::Trace::Core;
+use Perf::Trace::Util;
+
+my @cpus;
+
+sub workqueue::workqueue_destruction
+{
+    my ($event_name, $common_cpu, $common_secs, $common_nsecs, $common_pid,
+	$common_comm,
+        $thread_comm, $thread_pid) = @_;
+
+    $cpus[$common_cpu]{$thread_pid}{destroyed}++;
+    $cpus[$common_cpu]{$thread_pid}{comm} = $thread_comm;
+}
+
+sub workqueue::workqueue_creation
+{
+    my ($event_name, $common_cpu, $common_secs, $common_nsecs, $common_pid,
+	$common_comm,
+        $thread_comm, $thread_pid, $cpu) = @_;
+
+    $cpus[$common_cpu]{$thread_pid}{created}++;
+    $cpus[$common_cpu]{$thread_pid}{comm} = $thread_comm;
+}
+
+sub workqueue::workqueue_execution
+{
+    my ($event_name, $common_cpu, $common_secs, $common_nsecs, $common_pid,
+	$common_comm,
+        $thread_comm, $thread_pid, $func) = @_;
+
+    $cpus[$common_cpu]{$thread_pid}{executed}++;
+    $cpus[$common_cpu]{$thread_pid}{comm} = $thread_comm;
+}
+
+sub workqueue::workqueue_insertion
+{
+    my ($event_name, $common_cpu, $common_secs, $common_nsecs, $common_pid,
+	$common_comm,
+        $thread_comm, $thread_pid, $func) = @_;
+
+    $cpus[$common_cpu]{$thread_pid}{inserted}++;
+    $cpus[$common_cpu]{$thread_pid}{comm} = $thread_comm;
+}
+
+sub trace_end
+{
+    print "workqueue work stats:\n\n";
+    my $cpu = 0;
+    printf("%3s %6s %6s\t%-20s\n", "cpu", "ins", "exec", "name");
+    printf("%3s %6s %6s\t%-20s\n", "---", "---", "----", "----");
+    foreach $pidhash (@cpus) {
+	while (($pid, $wqhash) = each %$pidhash) {
+	    my $ins = $$wqhash{'inserted'};
+	    my $exe = $$wqhash{'executed'};
+	    my $comm = $$wqhash{'comm'};
+	    if ($ins || $exe) {
+		printf("%3u %6u %6u\t%-20s\n", $cpu, $ins, $exe, $comm);
+	    }
+	}
+	$cpu++;
+    }
+
+    $cpu = 0;
+    print "\nworkqueue lifecycle stats:\n\n";
+    printf("%3s %6s %6s\t%-20s\n", "cpu", "created", "destroyed", "name");
+    printf("%3s %6s %6s\t%-20s\n", "---", "-------", "---------", "----");
+    foreach $pidhash (@cpus) {
+	while (($pid, $wqhash) = each %$pidhash) {
+	    my $created = $$wqhash{'created'};
+	    my $destroyed = $$wqhash{'destroyed'};
+	    my $comm = $$wqhash{'comm'};
+	    if ($created || $destroyed) {
+		printf("%3u %6u %6u\t%-20s\n", $cpu, $created, $destroyed,
+		       $comm);
+	    }
+	}
+	$cpu++;
+    }
+
+    print_unhandled();
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
+    my ($event_name, $common_cpu, $common_secs, $common_nsecs, $common_pid,
+	$common_comm) = @_;
+
+    $unhandled{$event_name}++;
+}
-- 
1.6.4.GIT

