Return-Path: <linux-kernel-owner+w=401wt.eu-S1760772AbXISQ2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760772AbXISQ2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 12:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbXISQ2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 12:28:43 -0400
Received: from smtp.seznam.cz ([77.75.72.43]:58650 "HELO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751756AbXISQ2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 12:28:43 -0400
From: "Frantisek Rysanek" <Frantisek.Rysanek@post.cz>
To: linux-kernel@vger.kernel.org
Date: Wed, 19 Sep 2007 16:58:23 +0200
MIME-Version: 1.0
Subject: Re: [newbie:] Bonnie++2 hangs recent 2.6 kernels? Bash keeps looping in waitpid(), eating 100% CPU
Message-ID: <46F1552F.23463.489FBFDA@localhost>
X-mailer: Pegasus Mail for Windows (4.21c)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Smtpd: 1.0.12@11920:11921
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Piggin,

thanks for your response in the first place :-)

On 13 Sep 2007 at 2:30, Nick Piggin wrote:
>
> Can you see if it is looping in userspace or kernel? Can you kill -9
> the process?
> 
This is interesting. I can't run any classic system command. Any 
command hangs or coredumps. Any command except kill :-) Perhaps 
"kill" is an internal bash command, so that it needn't fork+exec 
(clone) to execute?

Anyway if I kill -9 the loopy bash process, the loopy console 
respawns, I get several segfaults from udevd and dircolors (called 
from .bashrc), and the new bash process on that console is no longer 
loopy. But I continue to get segfaults from any commands that I try 
to run...

> Are you able to test with the latest 2.6.23-rc kernel? If not (or if it
> still has the same problem), then can you get the output of sysrq+T
> and three sysrq+P calls, please? (this might help work out where in
> kernel it is spinning).
>
I've compiled 2.6.23-rc6, enabled serial console and captured 
the output of sysrq+P (on the affected virtual VGA console)
and sysrq+T. 

http://www.fccps.cz/download/adv/frr/bonnie/2.6.23-rc6.txt

The interesting bit of information, related to the erratic "bash" 
processes, is always a single line, such as:

bash          R running      0  2358      1

I've also taken a photo of `top` running
on another virtual console. I can't get any data out of the
affected box, as I can't run any shell commands...

http://www.fccps.cz/download/adv/frr/bonnie/top.jpg

Note that there are rather few processes running in the user space.
Can't say if that makes any difference from a full-blown distro.

Maybe I could set up the bootable CD for download somewhere 
(gzipped ISO of maybe 50 Megs).

In this scenario, Linux 2.6.16.18 once reported a soft lockup.
http://www.fccps.cz/download/adv/frr/bonnie/soft-lockup1.txt
Never again.

I also managed to catch the misbehavior in strace once, didn't
get a capture, but essentially it was stuck at a single open
syscall, I believe it was "waitpid(1, " . (Never managed that again, 
always got segfaults instead of the loopy bash when trying to watch 
bash by strace -p). 

Exactly where does the context switch from user to kernel take place?
I know that I can call ioctl() from user space, and I can write 
ioctl() handlers in kernel space as part of device drivers (the 
handlers take place entirely in kernel space). The waitpid()
thing is a syscall, being entered only once from user space
- and the bash process seems to keep looping inside it.
Does the single "running" line in Alt+SysRq+T mean that the
process is looping in user space?
Take a look at the CPU consumption % numbers though...

Note that there's no OOM killer. (Seen that one before, under 
different circumstances - when OCFS2 didn't like machines
with less than 1 GB RAM.)

My impression is that the erratic behavior could be a secondary 
symptom of a kernel-space memory leak taking place somewhere else 
than in the loopy code itself. Can't say if the leak takes place in 
memory management or EXT3 for instance...

Or maybe my problem lives in pure user space after all?

Frank Rysanek

