Return-Path: <linux-kernel-owner+w=401wt.eu-S1759376AbXERTI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376AbXERTI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 15:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbXERTIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 15:08:51 -0400
Received: from pool-72-92-171-78.albyny.east.verizon.net ([72.92.171.78]:50228
	"EHLO posidon.tmr.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752652AbXERTIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 15:08:50 -0400
Message-ID: <464DF9BF.6040000@tmr.com>
Date: Fri, 18 May 2007 15:08:47 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: glitch1 v1.6 script update and results on cfs-v13
Content-Type: multipart/mixed;
 boundary="------------050008000704080403050100"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050008000704080403050100
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The glitch1 script has been vastly updated, and now runs by itself after 
being started. It produces files with the fps from glxgears and a 
"fairloops" file which indicates the number of loops for each of the 
scrolling xterms. This gives a good indication of fairness, all 
processes should have about the same number of loops.

Testing 2.6.21.1-cfs-v13:

Using all default settings, all four processes ran the same number of 
loops over 40sec within about 8%. I'll have some neat results with 
standard deviation by the end of the weekend, it's supposed to rain. 
Visual inspection of the glxgears while running looked smooth as a 
baby's ass.

Current self-running script attached, I'm writing a doc, hopefully if 
you want to tune it the comments are clear.

*Note*: these values make sense when various schedulers and tuning 
values are run on the same machine. So I'll be testing on three 
machines, with dual-core, hyperthreaded uni, and pure uni. Unless I see 
a hint that one of these cases is handled less well than the others I 
won't compare.

-- 
Bill Davidsen
   He was a full-time professional cat, not some moonlighting
ferret or weasel. He knew about these things.

--------------050008000704080403050100
Content-Type: application/x-sh;
 name="glitch1.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="glitch1.sh"

#!/bin/bash
# look for glitches in scheduling
#   glitch1.sh 1.6 2007/05/18 18:49:22 davidsen Stable

Jobs=""

# xterm scroll option - SCROLL
#   -j - do jump scroll
#   +j - do one line scroll
# if SCROLL is specified that's used instead
scroll=${SCROLL:-"+j"}
#
# number of xwindows scrolling - MAXWIN
MaxWin=${MAXWIN:-4}

rm -f gl_loop*
for n in $(seq 1 ${MaxWin}); do
  vpos=$[(n-1)*80+50]
  xterm -geom 100x2-0+${vpos} ${scroll} \
  -e bash -c "exec 3>gl_loop$n; lc=0; while true; do echo \$RANDOM; let lc=lc+1; echo \$lc >&3; done" &
  Jobs="$Jobs $!"
done

# save the uname info for identification
uname -a >gl_uname

# track the resources in use
vmstat 1 >gl_vmstat &
Jobs="$Jobs $!"

echo -e "\nObserve the gear rotation for obvious glitches\n" \
  "Close the glxgears window to end this test early\n" \
  "Test will end automatically after about 40sec" >&2

# save the fps information
script -c 'glxgears & sleep 43; kill $!' gl_gears

# close the rest
kill ${Jobs}

# summarize the loop files
for n in $(seq 1 ${MaxWin})
do
  echo -n "$n "
  tail -n1 gl_loop$n
  rm gl_loop$n
done >gl_fairloops

--------------050008000704080403050100--
