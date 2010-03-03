Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab0CCHF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 02:05:56 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:51307 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124Ab0CCHFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 02:05:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=G+KZLVyVzv573zHdLZg9/IB4Sd121XDBcEfAqGBGGt6syeT3YI3PntZ5PqdMAIVh6W
         atkoithwHK1G+/XahzbWbosGjNxPiP5nxtLqGxtsoo3fGpSvGimj13Kr9UxCdez98L/c
         cTXXipZL+SQQ6IVPyu28hnmKBQwhA2epluynk=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com
Subject: [RFC PATCH 7/7] perf trace/scripting: rwtop and sctop scripts
Date: Wed,  3 Mar 2010 01:05:29 -0600
Message-Id: <1267599929-8310-8-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1267599929-8310-1-git-send-email-tzanussi@gmail.com>
References: <1267599929-8310-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of scripts, one in Python and the other in Perl, that
demonstrate 'live mode' tracing.  For each, the output of the perf
event stream is fed continuously to the script, which continuously
aggregates the data and reports the current results every 5 seconds.
After the current results are displayed, the aggregations are cleared
and the cycle begins anew.

To run the scripts, simply pipe the output of the 'perf trace record'
step as input to the corresponding 'perf trace report' step:

$ perf trace record sctop | perf trace report sctop

A future patch should probably automatically do this i.e. the user
should be able to just run 'perf trace sctop' and get the same thing,
and the output should do better than just continuously scroll, but
these are just demo scripts for now...

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/scripts/perl/bin/rwtop-record   |    2 +
 tools/perf/scripts/perl/bin/rwtop-report   |    6 +
 tools/perf/scripts/perl/rwtop.pl           |  165 ++++++++++++++++++++++++++++
 tools/perf/scripts/python/bin/sctop-record |    2 +
 tools/perf/scripts/python/bin/sctop-report |    4 +
 tools/perf/scripts/python/sctop.py         |   64 +++++++++++
 6 files changed, 243 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/scripts/perl/bin/rwtop-record
 create mode 100644 tools/perf/scripts/perl/bin/rwtop-report
 create mode 100644 tools/perf/scripts/perl/rwtop.pl
 create mode 100644 tools/perf/scripts/python/bin/sctop-record
 create mode 100644 tools/perf/scripts/python/bin/sctop-report
 create mode 100644 tools/perf/scripts/python/sctop.py

diff --git a/tools/perf/scripts/perl/bin/rwtop-record b/tools/perf/scripts/perl/bin/rwtop-record
new file mode 100644
index 0000000..0993193
--- /dev/null
+++ b/tools/perf/scripts/perl/bin/rwtop-record
@@ -0,0 +1,2 @@
+#!/bin/bash
+perf record -o - -c 1 -f -a -M -R -e syscalls:sys_enter_read -e syscalls:sys_exit_read -e syscalls:sys_enter_write -e syscalls:sys_exit_write
diff --git a/tools/perf/scripts/perl/bin/rwtop-report b/tools/perf/scripts/perl/bin/rwtop-report
new file mode 100644
index 0000000..3d06c98
--- /dev/null
+++ b/tools/perf/scripts/perl/bin/rwtop-report
@@ -0,0 +1,6 @@
+#!/bin/bash
+# description: system-wide r/w top
+perf trace -i - -s ~/libexec/perf-core/scripts/perl/rwtop.pl
+
+
+
diff --git a/tools/perf/scripts/perl/rwtop.pl b/tools/perf/scripts/perl/rwtop.pl
new file mode 100644
index 0000000..4e0d1fd
--- /dev/null
+++ b/tools/perf/scripts/perl/rwtop.pl
@@ -0,0 +1,165 @@
+#!/usr/bin/perl -w
+# (c) 2009, Tom Zanussi <tzanussi@gmail.com>
+# Licensed under the terms of the GNU GPL License version 2
+
+# Display r/w activity for all processes
+
+use 5.010000;
+use strict;
+use warnings;
+
+use lib "$ENV{'PERF_EXEC_PATH'}/scripts/perl/Perf-Trace-Util/lib";
+use lib "./Perf-Trace-Util/lib";
+use Perf::Trace::Core;
+use Perf::Trace::Util;
+
+my $interval = 5;
+my $nlines = 10;
+my $print_thread;
+
+my %reads;
+my %writes;
+
+sub syscalls::sys_exit_read
+{
+    my ($event_name, $context, $common_cpu, $common_secs, $common_nsecs,
+	$common_pid, $common_comm,
+	$nr, $ret) = @_;
+
+    if ($ret > 0) {
+	$reads{$common_pid}{bytes_read} += $ret;
+    } else {
+	if (!defined ($reads{$common_pid}{bytes_read})) {
+	    $reads{$common_pid}{bytes_read} = 0;
+	}
+	$reads{$common_pid}{errors}{$ret}++;
+    }
+}
+
+sub syscalls::sys_enter_read
+{
+    my ($event_name, $context, $common_cpu, $common_secs, $common_nsecs,
+	$common_pid, $common_comm,
+	$nr, $fd, $buf, $count) = @_;
+
+    $reads{$common_pid}{bytes_requested} += $count;
+    $reads{$common_pid}{total_reads}++;
+    $reads{$common_pid}{comm} = $common_comm;
+}
+
+sub syscalls::sys_exit_write
+{
+    my ($event_name, $context, $common_cpu, $common_secs, $common_nsecs,
+	$common_pid, $common_comm,
+	$nr, $ret) = @_;
+
+    if ($ret <= 0) {
+	$writes{$common_pid}{errors}{$ret}++;
+    }
+}
+
+sub syscalls::sys_enter_write
+{
+    my ($event_name, $context, $common_cpu, $common_secs, $common_nsecs,
+	$common_pid, $common_comm,
+	$nr, $fd, $buf, $count) = @_;
+
+    $writes{$common_pid}{bytes_written} += $count;
+    $writes{$common_pid}{total_writes}++;
+    $writes{$common_pid}{comm} = $common_comm;
+}
+
+sub trace_begin
+{
+    $SIG{ALRM} = \&print_totals;
+    alarm 5;
+}
+
+sub trace_end
+{
+    print_unhandled();
+    print_totals();
+}
+
+sub print_totals
+{
+    my $count;
+
+    $count = 0;
+
+    printf("\nread counts by pid:\n\n");
+
+    printf("%6s  %20s  %10s  %10s  %10s\n", "pid", "comm",
+	   "# reads", "bytes_requested", "bytes_read");
+    printf("%6s  %-20s  %10s  %10s  %10s\n", "------", "--------------------",
+	   "-----------", "----------", "----------");
+
+    foreach my $pid (sort {$reads{$b}{bytes_read} <=>
+			       $reads{$a}{bytes_read}} keys %reads) {
+	my $comm = $reads{$pid}{comm};
+	my $total_reads = $reads{$pid}{total_reads};
+	my $bytes_requested = $reads{$pid}{bytes_requested};
+	my $bytes_read = $reads{$pid}{bytes_read};
+
+	printf("%6s  %-20s  %10s  %10s  %10s\n", $pid, $comm,
+	       $total_reads, $bytes_requested, $bytes_read);
+
+	if (++$count == $nlines) {
+	    last;
+	}
+    }
+
+    $count = 0;
+
+    printf("\nwrite counts by pid:\n\n");
+
+    printf("%6s  %20s  %10s  %10s\n", "pid", "comm",
+	   "# writes", "bytes_written");
+    printf("%6s  %-20s  %10s  %10s\n", "------", "--------------------",
+	   "-----------", "----------");
+
+    foreach my $pid (sort {$writes{$b}{bytes_written} <=>
+			       $writes{$a}{bytes_written}} keys %writes) {
+	my $comm = $writes{$pid}{comm};
+	my $total_writes = $writes{$pid}{total_writes};
+	my $bytes_written = $writes{$pid}{bytes_written};
+
+	printf("%6s  %-20s  %10s  %10s\n", $pid, $comm,
+	       $total_writes, $bytes_written);
+
+	if (++$count == $nlines) {
+	    last;
+	}
+    }
+
+    %reads = ();
+    %writes = ();
+    alarm 5;
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
diff --git a/tools/perf/scripts/python/bin/sctop-record b/tools/perf/scripts/python/bin/sctop-record
new file mode 100644
index 0000000..1a46fb6
--- /dev/null
+++ b/tools/perf/scripts/python/bin/sctop-record
@@ -0,0 +1,2 @@
+#!/bin/bash
+perf record -o - -c 1 -f -a -M -R -e raw_syscalls:sys_enter
diff --git a/tools/perf/scripts/python/bin/sctop-report b/tools/perf/scripts/python/bin/sctop-report
new file mode 100644
index 0000000..4ca46c0
--- /dev/null
+++ b/tools/perf/scripts/python/bin/sctop-report
@@ -0,0 +1,4 @@
+#!/bin/bash
+# description: syscall top
+# args: [comm]
+perf trace -i - -s ~/libexec/perf-core/scripts/python/sctop.py $1
diff --git a/tools/perf/scripts/python/sctop.py b/tools/perf/scripts/python/sctop.py
new file mode 100644
index 0000000..a44de25
--- /dev/null
+++ b/tools/perf/scripts/python/sctop.py
@@ -0,0 +1,64 @@
+# system call top
+# (c) 2010, Tom Zanussi <tzanussi@gmail.com>
+# Licensed under the terms of the GNU GPL License version 2
+#
+# Periodically displays system-wide system call totals, broken down by
+# syscall.  If a [comm] arg is specified, only syscalls called by
+# [comm] are displayed.
+
+import thread
+import time
+import os
+import sys
+
+sys.path.append(os.environ['PERF_EXEC_PATH'] + \
+	'/scripts/python/Perf-Trace-Util/lib/Perf/Trace')
+
+from perf_trace_context import *
+from Core import *
+from Util import *
+
+usage = "perf trace -s syscall-counts.py [comm]\n";
+
+for_comm = None
+interval = 5
+
+if len(sys.argv) > 2:
+	sys.exit(usage)
+
+if len(sys.argv) > 1:
+	for_comm = sys.argv[1]
+
+syscalls = autodict()
+
+def trace_begin():
+	thread.start_new_thread(print_syscall_totals, (interval,))
+	pass
+
+def raw_syscalls__sys_enter(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	id, args):
+	if for_comm is not None:
+		if common_comm != for_comm:
+			return
+	try:
+		syscalls[id] += 1
+	except TypeError:
+		syscalls[id] = 1
+
+def print_syscall_totals(interval):
+	while 1:
+		if for_comm is not None:
+			print "\nsyscall events for %s:\n\n" % (for_comm),
+		else:
+			print "\nsyscall events:\n\n",
+
+			print "%-40s  %10s\n" % ("event", "count"),
+			print "%-40s  %10s\n" % ("----------------------------------------", \
+							 "-----------"),
+
+			for id, val in sorted(syscalls.iteritems(), key = lambda(k, v): (v, k), \
+						      reverse = True):
+				print "%-40d  %10d\n" % (id, val),
+			syscalls.clear()
+			time.sleep(interval)
-- 
1.6.4.GIT

