Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732AbYFZCOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbYFZCOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 22:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbYFZCOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 22:14:30 -0400
Received: from smtp5.freeserve.com ([193.252.22.159]:55807 "EHLO
	smtp5.freeserve.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbYFZCO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 22:14:29 -0400
X-Greylist: delayed 892 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jun 2008 22:14:29 EDT
X-ME-UUID: 20080626015924923.E15761C00081@mwinf3424.me.freeserve.com
Message-Id: <5DC8DBC2-AA22-448B-8646-06D5788C00FE@shu.ac.uk>
From: Tim Schmielau <T.Schmielau@shu.ac.uk>
To: David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v924)
Subject: Re: [PATCH] Speed up "make headers_*"
Date: Thu, 26 Jun 2008 02:59:21 +0100
Cc: Sam Ravnborg <sam@ravnborg.org>, Vegard Nossum <vegard.nossum@gmail.com>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Engelhardt <jengelh@computergmbh.de>, geert@linux-m68k.org,
       zippel@linux-m68k.org
X-Mailer: Apple Mail (2.924)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[apologies for the late reply, I do not follow lkml anymore]

On Sun, 2008-06-08 at 14:17 +0100, David Woodhouse wrote:
> On Sun, 2008-06-08 at 13:17 +0200, Sam Ravnborg wrote:
> > #if !defined(CONFIG_M68K) || !defined(__KERNEL__)
>
> That's just scary, and broken for m68k where in userspace neither
> CONFIG_M68K nor __KERNEL__ will be defined, so the unwanted ac_ahz
> member will actually show up and break the binary compatibility.
> Assuming we _don't_ want the ac_ahz member to be included on m68k,  
> this
> should fix it (is __mc68000__ the right thing to use?)...
>
> diff --git a/include/linux/acct.h b/include/linux/acct.h
> index e8cae54..228473b 100644
> --- a/include/linux/acct.h
> +++ b/include/linux/acct.h
> @@ -58,8 +58,7 @@ struct acct
>         comp_t          ac_minflt;              /* Minor Pagefaults */
>         comp_t          ac_majflt;              /* Major Pagefaults */
>         comp_t          ac_swaps;               /* Number of Swaps */
> -/* m68k had no padding here. */
> -#if !defined(CONFIG_M68K) || !defined(__KERNEL__)
> +#ifndef __mc68000__ /* m68k had no padding here. */
>         __u16           ac_ahz;                 /* AHZ */
>  #endif
>         __u32           ac_exitcode;            /* Exitcode */
>
This would make cross-compiled m68k kernels silently write wrong
accounting files.

I personally believe it more likely to find an m68k user cross-compiling
his kernels than one including kernel headers in userspace, which was
frowned upon at the time the above code was written (and the number
of BSD accounting users on m68k was estimated as nil, anyways).

If we want this header to work on m68k in userspace, something even
more scary like the following approximation to a mind-reading device
would be needed:

#if !defined(CONFIG_M68K) || (!defined(__KERNEL__) && ! 
defined(__mc68000__))

Tim

