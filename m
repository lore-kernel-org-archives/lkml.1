Return-Path: <linux-kernel-owner+w=401wt.eu-S1760087AbXEYMct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087AbXEYMct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 08:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbXEYMcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 08:32:43 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:45803 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbXEYMcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 08:32:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YS/B8CW+6fr2bCbiMEe0PAc5j8loZXwL25MsAZi1pMxU7o3EWAFr6xjVcL40IiPbVjS9pC0z1FTX8fIR4fD7qQzyuwqcyVDSYNp0DlPTSdP5i75RAM5s0DM1zIrWEiD8RBbHQ7Kb3lXoDEgVhR4cAQtyZVivUp4aJG9xu2QlX7c=
Message-ID: <a781481a0705250532q60bc99b0n93ec6275ac5ca951@mail.gmail.com>
Date: Fri, 25 May 2007 18:02:41 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Nitin Gupta" <nitingupta910@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 4
Cc: linux-kernel@vger.kernel.org, linux-mm-cc@laptop.org,
       "Richard Purdie" <richard@openedhand.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Andrey Panin" <pazke@donpac.ru>, "Bret Towe" <magnade@gmail.com>,
       "Michael-Luke Jones" <mlj28@cam.ac.uk>
In-Reply-To: <4cefeab80705250445m51736a9aj8c89af893d8c242c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705250445m51736a9aj8c89af893d8c242c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/25/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
> Hi,
>
> This is kernel port of LZO1X compressor and LZO1X decompressor (safe
> version only).
>
> * Changes since 'take 3' (Full Changelog after this):
> 1) Removed 'unsafe' decompressor - hence also do away with symlinks in
> Makefiles.

Nice :-)

> 2) Rolled back changes where I replaced COPY4 with memcpy() calls.
> This seemed to be causing too much perf. loss as shown by Richard's
> tests. Need perf. testing again to confirm that this patch has perf.
> comparable to original LZO code/Richard's patch.

Hmmm, you've done away with a lot of cleanup in one big swoop under
suspicion of what exactly causes the performance loss ... so I'd rather
wait till you pinpoint the exact cause.

> 3) Some functions were inlined (DX2, DX3 etc.) - this also seemed to
> be one of factors for perf. loss. Changed them back Macros.

Why would an inline function be slower than a macro? If you're
worried that gcc may ignore to inline them (which is unlikely as it is
with -O2), you can use __always_inline ... inline functions do provide
type-checking.

> 4) Added back the 'register' keyword - again seemed to me one of
> factors for perf. loss.

Again, I wonder whether the programmer's opinion to keep something in
the registers is necessarily better than the compiler's. Especially when
gcc would quite likely ignore your register hint in any case, can't think
of too many reasons to use register these days ...

> Once I pinpoint exact reason for bad perf., I will do above cleanups
> again. But this should not be reason for non-inclusion in mainline.
> These are only minor cleanups.

Right, it'd be nice if you do a step-by-step cleanup to find what exactly
caused the performance hit.

> Richard, can you please provide perf. results for this patch also?
> Also, can you please mail back latest version of your LZO patch? In
> meantime, I will try to include benchmarking support to the
> 'compress-test' module.

I wonder if you could try and use crypto/tcrypt.c -- the debugfs test
module involves userspace, the VFS layer etc ... tcrypt otoh is fully
within the kernel so less likely to introduce spurious noise to the numbers
and better suited to performance benchmarking.

> 5) The only code change: (as suggested by Andrey)
> -#if defined(__LITTLE_ENDIAN)
> -                             m_pos = op - 1;
> -                             m_pos -= (*(const unsigned short *)ip) >> 2;
> -#else
> -                             m_pos = op - 1;
> -                             m_pos -= (ip[0] >> 2) + (ip[1] << 6);
> -#endif
>
> + m_pos = op - 1 - (cpu_to_le16(*(const u16 *)ip) >> 2);
>
> (Andrey suggested le16_to_cpu for above but I think it should be cpu_to_le16).
> *** Need testing on big endian machine ***
>
> Similarly:
> -#if defined(__LITTLE_ENDIAN)
> -                             m_pos -= (*(const unsigned short *)ip) >> 2;
> -#else
> -                             m_pos -= (ip[0] >> 2) + (ip[1] << 6);
> -#endif
>
> + m_pos -= cpu_to_le16(*(const u16 *)ip) >> 2;

You could try and rollback this change too. Also, try to get results
on various arch's yourself (if you can lay your hands on some x86-64
/ sparc64 / etc boxen).

Otherwise, if it's still slower (and we're talking >10% here), there's not
much reason why we shouldn't stay with Richard's patches itself. You
could try and do cleanups to that itself (if Richard's fine with it and as
long as you retain performance).

Satyam
