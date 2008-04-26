Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbYDZNqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbYDZNqX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 09:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbYDZNqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 09:46:07 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:6178 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbYDZNqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 09:46:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=tfeUpdu6lXcQP2dHLzxC/RRAjKOPi1DFp1g/hKBgvHIBPL0JtqDfQoLegTr9Vz9qEXt7ht0NrIKt2XdBPN2YRXcZDko1a2mapEttlm858vaz+Wxd2Ao17+CbSEf5v/vqOnVANnFuug3ETmO0leNNBOJrgn+rfA+zJ8imUhGWm+0=
Date: Sat, 26 Apr 2008 15:45:54 +0200
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Adrian Bunk <bunk@kernel.org>,
       linux-kbuild@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] headerdep: a tool for detecting inclusion cycles in header
	file
Message-ID: <20080426134554.GA20727@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

Maybe something like this could be useful for cleaning up headers (and
maintaining that cleanliness once it has been achieved). What do you think?

(One thing which might or might not be good is that 'make headerdep' will
 also compile using CC if they're not already compiled. If this should be
 fixed, I think you'd know how to do it.)

Vegard


>From af7e8d3b620a5935b7bc15660d153b909a14abd9 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Sat, 26 Apr 2008 11:47:33 +0200
Subject: [PATCH] headerdep: a tool for detecting inclusion cycles in header files

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 Makefile             |    5 ++
 scripts/headerdep.pl |  143 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 148 insertions(+), 0 deletions(-)
 create mode 100755 scripts/headerdep.pl

diff --git a/Makefile b/Makefile
index 39516bf..488b193 100644
--- a/Makefile
+++ b/Makefile
@@ -1021,6 +1021,10 @@ PHONY += headers_check
 headers_check: headers_install
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.headersinst ARCH=$(SRCARCH) obj=include HDRCHECK=1
 
+PHONY += headerdep
+headerdep:
+	$(Q)$(MAKE) C=2 CHECK=scripts/headerdep.pl
+
 # ---------------------------------------------------------------------------
 # Modules
 
@@ -1210,6 +1214,7 @@ help:
 	@if [ -r $(srctree)/include/asm-$(SRCARCH)/Kbuild ]; then \
 	 echo  '  headers_check   - Sanity check on exported headers'; \
 	 fi
+	@echo  '  headerdep       - Detect inclusion cycles in headers'
 	@echo  ''
 	@echo  'Kernel packaging:'
 	@$(MAKE) $(build)=$(package-dir) help
diff --git a/scripts/headerdep.pl b/scripts/headerdep.pl
new file mode 100755
index 0000000..c993d16
--- /dev/null
+++ b/scripts/headerdep.pl
@@ -0,0 +1,143 @@
+#! /usr/bin/perl
+#
+# Detect cycles in the header file dependency graph
+# Vegard Nossum <vegardno@ifi.uio.no>
+#
+
+use strict;
+use warnings;
+
+my @I = ('include');
+my %deps = ();
+
+my @headers = grep { strip($_) } @ARGV;
+
+parse_all(@headers);
+
+detect_cycles(@headers);
+#graph();
+exit;
+
+
+# Get a file name that is relative to our include paths
+sub strip {
+	my $filename = shift;
+
+	for my $i (@I) {
+		my $stripped = $filename;
+		$stripped =~ s/^$i\///;
+
+		return $stripped if $stripped ne $filename;
+	}
+
+	return $filename;
+}
+
+# Search for the file name in the list of include paths
+sub search {
+	my $filename = shift;
+	return $filename if -f $filename;
+
+	for my $i (@I) {
+		my $path = sprintf "%s/%s", $i, $filename;
+		return $path if -f $path;
+	}
+
+	return undef;
+}
+
+sub parse_all {
+	# Parse all the headers.
+	my @queue = @_;
+	while(@queue) {
+		my $header = pop @queue;
+		next if exists $deps{$header};
+
+		$deps{$header} = [] unless exists $deps{$header};
+
+		my $path = search($header);
+		next unless $path;
+
+		open(my $file, '<', $path) or die($!);
+		chomp(my @lines = <$file>);
+		close($file);
+
+		for my $line (@lines) {
+			if(my($dep) = ($line =~ m/^#\s*include <([^>]+)>/)) {
+				push @queue, $dep;
+				push @{$deps{$header}}, $dep;
+			}
+		}
+	}
+}
+
+sub print_cycle {
+	my $cycle = shift;
+
+	my $first = shift @$cycle;
+	my $last = pop @$cycle;
+
+	my $msg = "In file included";
+	printf "%s from %s,\n", $msg, $last if defined $last;
+
+	for my $header (reverse @$cycle) {
+		printf "%*.s from %s\n", length $msg, '', $header;
+	}
+
+	printf "%s: warning: recursive header inclusion\n", $first;
+}
+
+# Find and print the smallest cycle starting in the specified node.
+sub detect_cycles {
+	my @queue = map { [$_] } @_;
+	while(@queue) {
+		my $top = pop @queue;
+		my $name = $top->[-1];
+
+		for my $dep (@{$deps{$name}}) {
+			my $chain = [@$top, $dep];
+
+			if(grep { $_ eq $dep } @$top) {
+				print_cycle($chain);
+				return;
+			}
+
+			push @queue, $chain;
+		}
+	}
+}
+
+sub mangle {
+	$_ = shift;
+	s/\//__/g;
+	s/\./_/g;
+	s/-/_/g;
+	$_;
+}
+
+sub escape {
+	$_ = shift;
+}
+
+# Output dependency graph in GraphViz language.
+sub graph {
+	printf "digraph {\n";
+
+	printf "\t/* vertices */\n";
+	for my $header (keys %deps) {
+		printf "\t%s [label=\"%s\"];\n",
+			mangle($header), escape($header);
+	}
+
+	printf "\n";
+
+	printf "\t/* edges */\n";
+	for my $header (keys %deps) {
+		for my $dep (@{$deps{$header}}) {
+			printf "\t%s -> %s;\n",
+				mangle($header), mangle($dep);
+		}
+	}
+
+	printf "}\n";
+}
-- 
1.5.4.1

