Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933646Ab0BGLbR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 06:31:17 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:32292 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab0BGLbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 06:31:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vMH3qZyqeSgPpAghcW+YEUkpitGyKX6pxcZ3W0INz0BFm0Rccr1ZD5bYHiFWyoPRKE
         0/Anf6A9H5Vue8GuVjvc/mjFIXgKEbbB//o4ONfgSUQsSAtIoy5olXEu3Lp4opiVW/iq
         0diYeA2T5YJj60x0NOfwzdR1z6GcsjQtjoreo=
From: highguy@gmail.com
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       andrea@suse.de, tglx@linutronix.de, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: [RFC][PATCH] PERF_COUNT_SW_RUNNABLE_TASKS: measure and act upon parallellism
Date: Sun,  7 Feb 2010 12:30:53 +0100
Message-Id: <1265542259-5596-1-git-send-email-HIGHGuY@gmail.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

Here's an initial RFC patch for the parallallism
events for perf_events.

It works with a low number of tasks, but runs into a
couple of issues:
- something goes wrong when a thread exits. Apparently
  the count is decremented twice. I'm still figuring this
  one out, perhaps sync_stat is to blame.
  This causes things to break with more than 3 threads if
  I recall correctly.
- the count is stored with the parent event only. This means
  the child list lock is not taken too often.
- adding threshold support to poll() breaks use with mmap.
  poll() returns when count < threshold although no new
  entries might be added to the memory map.
- min threshold is actually useless so it should be dropped.

There's definately more wrong with this early patchset
and I'm doubting whether perf_events is actually fit for
this purpose.
Currently, by design, it's not meant to support counters
that may also decrement. Also, the foreseen use of poll
to block execution of the thread doesn't seem to work
together well with the mmap()-use.

Some hints, pointers and remarks are definately welcome
at this stage.

Regards,
Stijn
