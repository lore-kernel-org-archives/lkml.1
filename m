Return-Path: <linux-kernel-owner+w=401wt.eu-S1758116AbZC3GwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbZC3GwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 02:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755920AbZC3GwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 02:52:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56339 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755870AbZC3GwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 02:52:14 -0400
Message-ID: <49D06B9C.3070209@cn.fujitsu.com>
Date: Mon, 30 Mar 2009 14:50:04 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
       Steven Rostedt <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: move scripts/trace/power.pl to scripts/tracing/power.pl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: Cleanup

We use scripts/tracing/ to contain tracing scripts.
Use one directory only instead of two.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/scripts/trace/power.pl b/scripts/trace/power.pl
deleted file mode 100644
index 4f729b3..0000000
--- a/scripts/trace/power.pl
+++ /dev/null
@@ -1,108 +0,0 @@
-#!/usr/bin/perl
-
-# Copyright 2008, Intel Corporation
-#
-# This file is part of the Linux kernel
-#
-# This program file is free software; you can redistribute it and/or modify it
-# under the terms of the GNU General Public License as published by the
-# Free Software Foundation; version 2 of the License.
-#
-# This program is distributed in the hope that it will be useful, but WITHOUT
-# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
-# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
-# for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program in a file named COPYING; if not, write to the
-# Free Software Foundation, Inc.,
-# 51 Franklin Street, Fifth Floor,
-# Boston, MA 02110-1301 USA
-#
-# Authors:
-# 	Arjan van de Ven <arjan@linux.intel.com>
-
-
-#
-# This script turns a cstate ftrace output into a SVG graphic that shows
-# historic C-state information
-#
-#
-# 	cat /sys/kernel/debug/tracing/trace | perl power.pl > out.svg
-#
-
-my @styles;
-my $base = 0;
-
-my @pstate_last;
-my @pstate_level;
-
-$styles[0] = "fill:rgb(0,0,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
-$styles[1] = "fill:rgb(0,255,0);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
-$styles[2] = "fill:rgb(255,0,20);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
-$styles[3] = "fill:rgb(255,255,20);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
-$styles[4] = "fill:rgb(255,0,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
-$styles[5] = "fill:rgb(0,255,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
-$styles[6] = "fill:rgb(0,128,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
-$styles[7] = "fill:rgb(0,255,128);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
-$styles[8] = "fill:rgb(0,25,20);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
-
-
-print "<?xml version=\"1.0\" standalone=\"no\"?> \n";
-print "<svg width=\"10000\" height=\"100%\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\">\n";
-
-my $scale = 30000.0;
-while (<>) {
-	my $line = $_;
-	if ($line =~ /([0-9\.]+)\] CSTATE: Going to C([0-9]) on cpu ([0-9]+) for ([0-9\.]+)/) {
-		if ($base == 0) {
-			$base = $1;
-		}
-		my $time = $1 - $base;
-		$time = $time * $scale;
-		my $C = $2;
-		my $cpu = $3;
-		my $y = 400 * $cpu;
-		my $duration = $4 * $scale;
-		my $msec = int($4 * 100000)/100.0;
-		my $height = $C * 20;
-		$style = $styles[$C];
-
-		$y = $y + 140 - $height;
-
-		$x2 = $time + 4;
-		$y2 = $y + 4;
-
-
-		print "<rect x=\"$time\" width=\"$duration\" y=\"$y\" height=\"$height\" style=\"$style\"/>\n";
-		print "<text transform=\"translate($x2,$y2) rotate(90)\">C$C $msec</text>\n";
-	}
-	if ($line =~ /([0-9\.]+)\] PSTATE: Going to P([0-9]) on cpu ([0-9]+)/) {
-		my $time = $1 - $base;
-		my $state = $2;
-		my $cpu = $3;
-
-		if (defined($pstate_last[$cpu])) {
-			my $from = $pstate_last[$cpu];
-			my $oldstate = $pstate_state[$cpu];
-			my $duration = ($time-$from) * $scale;
-
-			$from = $from * $scale;
-			my $to = $from + $duration;
-			my $height = 140 - ($oldstate * (140/8));
-
-			my $y = 400 * $cpu + 200 + $height;
-			my $y2 = $y+4;
-			my $style = $styles[8];
-
-			print "<rect x=\"$from\" y=\"$y\" width=\"$duration\" height=\"5\" style=\"$style\"/>\n";
-			print "<text transform=\"translate($from,$y2)\">P$oldstate (cpu $cpu)</text>\n";
-		};
-
-		$pstate_last[$cpu] = $time;
-		$pstate_state[$cpu] = $state;
-	}
-}
-
-
-print "</svg>\n";
diff --git a/scripts/tracing/power.pl b/scripts/tracing/power.pl
new file mode 100644
index 0000000..4f729b3
--- /dev/null
+++ b/scripts/tracing/power.pl
@@ -0,0 +1,108 @@
+#!/usr/bin/perl
+
+# Copyright 2008, Intel Corporation
+#
+# This file is part of the Linux kernel
+#
+# This program file is free software; you can redistribute it and/or modify it
+# under the terms of the GNU General Public License as published by the
+# Free Software Foundation; version 2 of the License.
+#
+# This program is distributed in the hope that it will be useful, but WITHOUT
+# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+# for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program in a file named COPYING; if not, write to the
+# Free Software Foundation, Inc.,
+# 51 Franklin Street, Fifth Floor,
+# Boston, MA 02110-1301 USA
+#
+# Authors:
+# 	Arjan van de Ven <arjan@linux.intel.com>
+
+
+#
+# This script turns a cstate ftrace output into a SVG graphic that shows
+# historic C-state information
+#
+#
+# 	cat /sys/kernel/debug/tracing/trace | perl power.pl > out.svg
+#
+
+my @styles;
+my $base = 0;
+
+my @pstate_last;
+my @pstate_level;
+
+$styles[0] = "fill:rgb(0,0,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[1] = "fill:rgb(0,255,0);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[2] = "fill:rgb(255,0,20);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[3] = "fill:rgb(255,255,20);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[4] = "fill:rgb(255,0,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[5] = "fill:rgb(0,255,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[6] = "fill:rgb(0,128,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[7] = "fill:rgb(0,255,128);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[8] = "fill:rgb(0,25,20);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+
+
+print "<?xml version=\"1.0\" standalone=\"no\"?> \n";
+print "<svg width=\"10000\" height=\"100%\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\">\n";
+
+my $scale = 30000.0;
+while (<>) {
+	my $line = $_;
+	if ($line =~ /([0-9\.]+)\] CSTATE: Going to C([0-9]) on cpu ([0-9]+) for ([0-9\.]+)/) {
+		if ($base == 0) {
+			$base = $1;
+		}
+		my $time = $1 - $base;
+		$time = $time * $scale;
+		my $C = $2;
+		my $cpu = $3;
+		my $y = 400 * $cpu;
+		my $duration = $4 * $scale;
+		my $msec = int($4 * 100000)/100.0;
+		my $height = $C * 20;
+		$style = $styles[$C];
+
+		$y = $y + 140 - $height;
+
+		$x2 = $time + 4;
+		$y2 = $y + 4;
+
+
+		print "<rect x=\"$time\" width=\"$duration\" y=\"$y\" height=\"$height\" style=\"$style\"/>\n";
+		print "<text transform=\"translate($x2,$y2) rotate(90)\">C$C $msec</text>\n";
+	}
+	if ($line =~ /([0-9\.]+)\] PSTATE: Going to P([0-9]) on cpu ([0-9]+)/) {
+		my $time = $1 - $base;
+		my $state = $2;
+		my $cpu = $3;
+
+		if (defined($pstate_last[$cpu])) {
+			my $from = $pstate_last[$cpu];
+			my $oldstate = $pstate_state[$cpu];
+			my $duration = ($time-$from) * $scale;
+
+			$from = $from * $scale;
+			my $to = $from + $duration;
+			my $height = 140 - ($oldstate * (140/8));
+
+			my $y = 400 * $cpu + 200 + $height;
+			my $y2 = $y+4;
+			my $style = $styles[8];
+
+			print "<rect x=\"$from\" y=\"$y\" width=\"$duration\" height=\"5\" style=\"$style\"/>\n";
+			print "<text transform=\"translate($from,$y2)\">P$oldstate (cpu $cpu)</text>\n";
+		};
+
+		$pstate_last[$cpu] = $time;
+		$pstate_state[$cpu] = $state;
+	}
+}
+
+
+print "</svg>\n";


