Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab0CJDZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 22:25:23 -0500
Received: from mail.perches.com ([173.55.12.10]:1584 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756105Ab0CJDZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 22:25:20 -0500
Subject: [PATCH V2] scripts/cvt_kernel_style.pl: partial "kernel style"
 pretty-printing
From: Joe Perches <joe@perches.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, devel@driverdev.osuosl.org,
       apw@shadowen.org
In-Reply-To: <201003100222.27201.elendil@planet.nl>
References: <1268177526.1545.62.camel@Joe-Laptop.home>
	 <201003100222.27201.elendil@planet.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Mar 2010 19:25:18 -0800
Message-ID: <1268191518.1545.228.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-10 at 02:22 +0100, Frans Pop wrote:
> Joe Perches wrote:
> > The article recommends running checkpatch and fixing the various
> > non-conforming style elements the output produces.
> Hmm. I thought that "style cleanup only" patches were generally frowned 
> upon?

Maybe so.
This article seemed geared to drivers/staging but it wasn't obvious.

> Maybe I missed it, but you should certainly add removal of trailing space.
> And possibly remove spaces before the closing ";" after statements.

OK, I can add that.

> Maybe the script should print a large warning (unless -q is used?) that all 
> changes should be carefully reviewed manually and not combined with 
> functional changes, and have a pointer to Documentation/SubmittingPatches?

> I wonder what traffic the advice to mail lkml when "I have a line of code 
> that's over 80 chars" is going to generate...

I think "get a life" was one, "come on" another.

Here's a new version that does individual style changes including
the trim and ; you suggested.
-----------------

Trivial source file reformatter.

Changes a few things to be more kernel style

Optionally convert any or all of:

Convert printk(KERN_<level> to pr_<level>(
Coalesces long format strings
Removes unnecessary parentheses from return
Add space after if, for and while
Convert "for (foo;bar;baz)" to "for (foo; bar; baz)"
Removes multiple semicolons
Convert leading spaces to tabs
Trims trailing whitespace
Moves labels to column 1

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/cvt_kernel_style.pl |  254 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 254 insertions(+), 0 deletions(-)

diff --git a/scripts/cvt_kernel_style.pl b/scripts/cvt_kernel_style.pl
new file mode 100755
index 0000000..fba6a9e
--- /dev/null
+++ b/scripts/cvt_kernel_style.pl
@@ -0,0 +1,254 @@
+#!/usr/bin/perl -w
+
+# Change some style elements of a source file.
+# An imperfect source code reformatter.
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
+my $quiet = 0;
+my $overwrite = 0;
+my $modified = 0;
+my $suffix = ".style";
+my $convert_options = "";
+my @avail_options = ("all",
+		     "convert_printk_to_pr_level",
+		     "coalesce_formats",
+		     "convert_leading_spaces_to_tabs",
+		     "remove_trailing_whitespace",
+		     "deparenthesize_returns",
+		     "remove_unnecessary_semicolons",
+		     "remove_space_before_quoted_newline",
+		     "space_after_KERN_level",
+		     "space_after_if_while_for",
+		     "space_after_for_semicolons",
+		     "move_labels_to_column_1",
+		     "remove_whitespace_before_trailing_semicolon",
+		 );
+
+my $version = 0;
+my $help = 0;
+
+if (!GetOptions(
+		'source-indent=i' => \$source_indent,
+		'convert=s' => \$convert_options,
+		'o|overwrite!' => \$overwrite,
+		'q|quiet!' => \$quiet,
+		'v|version' => \$version,
+		'h|help|usage' => \$help,
+		)) {
+    die "$P: invalid argument - use --help if necessary\n";
+}
+
+if ($help) {
+    usage();
+    exit 0;
+}
+
+if ($version) {
+    print "$P: v$V\n";
+    exit 0;
+}
+
+sub usage {
+    print <<EOT;
+usage: $P [options] <files>
+version: $V
+
+EOT
+    print "Available conversions:\n";
+    foreach my $convert (@avail_options) {
+	print "\t$convert\n";
+    }
+    print "\n";
+    print "Use --convert=(comma separated list)\n";
+    print "   ie: --convert=convert_printk_to_pr_level,coalesce_formats\n";
+    print <<EOT;
+
+Input source file descriptions:
+  --source-indent => How many spaces are used for an indent (default: 8)
+
+Output file:
+  --overwrite => write the changes to the source file
+  --suffix => suffix to append to new file (default: .style)
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
+my %hash;
+foreach my $opt (@avail_options) {
+    $hash{$opt} = 0;
+}
+
+my @actual_options = split(',', $convert_options);
+foreach my $opt (@actual_options) {
+    $hash{$opt} = 1;
+}
+
+sub test {
+    my ($check) = @_;
+
+    return 1 if ($convert_options eq "all");
+    return 1 if ($hash{$check});
+
+    return 0;
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
+    if (test("convert_printk_to_pr_level")) {
+	$text =~ s@\bprintk\s*\(\s*KERN_(INFO|WARNING|ERR|ALERT|CRIT|EMERG|NOTICE|CONT)\s*@pr_\L$1\(@g;
+    }
+
+# Coalesce long formats
+    if (test("coalesce_formats")) {
+	1 while $text =~ s@\b((dev_|pr_|netif_|netdev_)[^;]+)\"\s*\n\s*\"@$1@g;
+    }
+
+# Remove spaces and tabs before quoted newlines
+    if (test("remove space_before_quoted_newline")) {
+	$text =~ s@(\"[^\"]*)[ \t]+\\n@$1\\n@g;
+    }
+
+# Add space between KERN_<LEVEL> and open quote
+    if (test("space_after_KERN_level")) {
+	$text =~ s@\bKERN_([A-Z]+)[ \t]*\"@KERN_$1 \"@g;
+    }
+
+# Remove unnecessary parentheses around return
+    if (test("deparenthesize_returns")) {
+	$text =~ s@\breturn\s+\(([^\)]+)\s*\)\s*;@return $1;@g;
+    }
+
+# This doesn't work very well, too many comments modified
+# Put labels (but not "default:" on column 1
+    if (test("move_labels_to_column_1")) {
+	$text =~ s@^([ \t]+)([A-Za-z0-9_]+)\s*:[ \t]*:[ \t]*$@check_label($1, $2)@ge;
+    }
+
+# Add space after (if, for, or while) and open parenthesis
+    if (test("space_after_if_while_for")) {
+	$text =~ s@\b(if|while|for)\(@$1 \(@g;
+    }
+
+# Convert "for (foo;bar;baz)" to "for (foo; bar; baz)"
+    if (test("space_after_for_semicolons")) {
+	$text =~ s@\n([ \t]+)for\s*\([ \t]*([^;]+);[ \t]*([^;]+);[ \t]*([^\)]+)\)@check_for($1, $2, $3, $4)@ge;
+    }
+
+# Convert leading spaces to tabs
+    if (test("convert_leading_spaces_to_tabs")) {
+	$text =~ s@\n([ \t]+)@tabify($1)@ge;
+    }
+
+# Delete trailing whitespace
+    if (test("remove_trailing_whitespace")) {
+	$text =~ s@[ \t]+\n@\n@g;
+    }
+
+# Remove multiple semicolons at end-of-line
+    if (test("remove_multiple_semicolons")) {
+	$text =~ s@;[ \t]*;[ \t]*\n@;\n@g;
+    }
+
+# Delete whitespace before trailing semicolon
+    if (test("remove_whitespace_before_trailing_semicolon")) {
+	$text =~ s@[ \t]*;[ \t]*\n@;\n@g;
+    }
+
+# write the file if something was changed
+
+    if ($text ne $oldtext) {
+	my $newfile = $file;
+	if (!$overwrite) {
+	    $newfile = "$newfile$suffix";
+	}
+	open($f, '>', $newfile)
+	    or die "$P: Can't open $newfile for write\n";
+	print $f $text;
+	close($f);
+
+	if (!$quiet) {
+	    if ($overwrite) {
+		print "Converted $file\n";
+	    } else {
+		print "Converted $file to $newfile\n";
+	    }
+	    $modified = 1;
+	}
+    }
+}
+
+if ($modified && !$quiet) {
+    print <<EOT;
+
+Warning: these changes may not be correct.
+
+These changes should be carefully reviewed manually and not combined with
+any functional changes.
+
+Compile, build and test your changes.
+
+You should understand and be responsible for all object changes.
+
+Make sure you read Documentation/SubmittingPatches before sending
+any changes to reviewers, maintainers or mailing lists.
+EOT
+}


