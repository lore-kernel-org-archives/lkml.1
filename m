Return-Path: <linux-kernel-owner+w=401wt.eu-S1762789AbXJMSh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762789AbXJMSh2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 14:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759739AbXJMShS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 14:37:18 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:39857 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbXJMShQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 14:37:16 -0400
Date: Sat, 13 Oct 2007 14:35:12 -0400
Message-Id: <200710131835.l9DIZCYp030867@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Andy Whitcroft <apw@shadowen.org>
Cc: "Mike D. Day" <ncmike@us.ibm.com>, linux-kernel@vger.kernel.org,
       Erez Zadok <ezk@cs.sunysb.edu>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] checkpatch: Fix line number reporting 
In-reply-to: Your message of "Fri, 12 Oct 2007 20:37:51 BST."
             <20071012193751.GA31579@shadowen.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20071012193751.GA31579@shadowen.org>, Andy Whitcroft writes:
> On Fri, Oct 12, 2007 at 03:26:54PM -0400, Mike D. Day wrote:
> > Fix line number reporting when checking source files (as opposed to
> > patches)
> > 
> > Signed-off-by: Mike D. Day <ncmike@us.ibm.com>
> 
> Sorry you've had to fix this about 4 times, mostly because of ongoing
> changes, and slow replication getting in the way.  I've applied this
> and you should find it in -next when replication hits.  md5sum is
> below of the version with it in, so you can make sure you've got
> the right one.
> 
> 54f053c50265e44a6041e3147dc66a69  checkpatch.pl
> 
> -apw

Andy, I've tested the --emacs feature in the above latest
checkpatch.pl-next.  Below is a patch that completes the functionality of
the --emacs option: it ensures that only the cc-style error messages are
printed, no extra context lines or caret lines, no extra newlines, etc.
Although this patch changes every call to a message-producing function, it
is a trivial change, and I believe it's the cleanest way to handle the
separation between the terse cc-style messages and the verbose default
messages.  With this patch, I can finally test a single source file as
follows:

$ ./scripts/checkpatch.pl -q -q --emacs --file path/name/to/file

(Yes, I need two -q).

Cheers,
Erez.


diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 13de0e2..051b354 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -511,18 +511,21 @@ sub report_dump {
 	@report;
 }
 sub ERROR {
-	report("ERROR: $_[0]\n");
+	report("ERROR: $_[0]");
+	report("$_[1]\n") if (!$emacs);
 	our $clean = 0;
 	our $cnt_error++;
 }
 sub WARN {
-	report("WARNING: $_[0]\n");
+	report("WARNING: $_[0]");
+	report("$_[1]\n") if (!$emacs);
 	our $clean = 0;
 	our $cnt_warn++;
 }
 sub CHK {
 	if ($check) {
-		report("CHECK: $_[0]\n");
+		report("CHECK: $_[0]");
+		report("$_[1]\n") if (!$emacs);
 		our $clean = 0;
 		our $cnt_chk++;
 	}
@@ -663,18 +666,18 @@ sub process {
 			# This is a signoff, if ugly, so do not double report.
 			$signoff++;
 			if (!($line =~ /^\s*Signed-off-by:/)) {
-				WARN("Signed-off-by: is the preferred form\n" .
+				WARN("Signed-off-by: is the preferred form\n",
 					$herecurr);
 			}
 			if ($line =~ /^\s*signed-off-by:\S/i) {
-				WARN("need space after Signed-off-by:\n" .
+				WARN("need space after Signed-off-by:\n",
 					$herecurr);
 			}
 		}
 
 # Check for wrappage within a valid hunk of the file
 		if ($realcnt != 0 && $line !~ m{^(?:\+|-| |$)}) {
-			ERROR("patch seems to be corrupt (line wrapped?)\n" .
+			ERROR("patch seems to be corrupt (line wrapped?)\n",
 				$herecurr) if (!$emitted_corrupt++);
 		}
 
@@ -690,7 +693,7 @@ sub process {
 				| [\xF1-\xF3][\x80-\xBF]{3}          # planes 4-15
 				|  \xF4[\x80-\x8F][\x80-\xBF]{2}     # plane 16
 				)*$/x )) {
-			ERROR("Invalid UTF-8\n" . $herecurr);
+			ERROR("Invalid UTF-8\n", $herecurr);
 		}
 
 #ignore lines being removed
@@ -702,15 +705,15 @@ sub process {
 #trailing whitespace
 		if ($line =~ /^\+.*\015/) {
 			my $herevet = "$here\n" . cat_vet($line) . "\n";
-			ERROR("DOS line endings\n" . $herevet);
+			ERROR("DOS line endings\n", $herevet);
 
 		} elsif ($line =~ /^\+.*\S\s+$/ || $line =~ /^\+\s+$/) {
 			my $herevet = "$here\n" . cat_vet($line) . "\n";
-			ERROR("trailing whitespace\n" . $herevet);
+			ERROR("trailing whitespace\n", $herevet);
 		}
 #80 column limit
 		if ($line =~ /^\+/ && !($prevline=~/\/\*\*/) && $length > 80) {
-			WARN("line over 80 characters\n" . $herecurr);
+			WARN("line over 80 characters\n", $herecurr);
 		}
 
 # check we are in a valid source file *.[hc] if not then ignore this hunk
@@ -720,7 +723,7 @@ sub process {
 # more than 8 must use tabs.
 		if ($line=~/^\+\s* \t\s*\S/ or $line=~/^\+\s*        \s*/) {
 			my $herevet = "$here\n" . cat_vet($line) . "\n";
-			ERROR("use tabs not spaces\n" . $herevet);
+			ERROR("use tabs not spaces\n", $herevet);
 		}
 
 # Remove comments from the line before processing.
@@ -786,7 +789,7 @@ sub process {
 				}
 			}
 			if ($err ne '') {
-				ERROR("switch and case should be at the same indent\n$hereline$err");
+				ERROR("switch and case should be at the same indent\n", "$hereline$err");
 			}
 		}
 
@@ -806,13 +809,13 @@ sub process {
 			##warn "line<$line>\nctx<$ctx>\nnext<$lines[$ctx_ln - 1]>";
 
 			if ($ctx !~ /{\s*/ && $ctx_cnt > 0 && $lines[$ctx_ln - 1] =~ /^\+\s*{/) {
-				ERROR("That open brace { should be on the previous line\n" .
+				ERROR("That open brace { should be on the previous line\n",
 					"$here\n$ctx\n$lines[$ctx_ln - 1]");
 			}
 			if ($level == 0 && $ctx =~ /\)\s*\;\s*$/ && defined $lines[$ctx_ln - 1]) {
 				my ($nlength, $nindent) = line_stats($lines[$ctx_ln - 1]);
 				if ($nindent > $indent) {
-					WARN("Trailing semicolon indicates no statements, indent implies otherwise\n" .
+					WARN("Trailing semicolon indicates no statements, indent implies otherwise\n",
 						"$here\n$ctx\n$lines[$ctx_ln - 1]");
 				}
 			}
@@ -823,14 +826,14 @@ sub process {
 
 # TEST: allow direct testing of the type matcher.
 		if ($tst_type && $line =~ /^.$Declare$/) {
-			ERROR("TEST: is type $Declare\n" . $herecurr);
+			ERROR("TEST: is type $Declare\n", $herecurr);
 			next;
 		}
 
 # check for initialisation to aggregates open brace on the next line
 		if ($prevline =~ /$Declare\s*$Ident\s*=\s*$/ &&
 		    $line =~ /^.\s*{/) {
-			ERROR("That open brace { should be on the previous line\n" . $hereprev);
+			ERROR("That open brace { should be on the previous line\n", $hereprev);
 		}
 
 #
@@ -841,7 +844,7 @@ sub process {
 		if ($rawline =~ m{^.#\s*include\s+[<"](.*)[">]}) {
 			my $path = $1;
 			if ($path =~ m{//}) {
-				ERROR("malformed #include filename\n" .
+				ERROR("malformed #include filename\n",
 					$herecurr);
 			}
 			# Sanitise this special form of string.
@@ -851,7 +854,7 @@ sub process {
 
 # no C99 // comments
 		if ($line =~ m{//}) {
-			ERROR("do not use C99 // comments\n" . $herecurr);
+			ERROR("do not use C99 // comments\n", $herecurr);
 		}
 		# Remove C99 comments.
 		$line =~ s@//.*@@;
@@ -864,18 +867,18 @@ sub process {
 			   ($prevline !~ /^\+}/) &&
 			   ($prevline !~ /^ }/) &&
 			   ($prevline !~ /\b\Q$name\E(?:\s+$Attribute)?\s*(?:;|=)/)) {
-				WARN("EXPORT_SYMBOL(foo); should immediately follow its function/variable\n" . $herecurr);
+				WARN("EXPORT_SYMBOL(foo); should immediately follow its function/variable\n", $herecurr);
 			}
 		}
 
 # check for external initialisers.
 		if ($line =~ /^.$Type\s*$Ident\s*=\s*(0|NULL);/) {
-			ERROR("do not initialise externals to 0 or NULL\n" .
+			ERROR("do not initialise externals to 0 or NULL\n",
 				$herecurr);
 		}
 # check for static initialisers.
 		if ($line =~ /\s*static\s.*=\s*(0|NULL);/) {
-			ERROR("do not initialise statics to 0 or NULL\n" .
+			ERROR("do not initialise statics to 0 or NULL\n",
 				$herecurr);
 		}
 
@@ -884,24 +887,24 @@ sub process {
 		if ($line =~ /\btypedef\s/ &&
 		    $line !~ /\btypedef\s+$Type\s+\(\s*\*?$Ident\s*\)\s*\(/ &&
 		    $line !~ /\b__bitwise(?:__|)\b/) {
-			WARN("do not add new typedefs\n" . $herecurr);
+			WARN("do not add new typedefs\n", $herecurr);
 		}
 
 # * goes on variable not on type
 		if ($line =~ m{\($NonptrType(\*+)(?:\s+const)?\)}) {
-			ERROR("\"(foo$1)\" should be \"(foo $1)\"\n" .
+			ERROR("\"(foo$1)\" should be \"(foo $1)\"\n",
 				$herecurr);
 
 		} elsif ($line =~ m{\($NonptrType\s+(\*+)(?!\s+const)\s+\)}) {
-			ERROR("\"(foo $1 )\" should be \"(foo $1)\"\n" .
+			ERROR("\"(foo $1 )\" should be \"(foo $1)\"\n",
 				$herecurr);
 
 		} elsif ($line =~ m{$NonptrType(\*+)(?:\s+(?:$Attribute|$Sparse))?\s+[A-Za-z\d_]+}) {
-			ERROR("\"foo$1 bar\" should be \"foo $1bar\"\n" .
+			ERROR("\"foo$1 bar\" should be \"foo $1bar\"\n",
 				$herecurr);
 
 		} elsif ($line =~ m{$NonptrType\s+(\*+)(?!\s+(?:$Attribute|$Sparse))\s+[A-Za-z\d_]+}) {
-			ERROR("\"foo $1 bar\" should be \"foo $1bar\"\n" .
+			ERROR("\"foo $1 bar\" should be \"foo $1bar\"\n",
 				$herecurr);
 		}
 
@@ -931,7 +934,7 @@ sub process {
 				}
 			}
 			if ($ok == 0) {
-				WARN("printk() should include KERN_ facility level\n" . $herecurr);
+				WARN("printk() should include KERN_ facility level\n", $herecurr);
 			}
 		}
 
@@ -939,14 +942,14 @@ sub process {
 # or if closed on same line
 		if (($line=~/$Type\s*[A-Za-z\d_]+\(.*\).* {/) and
 		    !($line=~/\#define.*do\s{/) and !($line=~/}/)) {
-			ERROR("open brace '{' following function declarations go on the next line\n" . $herecurr);
+			ERROR("open brace '{' following function declarations go on the next line\n", $herecurr);
 		}
 
 # check for spaces between functions and their parentheses.
 		while ($line =~ /($Ident)\s+\(/g) {
 			if ($1 !~ /^(?:if|for|while|switch|return|volatile|__volatile__|__attribute__|format|__extension__|Copyright|case)$/ &&
 		            $line !~ /$Type\s+\(/ && $line !~ /^.\#\s*define\b/) {
-				WARN("no space between function name and open parenthesis '('\n" . $herecurr);
+				WARN("no space between function name and open parenthesis '('\n", $herecurr);
 			}
 		}
 # Check operator spacing.
@@ -1030,7 +1033,7 @@ sub process {
 				if ($op eq ';') {
 					if ($ctx !~ /.x[WEB]/ && $cc !~ /^\\/ &&
 					    $cc !~ /^;/) {
-						ERROR("need space after that '$op' $at\n" . $hereptr);
+						ERROR("need space after that '$op' $at\n", $hereptr);
 					}
 
 				# // is a comment
@@ -1039,13 +1042,13 @@ sub process {
 				# -> should have no spaces
 				} elsif ($op eq '->') {
 					if ($ctx =~ /Wx.|.xW/) {
-						ERROR("no spaces around that '$op' $at\n" . $hereptr);
+						ERROR("no spaces around that '$op' $at\n", $hereptr);
 					}
 
 				# , must have a space on the right.
 				} elsif ($op eq ',') {
 					if ($ctx !~ /.xW|.xE/ && $cc !~ /^}/) {
-						ERROR("need space after that '$op' $at\n" . $hereptr);
+						ERROR("need space after that '$op' $at\n", $hereptr);
 					}
 
 				# '*' as part of a type definition -- reported already.
@@ -1058,19 +1061,19 @@ sub process {
 				} elsif ($op eq '!' || $op eq '~' ||
 				         ($is_unary && ($op eq '*' || $op eq '-' || $op eq '&'))) {
 					if ($ctx !~ /[WEB]x./ && $ca !~ /(?:\)|!|~|\*|-|\&|\||\+\+|\-\-|\{)$/) {
-						ERROR("need space before that '$op' $at\n" . $hereptr);
+						ERROR("need space before that '$op' $at\n", $hereptr);
 					}
 					if ($ctx =~ /.xW/) {
-						ERROR("no space after that '$op' $at\n" . $hereptr);
+						ERROR("no space after that '$op' $at\n", $hereptr);
 					}
 
 				# unary ++ and unary -- are allowed no space on one side.
 				} elsif ($op eq '++' or $op eq '--') {
 					if ($ctx !~ /[WOB]x[^W]/ && $ctx !~ /[^W]x[WOBE]/) {
-						ERROR("need space one side of that '$op' $at\n" . $hereptr);
+						ERROR("need space one side of that '$op' $at\n", $hereptr);
 					}
 					if ($ctx =~ /Wx./ && $cc =~ /^;/) {
-						ERROR("no space before that '$op' $at\n" . $hereptr);
+						ERROR("no space before that '$op' $at\n", $hereptr);
 					}
 
 				# << and >> may either have or not have spaces both sides
@@ -1080,7 +1083,7 @@ sub process {
 					 $op eq '*' or $op eq '/')
 				{
 					if ($ctx !~ /VxV|WxW|VxE|WxE|VxO/) {
-						ERROR("need consistent spacing around '$op' $at\n" .
+						ERROR("need consistent spacing around '$op' $at\n",
 							$hereptr);
 					}
 
@@ -1089,7 +1092,7 @@ sub process {
 					# Ignore email addresses <foo@bar>
 					if (!($op eq '<' && $cb =~ /$;\S+\@\S+>/) &&
 					    !($op eq '>' && $cb =~ /<\S+\@\S+$;/)) {
-						ERROR("need spaces around that '$op' $at\n" . $hereptr);
+						ERROR("need spaces around that '$op' $at\n", $hereptr);
 					}
 				}
 				$off += length($elements[$n + 1]);
@@ -1098,7 +1101,7 @@ sub process {
 
 # check for multiple assignments
 		if ($line =~ /^.\s*$Lval\s*=\s*$Lval\s*=(?!=)/) {
-			CHK("multiple assignments should be avoided\n" . $herecurr);
+			CHK("multiple assignments should be avoided\n", $herecurr);
 		}
 
 ## # check for multiple declarations, allowing for a function declaration
@@ -1112,62 +1115,62 @@ sub process {
 ## 			while ($ln =~ s/\([^\(\)]*\)//g) {
 ## 			}
 ## 			if ($ln =~ /,/) {
-## 				WARN("declaring multiple variables together should be avoided\n" . $herecurr);
+## 				WARN("declaring multiple variables together should be avoided\n", $herecurr);
 ## 			}
 ## 		}
 
 #need space before brace following if, while, etc
 		if (($line =~ /\(.*\){/ && $line !~ /\($Type\){/) ||
 		    $line =~ /do{/) {
-			ERROR("need a space before the open brace '{'\n" . $herecurr);
+			ERROR("need a space before the open brace '{'\n", $herecurr);
 		}
 
 # closing brace should have a space following it when it has anything
 # on the line
 		if ($line =~ /}(?!(?:,|;|\)))\S/) {
-			ERROR("need a space after that close brace '}'\n" . $herecurr);
+			ERROR("need a space after that close brace '}'\n", $herecurr);
 		}
 
 # check spacing on square brackets
 		if ($line =~ /\[\s/ && $line !~ /\[\s*$/) {
-			ERROR("no space after that open square bracket '['\n" . $herecurr);
+			ERROR("no space after that open square bracket '['\n", $herecurr);
 		}
 		if ($line =~ /\s\]/) {
-			ERROR("no space before that close square bracket ']'\n" . $herecurr);
+			ERROR("no space before that close square bracket ']'\n", $herecurr);
 		}
 
 # check spacing on paretheses
 		if ($line =~ /\(\s/ && $line !~ /\(\s*(?:\\)?$/ &&
 		    $line !~ /for\s*\(\s+;/) {
-			ERROR("no space after that open parenthesis '('\n" . $herecurr);
+			ERROR("no space after that open parenthesis '('\n", $herecurr);
 		}
 		if ($line =~ /\s\)/ && $line !~ /^.\s*\)/ &&
 		    $line !~ /for\s*\(.*;\s+\)/) {
-			ERROR("no space before that close parenthesis ')'\n" . $herecurr);
+			ERROR("no space before that close parenthesis ')'\n", $herecurr);
 		}
 
 #goto labels aren't indented, allow a single space however
 		if ($line=~/^.\s+[A-Za-z\d_]+:(?![0-9]+)/ and
 		   !($line=~/^. [A-Za-z\d_]+:/) and !($line=~/^.\s+default:/)) {
-			WARN("labels should not be indented\n" . $herecurr);
+			WARN("labels should not be indented\n", $herecurr);
 		}
 
 # Need a space before open parenthesis after if, while etc
 		if ($line=~/\b(if|while|for|switch)\(/) {
-			ERROR("need a space before the open parenthesis '('\n" . $herecurr);
+			ERROR("need a space before the open parenthesis '('\n", $herecurr);
 		}
 
 # Check for illegal assignment in if conditional.
 		if ($line=~/\bif\s*\(.*[^<>!=]=[^=]/) {
 			#next if ($line=~/\".*\Q$op\E.*\"/ or $line=~/\'\Q$op\E\'/);
-			ERROR("do not use assignment in if condition\n" . $herecurr);
+			ERROR("do not use assignment in if condition\n", $herecurr);
 		}
 
 		# Check for }<nl>else {, these must be at the same
 		# indent level to be relevant to each other.
 		if ($prevline=~/}\s*$/ and $line=~/^.\s*else\s*/ and
 						$previndent == $indent) {
-			ERROR("else should follow close brace '}'\n" . $hereprev);
+			ERROR("else should follow close brace '}'\n", $hereprev);
 		}
 
 #studly caps, commented out until figure out how to distinguish between use of existing and adding new
@@ -1179,14 +1182,14 @@ sub process {
 
 #no spaces allowed after \ in define
 		if ($line=~/\#define.*\\\s$/) {
-			WARN("Whitepspace after \\ makes next lines useless\n" . $herecurr);
+			WARN("Whitepspace after \\ makes next lines useless\n", $herecurr);
 		}
 
 #warn if <asm/foo.h> is #included and <linux/foo.h> is available (uses RAW line)
 		if ($tree && $rawline =~ m{^.\#\s*include\s*\<asm\/(.*)\.h\>}) {
 			my $checkfile = "$root/include/linux/$1.h";
 			if (-f $checkfile && $1 ne 'irq.h') {
-				CHK("Use #include <linux/$1.h> instead of <asm/$1.h>\n" .
+				CHK("Use #include <linux/$1.h> instead of <asm/$1.h>\n",
 					$herecurr);
 			}
 		}
@@ -1194,7 +1197,7 @@ sub process {
 # if and else should not have general statements after it
 		if ($line =~ /^.\s*(?:}\s*)?else\b(.*)/ &&
 		    $1 !~ /^\s*(?:\sif|{|\\|$)/) {
-			ERROR("trailing statements should be on next line\n" . $herecurr);
+			ERROR("trailing statements should be on next line\n", $herecurr);
 		}
 
 # multi-statement macros should be enclosed in a do while loop, grab the
@@ -1233,9 +1236,9 @@ sub process {
 
 			if ($ctx =~ /\\$/) {
 				if ($ctx =~ /;/) {
-					ERROR("Macros with multiple statements should be enclosed in a do - while loop\n" . "$here\n$ctx\n");
+					ERROR("Macros with multiple statements should be enclosed in a do - while loop\n", "$here\n$ctx\n");
 				} else {
-					ERROR("Macros with complex values should be enclosed in parenthesis\n" . "$here\n$ctx\n");
+					ERROR("Macros with complex values should be enclosed in parenthesis\n", "$here\n$ctx\n");
 				}
 			}
 		}
@@ -1277,7 +1280,7 @@ sub process {
 				    $before !~ /}/ && $after !~ /{/) {
 				    	my $herectx = "$here\n" . join("\n", @control, @block[1 .. $#block]) . "\n";
 				    	shift(@block);
-					WARN("braces {} are not necessary for single statement blocks\n" . $herectx);
+					WARN("braces {} are not necessary for single statement blocks\n", $herectx);
 				}
 			}
 		}
@@ -1285,31 +1288,31 @@ sub process {
 # don't include deprecated include files (uses RAW line)
 		for my $inc (@dep_includes) {
 			if ($rawline =~ m@\#\s*include\s*\<$inc>@) {
-				ERROR("Don't use <$inc>: see Documentation/feature-removal-schedule.txt\n" . $herecurr);
+				ERROR("Don't use <$inc>: see Documentation/feature-removal-schedule.txt\n", $herecurr);
 			}
 		}
 
 # don't use deprecated functions
 		for my $func (@dep_functions) {
 			if ($line =~ /\b$func\b/) {
-				ERROR("Don't use $func(): see Documentation/feature-removal-schedule.txt\n" . $herecurr);
+				ERROR("Don't use $func(): see Documentation/feature-removal-schedule.txt\n", $herecurr);
 			}
 		}
 
 # no volatiles please
 		my $asm_volatile = qr{\b(__asm__|asm)\s+(__volatile__|volatile)\b};
 		if ($line =~ /\bvolatile\b/ && $line !~ /$asm_volatile/) {
-			WARN("Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt\n" . $herecurr);
+			WARN("Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt\n", $herecurr);
 		}
 
 # SPIN_LOCK_UNLOCKED & RW_LOCK_UNLOCKED are deprecated
 		if ($line =~ /\b(SPIN_LOCK_UNLOCKED|RW_LOCK_UNLOCKED)/) {
-			ERROR("Use of $1 is deprecated: see Documentation/spinlocks.txt\n" . $herecurr);
+			ERROR("Use of $1 is deprecated: see Documentation/spinlocks.txt\n", $herecurr);
 		}
 
 # warn about #if 0
 		if ($line =~ /^.#\s*if\s+0\b/) {
-			CHK("if this code is redundant consider removing it\n" .
+			CHK("if this code is redundant consider removing it\n",
 				$herecurr);
 		}
 
@@ -1317,7 +1320,7 @@ sub process {
 		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
 			my $expr = $1;
 			if ($line =~ /\bkfree\(\Q$expr\E\);/) {
-				WARN("kfree(NULL) is safe this check is probabally not required\n" . $hereprev);
+				WARN("kfree(NULL) is safe this check is probabally not required\n", $hereprev);
 			}
 		}
 
@@ -1330,37 +1333,37 @@ sub process {
 
 # warn about spacing in #ifdefs
 		if ($line =~ /^.#\s*(ifdef|ifndef|elif)\s\s+/) {
-			ERROR("exactly one space required after that #$1\n" . $herecurr);
+			ERROR("exactly one space required after that #$1\n", $herecurr);
 		}
 
 # check for spinlock_t definitions without a comment.
 		if ($line =~ /^.\s*(struct\s+mutex|spinlock_t)\s+\S+;/) {
 			my $which = $1;
 			if (!ctx_has_comment($first_line, $linenr)) {
-				CHK("$1 definition without comment\n" . $herecurr);
+				CHK("$1 definition without comment\n", $herecurr);
 			}
 		}
 # check for memory barriers without a comment.
 		if ($line =~ /\b(mb|rmb|wmb|read_barrier_depends|smp_mb|smp_rmb|smp_wmb|smp_read_barrier_depends)\(/) {
 			if (!ctx_has_comment($first_line, $linenr)) {
-				CHK("memory barrier without comment\n" . $herecurr);
+				CHK("memory barrier without comment\n", $herecurr);
 			}
 		}
 # check of hardware specific defines
 		if ($line =~ m@^.#\s*if.*\b(__i386__|__powerpc64__|__sun__|__s390x__)\b@ && $realfile !~ m@include/asm-@) {
-			CHK("architecture specific defines should be avoided\n" .  $herecurr);
+			CHK("architecture specific defines should be avoided\n",  $herecurr);
 		}
 
 # check the location of the inline attribute, that it is between
 # storage class and type.
 		if ($line =~ /\b$Type\s+$Inline\b/ ||
 		    $line =~ /\b$Inline\s+$Storage\b/) {
-			ERROR("inline keyword should sit between storage class and type\n" . $herecurr);
+			ERROR("inline keyword should sit between storage class and type\n", $herecurr);
 		}
 
 # check for new externs in .c files.
 		if ($line =~ /^.\s*extern\s/ && ($realfile =~ /\.c$/)) {
-			WARN("externs should be avoided in .c files\n" .  $herecurr);
+			WARN("externs should be avoided in .c files\n",  $herecurr);
 		}
 
 # checks for new __setup's
@@ -1368,21 +1371,21 @@ sub process {
 			my $name = $1;
 
 			if (!grep(/$name/, @setup_docs)) {
-				CHK("__setup appears un-documented -- check Documentation/kernel-parameters.txt\n" . $herecurr);
+				CHK("__setup appears un-documented -- check Documentation/kernel-parameters.txt\n", $herecurr);
 			}
 		}
 
 # check for pointless casting of kmalloc return
 		if ($line =~ /\*\s*\)\s*k[czm]alloc\b/) {
-			WARN("unnecessary cast may hide bugs, see http://c-faq.com/malloc/mallocnocast.html\n" . $herecurr);
+			WARN("unnecessary cast may hide bugs, see http://c-faq.com/malloc/mallocnocast.html\n", $herecurr);
 		}
 	}
 
 	if ($chk_patch && !$is_patch) {
-		ERROR("Does not appear to be a unified-diff format patch\n");
+		ERROR("Does not appear to be a unified-diff format patch\n", "");
 	}
 	if ($is_patch && $chk_signoff && $signoff == 0) {
-		ERROR("Missing Signed-off-by: line(s)\n");
+		ERROR("Missing Signed-off-by: line(s)\n", "");
 	}
 
 	if ($clean == 0 && ($chk_patch || $is_patch)) {
