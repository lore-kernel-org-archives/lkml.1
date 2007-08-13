Return-Path: <linux-kernel-owner+w=401wt.eu-S932444AbXHMFtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444AbXHMFtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 01:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbXHMFtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 01:49:46 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3319 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461AbXHMFtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 01:49:45 -0400
Subject: [PATCH] [1/2many] - FInd the maintainer(s) for a patch -
	scripts/get_maintainer.pl
From: Joe Perches <joe@perches.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Content-Type: text/plain
Date: Sun, 12 Aug 2007 22:49:34 -0700
Message-Id: <1186984174.10249.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I grew weary of looking up the appropriate
maintainer email address(es) to CC: for a patch.

I added flags to the MAINTAINERS file

F:	file pattern

for each maintained block and a script to parse
the modified blocks for maintainer and list
email addresses.

perl scripts/get_maintainer.pl <patch>

gives the appropriate maintainer(s).

Modifications since last post:

Added options to control email address style and multiple address separator

Please apply.

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
new file mode 100755
index 0000000..3e5cc6c
--- /dev/null
+++ b/scripts/get_maintainer.pl
@@ -0,0 +1,217 @@
+#!/usr/bin/perl -w
+# (c) 2007, Joe Perches <joe@perches.com>
+#           created from checkpatch.pl
+# Licensed under the terms of the GNU GPL License version 2
+
+use strict;
+
+my $P = $0;
+$P =~ s@.*/@@g;
+
+my $V = '0.02';
+
+use Getopt::Long qw(:config no_auto_abbrev);
+
+my $tree = "./";
+my $email_maintainer = 1;
+my $email_maintainer_name = 1;
+my $email_list = 1;
+my $email_subscriber_list = 0;
+my $email_separator = ", ";
+my %saw;
+
+GetOptions(
+	   'tree=s' => \$tree,
+	   'm!' => \$email_maintainer,
+	   'n!' => \$email_maintainer_name,
+	   'l!' => \$email_list,
+	   's!' => \$email_subscriber_list,
+	   'separator=s' => \$email_separator,
+	   ) or exit;
+
+my $exit = 0;
+
+if ($#ARGV < 0 ||
+    ($email_maintainer == 0 && $email_list == 0 && $email_subscriber_list == 0)) {
+    print "usage: $P [options] patchfile\n";
+    print "version: $V\n";
+    print "  --tree [path] => linux kernel source path\n";
+    print "  --m => include maintainer(s) if any\n";
+    print "  --n => include maintainer name 'Full Name <addr\@domain.tld>'\n";
+    print "  --l => include list(s) if any\n";
+    print "  --s => include subscriber only list(s) if any\n";
+    print "  --separator [, ] => separator for multiple addresses\n";
+    print "Default: [--m --l --separator \", \"]\n";
+    print "Be sure to select something...\n";
+    exit(1);
+}
+
+if ($tree && !top_of_kernel_tree($tree)) {
+    if (${tree} ne "") {
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
+	if ($type eq "F") {              ##Filename pattern matching
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
+foreach (@patchedfiles) {
+    my $patchedfile = $_;
+    my $tvi = 0;
+
+    foreach (@typevalue) {
+	if (m/^(\C):(.*)/) {
+	    my $type = $1;
+	    my $value = $2;
+	    if ($type eq 'F') {
+		if (file_match_pattern($patchedfile, $value)) {
+		    my $ptvi = $tvi - 1;
+		    while ($ptvi >= 0) {
+			my $tv = $typevalue[$ptvi];
+			if ($tv =~ m/^(\C):(.*)/) {
+			    my $ptype = $1;
+			    my $pvalue = $2;
+			    if ($ptype eq "L") {
+				my $subscr = $pvalue;
+				if ($subscr =~ m/\s*\(subscribers-only\)/) {
+				    if ($email_subscriber_list > 0) {
+					$subscr =~ s/\s*\(subscribers-only\)//g;
+					push(@email_to, $subscr);
+				    }
+				} else {
+				    if ($email_list > 0) {
+					push(@email_to, $pvalue);
+				    }
+				}
+			    } elsif ($ptype eq "M") {
+				if ($email_maintainer > 0) {
+				    if ($ptvi >= 0) {
+					my $tv = $typevalue[$ptvi - 1];
+					if ($tv =~ m/^(\C):(.*)/) {
+					    if ($1 eq "P" && $email_maintainer_name > 0) {
+						push(@email_to, "$2 <$pvalue>");
+					    } else {
+						push(@email_to, $pvalue);
+					    }
+					}
+				    } else {
+					push(@email_to, $pvalue);
+				    }
+				}
+			    }
+			    $ptvi--;
+			} else {
+			    $ptvi = -1;
+			}
+		    }
+		}
+	    }
+	}
+	$tvi++;
+    }
+}
+
+## sort and uniq email_to
+
+@email_to = sort @email_to;
+undef %saw;
+@email_to = grep(!$saw{$_}++, @email_to);
+
+## add lk if noone else...
+
+my $address_cnt = @email_to;
+if ($address_cnt == 0 && $email_list > 0) {
+    push(@email_to, "linux-kernel\@vger.kernel.org");
+}
+print(join($email_separator, @email_to));
+print("\n");
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
+	    $tree = $tree . "/";
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


