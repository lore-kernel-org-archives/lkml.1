Return-Path: <linux-kernel-owner+w=401wt.eu-S935390AbZJOVvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935390AbZJOVvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 17:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935344AbZJOVvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 17:51:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935314AbZJOVvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 17:51:14 -0400
Date: Thu, 15 Oct 2009 14:49:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Oleg Nesterov <oleg@redhat.com>,
       Paul Fulghum <paulkf@microgate.com>, Boyan <btanastasov@yahoo.co.uk>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
In-Reply-To: <87aazsh80x.fsf@devron.myhome.or.jp>
Message-ID: <alpine.LFD.2.01.0910151447440.6146@localhost.localdomain>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com> <87ljjgfcbu.fsf@spindle.srvr.nix> <alpine.LFD.2.01.0910121703390.3438@localhost.localdomain> <alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>
 <4AD3F769.5080405@gmail.com> <alpine.LNX.2.01.0910130405200.9297@dyndns.pervalidus.net> <4AD437F9.9020708@yahoo.co.uk> <alpine.LFD.2.01.0910130745550.3438@localhost.localdomain> <4AD4DE4C.4010402@yahoo.co.uk> <alpine.LFD.2.01.0910131317360.26777@localhost.localdomain>
 <4AD4F548.2030506@microgate.com> <alpine.LFD.2.01.0910131514100.3404@localhost.localdomain> <1255478932.19056.24.camel@localhost.localdomain> <4AD51D6B.7010509@microgate.com> <alpine.LFD.2.01.0910131744590.3404@localhost.localdomain>
 <20091014125846.1a3c8d40@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0910140804180.6146@localhost.localdomain> <alpine.LFD.2.01.0910140925440.6146@localhost.localdomain> <87aazsh80x.fsf@devron.myhome.or.jp>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 16 Oct 2009, OGAWA Hirofumi wrote:
> 
> I.e. the following or something,
> 
> static inline int input_available_p(struct tty_struct *tty, int amt)
> {
> 	int try = 0;
> 
> retry:
> 	if (tty->icanon) {
> 		if (tty->canon_data)
> 			return 1;
> 	} else if (tty->read_cnt >= (amt ? amt : 1))
> 		return 1;
> 
> 	if (!checked) {
> 		tty_flush_to_ldisc(tty);
> 		try = 1;
> 		goto retry;
> 	}
> 
> 	return 0;
> }

Yeah, we could do that. Especially if we ever see this in any profiles. I 
doubt we do, but..

> Sorry if I'm missing the point. Doesn't this have (possible) race with
> schedule_delayed_work() (i.e. by tty writer)?
> 
>              cpu0                                      cpu1
> 
>     if (del_timer(&dwork->timer)) {
>                                             // cpu0 doesn't set _PENDING
>                                             schedule_delayed_work()

We don't care.

We want to make sure that a writer that wrote the data strictly _before_ 
the reader is reading will always have the data show up.

But if the writer is exactly concurrent with the reader, it's fine to not 
see the data. Because at that point, we will rely not on the tty buffers, 
but on the writer doing a tty_wakeup() to notify us that there is new 
data.

			Linus
