Return-Path: <linux-kernel-owner+w=401wt.eu-S1761046AbYFHKMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761046AbYFHKMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 06:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756171AbYFHKMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 06:12:37 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:19831 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779AbYFHKMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 06:12:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sSsWi7p7Dipxi5+Be5156r2PBEVJ9r8D4J1ptXUMN9GF/NwGaWa44Gchrs/kFnzQUo
         /WqBdlPSl40ELpeRbMSNVnF/SWBHpw0RJXTNPHev0STTFMtSsjsy0MsmXhviAh9PuYCH
         CtLImWD1GbMsOhVSC3LYzgOocjfSjomLKUOhc=
Message-ID: <19f34abd0806080312j2b09179cpa384a0460af5874e@mail.gmail.com>
Date: Sun, 8 Jun 2008 12:12:35 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH] Speed up "make headers_*"
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jan Engelhardt" <jengelh@computergmbh.de>
In-Reply-To: <20080608094730.GA30098@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080608094730.GA30098@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 8, 2008 at 11:47 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> This is just a heads up patch if anyone is interested.
> I finally took the time needed to optimize the
> make headers_* targets.
>
> On my box it now takes less than 10 seconds to run
> the full install + check cycle.
> And it generates roughtly one screen full of output.
>
> Compare that to ~31 seconds and output filling up
> my scroll back buffer.

Nice :-)

> Comments (especially to the perl scripts) are welcome.

Will do! Some of my comments are a bit on the pedantic side, so you
choose yourself which ones you want to heed!

> diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
> new file mode 100644
> index 0000000..dfb2ec7
> --- /dev/null
> +++ b/scripts/headers_check.pl
> @@ -0,0 +1,48 @@
> +#!/usr/bin/perl
> +#
> +# headers_check.pl execute a number of trivial consistency checks
> +#
> +# Usage: headers_check.pl dir [files...]
> +# dir..:  dir to look for included files
> +# files:  list of files to check
> +#
> +# The script reads the supplied files line by line and:
> +#
> +# 1) for each include statement it checks if the
> +#    included file actually exists.
> +#    Only include files located in asm* and linux* are checked.
> +#    The rest are assumed to be system include files.
> +#
> +# 2) TODO

'use strict' and 'use warnings' is recommended. You have "my" on the
variables anyway (which is a good thing!).

> +
> +my ($dir, @files) = @ARGV;
> +
> +my $ret = 0;
> +my $lineno = 0;
> +my $filename;
> +
> +foreach $file (@files) {
> +       $filename = $file;
> +       open(FILE, "< $filename") or die "$filename: $!\n";

I personally prefer to put '<', $filename here instead of mashing them
together as one string. I don't know if it really matters.

If you want to compile with strict/warnings here, you should replace
FILE with "my $fh" here

> +       $lineno = 0;
> +       while ($line = <FILE>) {

...and use <$fh> here.

> +               $lineno++;
> +               &check_include();

The & should be gone (see perldoc -q 'calling a function')

> +       }
> +       close(FILE);
> +}
> +exit($ret);

The parentheses are not needed for most of the built-in functions.

> +
> +my $includere = qr/^\s*#\s*include\s+<(.*)>/;

What seems to be the purpose of this, also what's up with the funny name? :-D

> +sub check_include()

The parentheses should be gone. This has something to do with
prototypes and should normally not be used.

> +{
> +       if ($line =~ m/^\s*#\s*include\s+<(.*)>/) {
> +               my $inc = $1;

This could also be written as if (my($inc) = $line =~ ...), and you
bypass the use of $1, which is often error-prone... but it's correct
in this case and is simply a matter of taste.

> +               if ($inc =~ m/^asm/ || $inc =~ m/^linux/) {
> +                       if (!(stat($dir . "/" . $inc))) {

May use unless() instead of if(!()) here. But that's just perl pedantry.

> +                               printf STDERR "$filename:$lineno: included file '$inc' is not exported\n";
> +                               $ret = 1;
> +                       }
> +               }
> +       }
> +}

More or less the same comments would apply to the next script as well.

> diff --git a/scripts/headers_install.pl b/scripts/headers_install.pl
> new file mode 100644
> index 0000000..8aa66af
> --- /dev/null
> +++ b/scripts/headers_install.pl
...
> +               $line =~ s/([\s(])__user\s/\1/g;
...

Use of $1 instead of \1 is recommended, see perldoc perlre ("Warning
on \1 vs $1").


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
