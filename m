Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbYIVQDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbYIVQDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 12:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbYIVQDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 12:03:45 -0400
Received: from 25.mail-out.ovh.net ([91.121.27.228]:47304 "HELO
	25.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752780AbYIVQDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 12:03:44 -0400
To: linux-kernel@vger.kernel.org
Subject: [sh4][2.6.17] latency peaks with unix sockets on heavy loads
MIME-Version: 1.0
Date: Mon, 22 Sep 2008 18:02:40 +0200
From: guillaume ranquet <guillaume.ranquet@the-organisation.net>
X-Webmail-UserID: darkebola@the-organisation.net
X-Originating-IP: 213.41.232.205
Organization: the-org
Message-ID: <f471b8e6b930392808744c55ab4f3629@localhost>
User-Agent: RoundCube Webmail/0.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 13976077018743178263
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm experiencing little glitches when I try to send/receive datas
with local sockets under heavy loads.
 under normal load it behaves normally, but with load increasing, I
get latency peaks once every second.
 an Image is worth a thousand words:
 http://img255.imageshack.us/img255/3700/capplottsy7.th.png
 X: time elapsed from beginning of execution
 Y: call latency
 red: under heavy load
 green: no load at all
 those peeks of 200ms really disturbs me as I'm using the sockets for
RPC calls and 200ms (and far more with load increasing) is really too
much.
 I've been testing various things
 enabling/disabling kernel preempt : no effects
 active waiting (doing some stuff that consumes cpu) between RPC
calls: no effects (even worse)
 non blocking sockets doesn't show any improvements and never yield
for a EWOULDBLOCK
 setting policy to SCHED_FIFO solves the problem:
http://img47.imageshack.us/img47/4449/capplotschedfifoxh5.th.png
 also, adding a usleep(0) between each call (still with SCHED_NORMAL
policy) removes the peaks
 from my understanding, usleep(0) puts the task in sleeping mode
until the next TICK is emitted and may cause a context switch if
there's another runnable task
 sched_yield()'ing once every 1000 calls helps also greatly (some
peaks still appears here and there though)

 upgrading to 2.6.23:
 h00rray it solves everything:
http://img371.imageshack.us/img371/7028/capplotkernel2623lldnl6.th.png
 still the mean time is a bit higher and provokes a 30% overhead at
running the test
 but my problem is that I can't upgrade my kernel (yet) and need to
find a solution on 2.6.17
 I couldn't reproduce the behavior of the 2.6.17 with the 2.6.23, no
matter the kernel config
 what has changed and could impact on that 'glitch' between the 2
kernels:
 -lock classes of AF_UNIX domain has became bh-unsafe :: seems out of
suspicion since the peaks hasn't shown up with AF_INET sockets
 -scheduler for SCHED_NORMAL tasks has been completely rewritten ::
seems to be guilty of the new (improved?)  behavior

 is that a known bug of the pre-CFS scheduler?
am I totally wrong and should not blame the scheduler?

is there a solution with 2.6.17 and SHED_NORMAL?

ps: since I'm not subscribed (my e-mail account can't handle the traffic),
would you please CC me?

