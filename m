Return-Path: <linux-kernel-owner+w=401wt.eu-S1760596AbYDZSLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596AbYDZSLf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 14:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbYDZSL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 14:11:26 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45334 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbYDZSLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 14:11:25 -0400
Date: Sat, 26 Apr 2008 20:11:24 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Sam Ravnborg <sam@ravnborg.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Adrian Bunk <bunk@kernel.org>, linux-kbuild@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] headerdep: a tool for detecting inclusion cycles in
 header file
In-Reply-To: <20080426134554.GA20727@damson.getinternet.no>
Message-ID: <alpine.LNX.1.10.0804262004060.20150@fbirervta.pbzchgretzou.qr>
References: <20080426134554.GA20727@damson.getinternet.no>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2008-04-26 15:45, Vegard Nossum wrote:

>+exit;

exit is implicit.

>+# Get a file name that is relative to our include paths
>+sub strip {
>+	my $filename = shift;
>+
>+	for my $i (@I) {
>+		my $stripped = $filename;
>+		$stripped =~ s/^$i\///;

			s/^\Q$i\/\E//;

>+# Search for the file name in the list of include paths
>+sub search {
>+	my $filename = shift;
>+	return $filename if -f $filename;
>+
>+	for my $i (@I) {
>+		my $path = sprintf "%s/%s", $i, $filename;

		my $path = "$i/$filename";

>+		return $path if -f $path;
>+	}
>+
>+	return undef;
>+}
>+
>+sub parse_all {
>+	# Parse all the headers.
>+	my @queue = @_;
>+	while(@queue) {
>+		my $header = pop @queue;
>+		next if exists $deps{$header};
>+
>+		$deps{$header} = [] unless exists $deps{$header};
>+
>+		my $path = search($header);
>+		next unless $path;
>+
>+		open(my $file, '<', $path) or die($!);
>+		chomp(my @lines = <$file>);
>+		close($file);
>+
>+		for my $line (@lines) {
>+			if(my($dep) = ($line =~ m/^#\s*include <([^>]+)>/)) {

			$line =~ m/^#\s*include\s*<(.*?)>/

>+				push @queue, $dep;
>+				push @{$deps{$header}}, $dep;
>+			}
>+		}
>+	}
>+}
>+
>+sub print_cycle {
>+	my $cycle = shift;
>+
>+	my $first = shift @$cycle;
>+	my $last = pop @$cycle;
>+
>+	my $msg = "In file included";
>+	printf "%s from %s,\n", $msg, $last if defined $last;

	print "$msg from $last,\n" if defined $last;
>+
>+	for my $header (reverse @$cycle) {
>+		printf "%*.s from %s\n", length $msg, '', $header;

		print " " x length($msg), "from $header\n";

>+	}
>+
>+	printf "%s: warning: recursive header inclusion\n", $first;

	print "$first: warning: recursive header inclusion\n";

You seem to be addicted to printf?

>+}
>+
>+# Find and print the smallest cycle starting in the specified node.
>+sub detect_cycles {
>+	my @queue = map { [$_] } @_;
>+	while(@queue) {
>+		my $top = pop @queue;
>+		my $name = $top->[-1];
>+
>+		for my $dep (@{$deps{$name}}) {
>+			my $chain = [@$top, $dep];
>+
>+			if(grep { $_ eq $dep } @$top) {
>+				print_cycle($chain);
>+				return;
>+			}
>+
>+			push @queue, $chain;
>+		}
>+	}
>+}
>+
>+sub mangle {
>+	$_ = shift;
>+	s/\//__/g;
>+	s/\./_/g;
>+	s/-/_/g;
>+	$_;
>+}
>+
>+sub escape {
>+	$_ = shift;
>+}

Does escape() have... any use?

>+
>+# Output dependency graph in GraphViz language.
>+sub graph {
>+	printf "digraph {\n";
>+
>+	printf "\t/* vertices */\n";
>+	for my $header (keys %deps) {
>+		printf "\t%s [label=\"%s\"];\n",
>+			mangle($header), escape($header);
>+	}
>+
>+	printf "\n";
>+
>+	printf "\t/* edges */\n";
>+	for my $header (keys %deps) {
>+		for my $dep (@{$deps{$header}}) {
>+			printf "\t%s -> %s;\n",
>+				mangle($header), mangle($dep);
>+		}
>+	}
>+
>+	printf "}\n";
>+}

Might want to replace all those printfs too.
