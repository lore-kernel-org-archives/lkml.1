Return-Path: <linux-kernel-owner+w=401wt.eu-S934389AbZJMVch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934389AbZJMVch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 17:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761451AbZJMVch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 17:32:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48746 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761432AbZJMVcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 17:32:35 -0400
Date: Tue, 13 Oct 2009 22:32:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Boyan <btanastasov@yahoo.co.uk>,
       "=?ISO-8859-14?B?RnLpZOlyaWM=?= L. W. Meunier" <fredlwm@gmail.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>, Nix <nix@esperi.org.uk>,
       Paul Fulghum <paulkf@microgate.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
Message-ID: <20091013223212.3260a7eb@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0910131317360.26777@localhost.localdomain>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
	<L6tb-VyKHZK.A.PaB.Ozl0KB@chimera>
	<C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com>
	<87ljjgfcbu.fsf@spindle.srvr.nix>
	<alpine.LFD.2.01.0910121703390.3438@localhost.localdomain>
	<alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>
	<4AD3F769.5080405@gmail.com>
	<alpine.LNX.2.01.0910130405200.9297@dyndns.pervalidus.net>
	<4AD437F9.9020708@yahoo.co.uk>
	<alpine.LFD.2.01.0910130745550.3438@localhost.localdomain>
	<4AD4DE4C.4010402@yahoo.co.uk>
	<alpine.LFD.2.01.0910131317360.26777@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But flush_to_ldisc() itself has a real oddity: it uses "tty->buf.lock" to 
> protect everything, BUT NOT THE ACTUAL CALL TO ->receive_buf()!

Indeed or it deadlocks

> Anyway, the above explanation "feels right". It would easily explain the 
> behavior, because if the ->receive_buf() calls get re-ordered, then the 
> events get re-ordered, and one simple case of that would be to see the key 
> "release" event before the key "press" event.

And you would only see it in X11 because only X11 deals in raw key events.

> The sane fix would be to just run ->receive_buf() under the tty->buf.lock, 
> but I assume we'd have a lot of unhappy ldiscs if we did that (and 
> possibly irq latency problems too).

You bet

However there is nothing stopping you stuffing that lot into a per tty
mutex solely used for serializing those submissions. It can't really be a
mutex for anything else as we call back into the ldisc to send stuff. You
aren't allowed to stuff data into the ldisc unless it can sleep so a
mutex is fine.

I can't help feeling a mutex might be simpler. It would also then fix
tiocsti() which is most definitely broken right now and documented as
racing.

Alan
