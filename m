Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbYKZIS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbYKZIS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:18:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbYKZISs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:18:48 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:57277 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbYKZISr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:18:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Ar5aaDYcWeWibjDbaAn9IMAdbMB2IkaNIBXqgO7+ykZd7LADESyD7mDbZNe9g69Wfs
         dufK3P2W+sVOkOlCT05W81L8VCjlpshVhIxtbZm0XagkulvDshe9lOdWZC65sjffXLxL
         R1hRyNgT8yBDWd9Zldgig5ayoP3qNmXkQcTR0=
Message-ID: <19f34abd0811260018l6886ee07m7d39cb84a7138929@mail.gmail.com>
Date: Wed, 26 Nov 2008 09:18:46 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH] scripts: script from kerneloops.org to pretty print oops dumps
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Sam Ravnborg" <sam@ravnborg.org>
In-Reply-To: <20081123130042.1d194768@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081123130042.1d194768@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2008 at 10:00 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> From 57b0deb1ad706a94e3118baee4127676f465c4ab Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Wed, 5 Nov 2008 19:00:36 -0800
> Subject: [PATCH] scripts: script from kerneloops.org to pretty print oops dumps
>
> We're strugling all the time to figure out where the code came from
> that oopsed.. The script below (a adaption from a script used by kerneloops.org)
> can help developers quite a bit, at least for non-module cases.

Hi,

Just small style nitpicks below :-) (You pick which ones to heed.)


> ---
>  scripts/markup_oops.pl |  162 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 162 insertions(+), 0 deletions(-)
>  create mode 100644 scripts/markup_oops.pl
>
> diff --git a/scripts/markup_oops.pl b/scripts/markup_oops.pl
> new file mode 100644
> index 0000000..700a7a6
> --- /dev/null
> +++ b/scripts/markup_oops.pl
> @@ -0,0 +1,162 @@
> +#!/usr/bin/perl -w
> +
> +# Copyright 2008, Intel Corporation
> +#
> +# This file is part of the Linux kernel
> +#
> +# This program file is free software; you can redistribute it and/or modify it
> +# under the terms of the GNU General Public License as published by the
> +# Free Software Foundation; version 2 of the License.
> +#
> +# Authors:
> +#      Arjan van de Ven <arjan@linux.intel.com>

use strict;
use warnings;

:-)

> +
> +
> +my $vmlinux_name = $ARGV[0];

I think the idiomatic way would be:

my $vmlinux_name = shift || 'vmlinux';

> +
> +#
> +# Step 1: Parse the oops to find the EIP value
> +#
> +
> +my $target = "0";
> +while (<STDIN>) {
> +       if ($_ =~ /EIP: 0060:\[\<([a-z0-9]+)\>\]/) {

if (m/EIP:.../) {

is more elegant :-)

> +               $target = $1;
> +       }
> +}
> +
> +if ($target =~ /^f8/) {
> +       print "This script does not work on modules ... \n";
> +       exit;
> +}
> +
> +if ($target eq "0") {
> +       print "No oops found!\n";
> +       print "Usage: \n";
> +       print "    dmesg | perl scripts/markup_oops.pl vmlinux\n";
> +       exit;
> +}
> +
> +my $counter = 0;
> +my $state   = 0;
> +my $center  = 0;
> +my @lines;
> +
> +sub InRange {
> +       my ($address, $target) = @_;
> +       my $ad = "0x".$address;
> +       my $ta = "0x".$target;
> +       my $delta = hex($ad) - hex($ta);
> +
> +       if (($delta > -4096) && ($delta < 4096)) {
> +               return 1;
> +       }
> +       return 0;

or just return ($delta > -4096) && ($delta < 4096);

> +}
> +
> +
> +
> +# first, parse the input into the lines array, but to keep size down,
> +# we only do this for 4Kb around the sweet spot
> +
> +my $filename;
> +
> +open(FILE, "objdump -dS $vmlinux_name |") || die "Cannot start objdump";

use open(my $fd, ...); for running with strict, and replace FILE with
$fd everywhere else

> +
> +while (<FILE>) {
> +       my $line = $_;

Then you might as well do:

for my $line (<FILE>) {

> +       chomp($line);
> +       if ($state == 0) {
> +               if ($line =~ /^([a-f0-9]+)\:/) {
> +                       if (InRange($1, $target)) {
> +                               $state = 1;
> +                       }
> +               }
> +       } else {
> +               if ($line =~ /^([a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9]+)\:/) {
> +                       my $val = $1;
> +                       if (!InRange($val, $target)) {
> +                               last;
> +                       }

last unless InRange($val, $target);

> +                       if ($val eq $target) {
> +                               $center = $counter;
> +                       }

$center = $counter if $val eq $target;

> +               }
> +               $lines[$counter] = $line;
> +
> +               $counter = $counter + 1;
> +       }
> +}
> +
> +close(FILE);
> +
> +if ($counter == 0) {
> +       print "No matching code found \n";

Trailing space?

> +       exit;
> +}
> +
> +if ($center == 0) {
> +       print "No matching code found \n";

Also here.

> +       exit;
> +}
> +
> +my $start;
> +my $finish;
> +my $codelines = 0;
> +my $binarylines = 0;
> +# now we go up and down in the array to find how much we want to print
> +
> +$start = $center;
> +
> +while ($start > 1) {
> +       $start = $start - 1;
> +       my $line = $lines[$start];
> +       if ($line =~ /^([a-f0-9]+)\:/) {
> +               $binarylines = $binarylines + 1;
> +       } else {
> +               $codelines = $codelines + 1;
> +       }
> +       if ($codelines > 10) {
> +               last;
> +       }
> +       if ($binarylines > 20) {
> +               last;
> +       }

last if $codelines > 10 || $binarylines > 20;

> +}
> +
> +
> +$finish = $center;
> +$codelines = 0;
> +$binarylines = 0;
> +while ($finish < $counter) {
> +       $finish = $finish + 1;
> +       my $line = $lines[$finish];
> +       if ($line =~ /^([a-f0-9]+)\:/) {
> +               $binarylines = $binarylines + 1;
> +       } else {
> +               $codelines = $codelines + 1;
> +       }
> +       if ($codelines > 10) {
> +               last;
> +       }
> +       if ($binarylines > 20) {
> +               last;
> +       }

last if $codelines > 10 || $binarylines > 20;

> +}
> +
> +
> +my $i;
> +
> +my $fulltext = "";
> +$i = $start;
> +while ($i < $finish) {
> +       if ($i == $center) {
> +               $fulltext = $fulltext . "*$lines[$i]     <----- faulting instruction\n";
> +       } else {
> +               $fulltext = $fulltext .  " $lines[$i]\n";
> +       }
> +       $i = $i +1;
> +}
> +
> +print $fulltext;
> +
> --


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
