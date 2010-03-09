Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab0CIXcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 18:32:10 -0500
Received: from mail.perches.com ([173.55.12.10]:1566 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585Ab0CIXcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 18:32:08 -0500
Subject: Tuxradar patching article and [PATCH] scripts/cvt_kernel_style.pl
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel <devel@driverdev.osuosl.org>,
       Andy Whitcroft <apw@shadowen.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Mar 2010 15:32:06 -0800
Message-ID: <1268177526.1545.62.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was an article published recently:
http://www.tuxradar.com/content/newbies-guide-hacking-linux-kernel
that seems to have prompted several new contributors (welcome)
to create style reformatting patches.

The article recommends running checkpatch and fixing the various
non-conforming style elements the output produces.

A better solution might be to enhance checkpatch to rewrite the
patch or a file with -f, but that's more than I'd like to do.

Maybe Andy Whitcroft might find a little of his copious spare
time available to start something like that.

For now, here's a little script that reformats source code to
be more a very little more kernel style compatible.

Maybe something like this could be useful to initial contributors
and could be extended as appropriate.

scripts/cvt_kernel_style.pl: Change a source file to more match kernel style

Trivial source file formatter.

Changes a few things to be more kernel style

Convert printk(KERN_<level> to pr_<level>(
Removes unnecessary parenthesis from return
Add space after if, for and while
Convert "for (foo;bar;baz)" to "for (foo; bar; baz)"
Removes multiple semicolons
Convert leading spaces to tabs

Use --source-indent to specify the #space->tab conversion (default 8)

Signed-off-by: Joe Perches <joe@perches.com>
---
diff --git a/scripts/cvt_kernel_style.pl b/scripts/cvt_kernel_style.pl
new file mode 100755
index 0000000..39a8ab7
--- /dev/null
+++ b/scripts/cvt_kernel_style.pl
@@ -0,0 +1,134 @@
+#!/usr/bin/perl -w
+
+# Change some style elements of a source file
+# An imperfect source code rewriter.
+# Might make trivial patches a bit easier.
+#
+# usage: perl scripts/cvt_kernel_style.pl <files>
+#
+# Licensed under the terms of the GNU GPL License version 2
+
+use strict;
+use Getopt::Long qw(:config no_auto_abbrev);
+
+my $P = $0;
+my $V = '0.1';
+
+my $source_indent = 8;
+
+my $version = 0;
+my $help = 0;
+
+if (!GetOptions(
+		'source-indent=i' => \$source_indent,
+		'v|version' => \$version,
+		'h|help|usage' => \$help,
+		)) {
+    die "$P: invalid argument - use --help if necessary\n";
+}
+
+if ($help != 0) {
+    usage();
+    exit 0;
+}
+
+sub usage {
+    print <<EOT;
+usage: $P [options] <files>
+version: $V
+
+Input source file descriptions:
+  --source-indent => How many spaces are used for an indent (default: 8)
+
+Other options:
+  --version => show version
+  --help => show this help information
+EOT
+}
+
+sub check_label {
+    my ($leading, $label) = @_;
+
+    if ($label == "default") {
+	return "$leading$label:";
+    }
+    return "$label:";
+}
+
+sub check_for {
+    my ($leading, $test1, $test2, $test3) = @_;
+
+    $test1 =~ s/^\s+|\s+$//g;
+    $test2 =~ s/^\s+|\s+$//g;
+    $test3 =~ s/^\s+|\s+$//g;
+
+    return "\n${leading}for ($test1; $test2; $test3)";
+}
+
+sub tabify {
+    my ($leading) = @_;
+
+    my $max_spaces_before_tab = $source_indent - 1;
+    my $spaces_to_tab = sprintf("%*s", $source_indent, "");
+#convert leading spaces to tabs
+    1 while $leading =~ s@^([\t]*)$spaces_to_tab@$1\t@g;
+#Remove spaces before a tab
+    1 while $leading =~ s@^([\t]*)([ ]{1,$max_spaces_before_tab})\t@$1\t@g;
+
+    return "\n$leading";
+}
+
+foreach my $file (@ARGV) {
+    my $f;
+    my $text;
+    my $oldtext;
+
+# read the file
+
+    open($f, '<', $file)
+	or die "$P: Can't open $file for read\n";
+    $oldtext = do { local($/) ; <$f> };
+    close($f);
+
+    $text = $oldtext;
+
+# Convert printk(KERN_<level> to pr_<level>(
+    $text =~ s@\bprintk\s*\(\s*KERN_(INFO|WARNING|ERR|ALERT|CRIT|EMERG|NOTICE|CONT)\s*@pr_\L$1\(@g;
+
+# Coalesce long formats
+    1 while $text =~ s@\b((dev_|pr_|netif_|netdev_)[^;]+)\"\s*\n\s*\"@$1@g;
+
+# Remove spaces and tabs before quoted newlines
+    $text =~ s@(\"[^\"]*)[ \t]+\\n@$1\\n@g;
+
+# Add space between KERN_<LEVEL> and open quote
+    $text =~ s@KERN_([A-Z]+)\"@KERN_$1 \"@g;
+
+# Remove unnecessary parentheses around return
+    $text =~ s@\breturn\s+\(([^\)]+)\s*\)\s*;@return $1;@g;
+
+## This doesn't work very well, too many comments modified
+## Put labels (but not "default:" on column 1
+#    $text =~ s@^([ \t]+)([A-Za-z0-9_]+)\s*:[ \t]*:[ \t]*$@check_label($1, $2)@ge;
+
+# Add space after (if, for, or while) and open parenthesis
+    $text =~ s@\b(if|while|for)\(@$1 \(@g;
+
+# Convert "for (foo;bar;baz)" to "for (foo; bar; baz)"
+    $text =~ s@\n([ \t]+)for\s*\([ \t]*([^;]+);[ \t]*([^;]+);[ \t]*([^\)]+)\)@check_for($1, $2, $3, $4)@ge;
+
+# Remove multiple semicolons at end-of-line
+    $text =~ s@;[ \t]*;[ \t]*\n@;\n@g;
+
+# Convert leading spaces to tabs
+    $text =~ s@\n([ \t]+)@tabify($1)@ge;
+
+# write the file if something was changed
+
+    if ($text ne $oldtext) {
+	open($f, '>', $file)
+	    or die "$P: Can't open $file for write\n";
+	print $f $text;
+	close($f);
+    }
+}



