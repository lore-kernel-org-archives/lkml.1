Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbZGHXdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbZGHXdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 19:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbZGHXdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 19:33:00 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:64223 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZGHXc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 19:32:59 -0400
X-IronPort-AV: E=Sophos;i="4.42,370,1243814400"; 
   d="scan'208";a="340223157"
From: Roland Dreier <rdreier@cisco.com>
To: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: lib: Export generic atomic64_t functions
X-Message-Flag: Warning: May contain useful information
Date: Wed, 08 Jul 2009 16:32:55 -0700
Message-ID: <ada63e221js.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Jul 2009 23:32:58.0386 (UTC) FILETIME=[6D2B5720:01CA0024]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic atomic64_t implementation in lib/ did not export the
functions it defined, which means that modules that use atomic64_t
would not link on platforms (such as 32-bit powerpc).  For example,
trying to build a kernel with CONFIG_NET_RDS on such a platform would
fail with:

    ERROR: "atomic64_read" [net/rds/rds.ko] undefined!
    ERROR: "atomic64_set" [net/rds/rds.ko] undefined!

Fix this by exporting the atomic64_t functions to modules.  (I export
the entire API even if it's not all currently used by in-tree modules to
avoid having to continue fixing this in dribs and drabs)

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
Didn't see this appear anywhere yet, but I apologize if this duplicates
something already queued.  I see that the original implementation went
in through benh's tree but I'm not sure what the appropriate way to
merge this is, so I'll send it to both benh and akpm.

 lib/atomic64.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/lib/atomic64.c b/lib/atomic64.c
index c5e7255..8bee16e 100644
--- a/lib/atomic64.c
+++ b/lib/atomic64.c
@@ -13,6 +13,7 @@
 #include <linux/cache.h>
 #include <linux/spinlock.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <asm/atomic.h>
 
 /*
@@ -52,6 +53,7 @@ long long atomic64_read(const atomic64_t *v)
 	spin_unlock_irqrestore(lock, flags);
 	return val;
 }
+EXPORT_SYMBOL(atomic64_read);
 
 void atomic64_set(atomic64_t *v, long long i)
 {
@@ -62,6 +64,7 @@ void atomic64_set(atomic64_t *v, long long i)
 	v->counter = i;
 	spin_unlock_irqrestore(lock, flags);
 }
+EXPORT_SYMBOL(atomic64_set);
 
 void atomic64_add(long long a, atomic64_t *v)
 {
@@ -72,6 +75,7 @@ void atomic64_add(long long a, atomic64_t *v)
 	v->counter += a;
 	spin_unlock_irqrestore(lock, flags);
 }
+EXPORT_SYMBOL(atomic64_add);
 
 long long atomic64_add_return(long long a, atomic64_t *v)
 {
@@ -84,6 +88,7 @@ long long atomic64_add_return(long long a, atomic64_t *v)
 	spin_unlock_irqrestore(lock, flags);
 	return val;
 }
+EXPORT_SYMBOL(atomic64_add_return);
 
 void atomic64_sub(long long a, atomic64_t *v)
 {
@@ -94,6 +99,7 @@ void atomic64_sub(long long a, atomic64_t *v)
 	v->counter -= a;
 	spin_unlock_irqrestore(lock, flags);
 }
+EXPORT_SYMBOL(atomic64_sub);
 
 long long atomic64_sub_return(long long a, atomic64_t *v)
 {
@@ -106,6 +112,7 @@ long long atomic64_sub_return(long long a, atomic64_t *v)
 	spin_unlock_irqrestore(lock, flags);
 	return val;
 }
+EXPORT_SYMBOL(atomic64_sub_return);
 
 long long atomic64_dec_if_positive(atomic64_t *v)
 {
@@ -120,6 +127,7 @@ long long atomic64_dec_if_positive(atomic64_t *v)
 	spin_unlock_irqrestore(lock, flags);
 	return val;
 }
+EXPORT_SYMBOL(atomic64_dec_if_positive);
 
 long long atomic64_cmpxchg(atomic64_t *v, long long o, long long n)
 {
@@ -134,6 +142,7 @@ long long atomic64_cmpxchg(atomic64_t *v, long long o, long long n)
 	spin_unlock_irqrestore(lock, flags);
 	return val;
 }
+EXPORT_SYMBOL(atomic64_cmpxchg);
 
 long long atomic64_xchg(atomic64_t *v, long long new)
 {
@@ -147,6 +156,7 @@ long long atomic64_xchg(atomic64_t *v, long long new)
 	spin_unlock_irqrestore(lock, flags);
 	return val;
 }
+EXPORT_SYMBOL(atomic64_xchg);
 
 int atomic64_add_unless(atomic64_t *v, long long a, long long u)
 {
@@ -162,6 +172,7 @@ int atomic64_add_unless(atomic64_t *v, long long a, long long u)
 	spin_unlock_irqrestore(lock, flags);
 	return ret;
 }
+EXPORT_SYMBOL(atomic64_add_unless);
 
 static int init_atomic64_lock(void)
 {
