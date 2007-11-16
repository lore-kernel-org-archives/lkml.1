Return-Path: <linux-kernel-owner+w=401wt.eu-S935205AbXKPWQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935205AbXKPWQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 17:16:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759184AbXKPWPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 17:15:53 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:53620 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757788AbXKPWPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 17:15:52 -0500
Message-ID: <473E168A.9060305@cosmosbay.com>
Date: Fri, 16 Nov 2007 23:15:38 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
CC: Linux kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: [PATCH] PERCPU : __percpu_alloc_mask() can dynamically size percpu_data
 storage
Content-Type: multipart/mixed;
 boundary="------------040403090908000201070109"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Fri, 16 Nov 2007 23:15:43 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040403090908000201070109
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Instead of allocating a fix sized array of NR_CPUS pointers for percpu_data, 
we can use nr_cpu_ids, which is generally < NR_CPUS.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

  include/linux/percpu.h |    2 +-
  mm/allocpercpu.c       |    2 +-
  2 files changed, 2 insertions(+), 2 deletions(-)


--------------040403090908000201070109
Content-Type: text/plain;
 name="percpu_data.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="percpu_data.patch"

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 926adaa..1702ab5 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -34,7 +34,7 @@
 #ifdef CONFIG_SMP
 
 struct percpu_data {
-	void *ptrs[NR_CPUS];
+	void *ptrs[1];
 };
 
 #define __percpu_disguise(pdata) (struct percpu_data *)~(unsigned long)(pdata)
diff --git a/mm/allocpercpu.c b/mm/allocpercpu.c
index 00b0262..7e58322 100644
--- a/mm/allocpercpu.c
+++ b/mm/allocpercpu.c
@@ -98,7 +98,7 @@ EXPORT_SYMBOL_GPL(__percpu_populate_mask);
  */
 void *__percpu_alloc_mask(size_t size, gfp_t gfp, cpumask_t *mask)
 {
-	void *pdata = kzalloc(sizeof(struct percpu_data), gfp);
+	void *pdata = kzalloc(nr_cpu_ids * sizeof(void *), gfp);
 	void *__pdata = __percpu_disguise(pdata);
 
 	if (unlikely(!pdata))

--------------040403090908000201070109--
