Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502AbZF0K5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbZF0K5T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 06:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbZF0K5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 06:57:10 -0400
Received: from relay2.sgi.com ([192.48.179.30]:48153 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751919AbZF0K5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 06:57:09 -0400
Date: Sat, 27 Jun 2009 05:57:11 -0500
From: Robin Holt <holt@sgi.com>
To: linux-kernel@vger.kernel.org
Subject: [Patch] stop_machine stalls for a considerable period on large cpu
	count machines.
Message-ID: <20090627105711.GB6894@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot to include the linux-kernel mailing list.

Robin

----- Forwarded message from Robin Holt <holt@sgi.com> -----

Date: Sat, 27 Jun 2009 05:53:11 -0500
From: Robin Holt <holt@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, stable@kernel.org,
	mike travis <travis@sgi.com>
Subject: [Patch] stop_machine stalls for a considerable period on large cpu
	count machines.

Mike Travis noted that a 2048 cpu machine booting would take hours
to get through its modprobes.  We would get numerous back traces from
stop_cpu indicating they had not serviced interrupts.

A quick code review indicated we have a situation of heavy cacheline                                                      contention due to the 'state' (read-mostly) and 'thread_ack'
(write-mostly) variables being located in the same cacheline.


Signed-off-by: Robin Holt <holt@sgi.com>

---
 kernel/stop_machine.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
Index: stop_machine_false_sharing/kernel/stop_machine.c
===================================================================
--- stop_machine_false_sharing.orig/kernel/stop_machine.c	2009-06-27 05:26:57.000000000 -0500
+++ stop_machine_false_sharing/kernel/stop_machine.c	2009-06-27 05:34:45.182637682 -0500
@@ -36,8 +36,8 @@ struct stop_machine_data {
 
 /* Like num_online_cpus(), but hotplug cpu uses us, so we need this. */
 static unsigned int num_threads;
-static atomic_t thread_ack;
-static DEFINE_MUTEX(lock);
+static atomic_t thread_ack	____cacheline_aligned;
+static DEFINE_MUTEX(lock)	____cacheline_aligned;
 /* setup_lock protects refcount, stop_machine_wq and stop_machine_work. */
 static DEFINE_MUTEX(setup_lock);
 /* Users of stop_machine. */

----- End forwarded message -----
