Return-Path: <linux-kernel-owner+w=401wt.eu-S1759836AbYFNBuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759836AbYFNBuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 21:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756850AbYFNBuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 21:50:05 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:44704 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312AbYFNBuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 21:50:03 -0400
Message-ID: <485323C5.4030002@skyrush.com>
Date: Fri, 13 Jun 2008 19:49:57 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Alan Cox <alan@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Newall <davidn@davidnewall.com>, Willy Tarreau <w@1wt.eu>,
       Harald Dunkel <harald.dunkel@t-online.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: su gets stuck for root
References: <48438126.3080308@t-online.de> <20080602102033.63e4cd18@core>	 <48441138.90503@skyrush.com>	 <20080602155133.GC933@devserv.devel.redhat.com>	 <4846A9F4.40003@skyrush.com>	 <20080604151649.GB12625@devserv.devel.redhat.com>	 <4846C85E.7080309@skyrush.com>	 <20080604171056.GB17875@devserv.devel.redhat.com>	 <4846FBF2.9010206@skyrush.com> <484FDB63.6050504@skyrush.com> <19f34abd0806120452w433e9763v2ee92e2f278ae988@mail.gmail.com>
In-Reply-To: <19f34abd0806120452w433e9763v2ee92e2f278ae988@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> I think knowing the pgrps of the above processes (there is possibly
> one more involved, stty?) would be useful; try:
> 
>     $ ps -eo pid,pgrp,tpgid,user,args

OK, I performed this test again (getting the su to hang), and here is
the info:

tty_check_change: current->signal->tty = f7879800
tty_check_change: tty = f7879800
tty_check_change: tty->pgrp = f78639c0
  tty->pgrp->count = 5
  tty->pgrp->level = 0
  tty->pgrp->numbers[0].nr = 7036
tty_check_change: task_pgrp(current) = f7863f00
  task_pgrp(current)->count = 1
  task_pgrp(current)->level = 0
  task_pgrp(current)->numbers[0].nr = 7037
tty_check_change: kill_pgrp called; returning -ERESTARTSYS
set_termios: error return value (-512) from tty_check_change

scorpius ~ # ps aux | grep 7036
foo  7036  0.0  0.1   2336  1100 tty1     S+   19:30   0:00 su foo

scorpius ~ # ps aux | grep 7037
foo  7037  0.0  0.1   2988  1460 tty1     S    19:30   0:00 bash

scorpius ~ # ps -eo pid,pgrp,tpgid,user,args | grep 7036
 6902  6902  7036 root     /bin/login --
 6922  6922  7036 root     -bash
 7036  7036  7036 foo      su foo
 7037  7037  7036 foo      bash
 7042  7037  7036 foo      stty -ixany

scorpius ~ # ps -eo pid,pgrp,tpgid,user,args | grep 7037
 7037  7037  7036 foo      bash
 7042  7037  7036 foo      stty -ixany

scorpius ~ # ps aux | grep 7042
foo  7042  0.0  0.0   1608   376 tty1     T    19:30   0:00 stty -ixany

scorpius ~ # ps -eo pid,pgrp,tpgid,user,args | grep 7042
 7042  7037  7036 foo      stty -ixany

(I omitted, of course, when grep found itself, and I compressed some
white space to allow lines to fit nicely in the email)

> ..as this problem occurs because a process tries to change the
> terminal settings (and subsequently gets suspended because of that)
> while it's not the owner of the terminal.
> 
> This can happen if you fork something off to the background, e.g. like
> 
>     $ stty 9600 &
> 
> (which should immediately give you [1]+ Stopped stty 9600),
> 
> so can you please look for anything like that in your login scripts or
> shell rc files?

I do use stty in my .bashrc (that's why this happens), but I do not put
it in the background.

Anyway, hope the additional info above is of help...

					Thanks, Joe
