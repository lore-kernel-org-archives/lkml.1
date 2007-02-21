Return-Path: <linux-kernel-owner+w=401wt.eu-S1750745AbXBUAoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750745AbXBUAoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 19:44:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbXBUAoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 19:44:01 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48722 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbXBUAoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 19:44:00 -0500
Date: Wed, 21 Feb 2007 09:42:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       roland@redhat.com, mtk-manpages@gmx.net
Subject: Re: [PATCH] fix handling of SIGCHILD from reaped child
Message-Id: <20070221094225.4071ac3f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070220172049.GA67@tv-sign.ru>
References: <20070220183220.41b3f1ca.kamezawa.hiroyu@jp.fujitsu.com>
	<20070220142257.GA155@tv-sign.ru>
	<20070221002526.c6b7edb0.kamezawa.hiroyu@jp.fujitsu.com>
	<20070220172049.GA67@tv-sign.ru>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007 20:20:49 +0300
Oleg Nesterov <oleg@tv-sign.ru> wrote:
> > > > +		clear_stale_sigchild(current, retval);
> > > 
> > > But we are not checking that SIGCHLD is blocked?
> > > 
> > I'm sorry if I don't read SUSv3 correctly. SUSv3 doesn't define how we should
> > do if SIGCHLD is not blocked.(so I don't check not-blocked case.)
> 
> Probably it is me who misunderstands SUSv3. Could you point me the reference
> to authoritative document? My understanding: if blocked AND wait() succeeds.
> 
I read this:
http://www.opengroup.org/onlinepubs/009695399/


> > IMHO, user's sig-child-handler is tend to call wait()/waitpid() and expects
> > successful return. So removing stale signal here may be good.
> 
> Yes. But sig-child-handler should do
> 
> 	while (wait() >= 0)
> 		....
> 
> anyway, because SIGCHLD is not a realtime signal.
> 

Ah...it looks I should explation why I found this more.

A user (who is migrated from Solaris) met following situation.
==(single threaded program.)

pid1 = fork();
if (!pid1) {
	do_something_forever();
}
....set SIGCHLD handler here to catch pid1's error-exit....

if (!pid2) {
	do_something_in_shortterm();
}
Block SIGCHLD
ret = waitpid(pid2, hoge, hoge); // wait for pid2
UNBlock SIGCHLD
==

And SIGCHLD handler didn't use WNOHANG. 
I asked him to fix his program. He agreed.(So, no problem now.)

While our problem was fixed, it seems Linux doesn't meet spec.(SUSv3)
So I posted. 
But this is rare situation and this fix makes codes ugly....


Thanks,
-Kame

