Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbZHJMW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbZHJMW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 08:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbZHJMW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 08:22:58 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:51533 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbZHJMW5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 08:22:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=XwP1NKixw/RYNv9nX6AGv/hrDmKIWGgqP5+4UvkknBRCPG6Gi07OKYWTm/1P0EyOFf
         VP+SAdsSOI8h7piLGDAqnMccdt9nAShm04uyVfsCccOp6dhIfWJcveB3CiVeAlOOyJds
         xRsoI7BNaZIkhFb8i+rra8Wk8D5Kdk2DnQc8U=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20090809054601.GA26152@shareable.org>
References: <7c86c4470907270951i48886d56g90bc198f26bb0716@mail.gmail.com>
	 <20090729221703.GA25368@redhat.com> <1248953485.6391.41.camel@twins>
	 <20090730192040.GA9503@redhat.com> <1248984003.4164.0.camel@laptop>
	 <20090730202804.GA13675@redhat.com> <1249029320.6391.72.camel@twins>
	 <20090731141122.a1939712.akpm@linux-foundation.org>
	 <7c86c4470908030553v5a0a4448p94ab612700d68066@mail.gmail.com>
	 <20090809054601.GA26152@shareable.org>
Date: Mon, 10 Aug 2009 14:22:56 +0200
Message-ID: <7c86c4470908100522q44dc1228i315b29d69fc98da3@mail.gmail.com>
Subject: Re: F_SETOWN_TID: F_SETOWN was thread-specific for a while
From: stephane eranian <eranian@googlemail.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, oleg@redhat.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       robert.richter@amd.com, paulus@samba.org, andi@firstfloor.org,
       mpjohn@us.ibm.com, cel@us.ibm.com, cjashfor@us.ibm.com,
       mucci@eecs.utk.edu, terpstra@eecs.utk.edu,
       perfmon2-devel@lists.sourceforge.net, mtk.manpages@googlemail.com,
       roland@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie,

On Sun, Aug 9, 2009 at 7:46 AM, Jamie Lokier<jamie@shareable.org> wrote:
> stephane eranian wrote:
>> As Peter found out, the man page seems to indicate that if you specify a TID
>> instead a PID with F_SETOWN, then the kernel should interpret this as meaning
>> this particular thread, but this is not what is implemented right now.
>
> The behaviour was changed quietly in kernel 2.6.12.
>
> I wrote that part of the man page, and it was true at the time.  SIGIO
> signals _were_ thread-specific.
>

I knew at some point this worked because with perfmon we managed
to get signals delivered to the right thread. But I guess it was just
until 2.6.12 ;-<

> Starting in kernel 2.5.60, SIGIO signals were thread-specific when
> F_SETSIG was used to enable queued siginfo.
>
Thank you for bringing up F_SETSIG. I use it in some of my test programs.
I thought it was related to the shared vs. private queue. But I looked at it
again, and in fact it is related to another yet important issue when
sampling.

You must use F_SETSIG on SIGIO if you want your signal handler to
receive the file descriptor in siginfo. This is useful if you want to perform
some actions on the descriptor. That is the case in perfmon and this is
the case in certain situations with perfcounters as well.

Setting SA_SIGINFO provides siginfo, but the si_fd field is NOT set
correctly without F_SETSIG. I have verified this with perfcounters, and
this is indeed the case.

This behavior seems kind of odd to me. I think it may be a "lucky" side
effect of the intended behavior of F_SETSIG. It would be good to clarify
this point more.

> Prompted by this F_SETOWN_TID patch, I checked through old kernel
> patches, and found that signals set by F_SIGSIG were changed to
> process-wide in 2.6.12:
>
>    @@ -437,7 +438,7 @@ static void send_sigio_to_task(struct ta
>                            else
>                                    si.si_band = band_table[reason - POLL_IN];
>                            si.si_fd    = fd;
>    -                       if (!send_sig_info(fown->signum, &si, p))
>    +                       if (!send_group_sig_info(fown->signum, &si, p))
>                                    break;
>                    /* fall-through: fall back on the old plain SIGIO signal */
>                    case 0:
>
> That's a bit annoying, because it breaks a library which uses queued
> I/O signals as an I/O event mechanism when used with multiple threads.
> (Fortunatelly epoll is available nowadays; it does I/O events much
> better, but sometimes you want SIGIO from epoll's descriptor...)
>
> So the man page is now incorrect, but if F_SETOWN_TID is added and has
> the behaviour which F_SETOWN used to have, then the text can be
> shuffled around.
>
> If anyone is interested, I have a fairly detailed test program which
> checks queued "SIGIO" (F_SETSIG) signals due to I/O on a socket,
> including SIGURG and SIGIO on overflow, and checks whether each one is
> delivered properly and is thread-specific.  I found quite a few Glibc
> and kernel bugs with it in the past.
>
> -- Jamie
>
