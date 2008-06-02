Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbYFBKvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbYFBKvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbYFBKvC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:51:02 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbYFBKvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:51:00 -0400
Date: Mon, 2 Jun 2008 06:50:27 -0400
From: Alan Cox <alan@redhat.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Newall <davidn@davidnewall.com>,
       Willy Tarreau <w@1wt.eu>, Harald Dunkel <harald.dunkel@t-online.de>,
       Joe Peterson <joe@skyrush.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@redhat.com>
Subject: Re: 2.6.25.3: su gets stuck for root
Message-ID: <20080602105027.GG18697@devserv.devel.redhat.com>
References: <48434D57.6030801@skyrush.com> <48438126.3080308@t-online.de> <20080602053256.GF5609@1wt.eu> <20080602091016.571dda7c@core> <4843B6EE.8080104@davidnewall.com> <20080602102033.63e4cd18@core> <19f34abd0806020316v4135935dxff04bcf663ebd4bf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0806020316v4135935dxff04bcf663ebd4bf@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 12:16:56PM +0200, Vegard Nossum wrote:
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

This looks correct to me and in fact I see the behaviour you report on 2.6.23
when running it. If I tell it to ignore SIGTTOU that also then behaves as
expected.

If
	your pgrp is not the pgrp of the tty
	and you are not ignoring TTOU
	and you are not orphaned (as a group)

	Then we are *supposed* to send you SIGTTOU and kick you back
	into touch.


This is so that if you do

someapp
^Z
bg
otherapp

And someapp wants to change the tty settings it blocks back to the shell.

This is correct behaviour and behaviour we've had for years.

Alan

