Return-Path: <linux-kernel-owner+w=401wt.eu-S1753069AbZG1RF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbZG1RF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbZG1RF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:05:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54517 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751657AbZG1RF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:05:57 -0400
Date: Tue, 28 Jul 2009 18:06:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
Message-ID: <20090728180649.596c5412@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0907280944150.3186@localhost.localdomain>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk>
	<87bpn7mzli.fsf@devron.myhome.or.jp>
	<20090727115723.1e8de60e@lxorguk.ukuu.org.uk>
	<873a8iqqgv.fsf@devron.myhome.or.jp>
	<20090727142303.41096bf5@lxorguk.ukuu.org.uk>
	<877hxujkuv.fsf@devron.myhome.or.jp>
	<20090727145805.690afe5d@lxorguk.ukuu.org.uk>
	<87fxci6ub9.fsf@devron.myhome.or.jp>
	<20090727161424.GA4233@skywalker>
	<20090727174252.2d987830@lxorguk.ukuu.org.uk>
	<20090727171213.GB4233@skywalker>
	<87skgikjr8.fsf@devron.myhome.or.jp>
	<20090727222010.1a5efb7b@lxorguk.ukuu.org.uk>
	<87r5w19xsb.fsf@devron.myhome.or.jp>
	<20090728112203.7b70adba@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907280848090.3186@localhost.localdomain>
	<20090728174213.5e927428@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907280944150.3186@localhost.localdomain>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Imagine being in 'select()' (or read, for that matter), and getting EINTR 
> due to SIGCHLD. What is the correct expectations?

If you are asking that question I don't think you understand the bug
report.

> The correct expectation is that the select() (or read()) should have 
> returned any data that it saw _before_ it returns EINTR.

read() handles that correctly, has always done so.

emacs from the traces does this

	set O_NDELAY
	wait for SIGCLD
	read()
		EAGAIN
		shit_myself();

The EWOULDBLOCK is perfectly correctly reporting that at that precise
instant no data is available.

Correctly written code does this

	loop: 	read()
		EAGAIN
		poll
		goto loop

and in that case our code all works correctly.

If you put the whole thing on a timeline it looks like this (without
lowlatency being enabled but with the EOF thing fixed)


Slave			Emacs		Kernel

write "errors"
					Queue to tty->buf
close
					This is all the data
					Other end closed
exit
			SIGCLD
			read pty
			EWOULDBLOCK
			shit myself
					schedule n_tty ldisc
					queue bytes to parent

			died rather than waited

Had emacs used poll() properly then it ought to have all worked, although
a spot of review of that wouldn't be a bad thing.

Also calling into the n_tty ldisc side processing in the receiver
unfortunately opens up this stuff


	** interrupt path **
	data received
	queue to tty->buf, and wake

	** hangup **
	closes the ldisc down
	waits for the workqueue to complete
	physical instance goes away

	** a read already in progress **
	(new reads will go via tty_hung_up_write())
	process n_tty ldisc
		(which is already closed)
	echo char
		write to non-existant device
		jump to fishkill (or exploitville or wherever)

Because the hangup code, ldisc and open/close code all work on the basis
that

	- a hang up means the caller will not call tty_flip_buffer_push
	  after calling tty_hangup.
	- the only other path (the non low latency path) is the workqueue
	  which it takes care to kill off

