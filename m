Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbYKERjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbYKERjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 12:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264AbYKERjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 12:39:05 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56346 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbYKERjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 12:39:04 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix accidental implicit cast in HR-timer conversion
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: arjan@linux.intel.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       dhowells@redhat.com
Date: Wed, 05 Nov 2008 17:38:47 +0000
Message-ID: <20081105173846.6915.93337.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the hrtimer_add_expires_ns() function.  It should take a 'u64 ns' argument,
but rather takes an 'unsigned long ns' argument - which might only be 32-bits.

On FRV, this results in the kernel locking up because hrtimer_forward() passes
the result of a 64-bit multiplication to this function, for which the compiler
discards the top 32-bits - something that didn't happen when ktime_add_ns() was
called directly.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
---

 include/linux/hrtimer.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 2b3645b..07e510a 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -239,7 +239,7 @@ static inline void hrtimer_add_expires(struct hrtimer *timer, ktime_t time)
 	timer->_softexpires = ktime_add_safe(timer->_softexpires, time);
 }
 
-static inline void hrtimer_add_expires_ns(struct hrtimer *timer, unsigned long ns)
+static inline void hrtimer_add_expires_ns(struct hrtimer *timer, u64 ns)
 {
 	timer->_expires = ktime_add_ns(timer->_expires, ns);
 	timer->_softexpires = ktime_add_ns(timer->_softexpires, ns);

