Return-Path: <linux-kernel-owner+w=401wt.eu-S1758506AbYLCUie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506AbYLCUie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758752AbYLCUZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 15:25:18 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:59020 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758746AbYLCUZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 15:25:16 -0500
Message-ID: <4936EB04.8000609@cosmosbay.com>
Date: Wed, 03 Dec 2008 21:24:36 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux kernel <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] percpu_counter: Fix __percpu_counter_sum()
References: <4936D287.6090206@cosmosbay.com>
In-Reply-To: <4936D287.6090206@cosmosbay.com>
Content-Type: multipart/mixed;
 boundary="------------050609020607060206080904"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 03 Dec 2008 21:24:36 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050609020607060206080904
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Eric Dumazet a =E9crit :
> Hi Andrew
>=20
> While working on percpu_counter on net-next-2.6, I found
> a CPU unplug race in percpu_counter_destroy()
>=20
> (Very unlikely of course)
>=20
> Thank you
>=20
> [PATCH] percpu_counter: fix CPU unplug race in percpu_counter_destroy()=

>=20
> We should first delete the counter from percpu_counters list
> before freeing memory, or a percpu_counter_hotcpu_callback()
> could dereference a NULL pointer.
>=20
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> ---
> lib/percpu_counter.c |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>=20

Well, this percpu_counter stuff is simply not working at all.

We added some percpu_counters to network tree for 2.6.29 and we get
drift bugs if calling __percpu_counter_sum() while some heavy duty
benches are running, on a 8 cpus machine

1) __percpu_counter_sum() is buggy, it should not write
on per_cpu_ptr(fbc->counters, cpu), or another cpu
could get its changes lost.

__percpu_counter_sum should be read only (const struct percpu_counter *fb=
c),
and no locking needed.


2) Un-needed lock in percpu_counter_set()
   This wont block another cpu doing an _add anyway.
   Not a bug, but disturbing, giving false feeling of protection.
   percpu_counter are not precise, we cannot reliably set them
   or read them. Period.
   In fact percpu_counter_set() callers should use
   percpu_counter_add(). (only used from lib/proportions.c )


Thank you

[PATCH] percpu_counter: Fix __percpu_counter_sum()

This function should not write into percpu local storage,
without proper locking, or some changes done on other cpus
might be lost.

Adding proper locking would need to use atomic
operations in fast path and would be expensive.

Results of __percpu_counter_sum() can be wrong, this is a
known fact.

We also dont need to acquire the lock, this gives
no better results.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
 lib/percpu_counter.c |    5 -----
 1 files changed, 5 deletions(-)

--------------050609020607060206080904
Content-Type: text/plain;
 name="__percpu_counter_sum.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="__percpu_counter_sum.patch"

diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index a866389..e79bbae 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -57,16 +57,11 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc)
 	s64 ret;
 	int cpu;
 
-	spin_lock(&fbc->lock);
 	ret = fbc->count;
 	for_each_online_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		ret += *pcount;
-		*pcount = 0;
 	}
-	fbc->count = ret;
-
-	spin_unlock(&fbc->lock);
 	return ret;
 }
 EXPORT_SYMBOL(__percpu_counter_sum);

--------------050609020607060206080904--
