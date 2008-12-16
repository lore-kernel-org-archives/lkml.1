Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbYLPLvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbYLPLvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 06:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbYLPLvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 06:51:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:15593 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560AbYLPLvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 06:51:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:from;
        b=jwwvDl0Bun6lFOCVA7f1OLOSuX3Y+1v6Y8rkvPfGLBIe0p32gkWLDv73CPQ13vFPOI
         Ve1ebKROSWzf/iOqnPbQbVdu+KVSwGosJIypdExK5F8XT9DmZOq4oZSSVivkjQelyp5U
         +SDoL3u2xahmSC6zoOpCR75nY6kv6XK/yNC7g=
Date: Tue, 16 Dec 2008 12:52:49 +0100
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Adrian Bunk <bunk@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Nick Andrew <nick@nick-andrew.net>, Matthew Wilcox <matthew@wil.cx>,
       Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] headerdep: a tool for detecting inclusion cycles in
	header files
Message-ID: <20081216115249.GA3901@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081213222259.GB29080@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2008 at 11:22 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> I tried to apply it and saw following output:
> In file included from linux/mmzone.h,
>                from linux/topology.h
>                from linux/mmzone.h
>                from linux/gfp.h
>                from linux/slub_def.h
>                from linux/slab.h
>                from linux/percpu.h
>                from asm-generic/irq_regs.h
> include/asm-xtensa/irq_regs.h: warning: recursive header inclusion
>
> But looking at the file (include/asm-xtensa/irq_regs.h) did
> not help me understand where to look to fix it.

The program was run with include/asm-xtensa/irq_regs.h as input. So it
displays the whole chain of inclusion. The cycle is just the upper part:

> In file included from linux/mmzone.h,
>                from linux/topology.h
>                from linux/mmzone.h

...so that's where to look in general. I checked mmzone.h and topology.h,
and they do indeed include each other.

>
> Can you pinpoint the culprint better so this is becoming useful?

Line numbers would be nice, I agree. We can also have just the cycle stand
out a bit more. This is the new format:

    $ perl scripts/headerdep.pl include/asm-xtensa/irq_regs.h 
    In file included from linux/mmzone.h,
                     from linux/topology.h:32
                     from linux/mmzone.h:763 <-- here
                     from linux/gfp.h:4
                     from linux/slub_def.h:10
                     from linux/slab.h:152
                     from linux/percpu.h:5
                     from asm-generic/irq_regs.h:15
    include/asm-xtensa/irq_regs.h:1: warning: recursive header inclusion

> I would also like to see this integrated with checkincludes.pl
> as both script do some simple static checks of the header files.
>
> Additional bonus if we can reuse this to do better check of
> our exported headers.

This one is probably a bit too noisy? But if we can eliminate the existing
cycles, it would be nice, I agree. Thanks for the feedback! :)


Vegard


>From 24d6e19682ce2b7ffa6c032fb0199dbcabcc1a5b Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Tue, 16 Dec 2008 12:33:43 +0100
Subject: [PATCH] headerdep: add a tool to detect inclusion cycles in header files #3

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 Makefile             |    7 ++-
 scripts/headerdep.pl |  193 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 199 insertions(+), 1 deletions(-)
 create mode 100755 scripts/headerdep.pl

diff --git a/Makefile b/Makefile
index 9a49960..d4b13d9 100644
--- a/Makefile
+++ b/Makefile
@@ -1022,6 +1022,10 @@ include/linux/version.h: $(srctree)/Makefile FORCE
 include/linux/utsrelease.h: include/config/kernel.release FORCE
 	$(call filechk,utsrelease.h)
 
+PHONY += headerdep
+headerdep:
+	@find include/ -name '*.h' | xargs --max-args 1 scripts/headerdep.pl
+
 # ---------------------------------------------------------------------------
 
 PHONY += depend dep
@@ -1270,7 +1274,8 @@ help:
 	@echo  '  versioncheck    - Sanity check on version.h usage'
 	@echo  '  includecheck    - Check for duplicate included header files'
 	@echo  '  export_report   - List the usages of all exported symbols'
-	@echo  '  headers_check   - Sanity check on exported headers'; \
+	@echo  '  headers_check   - Sanity check on exported headers'
+	@echo  '  headerdep       - Detect inclusion cycles in headers'; \
 	 echo  ''
 	@echo  'Kernel packaging:'
 	@$(MAKE) $(build)=$(package-dir) help
diff --git a/scripts/headerdep.pl b/scripts/headerdep.pl
new file mode 100755
index 0000000..b3265f6
--- /dev/null
+++ b/scripts/headerdep.pl
@@ -0,0 +1,193 @@
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
+my %linenos = ();
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
+		for my $i (0 .. $#lines) {
+			my $line = $lines[$i];
+			if(my($dep) = ($line =~ m/^#\s*include\s*<(.*?)>/)) {
+				push @queue, $dep;
+				push @{$deps{$header}}, [$i + 1, $dep];
+			}
+		}
+	}
+}
+
+sub print_cycle {
+	# $cycle[n] includes $cycle[n + 1];
+	# $cycle[-1] will be the culprit
+	my $cycle = shift;
+
+	# Adjust the line numbers
+	for my $i (0 .. $#$cycle - 1) {
+		$cycle->[$i]->[0] = $cycle->[$i + 1]->[0];
+	}
+	$cycle->[-1]->[0] = 0;
+
+	my $first = shift @$cycle;
+	my $last = pop @$cycle;
+
+	my $msg = "In file included";
+	printf "%s from %s,\n", $msg, $last->[1] if defined $last;
+
+	for my $header (reverse @$cycle) {
+		printf "%s from %s:%d%s\n",
+			" " x length $msg,
+			$header->[1], $header->[0],
+			$header->[1] eq $last->[1] ? ' <-- here' : '';
+	}
+
+	printf "%s:%d: warning: recursive header inclusion\n",
+		$first->[1], $first->[0];
+}
+
+# Find and print the smallest cycle starting in the specified node.
+sub detect_cycles {
+	my @queue = map { [[0, $_]] } @_;
+	while(@queue) {
+		my $top = pop @queue;
+		my $name = $top->[-1]->[1];
+
+		for my $dep (@{$deps{$name}}) {
+			my $chain = [@$top, [$dep->[0], $dep->[1]]];
+
+			# If the dep already exists in the chain, we have a
+			# cycle...
+			if(grep { $_->[1] eq $dep->[1] } @$top) {
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
+				mangle($header), mangle($dep->[1]);
+		}
+	}
+
+	print "}\n";
+}
-- 
1.5.6.5

