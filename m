Return-Path: <linux-kernel-owner+w=401wt.eu-S1751570AbXDNQwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbXDNQwG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 12:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbXDNQwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 12:52:06 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:61817 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbXDNQwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 12:52:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=c4HkoZxi0i5cmgvfMtuMs9FO3HWx3+MiGUuGIjK4z3YHH6o2Bb++0E4LGSgU9hoZlwSa4WDwjFpn9yOIvgRQLDDaEnlgbrdpsnm38UJ/7tG7tOa/UZ+srOBeIRYyX30Bl3QsbcrQ6uFJKkmV0VoZemRG9d/Db6ceiKM1tmShU4g=
Message-ID: <4af2d03a0704140952w6e2338c4g3037f4ba03e2fb1d@mail.gmail.com>
Date: Sat, 14 Apr 2007 18:52:01 +0200
From: "Jiri Slaby" <jirislaby@gmail.com>
To: "Jan Yenya Kasprzak" <kas@fi.muni.cz>
Subject: Re: [RFC 1/1] Char: mxser_new, fix recursive locking
Cc: linux-kernel@vger.kernel.org, osv@javad.com
In-Reply-To: <20070414143719.GA5203@fi.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070414042725.GT20376@fi.muni.cz> <462079ED.2000605@gmail.com>
	 <3018694794025219@wsc.cz> <20070414143719.GA5203@fi.muni.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/14/07, Jan Yenya Kasprzak <kas@fi.muni.cz> wrote:
>         Works for me, altough it spits tons of (bogus, in this case)
> warnings about possibly uninitialized variable "flags".

This is a gcc problem. I has been thinking about flags = 0
initialization, but developers dislike this shutting gcc up.

>         Additionally, I think it is overzealous to wrap _all_
> spin_lock_irqsave/irqrestore() with if (!in_interrupt()). Some of them are
> never called from the interrupt context (mxser_block_till_ready(), for example
> - it can block, so if it is ever called from the interrupt context, we have
> a different, an order of magnitude worse problem here :-)

Yes, I had a patch, which changed only some of locks, but there were
only 2 or 3 spin_locks remaining. It's not a problem to test it
everywhere for little overhead, but maybe yes, I'll remove it from
open, close and block_til_whatever for the final patch.

>         I have another problem with the driver - it probably sometimes
> drops DCD signal on the serial line or something like that:
> when the traffic on the serial console is heavy, it sometimes disconnects
> me from the remote shell, and cu(1) displays the login prompt from the new
> instance of mgetty of the remote machine. However, it does so both with
> mxser.o and mxser_new.o (in 2.6.21-rc6, I think it worked in 2.6.19,
> but I have to retest it). So this is another problem, different from
> the one we are trying to solve now.

There were some changes, however nothing significant in mxser.c, maybe
some of tty or ldisc layer changes (but there is only termios ->
ktermios switch + some other things), this would probably be hard to
find without bisecting if 2.6.19 is really OK for you.

The only idea I have right now is to nohup process, which will
int fd = open("/dev/ttyMIXX", O_RDONLY | O_NONBLOCK);
while (1) {
  ioctl(fd, TIOCMIWAIT, TIOCM_CD);
  ioctl(fd, TIOCMGET, &ret);
  printf("%ld: carrier has changed: %u\n", time(NULL), !!(ret & TIOCM_CD));
}
to prove, if the carrier really becomes low.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
