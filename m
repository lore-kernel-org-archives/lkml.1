Return-Path: <linux-kernel-owner+w=401wt.eu-S1755751AbYJPLnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbYJPLnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 07:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbYJPLnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 07:43:32 -0400
Received: from sunrise.pg.gda.pl ([153.19.40.230]:61965 "EHLO
	sunrise.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbYJPLnb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 07:43:31 -0400
Date: Thu, 16 Oct 2008 13:43:03 +0200
From: Adam =?UTF-8?B?VGxhxYJrYQ==?= <atlka@pg.gda.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org
Subject: Re: [PATCH 0/5] SIGWINCH problem with terminal apps still alive
Message-ID: <20081016134303.686adea2@merlin.oi.pg.gda.pl>
In-Reply-To: <20081016115202.090a74cd@lxorguk.ukuu.org.uk>
References: <bjXel-4CU-17@gated-at.bofh.it>
	<bjYap-5Q0-25@gated-at.bofh.it>
	<bk30i-3Gx-1@gated-at.bofh.it>
	<bk6AV-8ms-7@gated-at.bofh.it>
	<bkrvO-1HF-49@gated-at.bofh.it>
	<blePJ-6rI-3@gated-at.bofh.it>
	<blmDC-7ZU-7@gated-at.bofh.it>
	<E1Kof4h-0005Q3-Ns@be1.7eggert.dyndns.org>
	<20081011185821.0dab4c81@lxorguk.ukuu.org.uk>
	<20081012143231.6ef9e590@merlin.oi.pg.gda.pl>
	<20081012152200.4a8f14c4@lxorguk.ukuu.org.uk>
	<20081012195957.50feada3@merlin.oi.pg.gda.pl>
	<20081012190312.0bd04ab8@lxorguk.ukuu.org.uk>
	<20081012210140.15cecf78@merlin.oi.pg.gda.pl>
	<20081012212244.117852e0@lxorguk.ukuu.org.uk>
	<alpine.LSU.0.999.0810131155280.5750@be1.lrz>
	<20081013110125.5e3e5fa6@lxorguk.ukuu.org.uk>
	<alpine.LSU.0.999.0810131359310.6408@be1.lrz>
	<20081014145104.24aa96d0@merlin.oi.pg.gda.pl>
	<20081014161157.0194c5c6@merlin.oi.pg.gda.pl>
	<20081016122741.3b89f6f3@merlin.oi.pg.gda.pl>
	<20081016115202.090a74cd@lxorguk.ukuu.org.uk>
Organization: =?UTF-8?B?R2RhxYRzaw==?= University of Technology
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Welcome,
Thu, 16 Oct 2008 11:52:02 +0100 - Alan Cox <alan@lxorguk.ukuu.org.uk>:

> > Now if xterm resizes itself then a program on slave gets its signal
> > but if this program sets terminal sizes by ioctl then only xterm
> > gets the SIGWINCH signal and could read desired sizes by ioctl and
> > then resize itself and set valid sizes on slave side by another
> > ioctl() call. If it not supports this method then there will be no
> > changes on slave side. I think that it is more proper so on the
> > slave side we will see always actual values and if terminal resizes
> > we will get SIGWINCH. 
> 
> The current and historic behaviour is I believe correct and matches
> other Unixes.

I don't know what it means ,,correct'' here. stty(,TIOCSWINSZ,) on pty
slave in its correct behaviour is unusable and leads to application
confuse and sometimes crash.

> Your patch doesn't really seem to make a lot of sense either. You add
> pty special cases in places they are not needed and you pass various
> extra arguments to functions that don't need them.

I do not agree. Adding real_tty arg to tiocgwinsz() is for purpose
of using always the same mutex but read winsize depending on call
side (master or slave). So master could get what it should set and
slave reads always actual terminal values corresponding to real
terminal sizes.
 
> I did actually have a glance at the pty signalling question a couple
> of days ago while further tidying up the default resize logic - see
> the ttydev tree. I'm cautious about changing the signal behaviour
> however without having a hard look to see whether any other Unixen
> has that behaviour currently as we may risk breaking stuff.

Other Unixes seem to have the ,,correct'' not quite usable behaviour ;).
If we want to stick to this my previous patch - [PATCH 0/4] seems to be
suitable.
It only corrects situaction with mutex usage and sending signal to the
master side in case of ioctl(,TIOCSWINS,) done on the slave side.
So a teminal emulator can get signal too and react. But 1. an app can
get its signal before terminal emulator while it is not really resized
yet; 2. a terminal emulator does not support SIGWINCH so we have no
resize but variable is updated and signal generated. So it is not usable
anymore till terminal emulator resizes by itself - but if it changes
sizes to values retuned by ioctl(,TIOCGWINSZ,) there will be no
SIGWINCH send to the app. So you have to manually force it to repaint
its screen so it looks correctly.

Regards

-- 
Adam Tlałka       mailto:atlka@pg.gda.pl    ^v^ ^v^ ^v^
System  & Network Administration Group       - - - ~~~~~~
Computer Center, Gdańsk University of Technology, Poland
