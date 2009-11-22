Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbZKVVOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbZKVVOv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 16:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbZKVVOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 16:14:51 -0500
Received: from isrv.corpit.ru ([81.13.33.159]:53391 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754638AbZKVVOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 16:14:50 -0500
Message-ID: <4B09A9CE.4080300@msgid.tls.msk.ru>
Date: Mon, 23 Nov 2009 00:14:54 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Why processes on linux loses signals?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's a very old issue, but I still don't know an answer.

In short, processes on linux loses signals.  It happens
rarely, but it happens, and the frequency of this happening
is enough to be annoying.

For example, I've a program that used alarm(2) to periodically
check for something.  Nothing fancy, nothing interesting is done
in the signal handler, no long operations or something, plain
signal(2) with sighandler just setting a global variable.  When
under heavy usage (it's a DNS nameserver), in about a week
(sometimes a few hours, sometimes after a month) it stops checking
for updates, because apparently some sigalrm got lost.

For this program I had to replace alarm() with setitimer(), but
only on linux.  On all other operating systems (Solaris, FreeBSD,
HP/UX, AIX) where it is used, everything works as expected.

Another common issue is SIGIO-based event loop.  For a classical
form of it, on a non-heavily-loaded process.  Quite often server
loses SIGIO so even if an I/O is possible, the process does not
know.  The pending (or stuck) I/O gets processed on receipt of
next SIGIO that indicates readiness of another filedescriptor --
since after SIGIO a process does poll() it notices both.

A "classical" (for me) example of this is an Oracle database
version 8 (we've many of these in production still; in later
versions they rewrote the event loop to use different techniques).
There, there's a dispatcher process that does nothing but listens
on the network, receives requests and sends them to a set of
worker processes.  Everything is non-blocking and the process
mostly does nothing.  It is very annoying when trivial actions
in a user application causes loooong delays - when an app sent
some request to oracle db and that request stuck in the event
queue because the corresponding SIGIO was never delivered.  It
helps immediately to make another connection to the same DB to
"unstuck" that request.  It is done transparently when there are
many users are working with the database at the same time, each
making requests --- this way any stuck/lost I/O unstucks immediately
because new requests are coming from other users; but at evenings
or over periods of small activity it becomes real problem.

I looked at the server behavour numerous times -- the server (oracle)
works quite reasonable, strace is sane enough.  That to say, one
can't blame "stupid closed-source programmers" for this.

There are other examples like this, all involving lost signals.
The two above are just the most "famous" for me.

The problem becomes much much worse when a system has multiple
cores.  On single-CPU system such situation is rare enough to
become almost unnoticeable.  But with even second core the issue
emerges almost immediately - enough for many users to start calling
techsupport because their apps are very slow.

Last time I asked similar question here, I was told that signals
are unreliable and should not be used.  But what is the reason for
the unreliability, and why signals should be unreliable on linux
only?

Thanks!

/mjt
