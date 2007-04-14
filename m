Return-Path: <linux-kernel-owner+w=401wt.eu-S965109AbXDNTzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965109AbXDNTzt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 15:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965164AbXDNTzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 15:55:49 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:58970 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965109AbXDNTzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 15:55:48 -0400
Date: Sat, 14 Apr 2007 21:55:43 +0200
From: Jan Yenya Kasprzak <kas@fi.muni.cz>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, osv@javad.com
Subject: Re: [RFC 1/1] Char: mxser_new, fix recursive locking
Message-ID: <20070414195543.GE20376@fi.muni.cz>
References: <20070414042725.GT20376@fi.muni.cz> <462079ED.2000605@gmail.com> <3018694794025219@wsc.cz> <20070414143719.GA5203@fi.muni.cz> <4af2d03a0704140952w6e2338c4g3037f4ba03e2fb1d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4af2d03a0704140952w6e2338c4g3037f4ba03e2fb1d@mail.gmail.com>
User-Agent: Mutt/1.4.1i
X-Muni-Spam-TestIP: 147.251.48.3
X-Muni-Envelope-From: kas@fi.muni.cz
X-Muni-Envelope-To: linux-kernel@vger.kernel.org
X-Muni-Virus-Test: Clean
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sat, 14 Apr 2007 21:55:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
: >        I have another problem with the driver - it probably sometimes
: >drops DCD signal on the serial line or something like that:
: >when the traffic on the serial console is heavy, it sometimes disconnects
: >me from the remote shell, and cu(1) displays the login prompt from the new
: >instance of mgetty of the remote machine. However, it does so both with
: >mxser.o and mxser_new.o (in 2.6.21-rc6, I think it worked in 2.6.19,
: >but I have to retest it). So this is another problem, different from
: >the one we are trying to solve now.
: 
: There were some changes, however nothing significant in mxser.c, maybe
: some of tty or ldisc layer changes (but there is only termios ->
: ktermios switch + some other things), this would probably be hard to
: find without bisecting if 2.6.19 is really OK for you.

	OK, I'll try to bisect in a few weeks.

: The only idea I have right now is to nohup process, which will
: int fd = open("/dev/ttyMIXX", O_RDONLY | O_NONBLOCK);
: while (1) {
:  ioctl(fd, TIOCMIWAIT, TIOCM_CD);
:  ioctl(fd, TIOCMGET, &ret);
:  printf("%ld: carrier has changed: %u\n", time(NULL), !!(ret & TIOCM_CD));
: }

	Hmm, I have tried to run this, and got a machine lockup, and after
a minute or so the following has been printed to the console:

~BUG: spinlock lockup on CPU#0, sshd/1671, ffffffff80557780

(I was logged in using ssh, and ran the above code inside the ssh session).

	I have tried to look at it from the remote side as well:
stracing the "find / -print" revealed that after some time,
the write(1, "/file/name/...", ...) call returned -EIO.
And from this point on, all subsequent writes to fd #1 did return
-EIO as well.

-Yenya

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
> I will never go to meetings again because I think  face to face meetings <
> are the biggest waste of time you can ever have.        --Linus Torvalds <
