Return-Path: <linux-kernel-owner+w=401wt.eu-S1757841AbXJCIPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841AbXJCIPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 04:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbXJCIO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 04:14:59 -0400
Received: from z2.cat.iki.fi ([212.16.98.133]:38054 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbXJCIO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 04:14:57 -0400
Date: Wed, 3 Oct 2007 11:14:53 +0300
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Davide Libenzi <davidel@xmailserver.org>, rdunlap@xenotime.net,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       geoff@gclare.org.uk, tglx@linutronix.de, david@hardeman.nu,
       Ulrich Drepper <drepper@redhat.com>, subrata@linux.vnet.ibm.com,
       corbet@lwn.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Man page for revised timerfd API
Message-ID: <20071003081453.GS6372@mea-ext.zmailer.org>
References: <46FA0657.20700@gmx.net> <Pine.LNX.4.64.0709261038550.25778@alien.or.mcafeemobile.com> <20070927103531.184550@gmx.net> <Pine.LNX.4.64.0709270944300.763@alien.or.mcafeemobile.com> <47033BA1.7070901@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47033BA1.7070901@gmx.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 08:50:09AM +0200, Michael Kerrisk wrote:
> Davide Libenzi wrote:
> > On Thu, 27 Sep 2007, Michael Kerrisk wrote:
> > 
> >> Davide,
> >>
> >> A further question: what is the expected behavior in the
> >> following scenario:
> >>
> >> 1. Create a timerfd and arm it.
> >> 2. Wait until M timer expirations have occurred
> >> 3. Modify the settings of the timer
> >> 4. Wait for N further timer expirations have occurred
> >> 5. read() from the timerfd
> >>
> >> Does the buffer returned by the read() contain the value
> >> N or (M+N)?  In other words, should modifying the timer
> >> settings reset the expiration count to zero?
> > 
> > Every timerfd_settime() zeroes the tick counter. So in your scenario it'll 
> > return N.
> 
> Thanks Davide.
> 
> I modified the first para of the read description to make this clear:
> 
>        read(2)
>               If the timer has already expired one or more times
>               since   its  settings  were  last  modified  using
>               timerfd_settime(), or since  the  last  successful
>               read(2),  then the buffer given to read(2) returns
>               an unsigned 8-byte integer  (uint64_t)  containing
>               the number of expirations that have occurred.

When returning multi-byte long numeric values via read(2) as byte streams,
my default question is:

   Can you explicitely state what is the byte order ?

It _probably_ is the host-byte-order as kernel- and userspaces can hardly
run with different ones and this does not sound like an API to be used
over the network, but nevertheless...


In the code-example:

    for (tot_exp = 0; tot_exp < max_exp;) {
        s = read(fd, &exp, sizeof(uint64_t));
        if (s != sizeof(uint64_t))
            die("read");
        tot_exp += exp;
        print_elapsed_time();
        printf("read: %llu; total=%d\\n", exp, tot_exp);
    }

If I may suggest some alterations:

    for (tot_exp = 0; tot_exp < max_exp;) {
        s = read(fd, &exp, sizeof(exp));
        if (s < 0) {
            /* add: EINTR etc. processing */
            continue;
        }
        if (s != sizeof(exp))
            die("read");
        tot_exp += exp;
        print_elapsed_time();
        printf("read: %lu; total=%d\\n", (unsigned long) exp, tot_exp);
    }

The "die if surprised" -strategy is not nice.
Somebody will take example out of that code.

Indeed defining all possible error modes may be impossible, but it may
be possible to define those errors that result in so severe dysfunction
that closing and re-creating the timer-handle may be your only choice.
(About the impossibility:  Solaris STREAMS based network accept() does/did
 yield all kinds of odd errors out from the STREAMS stack in addition to
 those listed in the syscall man-page.  Reacting on all unknown errors
 by dying is not really a smart thing on a program.)


> (In the earlier version of the page the text talked about expirations
> "since the timer was created".)
> 
> Cheers,
> 
> Michael
> -- 
> Michael Kerrisk
> maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

  /Matti Aarnio  <matti.aarnio@zmailer.org>
