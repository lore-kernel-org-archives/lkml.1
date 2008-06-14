Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbYFNUwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbYFNUwV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 16:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbYFNUwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 16:52:10 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:58994 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509AbYFNUwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 16:52:08 -0400
Message-ID: <48542F75.5070605@skyrush.com>
Date: Sat, 14 Jun 2008 14:52:05 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Alan Cox <alan@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Newall <davidn@davidnewall.com>, Willy Tarreau <w@1wt.eu>,
       Harald Dunkel <harald.dunkel@t-online.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: su gets stuck for root
References: <48438126.3080308@t-online.de>	 <20080604151649.GB12625@devserv.devel.redhat.com>	 <4846C85E.7080309@skyrush.com>	 <20080604171056.GB17875@devserv.devel.redhat.com>	 <4846FBF2.9010206@skyrush.com> <484FDB63.6050504@skyrush.com>	 <19f34abd0806120452w433e9763v2ee92e2f278ae988@mail.gmail.com>	 <485323C5.4030002@skyrush.com>	 <19f34abd0806140045l259bcb93ie4b7bfa2d73bd4d@mail.gmail.com>	 <48540343.4010200@skyrush.com> <19f34abd0806141334w67547e84hf1021c0fd1139b8b@mail.gmail.com>
In-Reply-To: <19f34abd0806141334w67547e84hf1021c0fd1139b8b@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------000203060003010104040501"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000203060003010104040501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Vegard Nossum wrote:
> Yeah, a user-space process can do this, and it's the right behaviour
> for the kernel. I did post a program that would "reproduce" what
> you're seeing. I do now believe that it's something timing-related, as
> Alan suggested initially. (But timing-related with your scripts, that
> is. I must say, that "sleep 2" does look a bit suspicious; I have no
> idea what that is supposed to do :-))

Ah, that is something I put in there to artificially make it more
reproducible.  Here's the reason: when I first encountered the problem,
it was happening if the home dir of the user was on the "btrfs"
filesystem (the new checksumming one from Oracle).  This made me suspect
btrfs initially.  But I reproduced the problem [more sporadically] when
the home was on ext3 as well.  Since btrfs has a different performance
profile, especially when first accessed after a mount (and it is a
filesystem still under development, so some optimizations are yet to
come), I figured it might be timing-related, and sure enough, adding the
"sleep 2" proved that.

So without the sleep 2 and with a home of ext3, it rarely happens, since
it takes very little time to read the homedir files (.bashrc, etc.).
Putting in the sleep makes it almost always happen.  It seems like the
delay invoked by the sleep causes that subsequent stty call to hang.

> I suppose it would be more useful to see a trace where you include a
> few more system calls, can you try:
> 
>     # strace -e trace=process,ioctl,setpgid -f su foo
> 
> instead?

OK, attached.

> Just for the record, I'm probably not the best person to debug this,
> so I'm just trying to figure it out as we go. On the other hand, I
> don't see better suggestions from anybody else. Thank you for
> persisting, though! :-)
> 
> (And the fact that the results differ with the kernel versions does
> make this relevant for LKML still.)

Thanks for helping.  Yes, this is the kind of nagging issue that really
bugs me, since it is intermittent and makes things feel unstable.  If we
determine the problem is in something else (like stty or bash), then at
least I can file a bug with them.

						-Joe

--------------000203060003010104040501
Content-Type: text/x-log;
 name="strace_su.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="strace_su.log"

9738  execve("/bin/su", ["su", "foo"], [/* 50 vars */]) = 0
9738  ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
9738  ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
9738  ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
9738  clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0xb7dfc708) = 9740
9738  waitpid(-1,  <unfinished ...>
9740  execve("/bin/bash", ["bash"], [/* 50 vars */]) = 0
9740  ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
9740  ioctl(2, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
9740  ioctl(255, TIOCGPGRP, [9737])     = 0
9740  setpgid(0, 9740)                  = 0
9740  ioctl(255, TIOCSPGRP, [9740])     = 0
9740  ioctl(255, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
9740  clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0xb7df1708) = 9741
9741  exit_group(0)                     = ?
9740  --- SIGCHLD (Child exited) @ 0 (0) ---
9740  waitpid(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], WNOHANG) = 9741
9740  waitpid(-1, 0xbfb187fc, WNOHANG)  = -1 ECHILD (No child processes)
9740  ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, 0xbfb18774) = -1 ENOTTY (Inappropriate ioctl for device)
9740  clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0xb7df1708) = 9742
9742  clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0xb7df1708) = 9743
9742  waitpid(-1,  <unfinished ...>
9743  execve("/usr/bin/dircolors", ["dircolors", "-b", "/etc/DIR_COLORS"], [/* 49 vars */]) = 0
9743  exit_group(0)                     = ?
9742  <... waitpid resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0) = 9743
9742  --- SIGCHLD (Child exited) @ 0 (0) ---
9742  waitpid(-1, 0xbfb17fbc, WNOHANG)  = -1 ECHILD (No child processes)
9742  exit_group(0)                     = ?
9740  --- SIGCHLD (Child exited) @ 0 (0) ---
9740  waitpid(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], WNOHANG) = 9742
9740  waitpid(-1, 0xbfb1824c, WNOHANG)  = -1 ECHILD (No child processes)
9740  clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0xb7df1708) = 9744
9740  waitpid(-1,  <unfinished ...>
9744  execve("/bin/sleep", ["sleep", "2"], [/* 49 vars */]) = 0
9744  exit_group(0)                     = ?
9740  <... waitpid resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0) = 9744
9740  ioctl(255, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
9740  ioctl(255, TIOCGWINSZ, {ws_row=30, ws_col=80, ws_xpixel=724, ws_ypixel=454}) = 0
9740  ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
9740  ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
9740  ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
9740  ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
9740  ioctl(1, TIOCGWINSZ, {ws_row=30, ws_col=80, ws_xpixel=724, ws_ypixel=454}) = 0
9740  ioctl(0, TIOCGWINSZ, {ws_row=30, ws_col=80, ws_xpixel=724, ws_ypixel=454}) = 0
9740  --- SIGCHLD (Child exited) @ 0 (0) ---
9740  waitpid(-1, 0xbfb18d3c, WNOHANG)  = -1 ECHILD (No child processes)
9740  clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0xb7df1708) = 9745
9740  waitpid(-1,  <unfinished ...>
9745  execve("/bin/stty", ["stty", "-ixany"], [/* 49 vars */]) = 0
9745  ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
9745  ioctl(0, SNDCTL_TMR_STOP or TCSETSW, {B38400 opost isig icanon echo ...}) = 0
9745  ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
9745  exit_group(0)                     = ?
9740  <... waitpid resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0) = 9745
9740  ioctl(255, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
9740  ioctl(255, TIOCGWINSZ, {ws_row=30, ws_col=80, ws_xpixel=724, ws_ypixel=454}) = 0
9740  --- SIGCHLD (Child exited) @ 0 (0) ---
9740  waitpid(-1, 0xbfb18d3c, WNOHANG)  = -1 ECHILD (No child processes)
9740  ioctl(255, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
9740  ioctl(255, TIOCGWINSZ, {ws_row=30, ws_col=80, ws_xpixel=724, ws_ypixel=454}) = 0
9740  ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
9740  ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
9740  ioctl(1, TIOCGWINSZ, {ws_row=30, ws_col=80, ws_xpixel=724, ws_ypixel=454}) = 0
9740  ioctl(0, TIOCGWINSZ, {ws_row=30, ws_col=80, ws_xpixel=724, ws_ypixel=454}) = 0
9740  ioctl(0, TIOCSWINSZ, {ws_row=30, ws_col=80, ws_xpixel=724, ws_ypixel=454}) = 0
9740  ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
9740  ioctl(255, TIOCSPGRP, [9740])     = 0
9740  ioctl(0, TIOCGWINSZ, {ws_row=30, ws_col=80, ws_xpixel=724, ws_ypixel=454}) = 0
9740  ioctl(0, TIOCSWINSZ, {ws_row=30, ws_col=80, ws_xpixel=724, ws_ypixel=454}) = 0
9740  ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
9740  ioctl(0, SNDCTL_TMR_STOP or TCSETSW, {B38400 opost isig -icanon -echo ...}) = 0
9740  ioctl(0, SNDCTL_TMR_STOP or TCSETSW, {B38400 opost isig icanon echo ...}) = 0
9740  ioctl(255, TIOCSPGRP, [9737])     = 0
9740  setpgid(0, 9737)                  = 0
9740  exit_group(0)                     = ?
9738  <... waitpid resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], WSTOPPED) = 9740
9738  exit_group(0)                     = ?

--------------000203060003010104040501--
