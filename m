Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbYFNUfD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbYFNUfD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 16:35:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbYFNUey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 16:34:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:27656 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbYFNUew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 16:34:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YBZPBtyRlrCK7vU3DA025IOfCB0tDvG3VpEaa1yNg2AOQfU15/Vou40sAIFD9KG2Nr
         QDI17dUdL9cH29wmKcG1MmQi2e/DEOPRsS3IkkVfw9jpPn37EzYuNBQsr5OZnIcWUlmi
         QV28SnW+feQYBWvBslkSDIFhRVdErfTgm7yiY=
Message-ID: <19f34abd0806141334w67547e84hf1021c0fd1139b8b@mail.gmail.com>
Date: Sat, 14 Jun 2008 22:34:51 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Joe Peterson" <joe@skyrush.com>
Subject: Re: 2.6.25.3: su gets stuck for root
Cc: "Alan Cox" <alan@redhat.com>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "David Newall" <davidn@davidnewall.com>, "Willy Tarreau" <w@1wt.eu>,
       "Harald Dunkel" <harald.dunkel@t-online.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <48540343.4010200@skyrush.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48438126.3080308@t-online.de>
	 <20080604151649.GB12625@devserv.devel.redhat.com>
	 <4846C85E.7080309@skyrush.com>
	 <20080604171056.GB17875@devserv.devel.redhat.com>
	 <4846FBF2.9010206@skyrush.com> <484FDB63.6050504@skyrush.com>
	 <19f34abd0806120452w433e9763v2ee92e2f278ae988@mail.gmail.com>
	 <485323C5.4030002@skyrush.com>
	 <19f34abd0806140045l259bcb93ie4b7bfa2d73bd4d@mail.gmail.com>
	 <48540343.4010200@skyrush.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 7:43 PM, Joe Peterson <joe@skyrush.com> wrote:
>> Can you try to run strace on the su to see where things go wrong, i.e.
>>
>>     $ strace -f -e trace=process su foo
>>
>> ...and we're only interested in what happens up to the point where it
>> hangs. That should hopefully tell us which process is doing the wrong
>> thing. In either case, as Alan pointed out, this seems unlikely to be
>> a kernel problem.
>
> OK, I attached this as a text file at the end.  But (*bummer*), using
> strace makes it impossible to reproduce the hang (figures, and I believe
> someone earlier in the thread also had this problem).

Yeah, but doesn't it loop indefinitely calling ioctl() and getting a
SIGTTOU? Tracing up till this point is okay (and what I had in mind).

>
> As for whether the kernel is at fault, not sure (i.e. does this hang
> behavior implicate the kernel automatically or can a user-space process
> cause itself such an issue?).  But I *do* see different behavior
> depending on the kernel version.  There were a couple of git kernels in
> which I could not reproduce it.  Still, if it is a race or something, it
> might be that the conditions were just slightly perturbed.

Yeah, a user-space process can do this, and it's the right behaviour
for the kernel. I did post a program that would "reproduce" what
you're seeing. I do now believe that it's something timing-related, as
Alan suggested initially. (But timing-related with your scripts, that
is. I must say, that "sleep 2" does look a bit suspicious; I have no
idea what that is supposed to do :-))

I suppose it would be more useful to see a trace where you include a
few more system calls, can you try:

    # strace -e trace=process,ioctl,setpgid -f su foo

instead?

Just for the record, I'm probably not the best person to debug this,
so I'm just trying to figure it out as we go. On the other hand, I
don't see better suggestions from anybody else. Thank you for
persisting, though! :-)

(And the fact that the results differ with the kernel versions does
make this relevant for LKML still.)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
