Return-Path: <linux-kernel-owner+w=401wt.eu-S1764567AbYFHLUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764567AbYFHLUj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 07:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762111AbYFHLUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 07:20:16 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:43264 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761308AbYFHLUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 07:20:14 -0400
Date: Sun, 8 Jun 2008 13:20:56 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] Speed up "make headers_*"
Message-ID: <20080608112056.GD10545@uranus.ravnborg.org>
References: <20080608094730.GA30098@uranus.ravnborg.org> <19f34abd0806080312j2b09179cpa384a0460af5874e@mail.gmail.com> <20080608104122.GA10545@uranus.ravnborg.org> <19f34abd0806080406u4e983421r2fe5c266371fcd43@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0806080406u4e983421r2fe5c266371fcd43@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2008 at 01:06:43PM +0200, Vegard Nossum wrote:
> On Sun, Jun 8, 2008 at 12:41 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> > headers_install.pl looks like this now.
> > I am not happy about the way I call unifdef - can it be
> > done better?
> > No error handling and I like to avid the extra tmp file.
> >
> >        Sam
> >
> > #!/usr/bin/perl
> > #
> > # headers_install prepare the listed header files for use in
> > # user space and copy the files to their destination.
> > #
> > # Usage: headers_install.pl odir installdir [files...]
> > # odir:    dir to open files
> > # install: dir to install the files
> > # files:   list of files to check
> > #
> > # Step in preparation for users space:
> > # 1) Drop all use of compiler.h definitions
> > # 2) Drop include of compiler.h
> > # 3) Drop all sections defined out by __KERNEL__
> >
> > use strict;
> > use warnings;
> >
> > my ($odir, $installdir, @files) = @ARGV;
> >
> > my $ret = 0;
> >
> > foreach my $file (@files) {
> >        open(my $infile, '<', "$odir/$file") or die "$odir/$file: $!\n";
> >        open(my $outfile, '>', "$installdir/$file.tmp") or
> >                die "$installdir/$file.tmp: $!\n";
> >        while (my $line = <$infile>) {
> >                $line =~ s/([\s(])__user\s/$1/g;
> >                $line =~ s/([\s(])__force\s/$1/g;
> >                $line =~ s/([\s(])__iomem\s/$1/g;
> >                $line =~ s/\s__attribute_const__\s/ /g;
> >                $line =~ s/\s__attribute_const__$//g;
> >                $line =~ s/^#include <linux\/compiler.h>//;
> >                printf $outfile "%s", $line;
> >        }
> >        close($outfile);
> >        close($outfile);
> 
> Btw, this should probably be $infile if you decide to keep this version.

Ups - thanks.

> 
> >        system "scripts/unifdef -U__KERNEL__ $installdir/$file.tmp > $installdir/$file"
> > }
> 
> Yeah, it should be possible, but I fear that it involves the use of a
> bidirectional pipe. You want to pipe some data into the program and
> some data out of it. See perldoc perlipc ("Bidirectional Communication
> with Another Process").
> 
> In short, I think you'd need this:
> 
> use FileHandle;
> use IPC::Open2;
> 
> my($unifdef_in, $unifdef_out);
> open2($unifdef_in, $unifdef_out, 'scripts/unifdef', '-U__KERNEL__') ...;
> 
> open(my $infile, '<', "$odir/$ofile") || die ...;
> while (my $line = <$infile>) {
>     print $unifdef_in $line;
> }
> close $infile;
> close $unifdef_in; # Send EOF to unifdef, so that it sends EOF to us.
> 
> open(my $outfile ...;
> while (my $line = <$unifdef_out>) {
>     print $outfile $line;
> }
> close $outfile;
> close $unifdef_out;
> 
> But as you see this is rather lengthy. I also don't know if it's
> correct (IOW, completely untested), so you may have to fiddle a bit to
> get it working.

I hope someone will cook up the limted unifdef functionality in perl,
then we do not have to care - hint ;-)

Otherwise I will play with your suggestion.

Thanks,
	Sam
