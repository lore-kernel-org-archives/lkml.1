Return-Path: <linux-kernel-owner+w=401wt.eu-S934575AbXEVOxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934575AbXEVOxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 10:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759303AbXEVOxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 10:53:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:61827 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759271AbXEVOx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 10:53:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PySLhAhNCFxg/exfdIHQu+lVpyyL9YGWYndW3tD+KiAGZxZQZqBV2n+UNHdWRgpbVaw03y1X8M6BnbyAZLMWvmTD981R3q5oIMyd4rrRuMqm3YEaxO+i3DIoFhA8GDe2dqj9J+tBVdhDconP7qvJgOuZ/8XthaFcwX7xGKdb5Ow=
Message-ID: <a781481a0705220753g25bb0dd8u33bbf8ddaf00f50c@mail.gmail.com>
Date: Tue, 22 May 2007 20:23:27 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: RFC: kconfig select warnings bogus?
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "Kumar Gala" <galak@kernel.crashing.org>,
       "Simon Horman" <horms@verge.net.au>, "Adrian Bunk" <bunk@stusta.de>,
       "Sam Ravnborg" <sam@ravnborg.org>
In-Reply-To: <46505DBD.5010005@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070519151523.GA26724@uranus.ravnborg.org>
	 <a781481a0705191753r25e0cay82785ed56c04b6eb@mail.gmail.com>
	 <a781481a0705191804u7f5a344cr92f2a1981c502bf7@mail.gmail.com>
	 <4650074A.6000307@s5r6.in-berlin.de>
	 <a781481a0705200438s634712e6v957d7085bca7407@mail.gmail.com>
	 <46503542.50300@s5r6.in-berlin.de>
	 <a781481a0705200457v70aae469n97be31fe55af4d91@mail.gmail.com>
	 <46504876.9040802@s5r6.in-berlin.de>
	 <a781481a0705200650v2ef7be85h19f8c8eb026a303b@mail.gmail.com>
	 <46505DBD.5010005@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

[ I was wondering whether to reply or not (this has become sort of a
a dead thread and subsumed by Sam's proposal to scan all Kconfig
files, but still) ... ]

> Satyam Sharma wrote:
> > On 5/20/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> >> config A
> >>         bool-or-tristate "option A"
> >>         depends on !PLATFORM_X || HELPER_N_ON_PLATFORM_X
> >
> > ??? I didn't get this entry,
>
> "A is available if N is there or if it's a platform other than X."
>
> That would be adequate if N is only present and required on platform X.

Umm, if A requires helper code N (which is available only on platform X),
then why/how do we want A to depend on platforms _other_ than X?
That "||" OR there is totally incorrect, because it allows A to be selected
even _without_ N, which won't even allow A to build properly! Remember,
something "depends on" or wishes to "select" some other thing only if
it *reuses code exported* by the dependency.

Beginning to wonder if you even _understood_ the problem that was
being solved there ... I seriously recommend that if / when you _really_
think you have some good idea to solve some problem, then submitting
a working patch is invariably always better (and causes lesser noise :-)

> > can you give a solid example
>
> Nothing exactly of this sort, but compare for example kernel/power/Kconfig:
>
> config SOFTWARE_SUSPEND
>         bool "Software Suspend (Hibernation)"
>         depends on PM && SWAP && (((X86 || PPC64_SWSUSP) &&
>                 (!SMP || SUSPEND_SMP)) || ((FRV || PPC32) && !SMP))
>
> Of course this could be written in a clearer fashion, for example as
>
>         depends on PM
>         depends on SWAP
>         depends on (X86 && !SMP) ||
>                    (X86 && SUSPEND_SMP) ||
>                    (PPC64_SWSUSP && !SMP) ||
>                    (PPC64_SWSUSP && SUSPEND_SMP) ||
>                    (FRV   && !SMP) ||
>                    (PPC32 && !SMP)

Ok, so perhaps you actually meant X && N_ON_X above. But your
suggestion is _still_ wrong. Using "depends on" instead of "select" does
get rid of the warnings, but that conversion would *not* maintain current
behaviour (that of the config option being visible and automatically
selecting its dependency -- "default y if ..." otoh does preserve current
behaviour and hence _can_ replace select).

This is precisely what Trent meant that the kind of dependencies you
were suggesting in your mails can't be "select"ed in the first place.

Anyway, I've had enough of this thread. The patch that I had sent was
a 7-line *triviality* that merely (1) preserved current behaviour, (2) did
not cause _any_ build problems, and (3) got rid of bogus warnings in
a way that was completely standard when dealing with arch/.../Kconfig's
and better than the initial suggestion by Sam. Can't quite understand
how this became such a fiasco that ruined my Sunday :-)

Satyam
