Return-Path: <linux-kernel-owner+w=401wt.eu-S1762349AbXE1Jsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762349AbXE1Jsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 05:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906AbXE1Js1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 05:48:27 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:57440 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757370AbXE1JsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 05:48:25 -0400
Date: Mon, 28 May 2007 11:45:37 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andy Whitcroft <apw@shadowen.org>
cc: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add a trivial patch style checker
In-Reply-To: <9a1288909c10f2935af82ec5cea0c46b@pinky>
Message-ID: <Pine.LNX.4.61.0705281123000.11140@yvahk01.tjqt.qr>
References: <9a1288909c10f2935af82ec5cea0c46b@pinky>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 27 2007 18:11, Andy Whitcroft wrote:
>+
>+my $P = $0;
>+
>+my $V = '0.01';
>+
>+use Getopt::Long qw(:config no_auto_abbrev);
>[...]
>+sub top_of_kernel_tree {
>+	if ((-f "COPYING") && (-f "CREDITS") && (-f "Kbuild") &&
>+	    (-f "MAINTAINERS") && (-f "Makefile") && (-f "README") &&
>+	    (-d "Documentation") && (-d "arch") && (-d "include") &&
>+	    (-d "drivers") && (-d "fs") && (-d "init") && (-d "ipc") &&
>+	    (-d "kernel") && (-d "lib") && (-d "scripts")) {
>+		return 1;
>+	}
>+	return 0;
>+}
>[...]

The consistent style quite looses after this point, esp. space around
operators ;-)

>+sub process {
>+	my $filename = shift;
>+	my @lines = @_;
>+
>+	my $linenr=0;
>+	my $prevline="";
>+	my $stashline="";
>+
>+	my $lineforcounting='';
>+	my $indent;
>+	my $previndent=0;
>+	my $stashindent=0;
>+
>+	my $clean = 1;
>+	my $signoff = 0;
>+
>+	# Trace the real file/line as we go.
>+	my $realfile = '';
>+	my $realline = 0;
>+	my $realcnt = 0;
>+	my $here = '';
>+	my $in_comment = 0;
>+	my $first_line = 0;

Like in the kernel/C (as far as .bss is concerned), they usually do not
need initialization. (They will be different from 0 though, namely
undef, but doing ++$x where x is undefined will also DTRT.)

>+
>+	foreach my $line (@lines) {
>+		$linenr++;
>+
>+#extract the filename as it passes
>+		if($line=~/^\+\+\+\s+(\S+)/) {

/^\+{3}\s+(\S+)/  "there's always more than one way to do it in Perl" - meh

>+			$realfile=$1;
>+			$in_comment = 0;
>+			next;
>+		}
>+#extract the line range in the file after the patch is applied
>+		if($line=~/^@@ -\d+,\d+ \+(\d+)(,(\d+))? @@/) {

The @ should be escaped afaicr
/^\@\@\s+-\d+,\d+\s+\+(\d+)(,(\d+))? \@\@/

>+			$first_line = 1;
>+			$in_comment = 0;
>+			$realline=$1-1;
>+			if (defined $2) {
>+				$realcnt=$3+1;
>+			} else {
>+				$realcnt=1+1;
>+			}
>+			next;
>+		}
>+#check the patch for a signoff:
>+		if ($line =~ /^[[:space:]]*Signed-off-by:/i) {

[[:space:]] = \s
Perhaps require a \s after : and get rid of /i? ;-)

>+			$signoff++;
>+		}
>+#track the line number as we move through the hunk
>+		if($line=~/^( |\+)/) {

Or ... /^([ \+])/  (mostly depends on taste)

>+			$realline++;
>+			$realcnt-- if ($realcnt);

That's a bit ambiguous at first, since it usually means (I think)
if(defined($realcnt) || $realcnt != 0).
Using if ($realcnt == 0) could help.

>+
>+			# track any sort of multi-line comment.  Obviously if
>+			# the added text or context do not include the whole
>+			# comment we will not see it. Such is life.
>+			#
>+			# Guestimate if this is a continuing comment.  If this
>+			# is the start of a diff block and this line starts
>+			# ' *' then it is very likely a comment.
>+			if ($first_line and $line =~ m@^.\s*\*@) {
>+				$in_comment = 1;
>+			}

m@@ and and needed? Could be just
	if ($first_line == 0 && $line =~ /^.\s*\*/)

>+			if ($line =~ m@/\*@) {
>+				$in_comment = 1;
>+			}
>+			if ($line =~ m@\*/@) {
>+				$in_comment = 0;
>+			}

Although not necessary here, I'd like to point out that I've had
more luck using paired characters as boundaries, i.e. m{} or s{}{},
which means less escaping for the inner regex in some cases.

>+# check we are in a valid source file *.[hc] if not then ignore this hunk
>+		next if ($realfile !~ /\.[hc]$/);

Oh I think trailing whitespace and 80 column limit should also be
applied to .S and .s files.

>+
>+#trailing whitespace
>+		if($line=~/\S\s+$/) {
>+			my $herevet = "$here\n" . cat_vet($line) . "\n\n";
>+			print ("trailing whitespace\n");
>+			print "$herevet";
>+			$clean = 0;
>+		}
>+#80 column limit
>+		if(!($prevline=~/\/\*\*/) && length($lineforcounting) > 80){

Actually, I think this should be "> 79" (after stripping a .diff's
control column), since the cursor may move to the 81th column when
editing an 80-col line - which is what we want to avoid, no?

>+			print "line over 80 characters\n";
>+			print "$herecurr";
>+			$clean = 0;
>+		}
>+
>+# at the beginning of a line any tabs must come first and anything
>+# more than 8 must use tabs.
>+		if($line=~/^\+\s* \t\s*\S/ or $line=~/^\+\s*        \s*/) {

|| will do instead of or.
Somehow this does not catch "Only spaces" lines (/^ +\S/), because there's
no \t in them. (Talk about regex fun.)

I'd say split and simplify:
	if ($line =~ /^\s* {8,}/) {
		print "Make that big space a \\t\n";
	}
	if ($line =~ /^ +\t/) {
		print "Inadvertent space at line start, or make it \\t\n";
	}

>+			my $herevet = "$here\n" . cat_vet($line) . "\n\n";
>+			print ("use tabs not spaces\n");
>+			print "$herevet";
>+			$clean = 0;
>+		}
>+
>+		#
>+		# The rest of our checks refer specifically to C style
>+		# only apply those _outside_ comments.
>+		#
>+		next if ($in_comment);
>+
>+# no C99 // comments
>+		if ($line =~ qr|//|) {
>+			print "do not use C99 // comments\n";
>+			print "$herecurr";
>+			$clean = 0;
>+		}

(Now we're using qr{}, what about being consistent with m{}?)
It may break on rare occassions:

	printk("Hello // World\n");

>+		# Remove comments from the line before processing.
>+		$line =~ s@/\*.*\*/@@g;
>+		$line =~ s@/\*.*@@;
>+		$line =~ s@.*\*/@@;
>+		$line =~ s@//.*@@;
>+
>+#EXPORT_SYMBOL should immediately follow its function closing }.
>+		if (($line =~ /EXPORT_SYMBOL.*\(.*\)/) ||
>+		    ($line =~ /EXPORT_UNUSED_SYMBOL.*\(.*\)/)) {
>+			if (($prevline !~ /^}/) &&
>+			   ($prevline !~ /^\+}/) &&
>+			   ($prevline !~ /^ }/)) {
>+				print "EXPORT_SYMBOL(func); should immediately follow its function\n";
>+				print "$herecurr";
>+				$clean = 0;
>+			}
>+		}
>+
>+		# check for static initialisers.
>+		if ($line=~/\s*static\s.*=\s+(0|NULL);/) {
>+			print "do not initialise statics to 0 or NULL\n";
>+			print "$herecurr";
>+			$clean = 0;
>+		}
>+
>+		# check for new typedefs.
>+		if ($line=~/\s*typedef\s/) {
>+			print "do not add new typedefs\n";
>+			print "$herecurr";
>+			$clean = 0;
>+		}
>+
>+# * goes on variable not on type
>+		if($line=~/[A-Za-z\d_]+\* [A-Za-z\d_]+/) {
>+			print ("\"foo* bar\" should be \"foo *bar\"\n"); 

print does not need parentheses in most cases.

>+			print "$herecurr";
>+			$clean = 0;
>+		}
>+
>+# no BUG() or BUG_ON()
>+		if ($line =~ /\b(BUG|BUG_ON)\b/) {
>+			print "Try to use WARN_ON & Recovery code rather than BUG() or BUG_ON()\n";
>+			print "$herecurr";
>+			$clean = 0;
>+		}
>+
>+# printk should use KERN_* levels
>+		if (($line =~ /\bprintk\b/) &&
>+		    ($line !~ /KERN_/)) {
>+			print "printk() should include KERN_ facility level\n";
>+			print "$herecurr";
>+			$clean = 0;
>+		}

if ($line =~ /\bprintk\((?!KERN_)/)



Attention span ran out. :)

	Jan
-- 
