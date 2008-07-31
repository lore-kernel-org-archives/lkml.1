Return-Path: <linux-kernel-owner+w=401wt.eu-S1757174AbYGaRAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174AbYGaRAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 13:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbYGaRAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 13:00:25 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43606 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756632AbYGaRAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 13:00:24 -0400
Date: Thu, 31 Jul 2008 12:00:22 -0500
From: Robin Holt <holt@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Pavel Emelyanov <xemul@openvz.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Paul Menage <menage@google.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [Patch] Scale pidhash_shift/pidhash_size up based on
	num_possible_cpus().
Message-ID: <20080731170022.GE9663@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For large cpu configurations, we find the number of pids in a pidhash
bucket cause things like 'ps' to perform slowly.  Raising pidhash_shift
from 12 to 16 cut the time for 'ps' in half on a 2048 cpu machine.

This patch makes the upper limit scale based upon num_possible_cpus().
For machines 128 cpus or less, the current upper limit of 12 is
maintained.

Signed-off-by: Robin Holt <holt@sgi.com>


Index: contention_unroll/kernel/pid.c
===================================================================
--- contention_unroll.orig/kernel/pid.c	2008-07-31 11:59:21.154284073 -0500
+++ contention_unroll/kernel/pid.c	2008-07-31 11:59:22.862497720 -0500
@@ -502,9 +502,10 @@ void __init pidhash_init(void)
 {
 	int i, pidhash_size;
 	unsigned long megabytes = nr_kernel_pages >> (20 - PAGE_SHIFT);
+	int pidhash_shift_ul = max(12, fls(num_possible_cpus() - 1) + 5);
 
 	pidhash_shift = max(4, fls(megabytes * 4));
-	pidhash_shift = min(12, pidhash_shift);
+	pidhash_shift = min(pidhash_shift_ul, pidhash_shift);
 	pidhash_size = 1 << pidhash_shift;
 
 	printk("PID hash table entries: %d (order: %d, %Zd bytes)\n",
