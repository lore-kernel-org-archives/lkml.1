Return-Path: <linux-kernel-owner+w=401wt.eu-S1757383AbYFHUhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbYFHUhv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 16:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754920AbYFHUhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 16:37:43 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:60902 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732AbYFHUhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 16:37:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bd/7dD0w9Je4DlBmp9yx5NfyfZJcTkDAXvckDBE2+UzuCkbQnUDZRaY8XuvK43Fax+
         nuY5tCyU9ck4+NNLvgIWZd4k8/GVbYAV3PlhhKBvgOQxyYd0rhkvrvrLU2RtIj+D0Mdh
         34MarUo/Zu5XQZxEqOymRX5kiWKesiifjjyr8=
Message-ID: <19f34abd0806081337n2024f33fof890f63b4e136b83@mail.gmail.com>
Date: Sun, 8 Jun 2008 22:37:41 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH 6/6] kbuild: optimize headers_* targets
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       "David Woodhouse" <dwmw2@infradead.org>
In-Reply-To: <1212955658-32168-6-git-send-email-sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080608094730.GA30098@uranus.ravnborg.org>
	 <1212955658-32168-6-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

Just one more comment from me :-)

On Sun, Jun 8, 2008 at 10:07 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> diff --git a/scripts/headers_install.pl b/scripts/headers_install.pl
> new file mode 100644
> index 0000000..283c055
> --- /dev/null
> +++ b/scripts/headers_install.pl
> @@ -0,0 +1,43 @@
> +#!/usr/bin/perl
> +#
> +# headers_install prepare the listed header files for use in
> +# user space and copy the files to their destination.
> +#
> +# Usage: headers_install.pl odir installdir [files...]
> +# odir:    dir to open files
> +# install: dir to install the files
> +# files:   list of files to check
> +#
> +# Step in preparation for users space:
> +# 1) Drop all use of compiler.h definitions
> +# 2) Drop include of compiler.h
> +# 3) Drop all sections defined out by __KERNEL__ (using unifdef)
> +
> +use strict;
> +use warnings;
> +
> +my ($odir, $installdir, @files) = @ARGV;
> +
> +my $ret = 0;
> +my $unifdef = "scripts/unifdef -U__KERNEL__";
> +
> +foreach my $file (@files) {
> +       my $tmpfile = "$installdir/$file.tmp";
> +       open(my $infile, '<', "$odir/$file") or die "$odir/$file: $!\n";
> +       open(my $outfile, '>', "$tmpfile") or die "$tmpfile: $!\n";
> +       while (my $line = <$infile>) {
> +               $line =~ s/([\s(])__user\s/$1/g;
> +               $line =~ s/([\s(])__force\s/$1/g;
> +               $line =~ s/([\s(])__iomem\s/$1/g;
> +               $line =~ s/\s__attribute_const__\s/ /g;
> +               $line =~ s/\s__attribute_const__$//g;
> +               $line =~ s/^#include <linux\/compiler.h>//;
> +               printf $outfile "%s", $line;
> +       }
> +       close $outfile;
> +       close $infile;
> +       $ret = system $unifdef . " $tmpfile > $installdir/$file";

This seems flawed as we'll always exit with the $ret of the last file.
Do you intend to abort on the first error, or go as far as possible?

Maybe you can use something like this:

system ... or warn "$file: $!\n"
$ret = $? unless $ret;

(This should preserve the $ret from the first process that fails with
a non-zero exit code.)

> +       unlink $tmpfile;
> +}
> +
> +exit $ret;

What do you think?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
