Return-Path: <linux-kernel-owner+w=401wt.eu-S1757407AbXEISMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbXEISMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 14:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756167AbXEISMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 14:12:35 -0400
Received: from gw.goop.org ([64.81.55.164]:52012 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756120AbXEISMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 14:12:34 -0400
Message-ID: <46420F17.2050106@goop.org>
Date: Wed, 09 May 2007 11:12:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm2 - 100% CPU on ksoftirqd/1
References: <20070509012322.199f292b.akpm@linux-foundation.org> <4123.1178726923@turing-police.cc.vt.edu>
In-Reply-To: <4123.1178726923@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> It comes up with a screaming ksoftirqd - usually /1 but one boot had /0.
> Just sitting there, 100% CPU according to 'top'.  Tried 'echo t > /proc/sysrq-trigger' to get
> a trace, but it was always running on the other CPU - even after I reniced
> it down to 19 and launched 2 'for(;;)' C programs to suck the cycles.  It would
> be failing to get any CPU - until I did the 'echo t' and then it would be
> "running" again.  Anybody got any good debugging ideas here?
>   

Huh.  I've just been trying to find a problem with events/1 spinning
after boot in current -git.  I was worried I'd introduced it, but looks
like there might be a wider problem.

I tracked it down to kernel/workqueue.c:run_workqueue(), where the while
(!list_empty(&cwq->worklist)) loop spins forever.  It turns out that the
list_empty test was failing, but cwq->worklist was pointing to itself
(iow, worklist.next points to a self-pointing list node).

I haven't found how it was getting into that state, but the use of
list_del_init(cwq->worklist.next) looks suspect to me.

Curiously, it seems to escape this loop after about 4-5mins, and then
seems well-behaved from then on.  And it doesn't always happen.

And, of course, no changes in kernel/workqueue.c since Feb, so whatever
changed was somewhere else, and I guess it could have affected kevent in
the same way.

It always seems to happen on the last CPU; when I run the kernel as Xen
guest with 4 vcpus, it happens on events/3.

    J
