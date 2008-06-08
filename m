Return-Path: <linux-kernel-owner+w=401wt.eu-S1762891AbYFHLFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762891AbYFHLFd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 07:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757818AbYFHLFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 07:05:25 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:8364 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757746AbYFHLFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 07:05:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CKYdsZ5ysr6IchRvBnz9qeb6vmTCGTKrasQRT6qOU0upDeg9Bg/67dc7BwwUG7Opyw
         cOgJcrIeyv0rOgN9XKKhXElp4Xp28J8yTiIeULXtouKSvDZZA97TEffZSW2ZeQtsMSyL
         Q5DJrx5ibSeQEpBNth+cdFT0BlJRTCmsDGSJ4=
Date: Sun, 8 Jun 2008 19:01:51 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] Speed up "make headers_*"
Message-ID: <20080608110151.GB2487@hacking>
References: <20080608094730.GA30098@uranus.ravnborg.org> <19f34abd0806080312j2b09179cpa384a0460af5874e@mail.gmail.com> <20080608104122.GA10545@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080608104122.GA10545@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2008 at 12:41:22PM +0200, Sam Ravnborg wrote:
>On Sun, Jun 08, 2008 at 12:12:35PM +0200, Vegard Nossum wrote:
>> On Sun, Jun 8, 2008 at 11:47 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
>> > This is just a heads up patch if anyone is interested.
>> > I finally took the time needed to optimize the
>> > make headers_* targets.
>> >
>> > On my box it now takes less than 10 seconds to run
>> > the full install + check cycle.
>> > And it generates roughtly one screen full of output.
>> >
>> > Compare that to ~31 seconds and output filling up
>> > my scroll back buffer.
>> 
>> Nice :-)
>> 
>> > Comments (especially to the perl scripts) are welcome.
>> 
>> Will do! Some of my comments are a bit on the pedantic side, so you
>> choose yourself which ones you want to heed!
>
>Thnaks!
>
>headers_install.pl looks like this now.
>I am not happy about the way I call unifdef - can it be
>done better?
>No error handling and I like to avid the extra tmp file.


I think you can open a pipe in Perl, e.g. open FILE, "|scripts/unifdef";.


>
>	Sam
>
>#!/usr/bin/perl
>#
># headers_install prepare the listed header files for use in
># user space and copy the files to their destination.
>#
># Usage: headers_install.pl odir installdir [files...]
># odir:    dir to open files
># install: dir to install the files
># files:   list of files to check
>#
># Step in preparation for users space:
># 1) Drop all use of compiler.h definitions
># 2) Drop include of compiler.h
># 3) Drop all sections defined out by __KERNEL__
>
>use strict;
>use warnings;
>
>my ($odir, $installdir, @files) = @ARGV;
>
>my $ret = 0;


This is only used by last exit, thus can be removed.

>
>foreach my $file (@files) {
>	open(my $infile, '<', "$odir/$file") or die "$odir/$file: $!\n";
>	open(my $outfile, '>', "$installdir/$file.tmp") or
>		die "$installdir/$file.tmp: $!\n";
>	while (my $line = <$infile>) {
>		$line =~ s/([\s(])__user\s/$1/g;
>		$line =~ s/([\s(])__force\s/$1/g;
>		$line =~ s/([\s(])__iomem\s/$1/g;
>		$line =~ s/\s__attribute_const__\s/ /g;
>		$line =~ s/\s__attribute_const__$//g;
>		$line =~ s/^#include <linux\/compiler.h>//;
>		printf $outfile "%s", $line;
>	}
>	close($outfile);
>	close($outfile);


'close' doesn't need parenthesises neither.

>	system "scripts/unifdef -U__KERNEL__ $installdir/$file.tmp > $installdir/$file"


Will scripts/unifdef clean the tmp file? If not, you should do it, right?


>}
>
>exit $ret;
>


-- 
Hi, I'm a .signature virus, please copy/paste me to help me spread
all over the world.
