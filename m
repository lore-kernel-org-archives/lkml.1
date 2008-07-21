Return-Path: <linux-kernel-owner+w=401wt.eu-S1759068AbYGUKn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759068AbYGUKn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 06:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756119AbYGUKns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 06:43:48 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:43381 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757845AbYGUKnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 06:43:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=PIBW6iA/6yKN4ePl5KiV6vc430zT5DqdibHIyMKsStzCr8JNYJwYT5oy5hXbmFpror
         FJft68DFDqPsAMMIXvEgPAHa3dCgN6pR531Uy1QoIj0r8891AoEMR/9ILKkUQbJ/Ikib
         DBDgAc6DQwxwQY4YGbgrJI9Y+FgkNMyEEgWYQ=
Message-ID: <517f3f820807210343m999957crcbba3c7843c0eae9@mail.gmail.com>
Date: Mon, 21 Jul 2008 12:43:45 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: EINTR under Linux
Cc: akineko <akineko@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <487FF1A2.8000404@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3f676a38-51a8-4fb6-bf02-c717b21bee06@e39g2000hsf.googlegroups.com>
	 <487FF1A2.8000404@shaw.ca>
X-Google-Sender-Auth: 8e687833ed2215dd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/18/08, Robert Hancock <hancockr@shaw.ca> wrote:
> akineko wrote:
>
> > Hello,
> >
> > I have a socket program that is running flawlessly under Solaris.
> > When I re-compiled it under Linux (CentOS 5.1) and run it, I got the
> > following error:
> >
> > recv() failed: Interrupted system call
> >
> > This only occurs very infrequently (probably one out of a million
> > packets exchanged).
> >
> > select() in my program is getting EINTR.
> >
> > From the postings I found in the news group seem suggesting that it is
> > due to GC.
> >
> >
> > > The GC sends signals to each thread which causes them all to enter a
> stop-the-world state.  When the GC
> > > is finished,  all the threads are resumed.  When the threads are
> resumed, any that were blocked in a
> > > blocking system call (like poll()) will return with EINTR.  Normally you
> would just retry the system call.
> > >
> >
> > So, I added to check if the errno == EINTR and now my program seems
> > working fine.
> >
> > //
> >
> > My question I would like to ask in this group is:
> > Does this mean any system call under Linux could return empty-hand
> > with EINTR due to GC?
> > I usually assume fatal if system call returns -1.
> > It is quite painful to check all system-call return status.
> >
> > My second question is:
> > Does this can occur in other OS's? (free-BSD, Solaris, ...)
> > Or, is this specific to Linux OS?
> >
>
>  I'm not sure what the GC you're referring to is, but I assume it's using a
> signal handler for that stop signal. If the signal handler is not installed
> with the SA_RESTART flag, then if a system call is interrupted by that
> signal it will get EINTR instead of being restarted automatically. For some
> system calls, EINTR can still occur, for example, see:
>
> http://www.opengroup.org/onlinepubs/007908775/xsh/select.html
>
>  This is not Linux specific, but the specs allow for some different behavior
> between UNIX variants.

And the signal.7 page has been very recently updated to include
Linux-specific details for most system calls.  Have a look here:

http://www.kernel.org/doc/man-pages/online/pages/man7/signal.7.html

Basically, recv() is restarted if you use SA_RESTART, but select() is
never restarted, regardless of SA_RESTART (and POSIX.1 allows this).
