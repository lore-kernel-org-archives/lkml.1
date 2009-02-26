Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbZBZCEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbZBZCEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 21:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755566AbZBZCD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 21:03:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:51860 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432AbZBZCD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 21:03:57 -0500
Message-ID: <49A5F876.2080607@kernel.org>
Date: Thu, 26 Feb 2009 11:03:34 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yinghai@kernel.org>, rusty@rustcorp.com.au, tglx@linutronix.de,
       x86@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       jeremy@goop.org, cpw@sgi.com, nickpiggin@yahoo.com.au,
       ink@jurassic.park.msu.ru
Subject: [PATCH core/percpu] percpu: fix too low alignment restriction on
 UP
References: <1235445101-7882-1-git-send-email-tj@kernel.org> <20090224201718.GE28772@elte.hu> <20090224205105.GA19460@elte.hu> <20090224211659.GA3687@elte.hu> <49A4ABAC.90602@kernel.org> <20090225125935.GG26273@elte.hu> <20090225134343.GA30279@elte.hu>
In-Reply-To: <20090225134343.GA30279@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 26 Feb 2009 02:03:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UP __alloc_percpu() triggered WARN_ON_ONCE() if the requested
alignment is larger than that of unsigned long long, which is too
small for all the cacheline aligned allocations.  Bump it up to
SMP_CACHE_BYTES which kmalloc allocations generally guarantee.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Ingo Molnar <mingo@elte.hu>
---
Hello, Ingo.

I somehow completely forgot about testing UP.  Sorry about that. :-)
The following patch should do it.  Also available in the #tj-percpu
tree.

Thanks.

 include/linux/percpu.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index d8e5a9a..545b068 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -156,7 +156,7 @@ static inline void *__alloc_percpu(size_t size, size_t align)
 	 * on it.  Larger alignment should only be used for module
 	 * percpu sections on SMP for which this path isn't used.
 	 */
-	WARN_ON_ONCE(align > __alignof__(unsigned long long));
+	WARN_ON_ONCE(align > SMP_CACHE_BYTES);
 	return kzalloc(size, GFP_KERNEL);
 }
 
-- 
1.6.0.2

