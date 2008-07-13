Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbYGMRdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbYGMRdT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 13:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbYGMRdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 13:33:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752704AbYGMRdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 13:33:07 -0400
Date: Sun, 13 Jul 2008 10:32:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Elias Oltmanns <eo@nebensachen.de>,
       =?ISO-8859-15?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86_64: fix delayed signals
In-Reply-To: <4879CCFD.70208@firstfloor.org>
Message-ID: <alpine.LFD.1.10.0807131017180.2959@woody.linux-foundation.org>
References: <20080710215039.2A143154218@magilla.localdomain> <20080711054605.GA17851@elte.hu> <alpine.LFD.1.10.0807111031310.2936@woody.linux-foundation.org> <87mykn2sos.fsf@basil.nowhere.org> <alpine.LFD.1.10.0807121030260.2875@woody.linux-foundation.org>
 <4879CCFD.70208@firstfloor.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 13 Jul 2008, Andi Kleen wrote:
> 
> At least the original report was about Ctrl-C only versus Ctrl-Z.

Yes, and I explained why.

> I see the problem regularly myself that Ctrl-C doesn't work,
> but Ctrl-Z+kill does (although I unfortunately cannot
> reproduce it on demand).

There's no way you _can_ reproduce it.

> But it was with programs who shouldn't catch Ctrl-C, like find.

No, it was not. I think you misread it.

Two facts:

 - ^Z and ^C are both going to be equally fast if they aren't blocked.

   This is just how things are. They are handled by the same codepaths.

 - the report you point to does mention 'find', but *not* in the place 
   where it talks about "^Z+kill". There it's much less specific, and I 
   bet that Edwin _had_ seen the "^Z works" behavior, and knew it to be 
   true, but hadn't realized that it depended on the command, so when he 
   gave an example of something where disk IO makes signals slow, he 
   happened to pick one where ^Z and ^C were equally slow.

In other words, I can pretty much _guarantee_ that if ^Z+kill is faster 
than ^C, then it's because the process blocked or caught ^C.

And I can pretty much also guarantee that when Edwin talked about 'find' 
and did that ^C cut-and-paste, he didn't try the ^Z thing (that had 
happened with _other_ programs), or if he did, it was just happenstance 
(because the latency isn't _always_ 10-30 seconds - that's just the worst 
case).

So yes, ^C often works slower. If the process catches it and removes 
temporary files as a result (for example - it's what things like gcc do), 
then of _course_ it's going to be slower. It's going to be very noticeably 
slower, especially since removing a temp-file is going to be even more 
likely to hit a filesystem lock if the write-queues are full than just a 
normal read is.

But ^C isn't always slower, and if 'find' doesn't block/ignore it (and I 
certainly believe you when you say that it doesn't), then for the case of 
'find', it won't be true that ^Z+kill is any faster.

In fact, Edwin later in this thread reported:

  "Also I wasn't able to reproduce the  'Ctrl+Z works faster than Ctrl+C'
   symptom, perhaps it is just a coincidence: by the time I press Ctrl+Z to
   interrupt, enough time has passed (30+ secs), that the same effect would
   have been obtained by another Ctrl+C, or by just waiting."

and I bet that is exactly because now he's been testing programs that 
don't block ^C (ie maybe he's now testing _just_ that "find /" thing).

So before, Edwin was probably doing random things when doing "normal 
work", and noticed that ^Z was sometimes faster. Now, he's trying to chase 
things down, and he creates this specific test-case, and for that 
particular test-case, ^Z _isn't_ faster. He just didn't pick up on the 
pattern that it depends on which particular command he works on.

Try "yum list", and you'll certainly see that ^Z works a *lot* faster than 
^C (and the latter often needs multiple ^C's even when there is no load 
at all)

			Linus
