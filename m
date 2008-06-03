Return-Path: <linux-kernel-owner+w=401wt.eu-S1758967AbYFCTFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967AbYFCTFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 15:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758668AbYFCTEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 15:04:22 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:58523 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758626AbYFCTEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 15:04:21 -0400
Date: Tue, 3 Jun 2008 15:02:35 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Cc: Nix <nix@esperi.org.uk>
Subject: [PATCH 1/6] UML - Deal with host time going backwards
Message-ID: <20080603190235.GA9511@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protection against the host's time going backwards - keep track of the
time at the last tick and if it's greater than the current time, keep
time stopped until the host catches up.

Cc: Nix <nix@esperi.org.uk>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/os-Linux/time.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6-git/arch/um/os-Linux/time.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/time.c	2008-05-14 10:44:02.000000000 -0400
+++ linux-2.6-git/arch/um/os-Linux/time.c	2008-06-02 15:43:53.000000000 -0400
@@ -106,6 +106,10 @@ static void deliver_alarm(void)
 	unsigned long long this_tick = os_nsecs();
 	int one_tick = UM_NSEC_PER_SEC / UM_HZ;
 
+	/* Protection against the host's time going backwards */
+	if ((last_tick != 0) && (this_tick < last_tick))
+		this_tick = last_tick;
+
 	if (last_tick == 0)
 		last_tick = this_tick - one_tick;
 
@@ -148,6 +152,9 @@ static int after_sleep_interval(struct t
 		start_usecs = usec;
 
 	start_usecs -= skew / UM_NSEC_PER_USEC;
+	if (start_usecs < 0)
+		start_usecs = 0;
+
 	tv = ((struct timeval) { .tv_sec  = start_usecs / UM_USEC_PER_SEC,
 				 .tv_usec = start_usecs % UM_USEC_PER_SEC });
 	interval = ((struct itimerval) { { 0, usec }, tv });
