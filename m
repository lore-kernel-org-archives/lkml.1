Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbZJEWxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbZJEWxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 18:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755571AbZJEWxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 18:53:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55495 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755051AbZJEWxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 18:53:44 -0400
From: Neil Brown <neilb@suse.de>
To: Vladimir Dronnikov <dronnikov@gmail.com>
Date: Tue, 6 Oct 2009 09:54:05 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19146.30989.928233.393339@notabene.brown>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, rob@landley.net,
       firmware@impactlinux.com
Subject: Re: [PATCH 1/1] md: drivers/md/unroll.pl replaced with awk analog
In-Reply-To: message from Vladimir Dronnikov on Monday October 5
References: <4aca1863.0a1ad00a.33bf.1017@mx.google.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday October 5, dronnikov@gmail.com wrote:
> From: Vladimir Dronnikov <dronnikov@gmail.com>
> 
> drivers/md/unroll.pl replaced by awk script to drop build-time dependency on perl

Thanks for the patch,
and thanks to Rob Landley for the pointer to where this was discussed
elsewhere.  The change makes sense to me.

Just a couple of little changes needed:

>  quiet_cmd_unroll = UNROLL  $@
> -      cmd_unroll = $(PERL) $(srctree)/$(src)/unroll.pl $(UNROLL) \
> +      cmd_unroll = awk -f$(srctree)/$(src)/unroll.awk -vN=$(UNROLL) \
>                     < $< > $@ || ( rm -f $@ && exit 1 )
>  

The top level Makefile defines
AWK          = awk

so I think $(AWK) should be used here, rather than a literal 'awk'.


> --- linux-2.6.31.orig/drivers/md/raid6test/Makefile	Wed Sep  9 22:13:59 2009
> +++ linux-2.6.31/drivers/md/raid6test/Makefile	Mon Oct  5 20:10:15 2009
> @@ -7,7 +7,7 @@
>  OPTFLAGS = -O2			# Adjust as desired
>  CFLAGS	 = -I.. -I ../../../include -g $(OPTFLAGS)
>  LD	 = ld
> -PERL	 = perl
> +AWK	 = awk
>  AR	 = ar
>  RANLIB	 = ranlib
>  
> @@ -35,35 +35,35 @@
>  raid6test: test.c raid6.a
>  	$(CC) $(CFLAGS) -o raid6test $^
>  
> -raid6altivec1.c: raid6altivec.uc ../unroll.pl
> -	$(PERL) ../unroll.pl 1 < raid6altivec.uc > $@
> +raid6altivec1.c: raid6altivec.uc ../unroll.awk
> +	$(AWK) ../unroll.awk 1 < raid6altivec.uc > $@

In the md/Makefile, you pass the unroll count as
      -vN=$NUMBER

in raid6test/Makefile you pass it as just
      $NUMBER

one of these is wrong.  Which one?

Well.....

> --- /dev/null	Thu Jan  1 00:00:00 1970
> +++ linux-2.6.31/drivers/md/unroll.awk	Mon Oct  5 20:12:24 2009
> @@ -0,0 +1,20 @@
> +
> +# This filter requires one command line argument (n) which must be a
> +# decimal number.

According to the comment, "$NUMBER" is correct. But

> +#
> +# Repeat each input line containing $$ n times, replacing $$ with 0...n-1.
> +# Replace each $# with n, and each $* with a single $.
> +
> +BEGIN {
> +	n = N + 0
> +}

according to the code  "-vN=$NUMBER" is correct.

So you need to fix either the code or the comment, then fix one of the
two Makefiles.

You might like to try running the test in raid6test as well, just to 
triple check that it all still works.

Thanks,
NeilBrown


> +{
> +	if (/\$\$/) { rep = n } else { rep = 1 }
> +	for (i = 0; i < rep; ++i) {
> +		tmp = $0
> +		gsub(/\$\$/, i, tmp)
> +		gsub(/\$\#/, n, tmp)
> +		gsub(/\$\*/, "$", tmp)
> +		print tmp
> +	}
> +}
> --- linux-2.6.31.orig/drivers/md/unroll.pl	Wed Sep  9 22:13:59 2009
> +++ /dev/null	Thu Jan  1 00:00:00 1970
> @@ -1,24 +0,0 @@
> -#!/usr/bin/perl
> -#
> -# Take a piece of C code and for each line which contains the sequence $$
> -# repeat n times with $ replaced by 0...n-1; the sequence $# is replaced
> -# by the unrolling factor, and $* with a single $
> -#
> -
> -($n) = @ARGV;
> -$n += 0;
> -
> -while ( defined($line = <STDIN>) ) {
> -    if ( $line =~ /\$\$/ ) {
> -	$rep = $n;
> -    } else {
> -	$rep = 1;
> -    }
> -    for ( $i = 0 ; $i < $rep ; $i++ ) {
> -	$tmp = $line;
> -	$tmp =~ s/\$\$/$i/g;
> -	$tmp =~ s/\$\#/$n/g;
> -	$tmp =~ s/\$\*/\$/g;
> -	print $tmp;
> -    }
> -}
