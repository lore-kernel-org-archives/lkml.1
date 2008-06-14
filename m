Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbYFNRnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbYFNRnp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 13:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYFNRnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 13:43:35 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:54497 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbYFNRne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 13:43:34 -0400
Message-ID: <48540343.4010200@skyrush.com>
Date: Sat, 14 Jun 2008 11:43:31 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Alan Cox <alan@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Newall <davidn@davidnewall.com>, Willy Tarreau <w@1wt.eu>,
       Harald Dunkel <harald.dunkel@t-online.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: su gets stuck for root
References: <48438126.3080308@t-online.de>	 <20080602155133.GC933@devserv.devel.redhat.com>	 <4846A9F4.40003@skyrush.com>	 <20080604151649.GB12625@devserv.devel.redhat.com>	 <4846C85E.7080309@skyrush.com>	 <20080604171056.GB17875@devserv.devel.redhat.com>	 <4846FBF2.9010206@skyrush.com> <484FDB63.6050504@skyrush.com>	 <19f34abd0806120452w433e9763v2ee92e2f278ae988@mail.gmail.com>	 <485323C5.4030002@skyrush.com> <19f34abd0806140045l259bcb93ie4b7bfa2d73bd4d@mail.gmail.com>
In-Reply-To: <19f34abd0806140045l259bcb93ie4b7bfa2d73bd4d@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------080301080304040102060609"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080301080304040102060609
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Vegard Nossum wrote:
> So this clearly shows what's wrong; 7036 is the "controlling process"
> group id. But only "su foo" is in this group, the bash and stty
> processes have their own group, 7037.
> 
> On my own system, when I do "su", I get this:
>  2891  2891  2892 root     su temp
>  2892  2892  2892 temp     bash
> 
> ...and here the "bash" process is in the right group, 2892, while "su"
> is the one in the background!

Hmm.

> Can you try to run strace on the su to see where things go wrong, i.e.
> 
>     $ strace -f -e trace=process su foo
> 
> ...and we're only interested in what happens up to the point where it
> hangs. That should hopefully tell us which process is doing the wrong
> thing. In either case, as Alan pointed out, this seems unlikely to be
> a kernel problem.

OK, I attached this as a text file at the end.  But (*bummer*), using
strace makes it impossible to reproduce the hang (figures, and I believe
someone earlier in the thread also had this problem).

As for whether the kernel is at fault, not sure (i.e. does this hang
behavior implicate the kernel automatically or can a user-space process
cause itself such an issue?).  But I *do* see different behavior
depending on the kernel version.  There were a couple of git kernels in
which I could not reproduce it.  Still, if it is a race or something, it
might be that the conditions were just slightly perturbed.

I attached the strace log just in case it is of help.

					-Joe

--------------080301080304040102060609
Content-Type: text/x-log;
 name="su_strace.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="su_strace.log"

7009  execve("/bin/su", ["su", "foo"], [/* 32 vars */]) = 0
7009  clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0xb7e3d708) = 7010
7010  execve("/bin/bash", ["bash"], [/* 31 vars */]) = 0
7010  clone( <unfinished ...>
7009  waitpid(-1,  <unfinished ...>
7010  <... clone resumed> child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0xb7db0708) = 7011
7011  exit_group(0)                     = ?
7010  --- SIGCHLD (Child exited) @ 0 (0) ---
7010  waitpid(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], WNOHANG) = 7011
7010  waitpid(-1, 0xbff58cec, WNOHANG)  = -1 ECHILD (No child processes)
7010  clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0xb7db0708) = 7012
7012  clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0xb7db0708) = 7013
7013  execve("/usr/bin/dircolors", ["dircolors", "-b", "/etc/DIR_COLORS"], [/* 31 vars */]) = 0
7013  exit_group(0)                     = ?
7012  --- SIGCHLD (Child exited) @ 0 (0) ---
7012  waitpid(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], WNOHANG) = 7013
7012  waitpid(-1, 0xbff585ec, WNOHANG)  = -1 ECHILD (No child processes)
7012  exit_group(0)                     = ?
7010  waitpid(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0) = 7012
7010  --- SIGCHLD (Child exited) @ 0 (0) ---
7010  waitpid(-1, 0xbff5873c, WNOHANG)  = -1 ECHILD (No child processes)
7010  clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0xb7db0708) = 7014
7014  execve("/bin/sleep", ["sleep", "2"], [/* 31 vars */]) = 0
7010  waitpid(-1,  <unfinished ...>
7014  exit_group(0)                     = ?
7010  <... waitpid resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0) = 7014
7010  --- SIGCHLD (Child exited) @ 0 (0) ---
7010  waitpid(-1, 0xbff593dc, WNOHANG)  = -1 ECHILD (No child processes)
7010  clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0xb7db0708) = 7015
7015  execve("/bin/stty", ["stty", "-ixany"], [/* 31 vars */]) = 0
7015  exit_group(0)                     = ?
7010  --- SIGCHLD (Child exited) @ 0 (0) ---
7010  waitpid(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], WNOHANG) = 7015
7010  waitpid(-1, 0xbff5936c, WNOHANG)  = -1 ECHILD (No child processes)
7010  exit_group(0)                     = ?
7009  <... waitpid resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], WSTOPPED) = 7010
7009  exit_group(0)                     = ?

--------------080301080304040102060609--
