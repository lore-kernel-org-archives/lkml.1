Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbYFNHp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbYFNHp2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 03:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbYFNHpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 03:45:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:58621 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbYFNHpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 03:45:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=o7coqb5bxqFirLB2UAJEs2b4oZZaZ8ZysVNMr1bVvm3pfbPN0CmE4Lfyq35QR3gyfs
         dROALidNPDBCiMkq9Ax2F+hqxTIHyTKuo5B3UN7IgVcN+sqC7QmUXNJBBjw8uLbK1aex
         QTi50cKN8nMQeK2XLY7ZAEoo2m3E1Pc3S14g0=
Message-ID: <19f34abd0806140045l259bcb93ie4b7bfa2d73bd4d@mail.gmail.com>
Date: Sat, 14 Jun 2008 09:45:17 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Joe Peterson" <joe@skyrush.com>
Subject: Re: 2.6.25.3: su gets stuck for root
Cc: "Alan Cox" <alan@redhat.com>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "David Newall" <davidn@davidnewall.com>, "Willy Tarreau" <w@1wt.eu>,
       "Harald Dunkel" <harald.dunkel@t-online.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <485323C5.4030002@skyrush.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48438126.3080308@t-online.de>
	 <20080602155133.GC933@devserv.devel.redhat.com>
	 <4846A9F4.40003@skyrush.com>
	 <20080604151649.GB12625@devserv.devel.redhat.com>
	 <4846C85E.7080309@skyrush.com>
	 <20080604171056.GB17875@devserv.devel.redhat.com>
	 <4846FBF2.9010206@skyrush.com> <484FDB63.6050504@skyrush.com>
	 <19f34abd0806120452w433e9763v2ee92e2f278ae988@mail.gmail.com>
	 <485323C5.4030002@skyrush.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 3:49 AM, Joe Peterson <joe@skyrush.com> wrote:
> Vegard Nossum wrote:
>> I think knowing the pgrps of the above processes (there is possibly
>> one more involved, stty?) would be useful; try:
>>
>>     $ ps -eo pid,pgrp,tpgid,user,args
>
> OK, I performed this test again (getting the su to hang), and here is
> the info:

[snip]

> scorpius ~ # ps -eo pid,pgrp,tpgid,user,args | grep 7036
>  6902  6902  7036 root     /bin/login --
>  6922  6922  7036 root     -bash
>  7036  7036  7036 foo      su foo
>  7037  7037  7036 foo      bash
>  7042  7037  7036 foo      stty -ixany

So this clearly shows what's wrong; 7036 is the "controlling process"
group id. But only "su foo" is in this group, the bash and stty
processes have their own group, 7037.

On my own system, when I do "su", I get this:
 2891  2891  2892 root     su temp
 2892  2892  2892 temp     bash

...and here the "bash" process is in the right group, 2892, while "su"
is the one in the background!

Can you try to run strace on the su to see where things go wrong, i.e.

    $ strace -f -e trace=process su foo

...and we're only interested in what happens up to the point where it
hangs. That should hopefully tell us which process is doing the wrong
thing. In either case, as Alan pointed out, this seems unlikely to be
a kernel problem.

[snip]

>> so can you please look for anything like that in your login scripts or
>> shell rc files?
>
> I do use stty in my .bashrc (that's why this happens), but I do not put
> it in the background.

Yeah, most likely the process that calls stty is first put in the
background itself (or never brought to the foreground?). But I don't
know why... when you get the trace, we can compare and find out where
it deviates.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
