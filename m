Return-Path: <linux-kernel-owner+w=401wt.eu-S932431AbXCKBrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431AbXCKBrl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 20:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932440AbXCKBrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 20:47:41 -0500
Received: from waste.org ([66.93.16.53]:37758 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932431AbXCKBrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 20:47:40 -0500
Date: Sat, 10 Mar 2007 19:35:06 -0600
From: Matt Mackall <mpm@selenic.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@osdl.org
Subject: RSDL-mm 0.28
Message-ID: <20070311013506.GD10459@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've tested -mm2 against -mm2+noyield and -mm2+rsdl+noyield. The
noyield patch simply makes the sched_yield syscall return immediately.
Xorg and all tests are run at nice 0.

Loads:
 memload: constant memcpy of 16MB buffer
 execload: constant re-exec of a trivial shell script
 forkload: constant fork and exit of a trivial shell script
 make -j 5: hot-cache kernel build without ccache
 make -j 5 ccache: hot-cache kernel build with ccache

Tests:
 beryl - 3D window manager, wiggle windows, spin desktop, etc.
 galeon - web browser, rapidly scrolling long web pages by grabbing
    the scroll bar
 mp3 - XMMS on a FUSE sshfs over wireless (during all tests)
 terminal - responsiveness of ssh and local terminal sessions
 mouse - responsiveness of mouse pointer

Results:
 great = completely smooth
 good = fully responsive
 ok = visible latency
 bad = becomes difficult to use (or mp3 skips)
 awful = make it stop, please

          -mm2        -mm2+noyield   rsdl+noyield
no load
 beryl    great       great          great
 galeon   good        good           good
 mp3      good        good           good
 terminal good        good           good
 mouse    good        good           good
memload x10
 beryl    awful/bad   great          good
 galeon   good        good           ok/good
 mp3      good        good           good
 terminal good        good           good
 mouse    good        good           good
execload x10
 beryl    awful/bad   bad/good       good
 galeon   good        bad/good       ok/good
 mp3      good        bad            good
 terminal good        bad/good       good
 mouse    good        bad/good       good
forkload x10
 beryl    good        good           great
 galeon   good        good           ok/good
 mp3      good        good           good
 terminal good        good           ok/good
 mouse    good        good           good
make -j 5
 beryl    ok          good           good/great
 galeon   good        good           ok/good
 mp3      good        good           good
 terminal good        good           good
 mouse    good        good           good
make -j 5 ccache
 beryl    ok          good           awful
 galeon   good        good           bad
 mp3      good        good           bad
 terminal good        good           bad/ok
 mouse    good        good           bad/ok

make -j 5
real      8m1.857s    8m50.659s      8m9.282s
user      7m19.127s   8m3.494s       7m30.740s
sys       0m30.910s   0m33.722s      0m29.542s

make -j 5 ccache
real      2m6.182s    2m19.032s      2m1.832s
user      1m39.466s   1m48.787s      1m37.250s
sys       0m19.741s   0m22.993s      0m20.109s

There's a substantial performance hit for not yield, so we probably
want to investigate alternate semantics for it. It seems reasonable
for apps to say "let me not hog the CPU" without completely expiring
them. Imagine you're in the front of the line (aka queue) and you
spend a moment fumbling for your wallet. The polite thing to do is to
let the next guy in front. But with the current sched_yield, you go
all the way to the back of the line.

RSDL makes most of the noyield hit back in normal make and then some
with ccache. Impressive. But ccache is still destroying interactivity
somehow. The ccache effect is fairly visible even with non-parallel
'make'.

Also note I could occassionally trigger nasty multi-second pauses with
-mm2+noyield under exectest that didn't show up elsewhere. That's
probably a bug in the mainline scheduler.

-- 
Mathematics is the supreme nostalgia of our time.
