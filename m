Return-Path: <linux-kernel-owner+w=401wt.eu-S1758933AbZJMCzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933AbZJMCzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 22:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758924AbZJMCzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 22:55:06 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:44540 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758921AbZJMCzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 22:55:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:x-archive:mime-version:content-type;
        b=EqGtFF/QXMucwlcEETCr0P/6UK5J+Xn0li+Lv/r0oBodIVCYbqtFlatNNQ1NwfmvCn
         hh7Yu6QM/vZWCULLejYKHrqRFejp8AWW88F5jHOnCUU4AxAC6AwjtUq+f/pGUnrCWIFJ
         FRlXz81XjvK/BZ+CmkRCXtTpU22+1IYX1sQnw=
Date: Mon, 12 Oct 2009 23:54:19 -0300 (BRST)
From: "=?ISO-8859-15?Q?Fr=E9d=E9ric_L=2E_W=2E_Meunier?=" 
	<fredlwm@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Nix <nix@esperi.org.uk>, "Justin P. Mattock" <justinmattock@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Boyan <btanastasov@yahoo.co.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
In-Reply-To: <alpine.LFD.2.01.0910121703390.3438@localhost.localdomain>
Message-ID: <alpine.LNX.2.01.0910122343340.19647@dyndns.pervalidus.net>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.PaB.Ozl0KB@chimera> <C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com> <87ljjgfcbu.fsf@spindle.srvr.nix> <alpine.LFD.2.01.0910121703390.3438@localhost.localdomain>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
X-Archive: encrypt
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1177665380-1255402465=:19647"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1177665380-1255402465=:19647
Content-Type: TEXT/PLAIN; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 12 Oct 2009, Linus Torvalds wrote:

> On Mon, 12 Oct 2009, Nix wrote:
>> On 12 Oct 2009, Justin P. Mattock uttered the following:
>>
>>> Not sure where this stands. Right now all three machines I have seem  to be having no issues with the kayboard
>>> (xserver 1.6.*) I can go and build the latest xserver(1.7) to see if I  hit something.
>> [...]
>>>> Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=14388
>>>> Subject        : keyboard under X with 2.6.31
>>>> Submitter    : Frédéric L. W. Meunier <fredlwm@gmail.com>
>>>> Date        : 2009-10-07 20:19 (5 days old)
>>>> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e043e42bdb66885b3ac10d27a01ccb9972e2b0a3
>>>> References    : http://marc.info/?l=linux-kernel&m=125494753228217&w=4
>>
>> I have been seeing problems precisely like those described (sometimes
>> the keyboard dies, sometimes it gets 'stuck' with a key held down, until
>> I switch TTYs, which generally means killing X as I'm not aware of an
>> easy way to switch VTs using only the mouse), since I moved to 2.6.31
>
> The particular commit that was bisected to should really not matter for X,
> except perhaps from a timing standpoint.
>
> The problem it fixed was in pty's, and X doesn't use them much if at all
> (various X _programs_ may, of course, but the symptoms don't sound like
> it's just a particular X app that has issues, but more of a generic X
> keyboard handling thing)
>
> But for non-pty's, there should be no semantic changes from that commit
> outside of some general tty timing differences by doing that
> tty_flush_to_ldisc() at new points.
>
> I could fairly easily imagine that some timing difference does expose
> another longer-standing problem in either the kernel or X itself. So the
> bisection isn't necessarily wrong, it's just not likely telling us what
> the real problem is.
>
> Of course, maybe there is some race condition in the tty_buffer.c code. We
> _used_ to not call flush_to_ldisc() except through the workqueue code, so
> races would not be seen in normal circumstances. Now that flush_to_ldisc()
> could easily get called both synchronously from tty_read()/tty_poll(),
> while also being hit from the workqueues.
>
> Alan, Ogawa-san, do either of you see some problem in tty_buffer.c,
> perhaps?

Just a note. With me, all the keyboard problems happened while I 
was under X, but doing something in a terminal running screen. 
Reverting the commit stopped the problem.
--8323328-1177665380-1255402465=:19647--
