Return-Path: <linux-kernel-owner+w=401wt.eu-S1758925AbXF0Pkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925AbXF0Pkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 11:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbXF0PkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 11:40:24 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:42152 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753670AbXF0PkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 11:40:23 -0400
Date: Wed, 27 Jun 2007 17:40:46 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, david@lang.hm,
       LKML Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux Kernel include files
Message-ID: <20070627154046.GN1094@stusta.de>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de> <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm> <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de> <1182483527.10524.31.camel@shinybook.infradead.org> <20070622150038.GN23017@stusta.de> <E27BAC4D-2F1E-4191-A75D-4DD18231C320@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <E27BAC4D-2F1E-4191-A75D-4DD18231C320@mac.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 09:32:39PM -0400, Kyle Moffett wrote:
> On Jun 22, 2007, at 11:00:38, Adrian Bunk wrote:
>> It would certainly help if Joerg would tell what exactly breaks, but I 
>> spot one likely problem in include/asm-i386/types.h:
>>
>> #if defined(__GNUC__) && !defined(__STRICT_ANSI__)
>> typedef __signed__ long long __s64;
>> typedef unsigned long long __u64;
>> #endif
>>
>> It might make sense to remove the #if and simply require that a C compiler 
>> under Linux must know about the C99 "long long"?
>
> Gah, this particular topic and a few other similar header-compatibility 
> ones show up once a month on LKML; I should probably just make a patch to 
> fix all the types.h files and be done with it.  The proper solution is 
> this:
>
> # if __STDC_VERSION__ >= 19901L
> typedef   signed long long __s64;
> typedef unsigned long long __u64;
> # elif defined(__GNUC__)
> __extension__ typedef   signed long long __s64;
> __extension__ typedef unsigned long long __u64;
> # else
> #  error "Your compiler doesn't support long long (IOW: It sucks).  Please 
> get a new one"

This part is wrong.

gcc supported "long long" before C99 existed.
And Joerg said the Sun cc supported "long long" before gcc did.

> # endif
>
> That way if you have any kind of vaguely-long-long-compatible compiler then 
> it will work, and otherwise you'll get a nice useful error message.

No, consider a pre-C99 gcc version that supports "long long".

> It 
> also makes sure that GCC doesn't spew warnings/errors when in c89-pedantic 
> mode.  The "__extension__" keyword is designed for use in implementation 
> header files which want to use GCC-isms unconditionally.

That's a good point I missed.

What about:

#if defined(__GNUC__) && __STDC_VERSION__ < 19901L
__extension__ typedef   signed long long __s64;
__extension__ typedef unsigned long long __u64;
#else
typedef   signed long long __s64;
typedef unsigned long long __u64;
#endif

> Cheers,
> Kyle Moffett

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

