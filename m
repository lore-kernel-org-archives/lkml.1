Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbXHTXut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbXHTXut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 19:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbXHTXuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 19:50:39 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2288 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbXHTXui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 19:50:38 -0400
Subject: [PATCH] scripts/get_maintainer.pl
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Chris Snook <csnook@redhat.com>
Content-Type: text/plain
Date: Mon, 20 Aug 2007 16:50:36 -0700
Message-Id: <1187653836.5963.42.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Find maintainer info for a patch or a file

Changes since last submission:

Added -f <file> to search for the maintainer for a specific file
Added --scm - Print the S: information
Added --web - Print the W: information
Added die message "git not found.  Add --nogit to options"
Changed git log tracking interval from last 6 months to last 12 months
Removed --tree lk_source option

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
new file mode 100755
index 0000000..abfa212
--- /dev/null
+++ b/scripts/get_maintainer.pl
@@ -0,0 +1,424 @@
+#!/usr/bin/perl -w
+# (c) 2007, Joe Perches <joe@perches.com>
+#           created from checkpatch.pl
+#
+# Print selected MAINTAINERS information for
+# the files modified in a patch or for a file
+#
+# usage: perl scripts/get_maintainers.pl [OPTIONS] <patch>
+#        perl scripts/get_maintainers.pl [OPTIONS] -f <file>
+#
+# Licensed under the terms of the GNU GPL License version 2
+
+use strict;
+
+my $P = $0;
+my $V = '0.10';
+
+use Getopt::Long qw(:config no_auto_abbrev);
+
+my $lk_path = "./";
+my $email_usename = 1;
+my $email_maintainer = 1;
+my $email_list = 1;
+my $email_subscriber_list = 0;
+my $email_git = 1;
+my $email_git_penguin_chiefs = 0;
+my $output_multiline = 1;
+my $output_separator = ", ";
+my $email = 0;
+my $scm = 0;
+my $web = 0;
+my $file = 0;
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
+my $penguin_chiefs = "\(" . join("|",@penguin_chief_names) . "\)";
+
+GetOptions(
+	   'git!' => \$email_git,
+	   'git-chief-penguins!' => \$email_git_penguin_chiefs,
+	   'm!' => \$email_maintainer,
+	   'n!' => \$email_usename,
+	   'l!' => \$email_list,
+	   's!' => \$email_subscriber_list,
+	   'multiline!' => \$output_multiline,
+	   'separator=s' => \$output_separator,
+	   'scm!' => \$scm,
+	   'web!' => \$web,
+	   'f' => \$file,
+	   ) or exit;
+
+my $exit = 0;
+
+if ($#ARGV < 0) {
+    usage();
+    die "$P: argument missing: patch file or -f file please";
+}
+
+$email = ($email_maintainer || $email_list || $email_subscriber_list
+	  || $email_git ||$email_git_penguin_chiefs);
+
+my $selections = $email + $scm + $web;
+if ( $selections == 0 || $selections > 1) {
+    usage();
+    die "$P: Please select one of email categories, scm, or web\n";
+}
+
+if (!top_of_kernel_tree("./")) {
+    die "$P: The current directory does not appear to be "
+	. "a linux kernel source tree.\n";
+}
+
+## Read MAINTAINERS for type/value pairs
+
+my @typevalue = ();
+open(MAINT, "<${lk_path}MAINTAINERS") || die "$P: Can't open ${lk_path}MAINTAINERS\n";
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
+## use the filename on the command line or find the filenames in the patchfile
+
+my @files = ();
+
+if ($file) {
+    if (!(-f $ARGV[0])) {
+	die "$P: file '${ARGV[0]}' not found\n";
+    }
+    push(@files, $ARGV[0]);
+} else {
+    open(PATCH, "<$ARGV[0]") or die "$P: Can't open ${ARGV[0]}\n";
+    while (<PATCH>) {
+	if (m/^\+\+\+\s+(\S+)/) {
+	    my $file = $1;
+	    $file =~ s@^[^/]*/@@;
+	    $file =~ s@\n@@;
+	    push(@files, $file);
+	}
+    }
+    close(PATCH);
+}
+
+@files = sort_and_uniq(@files);
+
+# Find responsible parties
+
+my @email_to = ();
+my @scm = ();
+my @web = ();
+
+foreach my $file (@files) {
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
+	recent_git_signoffs($file);
+    }
+
+#Do not match excluded file patterns
+
+    foreach my $line (@typevalue) {
+	if ($line =~ m/^(\C):(.*)/) {
+	    my $type = $1;
+	    my $value = $2;
+	    if ($type eq 'X') {
+		if (file_match_pattern($file, $value)) {
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
+		    if (file_match_pattern($file, $value)) {
+			add_categories($tvi);
+		    }
+		}
+	    }
+	    $tvi++;
+	}
+    }
+}
+
+if ($email) {
+
+## add lk if no one else is interested...
+
+    my $address_cnt = @email_to;
+    if ($address_cnt == 0 && $email_list) {
+	push(@email_to, "linux-kernel\@vger.kernel.org");
+    }
+
+    @email_to = sort_and_uniq(@email_to);
+    output(@email_to);
+
+} elsif ($scm) {
+
+    @scm = sort_and_uniq(@scm);
+    output(@scm);
+
+} elsif ($web) {
+
+    @web = sort_and_uniq(@web);
+    output(@web);
+
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
+sub usage {
+    print <<EOT;
+usage: $P [options] patchfile 
+       $P [options] -f file
+version: $V
+
+Options:
+  --git => include recent git \*-by: signers
+  --git-chief-penguins => include ${penguin_chiefs}
+  --m => include maintainer(s) if any
+  --n => include name 'Full Name <addr\@domain.tld>'
+  --l => include list(s) if any
+  --s => include subscriber only list(s) if any
+  --separator [, ] => separator for multiple entries on 1 line
+  --multiline => print 1 entry per line
+  --web => print website(s) if any
+  --scm => print SCM tree(s) if any
+
+Default options:
+  [--git --m --l --multiline]
+
+EOT
+}
+
+sub top_of_kernel_tree {
+	my ($lk_path) = @_;
+
+	if ($lk_path ne "" && substr($lk_path,length($lk_path)-1,1) ne "/") {
+	    $lk_path .= "/";
+	}
+	if (   (-f "${lk_path}COPYING")
+	    && (-f "${lk_path}CREDITS")
+	    && (-f "${lk_path}Kbuild")
+	    && (-f "${lk_path}MAINTAINERS")
+	    && (-f "${lk_path}Makefile")
+	    && (-f "${lk_path}README")
+	    && (-d "${lk_path}Documentation")
+	    && (-d "${lk_path}arch")
+	    && (-d "${lk_path}include")
+	    && (-d "${lk_path}drivers")
+	    && (-d "${lk_path}fs")
+	    && (-d "${lk_path}init")
+	    && (-d "${lk_path}ipc")
+	    && (-d "${lk_path}kernel")
+	    && (-d "${lk_path}lib")
+	    && (-d "${lk_path}scripts")) {
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
+sub add_categories {
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
+	    } elsif ($ptype eq "T") {
+		push(@scm, $pvalue);
+	    } elsif ($ptype eq "W") {
+		push(@web, $pvalue);
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
+	die("$P: git not found.  Add --nogit to options?\n");
+    }
+
+    $cmd = "git log --since=12.months.ago -- ${file}";
+    $cmd .= " | grep -i '^    [-a-z]*by:.*\\\@'";
+    if (!$email_git_penguin_chiefs) {
+	$cmd .= " | grep -E -v \"${penguin_chiefs}\"";
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
+
+sub sort_and_uniq {
+    my @parms = @_;
+
+    my %saw;
+    @parms = sort @parms;
+    @parms = grep(!$saw{$_}++, @_);
+    return @parms;
+}
+
+sub output {
+    my @parms = @_;
+
+    if ($output_multiline) {
+	foreach my $line (@parms) {
+	    print("${line}\n");
+	}
+    } else {
+	print(join($output_separator, @parms));
+	print("\n");
+    }
+}


