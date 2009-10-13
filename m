Return-Path: <linux-kernel-owner+w=401wt.eu-S1753691AbZJMOlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbZJMOlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbZJMOlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:41:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751521AbZJMOlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:41:19 -0400
Date: Tue, 13 Oct 2009 07:39:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Nix <nix@esperi.org.uk>, Paul Fulghum <paulkf@microgate.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Boyan <btanastasov@yahoo.co.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_L=2E_W=2E_Meunier?= 
	<fredlwm@gmail.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
In-Reply-To: <20091013113232.384b2432@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.01.0910130721530.3438@localhost.localdomain>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.PaB.Ozl0KB@chimera> <C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com> <87ljjgfcbu.fsf@spindle.srvr.nix> <alpine.LFD.2.01.0910121703390.3438@localhost.localdomain> <alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>
 <20091013113232.384b2432@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Oct 2009, Alan Cox wrote:
> 
> There is a simple reason the locking is sufficient. If you can call the
> function from two places at once in your serial driver at the same you've
> scrambled the data order so you've already lost.

Umm. No, Alan.

You also can race with:

 - whoever is _reading_ the buffer, and due to memory ordering may see the 
   update to the buffer length _before_ it actually sees the data itself. 
   That spinlock does all the memory ordering too.

 - scrambling the data order with two writers is certainly less annoying 
   than potentially screwing up ->used entirely, and having the memcpy's 
   overflow the buffer. Both writers may have decided that there is enough 
   room for each one - but that does not mean that there is enough room 
   for _both_.

Now, I do agree that generally there should be locking at a higher level, 
and you should never see two concurrent writers. But even if the locking 
is only for reading, the old locking is simply _wrong_.

> >   pointless: they then call tty_insert_flip_string(), which means that the 
> >   tty_buffer_request_room() call was totally redundant ]
> 
> It's a performance tweak. With a 3G USB modem or similar device running
> at 20Mbits or more being able to generate one allocation per chunk
> received for DMA made a measurable performance difference on some
> platforms. 

Have you even _read_ the code, Alan?

It's not a f*cking performance tweak, and you're ludicrous to claim it is. 
It's pointless, and it's making the code _slower_ rather than faster.

Lookie here, Alan - the common sequence is crap like this:

	tty_buffer_request_room(tty, buf->size);
	tty_insert_flip_string(tty, buf->base, buf->size);

and anybody who claims that is a "performance tweak" doesn't know what the 
hell he is talking about.

Look again.

The first thing that tty_insert_flup_string() does is to re-do the same 
tty_buffer_request_room() call. 

Performance tweak? No. Most of them are stupid, pointless, and worthless. 
Many of them do it for a single character too.

Not all, no. One or two seem to do one tty_buffer_request_room() call, and 
then some one-byte-at-a-time thing, but quite frankly, those are sure as 
hell not going to push lots of data quickly that way either.

Maybe there is some driver where there's a point to it, but from a quick 
grep, I couldn't find any.

			Linus
