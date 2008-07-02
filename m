Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbYGBSE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbYGBSE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 14:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbYGBSEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 14:04:50 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:33662 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbYGBSEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 14:04:49 -0400
Message-ID: <486BC30C.6010705@skyrush.com>
Date: Wed, 02 Jul 2008 13:03:56 -0500
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080514)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Alan Cox <alan@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Newall <davidn@davidnewall.com>, Willy Tarreau <w@1wt.eu>,
       Harald Dunkel <harald.dunkel@t-online.de>, linux-kernel@vger.kernel.org,
       tconnors@rather.puzzling.org
Subject: tty session leader issue (was Re: 2.6.25.3: su gets stuck for root)
References: <48438126.3080308@t-online.de>	 <20080604171056.GB17875@devserv.devel.redhat.com>	 <4846FBF2.9010206@skyrush.com> <484FDB63.6050504@skyrush.com>	 <19f34abd0806120452w433e9763v2ee92e2f278ae988@mail.gmail.com>	 <485323C5.4030002@skyrush.com>	 <19f34abd0806140045l259bcb93ie4b7bfa2d73bd4d@mail.gmail.com>	 <48540343.4010200@skyrush.com>	 <19f34abd0806141334w67547e84hf1021c0fd1139b8b@mail.gmail.com>	 <48542F75.5070605@skyrush.com> <19f34abd0806141426o7ba13f91h6720db3609146e16@mail.gmail.com>
In-Reply-To: <19f34abd0806141426o7ba13f91h6720db3609146e16@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have done some more investigation on this problem, and I am posting
here my results in hope that someone can point me in the right direction
for further investigation...

Summary: during the initialization of a new bash shell, the terminal
foreground process group often reverts back to that of the parent of the
bash shell (after being set *to* the bash shell pgrp by bash),
prohibiting commands like stty from being run by the init scripts.  The
result is that the execution of these commands will hang until killed,
causing the bash prompt to not appear.  Adding a delay in the script
(using sleep) increases the chance of this having time to happen.

For example, putting the following in a user's .bashrc:

sleep 2
stty -ixany

is a good way to reproduce this.  doing "su <user>" from root (note that
the fact that no password is required helps the timing) will then often
hang.  Killing -9 stty will allow the bash prompt to appear.

I have instrumented the bash source code in an attempt to see why this
is happeneing, partly because I suspected a bug in bash.  What I have
found is this:

1) bash calls tcsetpgrp() with the pgrp of the bash process (two times)
before starting to execute init scripts.  This makes sense, since bash
needs to be the session leader.  It is never called again until just
before the bash shell exits normally (at which time it returns control
to the parent).

2) During the processing of the init scripts (sometimes .bashrc, but
sometimes a system script that is processed first), calling tcgetpgrp()
shows that the pgrp has reverted back to the "su <user>" process.  It
does not appear that bash reverted it in my testing so far.  Running
stty while in the reverted state causes a hang, since bash is not the
session leader.

So here is the question: is there a way/reason the kernel would revert
the pgrp of the session leader after bash sets it?  Is there some more
instrumenting in the kernel or in bash that might reveal what is going
on?  I have heard yet another report of this happening since I added to
the thread, and I can get it to happen easily on two different machines
(a desktop and a laptop).

						Thanks, Joe

