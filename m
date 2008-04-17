Return-Path: <linux-kernel-owner+w=401wt.eu-S933647AbYDQBXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647AbYDQBXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760480AbYDQBIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:08:48 -0400
Received: from sous-sol.org ([216.99.217.87]:58954 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760372AbYDQBIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:08:47 -0400
Message-Id: <20080417010329.742004783@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:38 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, snitzer@gmail.com,
       clameter@sgi.com, davem@davemloft.net, dada1@cosmosbay.com
Subject: PERCPU : __percpu_alloc_mask() can dynamically size percpu_data storage
Content-Disposition: inline; filename=percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data-storage.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Eric Dumazet <dada1@cosmosbay.com>

upstream commit: b3242151906372f30f57feaa43b4cac96a23edb1

Instead of allocating a fix sized array of NR_CPUS pointers for percpu_data,
we can use nr_cpu_ids, which is generally < NR_CPUS.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 include/linux/percpu.h |    2 +-
 mm/allocpercpu.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

This is appropriate for 2.6.24.y

--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -34,7 +34,7 @@
 #ifdef CONFIG_SMP
 
 struct percpu_data {
-	void *ptrs[NR_CPUS];
+	void *ptrs[1];
 };
 
 #define __percpu_disguise(pdata) (struct percpu_data *)~(unsigned long)(pdata)
--- a/mm/allocpercpu.c
+++ b/mm/allocpercpu.c
@@ -98,7 +98,7 @@ EXPORT_SYMBOL_GPL(__percpu_populate_mask
  */
 void *__percpu_alloc_mask(size_t size, gfp_t gfp, cpumask_t *mask)
 {
-	void *pdata = kzalloc(sizeof(struct percpu_data), gfp);
+	void *pdata = kzalloc(nr_cpu_ids * sizeof(void *), gfp);
 	void *__pdata = __percpu_disguise(pdata);
 
 	if (unlikely(!pdata))

-- 
