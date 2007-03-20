Return-Path: <linux-kernel-owner+w=401wt.eu-S932794AbXCTMix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794AbXCTMix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 08:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933177AbXCTMix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 08:38:53 -0400
Received: from dks103.neoplus.adsl.tpnet.pl ([83.24.22.103]:59645 "EHLO
	dks103.neoplus.adsl.tpnet.pl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932794AbXCTMiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 08:38:52 -0400
X-Greylist: delayed 461 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Mar 2007 08:38:51 EDT
Message-ID: <45FFD40A.1090104@o2.pl>
Date: Tue, 20 Mar 2007 13:31:06 +0100
From: Artur Skawina <art_k@o2.pl>
User-Agent: Thunderbird 3.0a1 (X11/20070201)
MIME-Version: 1.0
To: Xavier Bestel <xavier.bestel@free.fr>
CC: Willy Tarreau <w@1wt.eu>, Linus Torvalds <torvalds@linux-foundation.org>,
       Mark Lord <lkml@rtr.ca>, Al Boldi <a1426z@gawab.com>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RSDL v0.31
References: <200703042335.26785.a1426z@gawab.com> <200703172048.46267.kernel@kolivas.org> <1174125534.7734.2.camel@Homer.simpson.net> <200703172355.30989.a1426z@gawab.com> <45FEB54A.3040602@rtr.ca> <1174321617.30876.69.camel@frg-rhel40-em64t-04> <45FEBBF5.9060002@rtr.ca> <1174322580.30876.72.camel@frg-rhel40-em64t-04> <Pine.LNX.4.64.0703192006130.6730@woody.linux-foundation.org> <20070320061152.GW943@1wt.eu> <1174381383.30876.86.camel@frg-rhel40-em64t-04>
In-Reply-To: <1174381383.30876.86.camel@frg-rhel40-em64t-04>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Xavier Bestel wrote:
> On Tue, 2007-03-20 at 07:11 +0100, Willy Tarreau wrote:
>> I don't agree with starting to renice X to get something usable
> 
> X looks very special to me: it's a big userspace driver, the primary
> task handling user interaction on the desktop, and on some OS the part
> responsible for moving the mouse pointer and interacting with windows is
> even implemented as an interrupt handler, and that for sure provides for
> smooth user experience even on very low-end hardware. Why not compensate
> for X design by prioritizing it a bit ?
> If RSDL + reniced X makes for a better desktop than sotck kernel + X, on
> all kind of workloads, it's good to know.

No, running X at a different priority than its clients is not really
a good idea. If it isn't immediately obvious why try something like
this:

mkdir /tmp/tempdir
cd /tmp/tempdir
for i in `seq -w 1 10000` ; do touch
longfilenamexxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx$i
; done
nice --20 xterm &
xterm &
nice -20 xterm &

then do "time ls -l ." in each xterm.

This is what i get on UP 2.6.20+RSDL.31 w/ X at nice 0:
-20: 0m0.244s user   0m0.156s system   0m3.113s elapsed   12.84% CPU
  0: 0m0.216s user   0m0.168s system   0m2.801s elapsed   13.70% CPU
 19: 0m0.188s user   0m0.196s system   0m3.268s elapsed   11.75% CPU

I just made this simple example up and it doesn't show the problem
too well, but you can already see the ~10% performance drop. It's
actually worse in practice, because for some apps the increased
amount of rendering is clearly visible; text areas scroll
line-by-line, content is incrementally redrawn several times etc.
This happens because an X server running at a higher priority than a
client will often get scheduled immediately after some x11 traffic
arrives; when the process priorities are equal usually the client
gets a chance to supply some more data. IOW by renicing the server
you make X almost synchronous.

This isn't specific to RSDL - it happens w/ any cpu scheduler; and
while the effects of less extreme prio differences (ie -5 instead of
-20 etc) may be less visible i also doubt they will help much.

A better approach to X interactivity might be allowing the server to
use (part of) the clients timeslice, but it's not trivial -- you'd
only want to do that when the client is waiting for a reply and you
almost never want to preempt the client just because the server
received some data.

As to RSDL - it seems to work great for desktop use and feels better
than mainline. However top output under 100% load (eg kernel
compilation) looks like below -- the %CPU error seems a bit high...

Tasks:  97 total,   6 running,  91 sleeping,   0 stopped,   0 zombie
Cpu(s): 81.7% us, 18.3% sy,  0.0% ni,  0.0% id,  0.0% wa,  0.0% hi,
 0.0% si
  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND

 7566 root      17   0  9196 4108 1188 R  3.0  0.8   0:00.09 cc1

 7499 root      11   0  1952  924  648 S  0.3  0.2   0:00.01 make

12279 root       1   0  5556 2928 2064 S  0.3  0.6   0:00.83 xterm

31510 root       1   0  2152 1100  840 R  0.3  0.2   0:00.25 top

    1 root       1   0  1584   88   60 S  0.0  0.0   0:00.30 init



artur
