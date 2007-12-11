Return-Path: <linux-kernel-owner+w=401wt.eu-S1754396AbXLKEvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbXLKEvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 23:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbXLKEvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 23:51:13 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:38183 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbXLKEvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 23:51:12 -0500
Message-ID: <475E1726.1040908@cosmosbay.com>
Date: Tue, 11 Dec 2007 05:50:46 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dipankar Sarma <dipankar@in.ibm.com>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] RCU : move three variables to __read_mostly to save space
Content-Type: multipart/mixed;
 boundary="------------010403050305020602070605"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Tue, 11 Dec 2007 05:50:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010403050305020602070605
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I noticed this vmlinux layout on i686 (where CONFIG_X86_L1_CACHE_SHIFT = 7) :

c06cdab4 d pid_caches_lh
c06cdb00 d qlowmark
c06cdb04 d qhimark
c06cdb08 d blimit
c06cdb80 d rcu_ctrlblk
c06cdc80 d rcu_bh_ctrlblk

This means that qlowmark, qhimark and blimit use a whole 128 bytes cache line. 
Linker is not smart enough for us.

Moving these three variables to read_mostly section saves 116 (128-12) bytes.

# size vmlinux vmlinux.before_patch
    text    data     bss     dec     hex filename
6343966  490818  630784 7465568  71ea60 vmlinux
6343966  490930  630784 7465680  71ead0 vmlinux.before_patch

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

--------------010403050305020602070605
Content-Type: text/plain;
 name="rcu.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="rcu.patch"

diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index a66d4d1..11c815c 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -75,9 +75,9 @@ DEFINE_PER_CPU(struct rcu_data, rcu_bh_data) = { 0L };
 
 /* Fake initialization required by compiler */
 static DEFINE_PER_CPU(struct tasklet_struct, rcu_tasklet) = {NULL};
-static int blimit = 10;
-static int qhimark = 10000;
-static int qlowmark = 100;
+static int blimit __read_mostly = 10;
+static int qhimark __read_mostly = 10000;
+static int qlowmark __read_mostly = 100;
 
 static atomic_t rcu_barrier_cpu_count;
 static DEFINE_MUTEX(rcu_barrier_mutex);

--------------010403050305020602070605--
