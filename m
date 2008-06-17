Return-Path: <linux-kernel-owner+w=401wt.eu-S1759362AbYFQPdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362AbYFQPdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 11:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757982AbYFQPdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 11:33:03 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:41444 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576AbYFQPdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 11:33:01 -0400
Message-ID: <4857D92A.8040402@skyrush.com>
Date: Tue, 17 Jun 2008 09:32:58 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Alan Cox <alan@redhat.com>
CC: Vegard Nossum <vegard.nossum@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Newall <davidn@davidnewall.com>, Willy Tarreau <w@1wt.eu>,
       Harald Dunkel <harald.dunkel@t-online.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: su gets stuck for root
References: <48434D57.6030801@skyrush.com> <48438126.3080308@t-online.de> <20080602053256.GF5609@1wt.eu> <20080602091016.571dda7c@core> <4843B6EE.8080104@davidnewall.com> <20080602102033.63e4cd18@core> <19f34abd0806020316v4135935dxff04bcf663ebd4bf@mail.gmail.com> <20080602105027.GG18697@devserv.devel.redhat.com>
In-Reply-To: <20080602105027.GG18697@devserv.devel.redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> This looks correct to me and in fact I see the behaviour you report on 2.6.23
> when running it. If I tell it to ignore SIGTTOU that also then behaves as
> expected.
> 
> If
> 	your pgrp is not the pgrp of the tty
> 	and you are not ignoring TTOU
> 	and you are not orphaned (as a group)
> 
> 	Then we are *supposed* to send you SIGTTOU and kick you back
> 	into touch.

OK, I am still baffled.  I've thought of several different theories,
wondering if bash does not have the right parent process, how there
could be a race in the kernel or elsewhere, but as far as I can tell,
things are in order.  Here's the ps -ax --forest output while hung:

 6435 tty3     Ss     0:00 /bin/login --
 7954 tty3     S      0:00  \_ -bash
 7958 tty3     S+     0:00      \_ su foo
 7959 tty3     S      0:00          \_ bash
 7964 tty3     T      0:00              \_ stty -ixany

I had logged into the tty as root (with shell set to bash), then su'd to
foo (with shell set to bash), so this tree makes sense.  During the
sleep before the stty, sleep is under the final bash similar to the way
stty is while it is hung.

Note that the stty is a child of bash (which, BTW, sometimes appears as
"-su" instead - I am not clear on that), and they all lead back to the
original tty, which I gather is the session leader (or is it the "su"?).

Now, the debugging I did shows that the reason that tty_check_change()
returns an error is that the tty->pgrg != task_pgrp(current).  The
former is the "su foo" process, and the latter is the bash child process.

So I guess that when it does work, they are the same process, but why
would they be the same (or not, as it were)?  Does something happen
during bash startup that causes bash to become the session leader?

Please, please, someone who understands the mechanics better than I let
me know how I can explore this more deeply.

						Thanks, Joe
