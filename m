Return-Path: <linux-kernel-owner+w=401wt.eu-S1757764AbZBYG47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764AbZBYG47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 01:56:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbZBYG4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 01:56:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35975 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbZBYG4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 01:56:49 -0500
Date: Wed, 25 Feb 2009 07:56:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kyle McMartin <kyle@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: mingo@redhat.com, dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com
Subject: Re: [rfc] headers_check cleanups break the whole world
Message-ID: <20090225065632.GB21903@elte.hu>
References: <20090225032553.GD6690@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225032553.GD6690@bombadil.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kyle McMartin <kyle@infradead.org> wrote:

> [names omitted to protect the innocent, hpa@ on the CC wrt klibc maybe
>   using these? ]
> 
> Hi,
> 
> Commits like
> 
>     headers_check fix: foo.h
>     
>     fix the following 'make headers_check' warnings:
>       usr/include/linux/foo.h:29: include of <linux/types.h> is preferred
>       usr/include/linux/foo.h:102: found __[us]{8,16,32,64} type without
> 
> have proved problematic...
> 
> I've had to point out at least two userspace fixes[1] for a 
> variety of reasons that these patches exacerbated. Note 
> however that I didn't say they were wrong.
>
> The reason for this is you cannot intermix glibc header 
> <sys/*.h> includes with <linux/*.h> includes for most things 
> without defining the __KERNEL_STRICT_NAMES guard. If you fail 
> to define this, you end up with multiple definitions of things 
> like dev_t.
> 
> Software was able to get by, because things that used the 
> headers, dvb for example were not getting <linux/types.h> into 
> the include chain, because they were using <asm/types.h> 
> directly.
> 
> I propose we invert that logic, so the presumable libc that 
> makes use of the <linux/types.h> header can just define that 
> it wants these types. (test __KERNEL__ as well so the kernel 
> doesn't need a pointless
> #define.)
> 
> If this isn't tenable, how about moving the 
> {,__}[su]{8,16,32,64} integer types into their own header, so 
> we can avoid this mess ever occuring in the future. I'm sure 
> the janitors can have a field day with that... :)
> 
> That said, who exactly is the userspace consumer for those
> 	typedef __kernel_dev_t	dev_t;
> defines? Can we just include them all in #ifdef __KERNEL__?
> 
> Thoughts?
> 
> cheers, Kyle
> 
> 1. Ok, one of them was libcap playing utterly stupid games 
> with <linux/capability.h> and header guards, but it was 
> exacerbated by a similar patch...

Well, the intention is to clean up the situation somewhat.

__KERNEL_STRICT_NAMES is a really old construct that has been 
with us forever. It's not widely used ... i dont know how widely 
it's being relied on. Sam, should we get rid of it, or should 
user-space define __KERNEL_STRICT_NAMES in cases the glibc 
definition collides with the kernel's definition?

Note that if user-space is "playing utterly stupid games", it 
can cause trouble no matter what scheme we pick - so we have to 
filter out the reasonable problems that we should and can fix in 
the kernel.

	Ingo
