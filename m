Return-Path: <linux-kernel-owner+w=401wt.eu-S1752520AbZIHXmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbZIHXmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 19:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbZIHXmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 19:42:42 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:53712 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751651AbZIHXml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 19:42:41 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: [long] Another BFS versus CFS shakedown
Date: Wed, 9 Sep 2009 01:42:39 +0200
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jens Axboe <jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200909090142.41738.elendil@planet.nl>
X-OriginalArrivalTime: 08 Sep 2009 23:42:43.0700 (UTC) FILETIME=[0FA7AB40:01CA30DE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've also run some tests and have very consciously tried to pay attention 
to interactivity, while also trying to get some "hard" data.

I've only BCCed Con on this mail as I get the impression he'll not be 
interested in following the LKML thread.

Con: you are very welcome to follow up either privately or to lkml if you 
do want to follow up on any of the results.

System info
-----------
HP 2510p Core2 Duo 1.33GHz 2GB notebook
Debian stable ("Lenny"), KDE desktop environment
Wireless networking (iwlagn)
Notebook is in a docking station with a second (main) display connected
using "old" style X and graphics drivers (no KMS)

CFS was tested with 2.6.31-rc9
BFS was tested with 2.6.30.5 + the bfs-209 patch

In both cases I've not done anything special with kernel configs. I've 
just used my old .30 config as base for BFS, and my current .31 one for 
CFS. I can't remember making any changes since .30, which was confirmed
by a quick look at the diff.

Kernel configs + test script and logs available at:
http://alioth.debian.org/~fjp/tmp/linux_BFSvsCFS/

BFS general impression
----------------------
I've used BFS for over a day yesterday and today, and in general I'm very 
impressed. During normal use (coding and testing a shell script that's 
CPU/memory heavy + normal mail/news/browser + amarok) I've not seen any 
strange issues. My notebook even suspended and resumed (StR) without any 
problems.

With CFS I regularly have short freezes of the mouse cursor or when 
typing. I think that it's related to KDE's news reader knode updating 
from my local news server. With CFS I also saw such freezes a few times, 
but they _seemed_ less frequent and less severe. No hard data though.

But this evening, while I was preparing and running the tests, I've had 4 
freezes of the desktop. The first two times it was only a partial freeze: 
taskbar was frozen, but I could still switch apps and use the graphical 
console; the last two times it was a full freeze of the display and 
keyboard (incl. e.g. numlock), but in the background everything continued 
to run normally and I could log in over SSH without any problem. On 
reboot some file systems did fail to unmount though.

Normally my desktop and X.Org are 100% reliable.


Test description
----------------
I've done two tests. The first consisted of:
- playing Marillion's "B'Sides Themselves" in amarok from an NFS share
- having the game "Chromium B.S.U." displaying it's opening graphics on
  the laptop display; this has very smoothly flowing graphics and is
  thus a nice visual reference for latency issues; the game itself is
  quite fast-paced and can get starved quite easily
- the two tasks above resulted in ~10% overall CPU usage
- running a script with kernel compiles and that script I had been
  working on

The script was invoked as:
./scheduler-tests 2>&1 | tee `uname -r`.log

The main steps in the script are:
- stop cron; clear ccache; prepare for kernel build (allnoconfig)
- 3 x make -j4 kernel build; 2 with 'time', 1 with Jens' 'latt' [1]
- 3 x make -j2 kernel build; 2 with 'time', 1 with Jens' 'latt' [1]
- 4 runs of my own script [2], the last two in parallel

[1] I used Peter's version from:
    http://marc.info/?l=linux-kernel&m=125242343131497&w=2
[2] The script produces .dot files showing graphs of Debian package
    depencies: http://alioth.debian.org/~fjp/debtree/
    It very inefficiently queries the package management databases
    and forks insane numbers of sub shells, but the output is great ;-)

Disclaimer: I have no idea what the numbers from 'latt' mean or how 
reliable they are.

The second test was:
- still playing Marillion
- playing a movie that's streamed from vlc on my server to vlc on the
  laptop display of the notebook, with sound muted
- running a make -j4 kernel compile
- actually playing Chromium

Test results
------------
Right, let's get down to the meat after that long intro.
Challenger goes first.

                	  BFS				  CFS
		=========================	==========================
make -j4 (1)	real	2m40.232s		real	2m41.907s
	time	user	3m25.617s		user	3m15.792s
		sys	0m34.450s		sys	0m33.534s

make -j4 (2)	real	2m16.196s		real	2m19.140s
	time	user	3m16.212s		user	3m6.052s
		sys	0m32.770s		sys	0m31.930s

make -j4 (3)	Entries: 3088 (clients=8)	Entries: 3168 (clients=8)
	latt	Max	    19066 usec		Max	    23665 usec
		Avg	       73 usec		Avg	     8637 usec
		Stdev	      694 usec		Stdev	     7565 usec
---------------
make -j2 (1)	real	2m14.962s		real	2m32.508s
	time	user	3m8.740s		user	3m8.320s
		sys	0m32.470s		sys	0m31.554s

make -j2 (2)	real	2m15.650s		real	2m33.396s
	time	user	3m8.428s		user	3m3.147s
		sys	0m31.490s		sys	0m31.566s

make -j2 (3)	Entries: 1568 (clients=4)	Entries: 1732 (clients=4)
	latt	Max	     8064 usec		Max	    24859 usec
		Avg	       78 usec		Avg	     9431 usec
		Stdev	      393 usec		Stdev	     7431 usec
---------------
debtree (1)	real	1m31.299s		real	1m8.275s
	time	user	1m13.973s		user	0m46.395s
		sys	0m19.653s		sys	0m14.277s

debtree (2)	real	1m27.140s		real	1m3.181s
	time	user	1m15.441s		user	0m46.223s
		sys	0m19.765s		sys	0m14.097s

Difference between (1) and (2) is probably that for (1) the cache was 
still empty, while during (2) all needed data was already in memory.

debtree (3)	This is mostly as background for (4) which ran in parallel.
	time	Results are not fully comparable due to timing issues!
		real	1m20.773s		real	1m6.512s
		user	1m5.460s		user	0m46.251s
		sys	0m17.813s		sys	0m13.361s

debtree (4)	Entries: 160 (clients=4)	Entries: 192 (clients=4)
	latt	Max	      134 usec		Max	    21214 usec
		Avg	       27 usec		Avg	    12139 usec
		Stdev	       17 usec		Stdev	     6707 usec

Observations during scripted tests
----------------------------------
- music play was never a problem
- with CFS the Chromium opening graphics stayed smooth and at close to
  normal speed, some minor slowdown only during -j4 kernel builds
- with BFS there was a very notable slowdown and sometimes short skips
  in the Chromium opening graphics during -j4 compiles; during -j2
  compiles it stayed smooth, with maybe a very slight slowdown
- with CFS overall CPU usage is horrible during -j2 kernel compiles:
  top -d1 shows idle of between 5 and 30% (!), probably averaging around
  15% and that's with amarok and chromium running as well; for -j4 it is
  close to 100% full time;
- BFS shows very close to 100% with both -j2 and -j4

Observations during interactive tests
-------------------------------------
Unfortunately the desktop froze completely with BFS very shortly after I
started the test, so observations are not completely reliable.

- with CFS the movie showed major skips during -j4 compile and Chromium
  was only barely playable (and zero fun); with compile at nice -n 10
  Chromium was a lot more playable, but movie still skipped a lot
- with BFS I only had a _very_ short observation period, but the movie
  seemed to play almost completely normally, even _without_ niceing -j4;
  at the same time the game was similar to CFS after nicing the build

Very Rough Conclusions
----------------------
* BFS is faster in real time for both -j4 and -j2 kernel compiles, but
  uses more resources getting there
* CFS might have done better if it'd been using CPUs at 100%
* BFS is indeed more efficient at -j2 than -j4 on a system with 2 cores,
  but when running more tasks than cores slowdown in interactive tasks
* BFS does significantly worse running my script, which means that I lost
  time doing my development work yesterday and today :-(
* BFS shows significantly better "latt" figures
* But at the same time only BFS showed notable slowdown in Chromium during
  kernel compiles
* BFS seems to distribute capacity much more equally and fluently: when
  there is too much work and no priorities are assigned, all tasks suffer,
  but none are starved
* there is certainly room for improvement in CFS; the under-usage of the
  CPUs and movie skips are quite bad

With BFS I suspect that running the kernel builds niced, which I normally 
do, would have shown perfect Chromium behavior.


I won't have opportunity to do follow-up testing in the very short term, 
but am in general prepared to spend more time on this in the coming 
months.

Hope this is of value.

Cheers,
FJP
