Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbYHYRh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbYHYRh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 13:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbYHYRhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 13:37:15 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:57908 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbYHYRhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 13:37:14 -0400
Message-ID: <48B2EDC2.1020608@davidnewall.com>
Date: Tue, 26 Aug 2008 03:07:06 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Chris Frey <cdfrey@foursquare.net>, Joe Peterson <joe@skyrush.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Visible Ctrl-C in latest kernels
References: <20080822201537.GA18242@foursquare.net> <19f34abd0808230253w663722dcwde1303998e194ddf@mail.gmail.com> <48B04E42.3030405@skyrush.com> <20080824010231.GA26030@foursquare.net> <20080825122024.GA19337@1wt.eu>
In-Reply-To: <20080825122024.GA19337@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> I would not be surprized that it is what has caused delays for Ctrl-C
> to take effect for some of us. As discussed in another thread on the
> subject, the problem was relatively recent and not easy to reproduce.
>   

I don't think so.  Joe Peterson raised A line of enquiry, which looked
quite promising to me, in
http://marc.info/?l=linux-kernel&m=121502197008293.  He observed weird
behaviour with pgrp, and that doesn't seem to have been explored
adequately.  I think it's worth highlighting that the code which sends
the signal is the following snippet, from n_tty.c:

    if (tty->pgrp)
            kill_pgrp(tty->pgrp, signal, 1);


I wonder if pgrp has a value different than we expect?


> Now we have a patch to try to revert if/when we finally get a reproducible
> case.

I had an idea; it didn't work out as I expected, but it did produce a
result that I can't immediately explain; and it might be relevant.  The
following program, when executed in background (./testprogram &) stops
at tcsetpgrp(), which is fine; and if then continued (fg), it is immune
to the interrupt, quit and suspend keys.  However, it is not immune to
those keys if executed in foreground (./testprogram).  As said, I can't
immediately explain this, and it seems like it might be important...

#include <unistd.h>
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>

main() {
        int i;
        pid_t pid = getpid();
        pid_t ppid = getppid();
        int tty = open("/dev/tty", 0);
        if (tty == -1) {
                perror("/dev/tty");
                exit(1);
        }
        printf("pid %d (pgrp %d), ppid %d (pgrp %d), pgrp %d\n", pid, getpgid(pid), ppid, getpgid(ppid), tcgetpgrp(tty));

        if (tcsetpgrp(tty, ppid) == -1) {
                perror("tcsetpgrp");
                exit(2);
        }

        for (i = 0; i < 5; i++) {
                sleep(1);
                write(1, ".", 1);
        }
        sleep(1);
        write(1, "\n", 1);

        return 0;
}


