Return-Path: <linux-kernel-owner+w=401wt.eu-S1757455AbZINWaC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbZINWaC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 18:30:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757424AbZINWaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 18:30:01 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:7904 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757373AbZINWaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 18:30:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=sWEdeD+Nxl3BkOGIemF/QKYMDiWpHzHL3ceT9yNur+XzIraG7JArpQG6niNskXrJ3b
         /G1/NRIyDdO/XIn6eLIkdlJeIWYDuX8mVNE9uaoSSEg6+DCUoMQdD0d8YcPB3AQ5zdqv
         KuxsuC34Ig2Z5ORfVSAGl67cWNHvfm/OWkPDU=
MIME-Version: 1.0
From: Jason Garrett-Glaser <darkshikari@gmail.com>
Date: Mon, 14 Sep 2009 15:29:42 -0700
Message-ID: <28f2fcbc0909141529n4ee32d6t47ca8bdaf02dad@mail.gmail.com>
Subject: More BFS benchmarks and scheduler issues
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As an x264 developer, I have no position on the whole debate over
BFS/CFS (nor am I a kernel hacker), but a friend of mine recently ran
this set of tests with BFS vs CFS that still doesn't make any sense to
me and suggests some sort of serious suboptimality in the existing
scheduler:

>>>>>>>>>>>>>>>>>>

Background information necessary to replicate test:

Input file: http://media.xiph.org/video/derf/y4m/soccer_4cif.y4m
x264 source: git://git.videolan.org/x264.git
revision of x264 used: e553a4c
CPU: Core 2 Quad Q9300 (2.5GHz)
Kernel/distro/platform: 2.6.31 patched with the gentoo patchset, Gentoo, x86_64.
BFS patch: Latest available (BFS 220).
Methodology: Each test was run 3 times. The median of the three was
then selected.

./x264/x264 --preset ultrafast --no-scenecut --sync-lookahead 0 --qp
20 samples/soccer_4cif.y4m -o /dev/null --threads X
    BFS                 CFS
1: 124.79 fps       131.69 fps
2: 252.14 fps       192.14 fps
3: 376.55 fps       223.24 fps
4: 447.69 fps       242.54 fps
5: 447.98 fps       252.43 fps
6: 447.87 fps       253.56 fps
7: 444.79 fps       250.37 fps
8: 441.08 fps       251.95 fps


./x264/x264 -B 2000 samples/soccer_4cif.y4m -o /dev/null --threads X
    BFS                 CFS
1: 19.72 fps        19.97 fps
2: 39.03 fps        29.75 fps
3: 60.85 fps        39.83 fps
4: 68.60 fps        42.04 fps
5: 70.61 fps        43.78 fps
6: 71.35 fps        46.43 fps
7: 70.80 fps        48.02 fps
8: 70.68 fps        46.95 fps


./x264/x264 --preset veryslow --crf 20 samples/soccer_4cif.y4m -o
/dev/null --threads X
    BFS                 CFS
1: 1.89 fps         1.89 fps
2: 3.24 fps         2.78 fps
3: 4.18 fps         3.47 fps
4: 5.76 fps         4.61 fps
5: 6.07 fps         4.67 fps
6: 6.29 fps         4.90 fps
7: 6.52 fps         5.08 fps
8: 6.65 fps         5.27 fps

I noticed when running single threaded, BFS seemed to be jumping the
process between CPUs. So bonding the process to a single CPU I got
the below numbers.

taskset -c 0 $x264_cmd --threads 1
ultrafast:  130.76 fps
defaults:   20.01 fps
veryslow:   1.90 fps

<<<<<<<<<<<<<<<<<<

What is particularly troubling about these results is that this is not
a situation that should seriously challenge the scheduler (like a
thousand-thread HTTP server).  In ultrafast mode, the threading model
is phenomenally simple: each thread, if it gets too far ahead of the
previous thread, is blocked.  That's it. (full gory details at
http://akuvian.org/src/x264/sliceless_threads.txt)

In the other modes, the only complication is that there is one more
thread (lookahead) in front of all the main threads and all the main
threads are set to a lower priority via nice() in order to avoid
blocking on the lookahead thread.

Though I'm not a scheduler hacker, these enormous differences in an
application which is entirely CPU-bound and uses very few threads
strikes me as seriously wrong.

Jason Garrett-Glaser
