Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbZLIPqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbZLIPqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 10:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbZLIPqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 10:46:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33362 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbZLIPqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 10:46:32 -0500
Message-ID: <4B1FC621.8060500@suse.cz>
Date: Wed, 09 Dec 2009 16:45:37 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-5.9 Thunderbird/3.0b4
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/3] Replace kernel/timeconst.pl with kernel/timeconst.sh
References: <200912080317.08254.rob@landley.net> <200912080319.30679.rob@landley.net>
In-Reply-To: <200912080319.30679.rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC hpa who wrote the timeconst.pl script]
On 8.12.2009 10:19, Rob Landley wrote:
> From: Rob Landley <rob@landley.net>
> 
> Replace kernel/timeconst.pl with kernel/timeconst.sh. The new shell script
> is much simpler, about 1/4 the size, and runs on Red Hat 9 from 2003.

I tried the shell script with the precomputed values in timeconst.pl and
it gave me different results than the perl version for 250 and 1000:

with HZ=250:
--- perl
+++ bash
@@ -8,14 +8,14 @@
 #error "kernel/timeconst.h has the wrong HZ value!"
 #endif

-#define HZ_TO_MSEC_MUL32        U64_C(0x80000000)
+#define HZ_TO_MSEC_MUL32       U64_C(0x100000000)
 #define HZ_TO_MSEC_ADJ32        U64_C(0x0)
-#define HZ_TO_MSEC_SHR32        29
+#define HZ_TO_MSEC_SHR32       30
 #define HZ_TO_MSEC_NUM          U64_C(4)
 #define HZ_TO_MSEC_DEN          U64_C(1)
-#define MSEC_TO_HZ_MUL32        U64_C(0x80000000)
-#define MSEC_TO_HZ_ADJ32        U64_C(0x180000000)
-#define MSEC_TO_HZ_SHR32        33
+#define MSEC_TO_HZ_MUL32       U64_C(0x100000000)
+#define MSEC_TO_HZ_ADJ32       U64_C(0x300000000)
+#define MSEC_TO_HZ_SHR32       34
 #define MSEC_TO_HZ_NUM          U64_C(1)
 #define MSEC_TO_HZ_DEN          U64_C(4)
 #define HZ_TO_USEC_MUL32        U64_C(0xfa000000)

and with HZ=1000:
--- perl
+++ bash
@@ -8,14 +8,14 @@
 #error "kernel/timeconst.h has the wrong HZ value!"
 #endif

-#define HZ_TO_MSEC_MUL32        U64_C(0x80000000)
+#define HZ_TO_MSEC_MUL32       U64_C(0x100000000)
 #define HZ_TO_MSEC_ADJ32        U64_C(0x0)
-#define HZ_TO_MSEC_SHR32        31
+#define HZ_TO_MSEC_SHR32       32
 #define HZ_TO_MSEC_NUM          U64_C(1)
 #define HZ_TO_MSEC_DEN          U64_C(1)
-#define MSEC_TO_HZ_MUL32        U64_C(0x80000000)
+#define MSEC_TO_HZ_MUL32       U64_C(0x100000000)
 #define MSEC_TO_HZ_ADJ32        U64_C(0x0)
-#define MSEC_TO_HZ_SHR32        31
+#define MSEC_TO_HZ_SHR32       32
 #define MSEC_TO_HZ_NUM          U64_C(1)
 #define MSEC_TO_HZ_DEN          U64_C(1)
 #define HZ_TO_USEC_MUL32        U64_C(0xfa000000)

$ bash --version
GNU bash, version 4.0.33(1)-release (x86_64-suse-linux-gnu)
...

You're trying to avoid the build dependency on Perl. What about adding a
timeconst.h_shipped with the precomputed values from timeconst.pl:

#if HZ == 24
#define ...
...
#endif

#if HZ == 32
...
#endif
...
#ifndef HZ_TO_MSEC_MUL32
# error "Unknown HZ value, please update kernel/timeconst.h using
kernel/timeconst.pl"
#endif

plus some makefile automagic to run the script iff the HZ value isn't
precomputed. Then you would only need Perl for exotic HZ configurations.

> 
> Signed-off-by: Rob Landley <rob@landley.net>
> --
> 
> kernel/Makefile | 4
> kernel/timeconst.pl | 378 ------------------------------------------
> kernel/timeconst.sh | 91 ++++++++++
> 3 files changed, 93 insertions(+), 380 deletions(-)
> 
> diff -ruN linux-2.6.30/kernel/Makefile linux-2.6.30.new/kernel/Makefile
> --- linux-2.6.30/kernel/Makefile	2009-06-09 22:05:27.000000000 -0500
> +++ linux-2.6.30.new/kernel/Makefile	2009-06-22 14:29:16.000000000 -0500
> @@ -123,7 +123,7 @@
>  $(obj)/time.o: $(obj)/timeconst.h
>  
>  quiet_cmd_timeconst  = TIMEC   $@
> -      cmd_timeconst  = $(PERL) $< $(CONFIG_HZ) > $@
> +      cmd_timeconst  = $(CONFIG_SHELL) $< $(CONFIG_HZ) $@
>  targets += timeconst.h
> -$(obj)/timeconst.h: $(src)/timeconst.pl FORCE
> +$(obj)/timeconst.h: $(src)/timeconst.sh FORCE
>  	$(call if_changed,timeconst)
> diff -ruN linux-2.6.30/kernel/timeconst.pl linux-2.6.30.new/kernel/timeconst.pl
> --- linux-2.6.30/kernel/timeconst.pl	2009-06-09 22:05:27.000000000 -0500
> +++ linux-2.6.30.new/kernel/timeconst.pl	1969-12-31 18:00:00.000000000 -0600
> @@ -1,378 +0,0 @@
> -#!/usr/bin/perl
> -# -----------------------------------------------------------------------
> -#
> -#   Copyright 2007-2008 rPath, Inc. - All Rights Reserved
> -#
> -#   This file is part of the Linux kernel, and is made available under
> -#   the terms of the GNU General Public License version 2 or (at your
> -#   option) any later version; incorporated herein by reference.
> -#
> -# -----------------------------------------------------------------------
> -#
> -
> -#
> -# Usage: timeconst.pl HZ > timeconst.h
[snip]
> diff -ruN linux-2.6.30/kernel/timeconst.sh linux-2.6.30.new/kernel/timeconst.sh
> --- linux-2.6.30/kernel/timeconst.sh	1969-12-31 18:00:00.000000000 -0600
> +++ linux-2.6.30.new/kernel/timeconst.sh	2009-06-22 14:29:16.000000000 -0500
> @@ -0,0 +1,148 @@
> +#!/bin/sh
> +
> +if [ $# -ne 2 ]
> +then
> +	echo "Usage: timeconst.sh HZ FILENAME"
> +	echo
> +	echo "Generate a header file with constants for coverting between"
> +	echo "decimal HZ timer ticks and milisecond or microsecond delays."
> +	echo
> +	exit 1
> +fi
> +
> +HZ=$1
> +shift
> +FILENAME=$1
> +
> +# Sanity test: even the shell in Red Hat 9 (circa 2003) supported 64 bit math.
> +
> +if [ $((1 << 32)) -lt 0 ]
> +then
> +	echo "timeconst.sh needs a shell with 64 bit math, such as bash,"
> +	echo "busybox ash, or dash running on a 64 bit host."
> +	exit 1
> +fi
> +
> +# If this script exits for any reason before this trap is removed,
> +# delete the output file so a partial file won't confuse the build.
> +
> +trap "rm $FILENAME" EXIT
> +
> +# Output start of header file
> +
> +cat > $FILENAME << EOF || exit 1
> +/* Automatically generated by kernel/timeconst.sh */
> +/* Conversion constants for HZ == $HZ */
> +
> +#ifndef __KERNEL_TIMECONST_H
> +#define __KERNEL_TIMECONST_H
> +
> +#include <linux/param.h>
> +#include <linux/types.h>
> +
> +#if HZ != $HZ
> +#error "kernel/timeconst.h has the wrong HZ value!"
> +#endif
> +
> +EOF
> +
> +# For both Milliseconds and Microseconds
> +
> +cat << EOF |
> +MSEC 1000
> +USEC 1000000
> +EOF
> +while read NAME PERIOD
> +do
> +	# Find greatest common denominator (using Euclid's algorithm)
> +
> +	A=$HZ
> +	B=$PERIOD
> +
> +	while [ $B -ne 0 ]
> +	do
> +		C=$(( $A % $B ))
> +		A=$B
> +		B=$C
> +	done
> +
> +	GCD=$A
> +
> +	# Do this for each direction (HZ_TO_PERIOD and PERIOD_TO_HZ)
> +
> +	for DIRECTION in 0 1
> +	do
> +		if [ $DIRECTION -eq 0 ]
> +		then
> +			CONVERT="HZ_TO_${NAME}"
> +			FROM=$HZ
> +			TO=$PERIOD
> +		else
> +			CONVERT="${NAME}_TO_HZ"
> +			FROM=$PERIOD
> +			TO=$HZ
> +		fi
> +
> +		# Calculate 32 significant bits of MUL32 data.
> +
> +		SHIFT=0
> +		while true
> +		do
> +			# This can't overflow 64 bit math.  Pathological case
> +			# (TO=1, FROM=1000000) uses around 32+20=52 bits.
> +
> +			MUL32=$(( ( ( $TO << $SHIFT ) + $FROM - 1 ) / $FROM ))
> +
> +			# Keep increasing $SHIFT until we've got 32 bits.
> +
> +			[ $MUL32 -gt $(( 1 << 31 )) ] && break
> +			SHIFT=$(( $SHIFT + 1 ))
> +		done
> +		MUL32=$( printf %x $MUL32 )
> +
> +		# ADJ32 is just (((FROM/GCD)-1)<<SHIFT)/(FROM/GCD) but this
> +		# can overflow 64 bit math (examples, HZ=24 or HZ=122).
> +		# Pathological case could use 32+20+20=72 bits.  (And this is
> +		# the pathological case because a larger $HZ results in a
> +		# smaller $SHIFT, so even insane HZ>USEC cases should be ok.)
> +
> +		# To get around this, we chop the bottom 32 bits off the
> +		# calculation and then reassemble it to avoid overflow:
> +		# 32+64=96, which is > 72.
> +
> +		ADJ32=$(( $FROM / $GCD ))
> +		if [ $SHIFT -gt 32 ]
> +		then
> +			UPPER=$(( ( $ADJ32 - 1 ) << ( $SHIFT - 32 ) ))
> +			LOWER=$(( ( $UPPER % $ADJ32 ) << 32 ))
> +			ADJ32=$(( ( ( $UPPER / $ADJ32 ) << 32 ) + ( $LOWER / $ADJ32 )))
> +		else
> +			ADJ32=$(( ( ( $ADJ32 - 1 ) << $SHIFT) / $ADJ32 ))
> +		fi
> +		ADJ32=$( printf %x $ADJ32 )
> +
> +		NUM=$(( $TO / $GCD ))
> +		DEN=$(( $FROM / $GCD ))
> +
> +		# Output next chunk of header data to file
> +
> +		(
> +			echo "#define ${CONVERT}_MUL32	U64_C(0x$MUL32)" &&
> +			echo "#define ${CONVERT}_ADJ32	U64_C(0x$ADJ32)" &&
> +			echo "#define ${CONVERT}_SHR32	$SHIFT" &&
> +			echo "#define ${CONVERT}_NUM		U64_C($NUM)" &&
> +			echo "#define ${CONVERT}_DEN		U64_C($DEN)"
> +		) >> $FILENAME || exit 1
> +	done
> +done
> +
> +(
> +	echo
> +	echo "#endif /* __KERNEL_TIMECHONST_H */"
                                      ^

Should be "__KERNEL_TIMECONST_H".


> +) >> $FILENAME || exit 1
> +
> +# Don't rm $FILENAME on exit anymore.
> +
> +trap "" EXIT
> +
> +exit 0
> 

Michal
