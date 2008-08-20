Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbYHTDsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbYHTDsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 23:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750864AbYHTDsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 23:48:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750824AbYHTDsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 23:48:14 -0400
Date: Tue, 19 Aug 2008 20:47:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>,
       Martin Ziegler <ziegler@uni-freiburg.de>,
       lkml <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [PATCH] fix adjtimex() freq return error
Message-Id: <20080819204752.d9540f15.akpm@linux-foundation.org>
In-Reply-To: <1219199346.6276.5.camel@localhost>
References: <1219199346.6276.5.camel@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008 19:29:06 -0700 john stultz <johnstul@us.ibm.com> wrote:

> Martin Ziegler reported a bug in adjtimex(), where odd positive 
> frequencies are reduced by 1 while negative values are correct.
> 
> See http://bugzilla.kernel.org/show_bug.cgi?id=11370 for details
> 
> The issue was introduced in the following commit that increased 
> time_freq to a 64bit value and increased its resolution:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=074b3b87941c99bc0ce35385b5817924b1ed0c23;hp=eea83d896e318bda54be2d2770d2c5d6668d11db
> 
> The problem is how we convert from our internal high res value back to
> userland. Instead of dividing, we shift, then mult, then shift again,
> causing the slight error seen in the bug.
> 
> I don't think adjtimex() is a terribly hot path, so this patch simply
> uses div_s64() to convert back to the external resolution and removes 
> the unused shift defines to resolve the issue.
> 
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> 
> Index: 2.6-git/kernel/time/ntp.c
> ===================================================================
> --- 2.6-git.orig/kernel/time/ntp.c
> +++ 2.6-git/kernel/time/ntp.c
> @@ -402,9 +402,7 @@ int do_adjtimex(struct timex *txc)
>  		if (!(time_status & STA_NANO))
>  			txc->offset /= NSEC_PER_USEC;
>  	}
> -	txc->freq	   = shift_right((s32)(time_freq >> PPM_SCALE_INV_SHIFT) *
> -					 (s64)PPM_SCALE_INV,
> -					 NTP_SCALE_SHIFT);
> +	txc->freq	   = div_s64(time_freq, PPM_SCALE);
>  	txc->maxerror	   = time_maxerror;
>  	txc->esterror	   = time_esterror;
>  	txc->status	   = time_status;
> Index: 2.6-git/include/linux/timex.h
> ===================================================================
> --- 2.6-git.orig/include/linux/timex.h
> +++ 2.6-git/include/linux/timex.h
> @@ -82,9 +82,6 @@
>   */
>  #define SHIFT_USEC 16		/* frequency offset scale (shift) */
>  #define PPM_SCALE (NSEC_PER_USEC << (NTP_SCALE_SHIFT - SHIFT_USEC))
> -#define PPM_SCALE_INV_SHIFT 20
> -#define PPM_SCALE_INV ((1ll << (PPM_SCALE_INV_SHIFT + NTP_SCALE_SHIFT)) / \
> -		       PPM_SCALE + 1)
>  
>  #define MAXPHASE 500000000l	/* max phase error (ns) */
>  #define MAXFREQ 500000		/* max frequency error (ns/s) */
> 

Thanks, John.  And Martin for the perfect bug report.

Based on Martin's observation that the bug has been there since 2.6.21
I marked this as needed in 2.6.25.x and in 2.6.26.x.  However the patch
doesn't apply at all to 2.6.25, so someone(tm) will have a bit of
rework to do if we want to fix 2.6.25.x.

This fix caused Roman's
ntp-fix-adj_offset_ss_read-bug-and-do_adjtimex-cleanup.patch (which I
have queued for when Thomas wakes up) to toss a reject, but fixing that
seemed pretty simple.  I think.  The scripts/kconfig/conf segfaults are
being a bit of a PITA at present.

