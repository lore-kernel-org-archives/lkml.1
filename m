Return-Path: <linux-kernel-owner+w=401wt.eu-S933861AbZJMKcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933861AbZJMKcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 06:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759389AbZJMKce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 06:32:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36227 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755630AbZJMKce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 06:32:34 -0400
Date: Tue, 13 Oct 2009 11:32:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nix <nix@esperi.org.uk>, Paul Fulghum <paulkf@microgate.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Boyan <btanastasov@yahoo.co.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       "=?ISO-8859-14?B?RnLpZOlyaWM=?= L. W. Meunier" <fredlwm@gmail.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
Message-ID: <20091013113232.384b2432@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
	<L6tb-VyKHZK.A.PaB.Ozl0KB@chimera>
	<C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com>
	<87ljjgfcbu.fsf@spindle.srvr.nix>
	<alpine.LFD.2.01.0910121703390.3438@localhost.localdomain>
	<alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It does that "tty_buffer_request_room()" call and subsequent copying with 
> no locking at all - sure, the tty_buffer_request_room() function itself 
> locks the buffers, but then unlocks it when returning, so when we actually 
> do the memcpy() etc, we can race with anybody.

The tty_buffer_request_room() is a hint to help better allocation. It's
also only safe to run from the receiving path of the driver (which
has always been assumed not to make two parallel calls to the function at
once.

There is a simple reason the locking is sufficient. If you can call the
function from two places at once in your serial driver at the same you've
scrambled the data order so you've already lost.

So - not a bug - and the lock changes don't actually "fix" any behaviour
either because the ordering must be imposed by the caller.

>   pointless: they then call tty_insert_flip_string(), which means that the 
>   tty_buffer_request_room() call was totally redundant ]

It's a performance tweak. With a 3G USB modem or similar device running
at 20Mbits or more being able to generate one allocation per chunk
received for DMA made a measurable performance difference on some
platforms. 
 
Alan
