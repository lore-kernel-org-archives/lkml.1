Return-Path: <linux-kernel-owner+w=401wt.eu-S1752938AbXHREUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbXHREUf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 00:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbXHREU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 00:20:28 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4517 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbXHREU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 00:20:27 -0400
Subject: [PATCH 1/2] scripts/get_maintainer.pl
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org
Content-Type: text/plain
Date: Fri, 17 Aug 2007 21:20:23 -0700
Message-Id: <1187410823.4087.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a easier method to find maintainers to CC for a patch

Signed-off-by: Joe Perches <joe@perches.com>

Changes since last submittal:

Added options to include|ignore penguin-chiefs
Changed defaults to appropriate for git-send-email
Added optional git signed-off-by: checking
Changed syntax to be more perl like  

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
new file mode 100755
index 0000000..9c1d4cb
--- /dev/null
+++ b/scripts/get_maintainer.pl
@@ -0,0 +1,375 @@
+#!/usr/bin/perl -w
+# (c) 2007, Joe Perches <joe@perches.com>
+#           created from checkpatch.pl
+#
+# Print the contact information for the maintainers
+# of the files modified in a patch
+#
+# usage: perl scripts/get_maintainers.pl <patch>
+#
+# Licensed under the terms of the GNU GPL License version 2
+
+use strict;
+
+my $P = $0;
+$P =~ s@.*/@@g;
+
+my $V = '0.08';
+
+use Getopt::Long qw(:config no_auto_abbrev);
+
+my $tree = "./";
+my $email_usename = 1;
+my $email_maintainer = 1;
+my $email_list = 1;
+my $email_subscriber_list = 0;
+my $email_git = 1;
+my $email_git_penguin_chiefs = 0;
+my $email_multiline = 1;
+my $email_separator = ", ";
+
+my %saw;
+
+my @penguin_chief = ();
+push(@penguin_chief,"Linus Torvalds:torvalds\@linux-foundation.org");
+push(@penguin_chief,"Andrew Morton:akpm\@linux-foundation.org");
+
+my @penguin_chief_names = ();
+foreach my $chief (@penguin_chief) {
+    if ($chief =~ m/^(.*):(.*)/) {
+	my $chief_name = $1;
+	my $chief_addr = $2;
+	push(@penguin_chief_names, $chief_name);
+    }
+}
+my $penguin_chiefs = join("|",@penguin_chief_names);
+
+GetOptions(
+	   'tree=s' => \$tree,
+	   'git!' => \$email_git,
+	   'git-chief-penguins!' => \$email_git_penguin_chiefs,
+	   'm!' => \$email_maintainer,
+	   'n!' => \$email_usename,
+	   'l!' => \$email_list,
+	   's!' => \$email_subscriber_list,
+	   'multiline!' => \$email_multiline,
+	   'separator=s' => \$email_separator,
+	   ) or exit;
+
+my $exit = 0;
+
+if ($#ARGV < 0 ||
+    (!$email_maintainer
+     && !$email_list
+     && !$email_subscriber_list
+     && !$email_git
+     && !$email_git_penguin_chiefs)) {
+    print "usage: $P [options] patchfile\n";
+    print "version: $V\n";
+    print "  --tree [path] => linux kernel source path\n";
+    print "  --git => include recent git \*-by: signers\n";
+    print "  --git-penguin-chiefs => include ${penguin_chiefs}\n";
+    print "  --m => include maintainer(s) if any\n";
+    print "  --n => include name 'Full Name <addr\@domain.tld>'\n";
+    print "  --l => include list(s) if any\n";
+    print "  --s => include subscriber only list(s) if any\n";
+    print "  --separator [, ] => separator for multiple addresses on 1 line\n";
+    print "  --multiline => print 1 address per line\n";
+    print "Default: [--g --m --l --multiline]\n";
+    print "Be sure to select something...\n";
+    exit(1);
+}
+
+if ($tree && !top_of_kernel_tree($tree)) {
+    if (${tree} ne "" and ${tree} ne "./") {
+	print "'${tree}' ";
+    } else {
+	print "The current directory ";
+    }
+    print "doesn't appear to be a linux kernel source tree\n";
+    exit(2);
+}
+
+## Read MAINTAINERS for type/value pairs
+
+my @typevalue = ();
+open(MAINT, "<${tree}MAINTAINERS") || die "$P: Can't open ${tree}MAINTAINERS\n";
+while (<MAINT>) {
+    if (m/^(\C):\s*(.*)/) {
+	my $type = $1;
+	my $value = $2;
+
+	##Filename pattern matching
+	if ($type eq "F" || $type eq "X") {
+	    $value =~ s@\.@\\\.@g;       ##Convert . to \.
+	    $value =~ s/\*/\.\*/g;       ##Convert * to .*
+	}
+	push(@typevalue, "$type:$value");
+    } elsif (!/^(\s)*$/) {
+	push(@typevalue, $_);
+    }
+}
+close(MAINT);
+
+## Find the patched filenames
+
+my @patchedfiles = ();
+open(PATCH, "<$ARGV[0]") or die "Can't open $ARGV[0]\n";
+while (<PATCH>) {
+    if (m/^\+\+\+\s+(\S+)/) {
+	my $file = $1;
+	$file =~ s@^[^/]*/@@;
+	$file =~ s@\n@@;
+	push(@patchedfiles, $file);
+    }
+}
+close(PATCH);
+
+# Sort and uniq patchedfiles
+
+undef %saw;
+@patchedfiles = sort @patchedfiles;
+@patchedfiles = grep(!$saw{$_}++, @patchedfiles);
+
+# Find responsible parties
+
+my @email_to = ();
+foreach my $patchedfile (@patchedfiles) {
+    my $exclude = 0;
+
+#Git
+
+    if ($email_git_penguin_chiefs) {
+	foreach my $chief (@penguin_chief) {
+	    if ($chief =~ m/^(.*):(.*)/) {
+		my $chief_name = $1;
+		my $chief_addr = $2;
+		if ($email_usename) {
+		    push(@email_to, format_email($chief_name, $chief_addr));
+		} else {
+		    push(@email_to, $chief_addr);
+		}
+	    }
+	}
+    }
+
+    if ($email_git) {
+	recent_git_signoffs($patchedfile);
+    }
+
+#Do not match excluded file patterns
+
+    foreach my $line (@typevalue) {
+	if ($line =~ m/^(\C):(.*)/) {
+	    my $type = $1;
+	    my $value = $2;
+	    if ($type eq 'X') {
+		if (file_match_pattern($patchedfile, $value)) {
+		    $exclude = 1;
+		}
+	    }
+	}
+    }
+
+    if (!$exclude) {
+	my $tvi = 0;
+	foreach my $line (@typevalue) {
+	    if ($line =~ m/^(\C):(.*)/) {
+		my $type = $1;
+		my $value = $2;
+		if ($type eq 'F') {
+		    if (file_match_pattern($patchedfile, $value)) {
+			add_emails($tvi);
+		    }
+		}
+	    }
+	    $tvi++;
+	}
+    }
+}
+
+## add lk if no one else is interested...
+
+my $address_cnt = @email_to;
+if ($address_cnt == 0 && $email_list) {
+    push(@email_to, "linux-kernel\@vger.kernel.org");
+}
+
+## sort and uniq email_to
+
+@email_to = sort @email_to;
+undef %saw;
+@email_to = grep(!$saw{$_}++, @email_to);
+
+if ($email_multiline) {
+    foreach my $addr (@email_to) {
+	print("${addr}\n");
+    }
+} else {
+    print(join($email_separator, @email_to));
+    print("\n");
+}
+
+exit($exit);
+
+sub file_match_pattern {
+    my ($file, $pattern) = @_;
+    if (substr($pattern, -1) eq "/") {
+	if ($file =~ m@^$pattern@) {
+	    return 1;
+	}
+    } else {
+	if ($file =~ m@^$pattern@) {
+	    my $s1 = ($file =~ tr@/@@);
+	    my $s2 = ($pattern =~ tr@/@@);
+	    if ($s1 == $s2) {
+		return 1;
+	    }
+	}
+    }
+    return 0;
+}
+
+sub top_of_kernel_tree {
+	my ($tree) = @_;
+
+	if ($tree ne "" && substr($tree,length($tree)-1,1) ne "/") {
+	    $tree .= "/";
+	}
+	if (   (-f "${tree}COPYING")
+	    && (-f "${tree}CREDITS")
+	    && (-f "${tree}Kbuild")
+	    && (-f "${tree}MAINTAINERS")
+	    && (-f "${tree}Makefile")
+	    && (-f "${tree}README")
+	    && (-d "${tree}Documentation")
+	    && (-d "${tree}arch")
+	    && (-d "${tree}include")
+	    && (-d "${tree}drivers")
+	    && (-d "${tree}fs")
+	    && (-d "${tree}init")
+	    && (-d "${tree}ipc")
+	    && (-d "${tree}kernel")
+	    && (-d "${tree}lib")
+	    && (-d "${tree}scripts")) {
+		return 1;
+	}
+	return 0;
+}
+
+sub format_email {
+    my ($name, $email) = @_;
+
+    my $formatted_email = "";
+
+    if ($name =~ /[^a-z0-9 \.\-]/i) {    ##has "must quote" chars
+	$name =~ s/(?<!\\)"/\\"/g;       ##escape quotes
+	$formatted_email = "\"${name}\"\ \<${email}\>";
+    } else {
+	$formatted_email = "${name} \<${email}\>";
+    }
+    return $formatted_email;
+}
+
+sub add_emails {
+    my ($index) = @_;
+
+    $index = $index - 1;
+    while ($index >= 0) {
+	my $tv = $typevalue[$index];
+	if ($tv =~ m/^(\C):(.*)/) {
+	    my $ptype = $1;
+	    my $pvalue = $2;
+	    if ($ptype eq "L") {
+		my $subscr = $pvalue;
+		if ($subscr =~ m/\s*\(subscribers-only\)/) {
+		    if ($email_subscriber_list) {
+			$subscr =~ s/\s*\(subscribers-only\)//g;
+			push(@email_to, $subscr);
+		    }
+		} else {
+		    if ($email_list) {
+			push(@email_to, $pvalue);
+		    }
+		}
+	    } elsif ($ptype eq "M") {
+		if ($email_maintainer) {
+		    if ($index >= 0) {
+			my $tv = $typevalue[$index - 1];
+			if ($tv =~ m/^(\C):(.*)/) {
+			    if ($1 eq "P" && $email_usename) {
+				push(@email_to, format_email($2, $pvalue));
+			    } else {
+				push(@email_to, $pvalue);
+			    }
+			}
+		    } else {
+			push(@email_to, $pvalue);
+		    }
+		}
+	    }
+	    $index--;
+	} else {
+	    $index = -1;
+	}
+    }
+}
+
+sub which {
+    my ($bin) = @_;
+
+    foreach my $path (split /:/, $ENV{PATH}) {
+	if (-e "$path/$bin") {
+	    return "$path/$bin";
+	}
+    }
+    
+    return "";
+}
+
+sub recent_git_signoffs {
+    my ($file) = @_;
+
+    my $sign_offs = "";
+    my $cmd = "";
+    my $output = "";
+
+    my @lines = ();
+
+    if (which("git") eq "") {
+	die("git not found\n");
+    }
+
+    $cmd = "git log --since=6.months.ago -- ${file}";
+    $cmd .= " | grep -i '^    [-a-z]*by:.*\\\@'";
+    if (!$email_git_penguin_chiefs) {
+	$cmd .= " | grep -E -v '${penguin_chiefs}'";
+    }
+    $cmd .= " | sort | uniq -c | sort -r -n | head -n 5";
+    $cmd .= " | cut -f 2 -d ':' -s";
+
+    $output = `${cmd}`;
+
+    $output =~ s/^\s*//gm;
+
+    @lines = split("\n", $output);
+    foreach my $line (@lines) {
+	if ($line =~ m/(.*) <(.*)>/) {
+	    my $git_name = $1;
+	    my $git_addr = $2;
+	    $git_name =~ tr/^\"//;
+	    $git_name =~ tr/\"$//;
+	    if ($email_usename) {
+		push(@email_to, format_email($git_name, $git_addr));
+	    } else {
+		push(@email_to, $git_addr);
+	    }
+	} elsif ($line =~ m/<(.*)>/) {
+	    my $git_addr = $1;
+	    push(@email_to, $git_addr);
+	} else {
+	    push(@email_to, $line);
+	}
+    }
+    return $output;
+}


