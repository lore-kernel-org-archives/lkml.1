Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbYLCSk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbYLCSk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 13:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbYLCSkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 13:40:18 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:33388 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbYLCSkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 13:40:18 -0500
Message-ID: <4936D287.6090206@cosmosbay.com>
Date: Wed, 03 Dec 2008 19:40:07 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux kernel <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] percpu_counter: fix CPU unplug race in percpu_counter_destroy()
Content-Type: multipart/mixed;
 boundary="------------000809090301050906040309"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 03 Dec 2008 19:40:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000809090301050906040309
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Andrew

While working on percpu_counter on net-next-2.6, I found
a CPU unplug race in percpu_counter_destroy()

(Very unlikely of course)

Thank you

[PATCH] percpu_counter: fix CPU unplug race in percpu_counter_destroy()

We should first delete the counter from percpu_counters list
before freeing memory, or a percpu_counter_hotcpu_callback()
could dereference a NULL pointer.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
 lib/percpu_counter.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

--------------000809090301050906040309
Content-Type: text/plain;
 name="percpu_counter_destroy.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="percpu_counter_destroy.patch"

diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index a866389..71b265c 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -104,13 +104,13 @@ void percpu_counter_destroy(struct percpu_counter *fbc)
 	if (!fbc->counters)
 		return;
 
-	free_percpu(fbc->counters);
-	fbc->counters = NULL;
 #ifdef CONFIG_HOTPLUG_CPU
 	mutex_lock(&percpu_counters_lock);
 	list_del(&fbc->list);
 	mutex_unlock(&percpu_counters_lock);
 #endif
+	free_percpu(fbc->counters);
+	fbc->counters = NULL;
 }
 EXPORT_SYMBOL(percpu_counter_destroy);
 

--------------000809090301050906040309--
