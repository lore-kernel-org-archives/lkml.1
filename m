Return-Path: <linux-kernel-owner+w=401wt.eu-S1764072AbYHEUPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764072AbYHEUPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763585AbYHEUOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:14:31 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:48072 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758710AbYHEUOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:14:30 -0400
Date: Tue, 5 Aug 2008 16:14:06 -0400
From: Jeff Dike <jdike@addtoit.com>
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 6/14] uml: deal with host time going backwards
Message-ID: <20080805201406.GA11786@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 06e1e4ffbd1932e288839b3140cda6b8141eb684

Protection against the host's time going backwards (eg, ntp activity on
the host) by keeping track of the time at the last tick and if it's
greater than the current time, keep time stopped until the host catches
up.

Cc: Nix <nix@esperi.org.uk>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/um/os-Linux/time.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/um/os-Linux/time.c b/arch/um/os-Linux/time.c
index bee98f4..dec5678 100644
--- a/arch/um/os-Linux/time.c
+++ b/arch/um/os-Linux/time.c
@@ -106,6 +106,10 @@ static void deliver_alarm(void)
 	unsigned long long this_tick = os_nsecs();
 	int one_tick = UM_NSEC_PER_SEC / UM_HZ;
 
+	/* Protection against the host's time going backwards */
+	if ((last_tick != 0) && (this_tick < last_tick))
+		this_tick = last_tick;
+
 	if (last_tick == 0)
 		last_tick = this_tick - one_tick;
 
@@ -148,6 +152,9 @@ static int after_sleep_interval(struct timespec *ts)
 		start_usecs = usec;
 
 	start_usecs -= skew / UM_NSEC_PER_USEC;
+	if (start_usecs < 0)
+		start_usecs = 0;
+
 	tv = ((struct timeval) { .tv_sec  = start_usecs / UM_USEC_PER_SEC,
 				 .tv_usec = start_usecs % UM_USEC_PER_SEC });
 	interval = ((struct itimerval) { { 0, usec }, tv });
-- 
1.5.5.1

