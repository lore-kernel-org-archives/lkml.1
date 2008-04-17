Return-Path: <linux-kernel-owner+w=401wt.eu-S933934AbYDQP0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933934AbYDQP0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 11:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933732AbYDQPZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 11:25:52 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:38944 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933684AbYDQPZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 11:25:51 -0400
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Bart Samwel <bart@samwel.tk>, sct@redhat.com, akpm@linux-foundation.org,
       adilger@clusterfs.com, Jens Axboe <axboe@suse.de>
Subject: remount for commit=600 taking more than 90 min CPU time
X-Mailer: MH-E 8.0.3; nmh 1.2; GNU Emacs 22.2.1
Date: Thu, 17 Apr 2008 11:24:52 -0400
From: Sanjoy Mahajan <sanjoy@MIT.EDU>
Message-Id: <E1JmVym-0001QV-4X@approx.mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC'ing ext3 maintainers and, in case it involves io priorities, Jens Axboe]

The report started with <http://bugs.debian.org/471465/>
("laptop-mode-tools: mount takes 100% of CPU after unplugging AC")

The problem first happened when unplugging the AC power a few minutes
after the daily 'locate' cron job started.  The 'mount', spawned by the
laptop-mode tools (to remount the / partition with commit=600), took
about 25 minutes to complete!

I can now reproduce the problem without unplugging the AC power:

>From Bart Samwel <bart@samwel.tk>:
> I think this is definitely getting to the point where it looks like a
> kernel problem. Could you report this to the Linux Kernel mailing list
> and to the ext3 maintainers?

Hardware : Thinkpad T60 (Intel graphics and wireless)
Kernel   : Debian package linux-image-2.6.24-1-686, version 2.6.24-5
uname -a :
  Linux approx 2.6.24-1-686 #1 SMP Thu Mar 27 17:45:04 UTC 2008 i686 GNU/Linux

The changelog.Debian.gz for the kernel package indicates that it's
basically the 2.6.24.4 upstream kernel with a few Debian changes (mostly
to enable a few options).

mount -V says:
  mount (util-linux-ng 2.13.1)  [from the Debian 2.13.1-4 package]

To reproduce the problem, I rebooted this morning at 7:20am and saw the
'locate' cron job start at 7:30.  A few minutes later, at 7:35:11, I ran
the following mount command while leaving the AC power plugged in (and
leaving the laptop-mode settings unchanged, so I didn't turn off laptop
mode).

Here is the command (given to bash):

  time mount /dev/sda2 -t ext3 / -o remount,rw,errors=remount-ro,commit=600

It was still running at 9.00am!  The system was sluggish, and was
especially sluggish with anything requiring disk I/O, like saving or
loading new files in Emacs.

Here are the first two lines of the 'top' output (at 9:10):

  4637 root      20   0  3260  756  644 R  106  0.0  93:39.75 mount
  4509 nobody    39  19  6916 4680  908 R   96  0.3  67:10.69 find

One guess is that the mount keeps waiting for the 'find' to do something
or other, but the 'find' never gets a chance because its ionice priority
is too low:

  $ ionice -p 4509
  idle

At 9.05am I did:

  ionice -p4509 -c2 -n0

but it didn't help (the 'mount' kept running strong).

'top' claims that all the CPU time is system time, on both cores.  
The 'find' process is probably in system time with all its 'stat' calls.
But 'strace -p 4637' (on the 'mount' process) produces no output, so I
cannot figure out what system calls are taking up so much system time.

And the 'strace' is not interruptable with ^C.  It needed to be stopped
with ^Z and the 'kill -9 %1' to get rid of it (which I just did).

I tried to kill the 'mount' process.  Neither ^C, 'kill', nor 'kill -9'
worked.  I tried to reboot after the 'mount' had been running for almost
two hours, and the CPU had become hot (92 C).

But it wouldn't reboot because of the 'mount' command, so I had to
hard-reset the machine by holding down the power button.

-Sanjoy
