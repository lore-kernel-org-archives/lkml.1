Return-Path: <linux-kernel-owner+w=401wt.eu-S1758770AbXERDNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770AbXERDNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 23:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755692AbXERDNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 23:13:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:1976 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646AbXERDNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 23:13:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=j82a91/KYQrgODEy1vWoZ2QfAKWwleZLU6M1UGNRuEG7xyVxGYbbppuNbVoTXAtTF+92nUwlxXqGpa7Lg9XUFmmC38EULtKE2EjMP6HHzF19PqHp78i7sMSIbDXWYrr6/Ec+9se4Eb+9OG1l3cysafJl88ufzr7CCZCdyGXx66U=
Message-ID: <a781481a0705172013k1536e586u6908ded5c8f8df@mail.gmail.com>
Date: Fri, 18 May 2007 08:43:17 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Bill Davidsen" <davidsen@tmr.com>
Subject: Re: [PATCH] "volatile considered harmful", take 3
Cc: 7eggert@gmx.de, "H. Peter Anvin" <hpa@zytor.com>,
       "Jonathan Corbet" <corbet@lwn.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Johannes Stezenbach" <js@linuxtv.org>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Heikki Orsila" <shdl@zakalwe.fi>,
       "jimmy bahuleyan" <knight.camelot@gmail.com>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>
In-Reply-To: <464CEA70.1080908@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8jHg3-1T2-5@gated-at.bofh.it> <8jQt5-7As-3@gated-at.bofh.it>
	 <8jSuQ-28J-21@gated-at.bofh.it> <8jT7y-39x-9@gated-at.bofh.it>
	 <E1Hn1VO-0001Gp-Ka@be1.lrz>
	 <a781481a0705132037v2229e675p1f51a9f18222b46b@mail.gmail.com>
	 <464CEA70.1080908@tmr.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bill,

On 5/18/07, Bill Davidsen <davidsen@tmr.com> wrote:
> Satyam Sharma wrote:
>
> > *Unfortunately* (the trouble with C itself, is that a *committee* has made
> > it into ... something ... that it should not have made it into) -- anyway,
> > unfortunately C took it upon itself to solve a problem that it did not
> > have (and does not even bring about) in the first place: and the
> > half-hearted (or vague, call it what you will) attempt _then_ ends up
> > being a problem -- by making people _feel_ as if they are doing things
> > right, when that is probably not the case.
> >
> > [ And we've not even touched the issue of whether the _same_ compiler's
> > implementation of volatile across archs/platforms is consistent. ]

> It was a fun experience, where I first learned the modern equivalent of
> Occam's Razor, Plauger's "Law of least astonishment," which compiler
> writers regularly violate :-(

Well, here it was a case of the standard committee violating the principle
of solving a problem _where_ it exists in the first place. As far as volatile
is concerned, the _language_ itself had absolutely no problems that
needed fixing ...

> Pardon, I was GE's representative to the original X3J11 committee, and
> 'volatile' was added to "codify existing practice" which is one of the
> goals of a standard. The extension existed, in at least two forms, to
> allow handling of memory mapped hardware. So the committee did not take
> it upon itself, it was a part of the defined duty of the committee.
>
> The intents was simple, clear, and limited, to tell the compiler that
> every read of a variable in source code should result in a read, at that
> point in the logic, and similar for writes. In other words, the code
> should not be moved and should generate a real memory access every time.
> People have tried to do many things with that limited concept since,
> some with "clarification" and some with assuming the compiler knows when
> to ignore volatile.

In fact I wish the standard just left this functionality entirely up to the
implementation.

After all, C (the _language_) does not mandate memory access
reordering / optimization by implementations so dumb compilers
(5.1.2.3:1) that do not do any are still conformant and hence
don't require the volatile extension (5.1.2.3:8). Implementations that
do perform optimization, otoh, _must_ then solve the possible problems
_themselves_ by providing an extension that allows the programmer
to turn it off (wherever necessary) to prevent those side-effects that the
implementation itself brought about by performing optimization in the
first place. That _compiler extension_ could then of course be called
anything (volatile, foo, bar, barrier, ...) and implemented in any way --
whatever is appropriate for that compiler [1].

[ Analogically, C (or any language) does not mandate the hardware
it runs on to reorder / optimize memory accesses. Those that do, must
clearly then also provide instructions like lfence/sfence/mfence as part
of their instruction set to solve potential issues that _their_ behaviour
brings about in the first place. How horribly wrong it would be for a
_language_ to try and go about solving this problem ... ]

So the way I see it, it's just a case of solving a problem _where_ it
exists in the first place.

Satyam

[1] Which begs the question, so if we wished (note past tense here)
to keep generic kernel code compiler-independent, what do we do in
situations where we want to disable _compiler optimizations_ temporarily
for some piece of code? => By defining macros / some API as part of
our codebase in implementation-specific headers that does whatever
needs to be done for _that_ compiler. => Which is precisely what we
have already and why I like/prefer that.
