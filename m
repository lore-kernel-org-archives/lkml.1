Return-Path: <linux-kernel-owner+w=401wt.eu-S1757762AbXE2JBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762AbXE2JBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 05:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbXE2JB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 05:01:29 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2080 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbXE2JB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 05:01:28 -0400
Message-ID: <465BEBE5.5070008@shadowen.org>
Date: Tue, 29 May 2007 10:01:25 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add a trivial patch style checker
References: <9a1288909c10f2935af82ec5cea0c46b@pinky> <Pine.LNX.4.61.0705281123000.11140@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705281123000.11140@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On May 27 2007 18:11, Andy Whitcroft wrote:
>> +
>> +my $P = $0;
>> +
>> +my $V = '0.01';
>> +
>> +use Getopt::Long qw(:config no_auto_abbrev);
>> [...]
>> +sub top_of_kernel_tree {
>> +	if ((-f "COPYING") && (-f "CREDITS") && (-f "Kbuild") &&
>> +	    (-f "MAINTAINERS") && (-f "Makefile") && (-f "README") &&
>> +	    (-d "Documentation") && (-d "arch") && (-d "include") &&
>> +	    (-d "drivers") && (-d "fs") && (-d "init") && (-d "ipc") &&
>> +	    (-d "kernel") && (-d "lib") && (-d "scripts")) {
>> +		return 1;
>> +	}
>> +	return 0;
>> +}
>> [...]
> 
> The consistent style quite looses after this point, esp. space around
> operators ;-)

Yep thats on my list for cleanup ...

>> +sub process {
>> +	my $filename = shift;
>> +	my @lines = @_;
>> +
>> +	my $linenr=0;
>> +	my $prevline="";
>> +	my $stashline="";
>> +
>> +	my $lineforcounting='';
>> +	my $indent;
>> +	my $previndent=0;
>> +	my $stashindent=0;
>> +
>> +	my $clean = 1;
>> +	my $signoff = 0;
>> +
>> +	# Trace the real file/line as we go.
>> +	my $realfile = '';
>> +	my $realline = 0;
>> +	my $realcnt = 0;
>> +	my $here = '';
>> +	my $in_comment = 0;
>> +	my $first_line = 0;
> 
> Like in the kernel/C (as far as .bss is concerned), they usually do not
> need initialization. (They will be different from 0 though, namely
> undef, but doing ++$x where x is undefined will also DTRT.)

Well I tend to prefer initialisers as they are the only up front hint as
to the notional type of the thing.

>> +
>> +	foreach my $line (@lines) {
>> +		$linenr++;
>> +
>> +#extract the filename as it passes
>> +		if($line=~/^\+\+\+\s+(\S+)/) {
> 
> /^\+{3}\s+(\S+)/  "there's always more than one way to do it in Perl" - meh
> 
>> +			$realfile=$1;
>> +			$in_comment = 0;
>> +			next;
>> +		}
>> +#extract the line range in the file after the patch is applied
>> +		if($line=~/^@@ -\d+,\d+ \+(\d+)(,(\d+))? @@/) {
> 
> The @ should be escaped afaicr
> /^\@\@\s+-\d+,\d+\s+\+(\d+)(,(\d+))? \@\@/

The @'s need quoting yes.  The spaces are officially spaces though.

>> +			$first_line = 1;
>> +			$in_comment = 0;
>> +			$realline=$1-1;
>> +			if (defined $2) {
>> +				$realcnt=$3+1;
>> +			} else {
>> +				$realcnt=1+1;
>> +			}
>> +			next;
>> +		}
>> +#check the patch for a signoff:
>> +		if ($line =~ /^[[:space:]]*Signed-off-by:/i) {
> 
> [[:space:]] = \s
> Perhaps require a \s after : and get rid of /i? ;-)

Yeah, split this into a couple of checks implementing the recommended
capitalisation and checking for a space after the : etc.

>> +			$signoff++;
>> +		}
>> +#track the line number as we move through the hunk
>> +		if($line=~/^( |\+)/) {
> 
> Or ... /^([ \+])/  (mostly depends on taste)

We generally use [] so switched to that.

>> +			$realline++;
>> +			$realcnt-- if ($realcnt);
> 
> That's a bit ambiguous at first, since it usually means (I think)
> if(defined($realcnt) || $realcnt != 0).
> Using if ($realcnt == 0) could help.

if ($realcnt != 0); but yes

>> +
>> +			# track any sort of multi-line comment.  Obviously if
>> +			# the added text or context do not include the whole
>> +			# comment we will not see it. Such is life.
>> +			#
>> +			# Guestimate if this is a continuing comment.  If this
>> +			# is the start of a diff block and this line starts
>> +			# ' *' then it is very likely a comment.
>> +			if ($first_line and $line =~ m@^.\s*\*@) {
>> +				$in_comment = 1;
>> +			}
> 
> m@@ and and needed? Could be just
> 	if ($first_line == 0 && $line =~ /^.\s*\*/)
> 

This one is being consistent with the ones around it.

>> +			if ($line =~ m@/\*@) {
>> +				$in_comment = 1;
>> +			}
>> +			if ($line =~ m@\*/@) {
>> +				$in_comment = 0;
>> +			}
> 
> Although not necessary here, I'd like to point out that I've had
> more luck using paired characters as boundaries, i.e. m{} or s{}{},
> which means less escaping for the inner regex in some cases.

Some consistancy would help for sure.  Will try and move to some common
form.

>> +# check we are in a valid source file *.[hc] if not then ignore this hunk
>> +		next if ($realfile !~ /\.[hc]$/);
> 
> Oh I think trailing whitespace and 80 column limit should also be
> applied to .S and .s files.

Seems sane.

>> +
>> +#trailing whitespace
>> +		if($line=~/\S\s+$/) {
>> +			my $herevet = "$here\n" . cat_vet($line) . "\n\n";
>> +			print ("trailing whitespace\n");
>> +			print "$herevet";
>> +			$clean = 0;
>> +		}
>> +#80 column limit
>> +		if(!($prevline=~/\/\*\*/) && length($lineforcounting) > 80){
> 
> Actually, I think this should be "> 79" (after stripping a .diff's
> control column), since the cursor may move to the 81th column when
> editing an 80-col line - which is what we want to avoid, no?

80 tends to work for me because of that "if on 80 then don't wrap until
there is another character" behaviour of most terminals.  Anyone else
with a firm opinion.

>> +			print "line over 80 characters\n";
>> +			print "$herecurr";
>> +			$clean = 0;
>> +		}
>> +
>> +# at the beginning of a line any tabs must come first and anything
>> +# more than 8 must use tabs.
>> +		if($line=~/^\+\s* \t\s*\S/ or $line=~/^\+\s*        \s*/) {
> 
> || will do instead of or.
> Somehow this does not catch "Only spaces" lines (/^ +\S/), because there's
> no \t in them. (Talk about regex fun.)

Well this is designed to pick up spaces before tabs and any sets of
spaces which are long enough to be a tab.  The only thing it would not
pick up as bad is things indented less than 8 which would be possibly
frowned upon but would be correct with spaces.

> I'd say split and simplify:
> 	if ($line =~ /^\s* {8,}/) {
> 		print "Make that big space a \\t\n";
> 	}
> 	if ($line =~ /^ +\t/) {
> 		print "Inadvertent space at line start, or make it \\t\n";
> 	}
> 
>> +			my $herevet = "$here\n" . cat_vet($line) . "\n\n";
>> +			print ("use tabs not spaces\n");
>> +			print "$herevet";
>> +			$clean = 0;
>> +		}
>> +
>> +		#
>> +		# The rest of our checks refer specifically to C style
>> +		# only apply those _outside_ comments.
>> +		#
>> +		next if ($in_comment);
>> +
>> +# no C99 // comments
>> +		if ($line =~ qr|//|) {
>> +			print "do not use C99 // comments\n";
>> +			print "$herecurr";
>> +			$clean = 0;
>> +		}
> 
> (Now we're using qr{}, what about being consistent with m{}?)
> It may break on rare occassions:
> 
> 	printk("Hello // World\n");

Yep, tighened this up to catch this one.

>> +		# Remove comments from the line before processing.
>> +		$line =~ s@/\*.*\*/@@g;
>> +		$line =~ s@/\*.*@@;
>> +		$line =~ s@.*\*/@@;
>> +		$line =~ s@//.*@@;
>> +
>> +#EXPORT_SYMBOL should immediately follow its function closing }.
>> +		if (($line =~ /EXPORT_SYMBOL.*\(.*\)/) ||
>> +		    ($line =~ /EXPORT_UNUSED_SYMBOL.*\(.*\)/)) {
>> +			if (($prevline !~ /^}/) &&
>> +			   ($prevline !~ /^\+}/) &&
>> +			   ($prevline !~ /^ }/)) {
>> +				print "EXPORT_SYMBOL(func); should immediately follow its function\n";
>> +				print "$herecurr";
>> +				$clean = 0;
>> +			}
>> +		}
>> +
>> +		# check for static initialisers.
>> +		if ($line=~/\s*static\s.*=\s+(0|NULL);/) {
>> +			print "do not initialise statics to 0 or NULL\n";
>> +			print "$herecurr";
>> +			$clean = 0;
>> +		}
>> +
>> +		# check for new typedefs.
>> +		if ($line=~/\s*typedef\s/) {
>> +			print "do not add new typedefs\n";
>> +			print "$herecurr";
>> +			$clean = 0;
>> +		}
>> +
>> +# * goes on variable not on type
>> +		if($line=~/[A-Za-z\d_]+\* [A-Za-z\d_]+/) {
>> +			print ("\"foo* bar\" should be \"foo *bar\"\n"); 
> 
> print does not need parentheses in most cases.

Indeed, removed.

>> +			print "$herecurr";
>> +			$clean = 0;
>> +		}
>> +
>> +# no BUG() or BUG_ON()
>> +		if ($line =~ /\b(BUG|BUG_ON)\b/) {
>> +			print "Try to use WARN_ON & Recovery code rather than BUG() or BUG_ON()\n";
>> +			print "$herecurr";
>> +			$clean = 0;
>> +		}
>> +
>> +# printk should use KERN_* levels
>> +		if (($line =~ /\bprintk\b/) &&
>> +		    ($line !~ /KERN_/)) {
>> +			print "printk() should include KERN_ facility level\n";
>> +			print "$herecurr";
>> +			$clean = 0;
>> +		}
> 
> if ($line =~ /\bprintk\((?!KERN_)/)
> 

Yep, nicer, changed.

> Attention span ran out. :)

Thanks for bothering :)  Any review is appreciated.

-apw
