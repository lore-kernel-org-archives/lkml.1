Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbZLITYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbZLITYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 14:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757392AbZLITYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 14:24:25 -0500
Received: from higgs.elka.pw.edu.pl ([194.29.160.5]:47645 "EHLO
	higgs.elka.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384AbZLITYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 14:24:24 -0500
X-Greylist: delayed 819 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Dec 2009 14:24:24 EST
X-Comment: RFC 2476 MSA function at elektron.elka.pw.edu.pl logged sender identity as: wzabolot
Message-ID: <4B1FF616.8010900@ise.pw.edu.pl>
Date: Wed, 09 Dec 2009 20:10:14 +0100
From: wzab <wzab@ise.pw.edu.pl>
Reply-To: wzab@ise.pw.edu.pl
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "Zabolotny, Wojciech" <wzab@ise.pw.edu.pl>
Subject: Driver snd-hrtimer - causing system freeze with Rosegarden 
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------010809070109030206060208"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010809070109030206060208
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

When I try to use the "HR timer" as a MIDI sequencer timer in the
Rosegarden (http://www.rosegardenmusic.com) application, the system
freezes. Another people also reported similar problems with other
sequencer - OpenOctave (
https://linuxmusicians.com/viewtopic.php?f=27&p=8917 )

I have tested the problem on two SMP machines with diffrent kernels
(2.6.30, 2.6.31.6, 2.6.32).
The problem seems to be associated with the "snd-hrtimer" module.
I've tried to run the application vie remote X session, while having the
text console active.
Before the machine froze, the following messages have been displayed in
the console:

System 1 (Intel(R) Pentium(R) 4 CPU 2.80GHz HT)

hrtimer: interrupt too slow, forcing clock min delta to 3568 ns

System 2 (Intel(R) Core(TM)2 CPU         T5500  @ 1.66GHz)
hrtimer: interrupt too slow, forcing clock min delta to 11103 ns
CE: hpet increasing min_delta_ns to 15000 nsec
CE: hpet increasing min_delta_ns to 22500 nsec
CE: hpet increasing min_delta_ns to 33750 nsec

Analyzing the problem, I had an idea, that maybe the snd-hrtimer should
be rewritten to call
the callback via tasklet (I attach my patch only as an ilustration, my
code doesn't work either),
 however then I got the message "BUG: scheduling while atomic" or
something like this
 from the snd_hrtimer_stop function called from _snd_timer_stop.
Therefore I've tried to investigate the snd_hrtimer_stop more thoroughly.

Looking further into the code, I have found, that snd_hrtimer_stop may
be called
from the callback routine (e.g.:
http://lxr.linux.no/linux+v2.6.32/sound/core/timer.c#L709 or
http://lxr.linux.no/linux+v2.6.32/sound/core/timer.c#L719 )

It seems to me, that calling hrtimer_cancel (in the original code),
which waits for the handler to finish,
from that handler  may lock the machine...
(snd_hrtimer_callback calls the snd_timer_interrupt:
http://lxr.linux.no/linux+v2.6.32/sound/core/hrtimer.c#L47
which in turn calls snd_hrtimer_stop (as above) which calls hrtimer_cancel).


Unfortunately currently I have no idea how to fix this problem. Maybe
snd_hrtimer_stop shouldn't try to cancel the timer,
instead setting a flag causing callback to return immediately without
rearming of the timer?

-- 
Best regards,
Wojtek Zabolotny
wzab@ise.pw.edu.pl


--------------010809070109030206060208
Content-Type: text/x-patch;
 name="hrtimer.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="hrtimer.patch"

--- hrtimer.c	2009-11-10 01:32:31.000000000 +0100
+++ /tmp/hrtimer.c	2009-12-09 19:10:34.000000000 +0100
@@ -36,12 +36,13 @@
 
 struct snd_hrtimer {
 	struct snd_timer *timer;
-	struct hrtimer hrt;
+	struct tasklet_hrtimer thrt;
 };
 
 static enum hrtimer_restart snd_hrtimer_callback(struct hrtimer *hrt)
 {
-	struct snd_hrtimer *stime = container_of(hrt, struct snd_hrtimer, hrt);
+	struct tasklet_hrtimer *thrt = container_of(hrt, struct tasklet_hrtimer, timer);
+	struct snd_hrtimer *stime = container_of(thrt, struct snd_hrtimer, thrt);
 	struct snd_timer *t = stime->timer;
 	hrtimer_forward_now(hrt, ns_to_ktime(t->sticks * resolution));
 	snd_timer_interrupt(stime->timer, t->sticks);
@@ -55,9 +56,8 @@
 	stime = kmalloc(sizeof(*stime), GFP_KERNEL);
 	if (!stime)
 		return -ENOMEM;
-	hrtimer_init(&stime->hrt, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	tasklet_hrtimer_init(&stime->thrt, snd_hrtimer_callback, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	stime->timer = t;
-	stime->hrt.function = snd_hrtimer_callback;
 	t->private_data = stime;
 	return 0;
 }
@@ -67,7 +67,7 @@
 	struct snd_hrtimer *stime = t->private_data;
 
 	if (stime) {
-		hrtimer_cancel(&stime->hrt);
+		tasklet_hrtimer_cancel(&stime->thrt);
 		kfree(stime);
 		t->private_data = NULL;
 	}
@@ -78,7 +78,7 @@
 {
 	struct snd_hrtimer *stime = t->private_data;
 
-	hrtimer_start(&stime->hrt, ns_to_ktime(t->sticks * resolution),
+	tasklet_hrtimer_start(&stime->thrt, ns_to_ktime(t->sticks * resolution),
 		      HRTIMER_MODE_REL);
 	return 0;
 }
@@ -87,12 +87,14 @@
 {
 	struct snd_hrtimer *stime = t->private_data;
 
-	hrtimer_cancel(&stime->hrt);
+	tasklet_hrtimer_cancel(&stime->thrt);
 	return 0;
 }
 
 static struct snd_timer_hardware hrtimer_hw = {
-	.flags =	SNDRV_TIMER_HW_AUTO,
+	.flags =	SNDRV_TIMER_HW_AUTO |\
+	                SNDRV_TIMER_HW_FIRST |\
+	                SNDRV_TIMER_HW_TASKLET,
 	.open =		snd_hrtimer_open,
 	.close =	snd_hrtimer_close,
 	.start =	snd_hrtimer_start,

--------------010809070109030206060208--
