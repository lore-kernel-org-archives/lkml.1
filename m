Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbYECU1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbYECU1f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 16:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbYECU11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 16:27:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:49307 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbYECU10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 16:27:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=mESLgWwPyKnFTx16fQKUOA//R48IACUDt/87ZB7t2fDZSK0WVoqItlSrAp6JnRCteC+48i833hcxIa7mL7YijpUrK4YAMOCM4QchxdSzRw2/O7l6JWiGxoEK3/7rZlRe9CDjNqNCzgUJ0jYoD9oNzwKFBkPoDYBtyC6FAvJaogU=
Date: Sat, 3 May 2008 22:27:18 +0200
To: Sam Ravnborg <sam@ravnborg.org>, Adrian Bunk <bunk@kernel.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Nick Andrew <nick@nick-andrew.net>,
       Matthew Wilcox <matthew@wil.cx>,
       Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] headerdep: a tool for detecting inclusion cycles in header
	files
Message-ID: <20080503202718.GA9996@damson>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here comes v2 of this tool. I've addressed most of your nitpicks and specific
comments. Running 'make headerdep', will go through all headers (instead of
source files as v1 did). Running with the --graph option will produce a
dependency graph in the 'dot' language (GraphViz).

Note that I am not really making an attempt to include this in the kernel
itself; I am submitting it in the hope that somebody will find it useful.

For Sam: Writing this in sparse is a waste of time. Sparse is good for parsing
C code; this script only cares about a subset of the C _preprocessor_ parsing.
Perl is good at this, and the script was finished in a couple of hours. Sparse
is C and would require a bit more work, I'm sure.

The most useful tool, as suggested by several people (Matthew Wilcox,
Sam Ravnborg), would be the one that detects unused headers and missing
(implicit) includes. That is indeed a job for sparse. But not a job for me,
or at least not yet :-)

So again, I have no expectations for this to go in the kernel -- but in my
opinion a tool that could be used on the kernel headers with some advantage.

Happy hacking! :-)


Vegard


From: Vegard Nossum <vegard.nossum@gmail.com>
Subject: [PATCH] headerdep: add a tool to detect inclusion cycles in header files

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 Makefile             |    5 ++
 scripts/headerdep.pl |  177 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 182 insertions(+), 0 deletions(-)
 create mode 100755 scripts/headerdep.pl

diff --git a/Makefile b/Makefile
index 39516bf..eeab061 100644
--- a/Makefile
+++ b/Makefile
@@ -1021,6 +1021,10 @@ PHONY += headers_check
 headers_check: headers_install
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.headersinst ARCH=$(SRCARCH) obj=include HDRCHECK=1
 
+PHONY += headerdep
+headerdep:
+	@find include/ -name '*.h' | xargs --max-args 1 scripts/headerdep.pl
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
index 0000000..aaabd72
--- /dev/null
+++ b/scripts/headerdep.pl
@@ -0,0 +1,177 @@
+#! /usr/bin/perl
+#
+# Detect cycles in the header file dependency graph
+# Vegard Nossum <vegardno@ifi.uio.no>
+#
+
+use strict;
+use warnings;
+
+use Getopt::Long;
+
+my $opt_all;
+my @opt_include;
+my $opt_graph;
+
+&Getopt::Long::Configure(qw(bundling pass_through));
+&GetOptions(
+	help	=> \&help,
+	version	=> \&version,
+
+	all	=> \$opt_all,
+	I	=> \@opt_include,
+	graph	=> \$opt_graph,
+);
+
+push @opt_include, 'include';
+my %deps = ();
+
+my @headers = grep { strip($_) } @ARGV;
+
+parse_all(@headers);
+
+if($opt_graph) {
+	graph();
+} else {
+	detect_cycles(@headers);
+}
+
+
+sub help {
+	print "Usage: $0 [options] file...\n";
+	print "\n";
+	print "Options:\n";
+	print "  --all\n";
+	print "  --graph\n";
+	print "\n";
+	print "  -I includedir\n";
+	print "\n";
+	print "To make nice graphs, try:\n";
+	print "  $0 --graph include/linux/kernel.h | dot -Tpng -o graph.png\n";
+	exit;
+}
+
+sub version {
+	print "headerdep version 2\n";
+	exit;
+}
+
+# Get a file name that is relative to our include paths
+sub strip {
+	my $filename = shift;
+
+	for my $i (@opt_include) {
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
+	for my $i (@opt_include) {
+		my $path = "$i/$filename";
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
+			if(my($dep) = ($line =~ m/^#\s*include\s*<(.*?)>/)) {
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
+	print "$msg from $last,\n" if defined $last;
+
+	for my $header (reverse @$cycle) {
+		print " " x length $msg, "from $header\n";
+	}
+
+	print "$first: warning: recursive header inclusion\n";
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
+				next if $opt_all;
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
+# Output dependency graph in GraphViz language.
+sub graph {
+	print "digraph {\n";
+
+	print "\t/* vertices */\n";
+	for my $header (keys %deps) {
+		printf "\t%s [label=\"%s\"];\n",
+			mangle($header), $header;
+	}
+
+	print "\n";
+
+	print "\t/* edges */\n";
+	for my $header (keys %deps) {
+		for my $dep (@{$deps{$header}}) {
+			printf "\t%s -> %s;\n",
+				mangle($header), mangle($dep);
+		}
+	}
+
+	print "}\n";
+}
-- 
1.5.4.1

