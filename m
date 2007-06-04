Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbXFDRiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbXFDRiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 13:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbXFDRiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 13:38:04 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50019 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbXFDRiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 13:38:01 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Richard Purdie <rpurdie@openedhand.com>
Subject: Re: [PATCH -mm 0/5] LZO and swap write failure patches for -mm
Date: Mon, 4 Jun 2007 13:37:51 -0400
User-Agent: KMail/1.9.6
Cc: akpm <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh@veritas.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Woodhouse <dwmw2@infradead.org>,
       Nitin Gupta <nitingupta910@gmail.com>
References: <1180971378.6313.72.camel@localhost.localdomain> <200706041214.38017.dhazelton@enter.net> <1180975976.6313.133.camel@localhost.localdomain>
In-Reply-To: <1180975976.6313.133.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706041337.51563.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 June 2007 12:52:55 Richard Purdie wrote:
> On Mon, 2007-06-04 at 12:14 -0400, Daniel Hazelton wrote:
> > On Monday 04 June 2007 11:36:18 Richard Purdie wrote:
> > I have been involved in benchmarking and testing that stripped down and
> > kernel-style version and cannot recall any mention of said alignment
> > errors. Perhaps I was removed from the CC: list - could you point me at
> > them?
>
> I've forwarded you the full mail. To quote Nitin Gupta:
> > The author (Markus Oberhumer) of LZO  provided these comments for this
> > patch:
>
> [...]
>
> > I've only briefly looked over it, but it's obvious that your version
> > does not work on architechtures which do not allow unaligned access
> > (arm, mips, ...).
>
> [...]
>
> > Still a lot to do...
>
> So its author admits it isn't ready yet. I'm not saying that code is bad
> or shouldn't be included, just that we've ascertained it isn't ready
> *yet*. Which brings us back to my last mail and its proposal.

Yes - most of that work, IIRC, is related to the alignment issues that Herr 
Oberhumer noted. As it stands, the alternative does work well for a large 
number of the platforms that the kernel supports. With a little Kconfig magic 
it could be made available *only* for those platforms that it currently 
supports. Then people can help work on the alignment issues - possibly by 
providing platform conditional code.

> > If there *are* memory alignment issues, why not fix them in that tiny
> > code rather than pushing a different version of the code into the
> > kernel that is
> > 1) Not kernel style and 2) bloated?
>
> The zlib code isn't kernel style and is arguably bloated, perhaps we
> should remove that?

I'm not familiar with the zlib code, but it was included a long time ago - 
since zlib was included I'm pretty certain that if it had been proposed today 
it would have been NACK'd for the style violations and bloat.

> If Nitin or others can fix that patch, fine but I can't afford the time
> to do it and until those issues are fixed, it isn't ready.

You can take the time to produce a patch and spread FUD about the speed of a 
competing patches code but you don't have the time to work on fixing a 
cleaner implementation? I'll admit that actually working on fixing problems 
in code can take more time, but still - the time taken for those pursuits 
*could* have been spent actually working on fixing the problems.

> Also, Nitin has already claimed several times that he's made no
> functional changes to that code only to find that actually there are
> functional changes. That does give rise to concern (not least for
> security). There are ways to address this but I don't have time to do it
> so it needs someone, preferably independent who has.

Time and again? Only "Functional Changes" he made that negatively impacted the 
code was an attempt to replace an open-coded copy with a call to memcpy(). 
That it broke on PPC (and likely other big-endian architectures) is something 
I have been trying to figure out, since it should not have occurred. (Though 
it might just be that the kernel's highly optimized memcpy() somehow munged 
the byte-ordering)

And that *is* the only time I can remember someone mentioning that the code 
had broken - back around version 2 of his patch. Making it sound like this 
has happened numerous times certainly does qualify as something other than 
being honest, however you phrase it. As it stands you are the *first* and, 
IMHO, *only* person to have made a claim like this. From the comments that 
the original author of LZO has made I'd say he isn't concerned - after all, 
he's said: "As for further quality assurance, your version should generate 
byte-identical object code to LZO 2.02 when using the same compiler & flags."

The differences that *might* exist could possibly be tracked down to the use 
of a helper function and things like the likely()/unlikely() macros and the 
use of cpu_to_le16() (which should, instead be le16_to_cpu according to at 
least one commentor - I *think* it was Jan)

> > > I've trimmed my patch down to only contain the "safe" decompression
> > > function, pruned the headers a little further and merged in the cleanup
> > > patch I submitted to -mm previously. I've also included an updated
> > > version of the patch to make resier4 use the shared LZO functions
> > > (fixing a security hole in the process).
> >
> > Then submit the fix for the security hole as a seperate patch to the
> > Rieser4 people.
>
> I have done and they are aware of it.

Ah, okay.

>
> > Unless you can clearly point out those "memory alignment" issues in
> > the
> > kernel-style code of the other LZO implementation that was posted as
> > an RFC I
> > have to say this: stop the FUD.
>
> This is not FUD, I've actually done things to help the other LZO
> implementation forward but my available time to help is limited.

Call me paranoid, but even with MFXJ Oberhumer making a statement about the 
codes suitability for platforms that don't allow unaligned access I'm not 
convinced that it is a problem with the LZO implementation itself. After all, 
a processor really can't make it impossible to access single bytes without 
making life hard for a lot of people and almost all memory alignment issues 
processors have come back to how and/or where buffers are allocated. *IF* 
that is the case with Nitin's stripped down LZO code, then isn't it the job 
of the user of the library code to assure that the buffers are properly 
aligned?

> Note that I am not the only person to have expressed concerns with the
> alternative LZO implementation and some questions raised by others as
> well as myself regarding some of the code differences still remain
> unanswered too.

IMHO, Nitin has been great about addressing all questions raised. The 
differences in the generated code - at least here on my machine - all appear 
to be related to the macro's I defined to allow the kernel-level code to 
compile in userspace and Nitin's code's use of a helper-function to do a lot 
of the work. Other differences could be related to differences in how the 
code generator reacts to the lack of the "register" specifier on the 
variables (I can't really say - I don't have more than a passing familiarity 
with GCC's code generator)

Markus Oberhumer himself has stated that the output code for "cc -O2 -o 
minilzo.o minilzo.c" and "cc -O2 -o nitinlzo.o nitinlzo.c" should be almost 
exactly the same. What differences *might* exist can be tracked down to the 
functional changes that have been made - such as removal of the 
LZO_CHECK_MPOS_NON_DET macro, use of size_t/ssize_t/u32 in place of the 
renamed C99 types and a lot of other small things.

All told I wasn't surprised by the differences between miniLZO's object code 
and the object code for Nitin's stripped down "Tiny" version.

> Regards,
>
> Richard

DRH
