Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957Ab0AQWgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab0AQWgh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 17:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384Ab0AQWgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 17:36:36 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:55942 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab0AQWgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 17:36:35 -0500
Date: Sun, 17 Jan 2010 23:36:34 +0100
From: Andreas Mohr <andi@lisas.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Clemens Ladisch <clemens@ladisch.de>,
       Ingo Molnar <mingo@redhat.com>
Subject: Really weird timer behaviour (event lag) when emacs21-x is running
	(2.6.33-rc4)
Message-ID: <20100117223634.GA12785@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I've got a load test which I'm running from time to time,
and today I noticed the following:
everything was quite ok when launching several dozen apps, but as soon
as emacs21-x (Debian) was started, I noticed that top display
actually didn't update any more. Wiggle the mouse / keyboard (as is so
well-known from earlier issues with nohz etc.), and it does update,
immediately.

Well, in fact top display does update even when not wiggling,
just not in 3-second intervals any more, more like every dozen seconds or so.

emacs21-x does lots of

poll([{fd=4, events=POLLIN}], 1, -1)    = 1 ([{fd=4, revents=POLLIN}])
read(4,
"\1\0rX\0\0\0\0\35\0\0\1\0\0\0\0\4\0\0\0\0\0\0\0(\35@\n\0\0\0\0", 4096)
= 32
read(4, 0x84a2940, 4096)                = -1 EAGAIN (Resource
temporarily unavailable)
--- SIGALRM (Alarm clock) @ 0 (0) ---
gettimeofday({1263766587, 638092}, NULL) = 0
gettimeofday({1263766587, 638236}, NULL) = 0
setitimer(ITIMER_REAL, {it_interval={0, 0}, it_value={0, 1000}}, NULL) =
0
sigreturn()                             = ? (mask now [IO])
poll([{fd=4, events=POLLIN|POLLOUT}], 1, -1) = 1 ([{fd=4,
revents=POLLOUT}])
writev(4, [{"\17\1\2\0z\0\240\3", 8}, {NULL, 0}, {"", 0}], 3) = 8
poll([{fd=4, events=POLLIN}], 1, -1)    = ? ERESTART_RESTARTBLOCK (To be
restarted)
--- SIGALRM (Alarm clock) @ 0 (0) ---
gettimeofday({1263766587, 647191}, NULL) = 0
gettimeofday({1263766587, 647347}, NULL) = 0
setitimer(ITIMER_REAL, {it_interval={0, 0}, it_value={0, 1000}}, NULL) =
0
sigreturn()                             = ? (mask now [IO])
poll([{fd=4, events=POLLIN}], 1, -1)    = ? ERESTART_RESTARTBLOCK (To be
restarted)
--- SIGALRM (Alarm clock) @ 0 (0) ---
gettimeofday({1263766587, 648973}, NULL) = 0
gettimeofday({1263766587, 649117}, NULL) = 0
setitimer(ITIMER_REAL, {it_interval={0, 0}, it_value={0, 1000}}, NULL) =
0
sigreturn()                             = ? (mask now [IO])
poll([{fd=4, events=POLLIN}], 1, -1)    = ? ERESTART_RESTARTBLOCK (To be
restarted)
--- SIGALRM (Alarm clock) @ 0 (0) ---
gettimeofday({1263766587, 650808}, NULL) = 0
gettimeofday({1263766587, 650956}, NULL) = 0
setitimer(ITIMER_REAL, {it_interval={0, 0}, it_value={0, 1000}}, NULL) =
0
sigreturn()                             = ? (mask now [IO])
poll([{fd=4, events=POLLIN}], 1, -1)    = ? ERESTART_RESTARTBLOCK (To be
restarted)
--- SIGALRM (Alarm clock) @ 0 (0) ---
gettimeofday({1263766587, 652597}, NULL) = 0
gettimeofday({1263766587, 652741}, NULL) = 0
setitimer(ITIMER_REAL, {it_interval={0, 0}, it_value={0, 1000}}, NULL) =
0
sigreturn()                             = ? (mask now [IO])
poll([{fd=4, events=POLLIN}], 1, -1)    = ? ERESTART_RESTARTBLOCK (To be
restarted)
--- SIGALRM (Alarm clock) @ 0 (0) ---
gettimeofday({1263766587, 657317}, NULL) = 0
gettimeofday({1263766587, 657471}, NULL) = 0
setitimer(ITIMER_REAL, {it_interval={0, 0}, it_value={0, 1000}}, NULL) =
0

Once emacs21-x window gets shown on screen, I get much higher sys times
than before.
A typical top output is:

top - 23:21:24 up 45 min,  6 users,  load average: 1.03, 2.02, 2.22
Tasks: 143 total,   3 running, 140 sleeping,   0 stopped,   0 zombie
Cpu(s): 41.7%us, 58.3%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Mem:    510984k total,   499656k used,    11328k free,     7020k buffers
Swap:   755044k total,    87656k used,   667388k free,   141132k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 2409 root      20   0  163m  58m 4940 R 51.9 11.7   5:51.54 Xorg
 5496 andi      20   0 15084 8236 3908 S 21.7  1.6   0:11.01 emacs21-x
 2949 andi      20   0 14120 4736 3508 S 19.3  0.9   1:44.62 icewm
 4062 andi      20   0 30088 2960 1668 S  1.9  0.6   0:13.61 xmms
 2953 andi      20   0  136m  15m 8588 S  1.4  3.0   0:43.91
x-terminal-emul
 4063 andi      20   0  218m  24m 6652 S  1.1  4.8   0:09.35 xine


With emacs21-x killed:

top - 23:22:58 up 47 min,  6 users,  load average: 1.25, 1.85, 2.14
Tasks: 141 total,   1 running, 140 sleeping,   0 stopped,   0 zombie
Cpu(s): 13.6%us,  8.6%sy,  0.0%ni, 77.5%id,  0.3%wa,  0.0%hi,  0.0%si,
0.0%st
Mem:    510984k total,   496572k used,    14412k free,     7096k buffers
Swap:   755044k total,    89032k used,   666012k free,   142860k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 2409 root      20   0  163m  58m 5060 S 10.2 11.7   6:31.77 Xorg
 2953 andi      20   0  136m  17m  10m S  3.6  3.5   0:45.95
x-terminal-emul
 4291 andi      20   0  111m  24m 6928 S  1.6  5.0   0:12.35 acroread
 2949 andi      20   0 14120 4812 3520 S  1.3  0.9   1:59.53 icewm
 4062 andi      20   0 30088 2944 1664 S  1.3  0.6   0:15.21 xmms


Note that this is on a P3/700 with available_clocksource narrowed down
to acpi_pm only, PIT running and lapic enabled (and no HPET either -
IOW very poor hardware environment).

It could just as well be that the setitimer loop that emacs21-x does is
simply overwhelming the system so much (and with the 50% system load as
indicated above! Perhaps due to PIT I/O penalties or so...)
that it's not even able to update the 3-second refresh of top any more.
However, since wiggling the mouse almost always _immediately_
updates top output, this suggests that the system isn't really _fully_
overloaded, yet we simply somewhere miss the chance to process waiting
events, since we're so busy reprogramming timers or so.

Or, even more drastically speaking, the timer reprogramming/insertion (of a
painfully slow legacy timer device) being done by a different app
actually seems to manage to make us actively lose triggers
of the unrelated running top.
Or it could just be a timer lock contention issue...

Any thoughts?

Andreas Mohr
