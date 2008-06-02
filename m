Return-Path: <linux-kernel-owner+w=401wt.eu-S1757481AbYFBKji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbYFBKji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbYFBKja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:39:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:1977 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbYFBKj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:39:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ee15iKb0WKSeAjpws2bkGqooMEfO3xVhxOA7GxZGlXJW1t6Ggbp0vM9mx+VGwq5QbgoGEc/20UXbOREvcJYr9Cz0BWA+Z3ox/Gqi/Fpso0jFi2v8GJKyEAJ+gSY5jD8YvCUYv+q/wxJtHRCo5fJFS0m6qrj9F01LNfrdQn4iy9A=
Message-ID: <19f34abd0806020339m100fd3f8m6c0c6ff0c08a66d2@mail.gmail.com>
Date: Mon, 2 Jun 2008 12:39:29 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.25.3: su gets stuck for root
Cc: "David Newall" <davidn@davidnewall.com>, "Willy Tarreau" <w@1wt.eu>,
       "Harald Dunkel" <harald.dunkel@t-online.de>,
       "Joe Peterson" <joe@skyrush.com>, linux-kernel@vger.kernel.org,
       "Alan Cox" <alan@redhat.com>
In-Reply-To: <19f34abd0806020316v4135935dxff04bcf663ebd4bf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48434D57.6030801@skyrush.com> <48438126.3080308@t-online.de>
	 <20080602053256.GF5609@1wt.eu> <20080602091016.571dda7c@core>
	 <4843B6EE.8080104@davidnewall.com> <20080602102033.63e4cd18@core>
	 <19f34abd0806020316v4135935dxff04bcf663ebd4bf@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2008 at 12:16 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Mon, Jun 2, 2008 at 11:20 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> On Mon, 02 Jun 2008 18:31:34 +0930
>> David Newall <davidn@davidnewall.com> wrote:
>>
>>> Alan Cox wrote:
>>> > Not really. The task would get suspended if it attempted to change the
>>> > tty settings while not being session leader. This is part of the POSIX
>>> > and BSD job control.
>>>
>>> I haven't heard about this new restriction, but it begs the observation
>>> that stty, when forked from a shell (the usual case), is never a session
>>> leader.
>>
>> Sorry I mean part of the current session. I was thinking about the
>> specific case of bash or the ssh->bash setup where the question would be
>> whether the shell was session leader.
>>
>> Someone who can dup this needs to instrument it in tty_ioctl really.
>
> Hi,
>
> I have written a short test program that seems to reproduce it for me
> (see attachment), even though the original su/stty stuff wouldn't.
>
> Basically, the strace shows this:
> ioctl(0, SNDCTL_TMR_START or TCSETS, {B38400 opost isig icanon echo
> ...}) = ? ERESTARTSYS (To be restarted)
> --- SIGTTOU (Stopped (tty output)) @ 0 (0) ---
> --- SIGTTOU (Stopped (tty output)) @ 0 (0) ---
> ioctl(0, SNDCTL_TMR_START or TCSETS, {B38400 opost isig icanon echo
> ...}) = ? ERESTARTSYS (To be restarted)
> --- SIGTTOU (Stopped (tty output)) @ 0 (0) ---
> --- SIGTTOU (Stopped (tty output)) @ 0 (0) ---
> ... (repeating)
>
> The exact code path triggering this seems to be:
>
> tcsetattr() -> ioctl(TCSETS) -> set_termios() -> tty_check_change()
>
> This is on a 2.6.24.5-85.fc8 kernel.
>
> I don't know what's wrong, but I hope this helps.

The error seems that tty_check_change() returns -ERESTARTSYS.
Shouldn't it be EINTR to allow the signal to be processed and let the
process decide whether to retry the tcsetattr()?

Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
