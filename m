Return-Path: <linux-kernel-owner+w=401wt.eu-S1764079AbYFHLSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764079AbYFHLSA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 07:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758374AbYFHLRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 07:17:52 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:41879 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757818AbYFHLRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 07:17:51 -0400
Date: Sun, 8 Jun 2008 13:18:33 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] Speed up "make headers_*"
Message-ID: <20080608111833.GC10545@uranus.ravnborg.org>
References: <20080608094730.GA30098@uranus.ravnborg.org> <19f34abd0806080312j2b09179cpa384a0460af5874e@mail.gmail.com> <20080608104122.GA10545@uranus.ravnborg.org> <20080608110151.GB2487@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080608110151.GB2487@hacking>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi WANG.

> >No error handling and I like to avid the extra tmp file.
> 
> 
> I think you can open a pipe in Perl, e.g. open FILE, "|scripts/unifdef";.
> 
> 
> >
> >	Sam
> >
> >#!/usr/bin/perl
> >#
> ># headers_install prepare the listed header files for use in
> ># user space and copy the files to their destination.
> >#
> ># Usage: headers_install.pl odir installdir [files...]
> ># odir:    dir to open files
> ># install: dir to install the files
> ># files:   list of files to check
> >#
> ># Step in preparation for users space:
> ># 1) Drop all use of compiler.h definitions
> ># 2) Drop include of compiler.h
> ># 3) Drop all sections defined out by __KERNEL__
> >
> >use strict;
> >use warnings;
> >
> >my ($odir, $installdir, @files) = @ARGV;
> >
> >my $ret = 0;
> 
> 
> This is only used by last exit, thus can be removed.
> 
> >
> >foreach my $file (@files) {
> >	open(my $infile, '<', "$odir/$file") or die "$odir/$file: $!\n";
> >	open(my $outfile, '>', "$installdir/$file.tmp") or
> >		die "$installdir/$file.tmp: $!\n";
> >	while (my $line = <$infile>) {
> >		$line =~ s/([\s(])__user\s/$1/g;
> >		$line =~ s/([\s(])__force\s/$1/g;
> >		$line =~ s/([\s(])__iomem\s/$1/g;
> >		$line =~ s/\s__attribute_const__\s/ /g;
> >		$line =~ s/\s__attribute_const__$//g;
> >		$line =~ s/^#include <linux\/compiler.h>//;
> >		printf $outfile "%s", $line;
> >	}
> >	close($outfile);
> >	close($outfile);
> 
> 
> 'close' doesn't need parenthesises neither.
> 
> >	system "scripts/unifdef -U__KERNEL__ $installdir/$file.tmp > $installdir/$file"
> 
> 
> Will scripts/unifdef clean the tmp file? If not, you should do it, right?

Will fix - it was left as I hope to fix the unifdef thing
and then it may error out too.

	Sam
