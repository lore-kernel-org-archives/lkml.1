Return-Path: <linux-kernel-owner+w=401wt.eu-S1763291AbYFHLGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763291AbYFHLGx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 07:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757814AbYFHLGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 07:06:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:47035 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757542AbYFHLGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 07:06:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sCHoqJJ7Lt5/Fqvgw6FEHVyKIKygOrbpLChxwpAOL4BjHEbLIyfPdvH+Cy1UBsr4o+
         Q09HitOC6SmPRrFZaMSiDDxp7v8iK9VSm96HbolnNewJJxLhIjgUKQLtWavQwYixzN6R
         k2XaaKGkEpegliYVAJQ5ZKa9A9YZvoY3B5/5c=
Message-ID: <19f34abd0806080406u4e983421r2fe5c266371fcd43@mail.gmail.com>
Date: Sun, 8 Jun 2008 13:06:43 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH] Speed up "make headers_*"
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jan Engelhardt" <jengelh@computergmbh.de>
In-Reply-To: <20080608104122.GA10545@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080608094730.GA30098@uranus.ravnborg.org>
	 <19f34abd0806080312j2b09179cpa384a0460af5874e@mail.gmail.com>
	 <20080608104122.GA10545@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 8, 2008 at 12:41 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> headers_install.pl looks like this now.
> I am not happy about the way I call unifdef - can it be
> done better?
> No error handling and I like to avid the extra tmp file.
>
>        Sam
>
> #!/usr/bin/perl
> #
> # headers_install prepare the listed header files for use in
> # user space and copy the files to their destination.
> #
> # Usage: headers_install.pl odir installdir [files...]
> # odir:    dir to open files
> # install: dir to install the files
> # files:   list of files to check
> #
> # Step in preparation for users space:
> # 1) Drop all use of compiler.h definitions
> # 2) Drop include of compiler.h
> # 3) Drop all sections defined out by __KERNEL__
>
> use strict;
> use warnings;
>
> my ($odir, $installdir, @files) = @ARGV;
>
> my $ret = 0;
>
> foreach my $file (@files) {
>        open(my $infile, '<', "$odir/$file") or die "$odir/$file: $!\n";
>        open(my $outfile, '>', "$installdir/$file.tmp") or
>                die "$installdir/$file.tmp: $!\n";
>        while (my $line = <$infile>) {
>                $line =~ s/([\s(])__user\s/$1/g;
>                $line =~ s/([\s(])__force\s/$1/g;
>                $line =~ s/([\s(])__iomem\s/$1/g;
>                $line =~ s/\s__attribute_const__\s/ /g;
>                $line =~ s/\s__attribute_const__$//g;
>                $line =~ s/^#include <linux\/compiler.h>//;
>                printf $outfile "%s", $line;
>        }
>        close($outfile);
>        close($outfile);

Btw, this should probably be $infile if you decide to keep this version.

>        system "scripts/unifdef -U__KERNEL__ $installdir/$file.tmp > $installdir/$file"
> }

Yeah, it should be possible, but I fear that it involves the use of a
bidirectional pipe. You want to pipe some data into the program and
some data out of it. See perldoc perlipc ("Bidirectional Communication
with Another Process").

In short, I think you'd need this:

use FileHandle;
use IPC::Open2;

my($unifdef_in, $unifdef_out);
open2($unifdef_in, $unifdef_out, 'scripts/unifdef', '-U__KERNEL__') ...;

open(my $infile, '<', "$odir/$ofile") || die ...;
while (my $line = <$infile>) {
    print $unifdef_in $line;
}
close $infile;
close $unifdef_in; # Send EOF to unifdef, so that it sends EOF to us.

open(my $outfile ...;
while (my $line = <$unifdef_out>) {
    print $outfile $line;
}
close $outfile;
close $unifdef_out;

But as you see this is rather lengthy. I also don't know if it's
correct (IOW, completely untested), so you may have to fiddle a bit to
get it working.

Good luck.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
