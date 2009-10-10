Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbZJJJJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbZJJJJt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 05:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756034AbZJJJJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 05:09:49 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:64384 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003AbZJJJJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 05:09:48 -0400
Subject: ERESTARTSYS escaping from sem_wait with RTLinux patch
From: Blaise Gassend <blaise@willowgarage.com>
To: linux-kernel@vger.kernel.org
Cc: Jeremy Leibs <leibs@willowgarage.com>
Content-Type: multipart/mixed; boundary="=-Zk+/0dLwTR8xnwFbOzy2"
Organization: Willow Garage
Date: Sat, 10 Oct 2009 02:09:07 -0700
Message-Id: <1255165747.6385.117.camel@doodleydee>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Zk+/0dLwTR8xnwFbOzy2
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

The attached python program, in which 500 threads spin with microsecond
sleeps, crashes with a "sem_wait: Unknown error 512" (conditions
described below). This appears to be due to an ERESTARTSYS generated
from futex_wait escaping to user space (libc). My understanding is that
this should never happen and I am trying to track down what is going on.

Questions that would help me make progress:
-------------------------------------------

1) Where is the ERESTARTSYS being prevented from getting to user space? 

The only likely place I see for preventing ERESTARTSYS from escaping to
user space is in arch/*/kernel/signal*.c. However, I don't see how the
code there is being called if there no signal pending. Is that a path
for ERESTARTSYS to escape from the kernel?
        
The following comment in kernel/futex.h in futex_wait makes me wonder if
two threads are getting marked as ERESTARTSYS. The first one to leave
the kernel processes the signal and restarts. The second one doesn't
have a signal to handle, so it returns to user space without getting
into signal*.c and wreaks havoc.

    (...)
        /*
         * We expect signal_pending(current), but another thread may
         * have handled it for us already.
         */
        if (!abs_time)
                return -ERESTARTSYS;
    (...)

2) Why would this be happening only with RT kernels?

3) Any suggestions on the best place to patch/workaround this? 

My understanding is that if I was to treat ERESTARTSYS as an EAGAIN,
most applications would be perfectly happy. Would bad things happen if I
replaced the ERESTARTSYS in futex_wait with an EAGAIN?

Crash conditions:
-----------------

- RTLinux only.
- More cores seems to make things worse. Lots of crashes on a dual-quad
core machine. None observed yet on dual core. At least one crash on a
dual-quad core when run with "taskset -c 1"
- Various versions, including 2.6.29.6-rt23, and whatever the latest was
earlier today.
- Seen on both ia64 and x86
- Ubuntu hardy and jaunty
- Sometimes hapens within 2 seconds on a dual quad-core machine, other
times will go for up to 30 minutes to an hour without crashing. I
suspect a dependence on system activity, but haven't noticed an obvious
pattern.
- Time to crash appears to drop fast with more CPU cores.

--=-Zk+/0dLwTR8xnwFbOzy2
Content-Disposition: attachment; filename="threadprocs8.py"
Content-Type: text/x-python; name="threadprocs8.py"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

import threading
import time

exiting = False

def spin():
    while not exiting:
        time.sleep(0.000001)

for i in range(0,500):
    threading.Thread(target=spin).start()

try:
    spin()
finally:
    exiting = True

--=-Zk+/0dLwTR8xnwFbOzy2--

