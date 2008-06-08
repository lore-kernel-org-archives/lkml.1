Return-Path: <linux-kernel-owner+w=401wt.eu-S1757475AbYFHVOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbYFHVOu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 17:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755357AbYFHVOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 17:14:43 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:37707 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755247AbYFHVOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 17:14:42 -0400
Date: Sun, 8 Jun 2008 23:15:24 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 6/6] kbuild: optimize headers_* targets
Message-ID: <20080608211524.GB32741@uranus.ravnborg.org>
References: <20080608094730.GA30098@uranus.ravnborg.org> <1212955658-32168-6-git-send-email-sam@ravnborg.org> <19f34abd0806081337n2024f33fof890f63b4e136b83@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0806081337n2024f33fof890f63b4e136b83@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2008 at 10:37:41PM +0200, Vegard Nossum wrote:
> Hi Sam,
> 
> Just one more comment from me :-)
> 
> On Sun, Jun 8, 2008 at 10:07 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> > diff --git a/scripts/headers_install.pl b/scripts/headers_install.pl
> > new file mode 100644
> > index 0000000..283c055
> > --- /dev/null
> > +++ b/scripts/headers_install.pl
> > @@ -0,0 +1,43 @@
> > +#!/usr/bin/perl
> > +#
> > +# headers_install prepare the listed header files for use in
> > +# user space and copy the files to their destination.
> > +#
> > +# Usage: headers_install.pl odir installdir [files...]
> > +# odir:    dir to open files
> > +# install: dir to install the files
> > +# files:   list of files to check
> > +#
> > +# Step in preparation for users space:
> > +# 1) Drop all use of compiler.h definitions
> > +# 2) Drop include of compiler.h
> > +# 3) Drop all sections defined out by __KERNEL__ (using unifdef)
> > +
> > +use strict;
> > +use warnings;
> > +
> > +my ($odir, $installdir, @files) = @ARGV;
> > +
> > +my $ret = 0;
> > +my $unifdef = "scripts/unifdef -U__KERNEL__";
> > +
> > +foreach my $file (@files) {
> > +       my $tmpfile = "$installdir/$file.tmp";
> > +       open(my $infile, '<', "$odir/$file") or die "$odir/$file: $!\n";
> > +       open(my $outfile, '>', "$tmpfile") or die "$tmpfile: $!\n";
> > +       while (my $line = <$infile>) {
> > +               $line =~ s/([\s(])__user\s/$1/g;
> > +               $line =~ s/([\s(])__force\s/$1/g;
> > +               $line =~ s/([\s(])__iomem\s/$1/g;
> > +               $line =~ s/\s__attribute_const__\s/ /g;
> > +               $line =~ s/\s__attribute_const__$//g;
> > +               $line =~ s/^#include <linux\/compiler.h>//;
> > +               printf $outfile "%s", $line;
> > +       }
> > +       close $outfile;
> > +       close $infile;
> > +       $ret = system $unifdef . " $tmpfile > $installdir/$file";
> 
> This seems flawed as we'll always exit with the $ret of the last file.
> Do you intend to abort on the first error, or go as far as possible?
> 
> Maybe you can use something like this:
> 
> system ... or warn "$file: $!\n"
> $ret = $? unless $ret;
> 
> (This should preserve the $ret from the first process that fails with
> a non-zero exit code.)
> 
> > +       unlink $tmpfile;
> > +}
> > +
> > +exit $ret;
> 
> What do you think?
[Not much - late here....]

Thanks - I will try to fix it somehow.
But I hope that someone with more perl fu than me will redo
the unifdef stuff so I do not have to worry...

	Sam
