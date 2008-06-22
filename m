Return-Path: <linux-kernel-owner+w=401wt.eu-S1756477AbYFVUGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbYFVUGx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 16:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754331AbYFVUGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 16:06:44 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:51328 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302AbYFVUGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 16:06:43 -0400
Date: Sun, 22 Jun 2008 13:06:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, josh@freedesktop.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       dino@in.ibm.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, vegard.nossum@gmail.com,
       adobriyan@gmail.com, oleg@tv-sign.ru, bunk@kernel.org, rjw@sisk.pl
Subject: [PATCH -tip-rcu] Make rcutorture more vicious: make quiescent rcutorture less power-hungry
Message-ID: <20080622200638.GA25328@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080618122144.GA27143@linux.vnet.ibm.com> <20080618162649.GA18326@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080618162649.GA18326@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the non-module rcutorture a bit more friendly to
the power-conservation code.  This is a rather simple-minded approach.
More sophisticated approaches would get rid of the rcutorture tasks
while rcutorture execution was suppressed, but attempts thus far to
do this have not gone well -- calling rcu_torture_init() from a /proc
callout results in oopses.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcutorture.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -urpNa -X dontdiff linux-2.6.26-rc4-rcut2-proc/kernel/rcutorture.c linux-2.6.26-rc4-rcut3-procq/kernel/rcutorture.c
--- linux-2.6.26-rc4-rcut2-proc/kernel/rcutorture.c	2008-06-22 10:29:04.000000000 -0700
+++ linux-2.6.26-rc4-rcut3-procq/kernel/rcutorture.c	2008-06-22 12:20:10.000000000 -0700
@@ -196,7 +196,10 @@ static void
 rcu_stutter_wait(void)
 {
 	while (stutter_pause_test || !rcutorture_runnable)
-		schedule_timeout_interruptible(1);
+		if (rcutorture_runnable)
+			schedule_timeout_interruptible(1);
+		else
+			schedule_timeout_interruptible(HZ);
 }
 
 /*
