Return-Path: <linux-kernel-owner+w=401wt.eu-S934079AbXHGQKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934079AbXHGQKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 12:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755160AbXHGQKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 12:10:41 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1318 "EHLO Perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbXHGQKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 12:10:40 -0400
Subject: Re: + remove-current-defines-and-uses-of-pr_err-add-pr_emerg.patch
	added to -mm tree
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: jengelh@computergmbh.de, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mm-commits@vger.kernel.org, adaplas@pol.net,
       greg@kroah.com, jeff@garzik.org
In-Reply-To: <0H03p0ll.1186246070.5043630.khali@localhost>
References: <0H03p0ll.1186246070.5043630.khali@localhost>
Content-Type: text/plain
Date: Tue, 07 Aug 2007 09:10:16 -0700
Message-Id: <1186503016.5983.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-08-04 at 18:47 +0200, Jean Delvare wrote:
> On 8/4/2007, "Jan Engelhardt" <jengelh@computergmbh.de> wrote: 
> >Ugh. What do we have printk for then? I do not like this.
> >For pr_debug() it makes sense because its semantics change with
> >-DDEBUG and -UDEBUG, but for these pr_()s it does not seem so.
> I think I agree with Jan here, I see no fundamental need for these
> additional macros. But if they are really added, then they should follow
> the same standard as pr_debug() and pr_info(), that is: no "\n" added
> automatically. Otherwise this will become quite messy.

2 reasons:

This change will eventually isolate multiple line
printk messages and allow easier insertion of 

printk_block_start
printks
printk_block_end

so that multiple line messages are kept together
in the message logs.

and I've done tree-wide patches for single line

printk(KERN_\(emerg|alert|notice|crit\),

(about 2000) and fixed several dozen lines without \n
or things like "KERN_<level> /n msg"

Here's the perl script I used.

It's imperfect of course.  There are comments with
embedded semicolons where it fails, and #defines
aren't substituted too well.

if ($#ARGV < 2) {
    print "usage: KERN_<level> pr_<level> files...\n";
    exit;
}

for ($i=2; $i <= $#ARGV; $i++) {
    PrintkSearchReplace($ARGV[$i], $ARGV[0], $ARGV[1]);
}

sub PrintkSearchReplace{
    my($file, $search, $replace) = @_;

    my $orig = "";
    local($/);
    open(my $fh, $file) or die "File not found '$file'\n";
    $orig = <$fh>;
    close(my $fh);

    my $parts = $orig;
    my $whole = "";
    @segments = split(/\;/, $parts);
    foreach $line (@segments) {

	if ($whole ne "") {
	    $whole = $whole . "\;";
	}

	my $origline = $line;

	if ($line =~ m/\bprintk\s*\(\s*${search}\s*.*\".*\\n\s*\"/ms) {
	    
	    $line =~ s/\bprintk\s*\(\s*${search}\s*([^\"]*)\"/${replace}\(\1\"/ms;
	    $line =~ s/\\n\s*\"\s*/\"/ms;

	    print "${file}: changed:\n" . $origline . "\;" . "\nto:\n" . $line . "\;" . "\n" ;

	}
	$whole = $whole . $line;
    }

    if ($orig ne $whole) {
	open(my $fh, ">${file}") or die "Could not open '$file'\n";
	print $fh $whole;
	close(my $fh);
    }

}


