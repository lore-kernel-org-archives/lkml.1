Return-Path: <linux-kernel-owner+w=401wt.eu-S1758781AbZLIXkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781AbZLIXkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 18:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758730AbZLIXkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 18:40:45 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:48002
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758705AbZLIXko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 18:40:44 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH 1/3] Replace kernel/timeconst.pl with kernel/timeconst.sh
Date: Wed, 9 Dec 2009 17:40:41 -0600
User-Agent: KMail/1.11.2 (Linux/2.6.28-16-generic; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kbuild@vger.kernel.org
References: <200912080317.08254.rob@landley.net> <200912080319.30679.rob@landley.net> <4B1FC621.8060500@suse.cz>
In-Reply-To: <4B1FC621.8060500@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912091740.43147.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 December 2009 09:45:37 Michal Marek wrote:
> [CC hpa who wrote the timeconst.pl script]
>
> On 8.12.2009 10:19, Rob Landley wrote:
> > From: Rob Landley <rob@landley.net>
> >
> > Replace kernel/timeconst.pl with kernel/timeconst.sh. The new shell
> > script is much simpler, about 1/4 the size, and runs on Red Hat 9 from
> > 2003.
>
> I tried the shell script with the precomputed values in timeconst.pl and
> it gave me different results than the perl version for 250 and 1000:

You're right.

They're functionally equivalent (due to the relationship between MUL32 and 
SHR32), which is why this code has worked for me and other people for a year 
now.  The difference is the possibility of an integer overflow if you try to 
convert a time period of "0xffffffff".

Trivial fix:

--- a/sources/patches/linux-2.6.25-rc1-noperl.patch	Tue Dec 08 20:22:53 2009 
-0600
+++ b/sources/patches/linux-2.6.25-rc1-noperl.patch	Wed Dec 09 17:28:26 2009 
-0600
@@ -507,7 +507,7 @@
 +
 +			# Keep increasing $SHIFT until we've got 32 bits.
 +
-+			[ $MUL32 -gt $(( 1 << 31 )) ] && break
++			[ $MUL32 -ge $(( 1 << 31 )) ] && break
 +			SHIFT=$(( $SHIFT + 1 ))
 +		done
 +		MUL32=$( printf %x $MUL32 )

As long as MUL32 fits in 32 bits than you can multiply it by another 32 bit 
number without overflow, and that's probably all the kernel's enforcing.

>  #define HZ_TO_MSEC_NUM          U64_C(4)
>  #define HZ_TO_MSEC_DEN          U64_C(1)
> -#define MSEC_TO_HZ_MUL32        U64_C(0x80000000)
> -#define MSEC_TO_HZ_ADJ32        U64_C(0x180000000)
> -#define MSEC_TO_HZ_SHR32        33
> +#define MSEC_TO_HZ_MUL32       U64_C(0x100000000)
> +#define MSEC_TO_HZ_ADJ32       U64_C(0x300000000)
> +#define MSEC_TO_HZ_SHR32       34
>  #define MSEC_TO_HZ_NUM          U64_C(1)
>  #define MSEC_TO_HZ_DEN          U64_C(4)
>  #define HZ_TO_USEC_MUL32        U64_C(0xfa000000)

The same.

> and with HZ=1000:
> --- perl
> +++ bash
> @@ -8,14 +8,14 @@
>  #error "kernel/timeconst.h has the wrong HZ value!"
>  #endif
>
> -#define HZ_TO_MSEC_MUL32        U64_C(0x80000000)
> +#define HZ_TO_MSEC_MUL32       U64_C(0x100000000)
>  #define HZ_TO_MSEC_ADJ32        U64_C(0x0)
> -#define HZ_TO_MSEC_SHR32        31
> +#define HZ_TO_MSEC_SHR32       32

And again.

>  #define HZ_TO_MSEC_NUM          U64_C(1)
>  #define HZ_TO_MSEC_DEN          U64_C(1)
> -#define MSEC_TO_HZ_MUL32        U64_C(0x80000000)
> +#define MSEC_TO_HZ_MUL32       U64_C(0x100000000)
>  #define MSEC_TO_HZ_ADJ32        U64_C(0x0)
> -#define MSEC_TO_HZ_SHR32        31
> +#define MSEC_TO_HZ_SHR32       32

Same thing.

> You're trying to avoid the build dependency on Perl. What about adding a
> timeconst.h_shipped with the precomputed values from timeconst.pl:

Been there, done that.  My first patch (way back for 2.6.25) took that 
approach:

http://landley.net/hg/hgwebdir.cgi/firmware/file/a791ca629d9c/sources/patches/linux-2.6.25-
rc1-noperl.patch

But it turns out various non-x86 targets (such as ARM OMAP) allow HZ to be 
specified by an entry field in the config file, into which the user can type a 
range of numbers.  See this post from last year for details:

http://lists.impactlinux.com/pipermail/firmware-impactlinux.com/2008-
December/000022.html

This is why reducing the perl version to just the precomputed constants 
wouldn't work either.  (They're there so that you only need to install a 
random cpan library when surprised by a build break on non-x86 machines.)

> > +	echo
> > +	echo "#endif /* __KERNEL_TIMECHONST_H */"
>
>                                       ^
>
> Should be "__KERNEL_TIMECONST_H".

Yeah, Joe Perches pointed that out to me off-list.  It's just a comment so I 
didn't resubmit the patch for that, but I've fixed my local version already.

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
