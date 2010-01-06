Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228Ab0AFUVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab0AFUVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 15:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756017Ab0AFUVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 15:21:16 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:52008 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932563Ab0AFUVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 15:21:15 -0500
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAD5/REurRN+J/2dsb2JhbADADZNfhDAE
X-IronPort-AV: E=Sophos;i="4.49,231,1262563200"; 
   d="scan'208";a="129342434"
From: Roland Dreier <rdreier@cisco.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bart Van Assche <bart.vanassche@gmail.com>,
       David Dillow <dave@thedillows.org>
Subject: [PATCH] log2.h: Macro-ize is_power_of_2() for use in BUILD_BUG_ON
X-Message-Flag: Warning: May contain useful information
Date: Wed, 06 Jan 2010 12:21:13 -0800
Message-ID: <ada3a2jugqu.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Jan 2010 20:21:13.0739 (UTC) FILETIME=[CB0C05B0:01CA8F0D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When code relies on a constant being a power of 2:

	#define FOO	512	/* must be a power of 2 */

it would be nice to be able to do:

	BUILD_BUG_ON(!is_power_of_2(FOO));

However applying an inline function does not result in a compile-time
constant that can be used with BUILD_BUG_ON(), so trying that gives
results in:

	error: bit-field '<anonymous>' width not an integer constant

We can fix this by changing is_power_of_2() to a macro; we leave the
inline function for the non-constant case, to avoid evaluating the
parameter more than once.  (gcc does not accept a multi-statement
expression like "({ unsigned long __n = n; ... })" as a compile-time
constant so that solution doesn't work)

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
This is somewhat of an RFC -- I'm a bit undecided whether it's really
worth making this change.  It's prompted by
http://www.mail-archive.com/linux-rdma@vger.kernel.org/msg01941.html and
http://www.mail-archive.com/linux-rdma@vger.kernel.org/msg01950.html
which do ugly things to work around is_power_of_2 not being usable in
BUILD_BUG_ON().

On the other hand maybe just

/* FOO must be a power of 2 */
#define FOO_SHIFT 9
#define FOO (1 << FOO_SHIFT)

is good enough.

 include/linux/log2.h |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/include/linux/log2.h b/include/linux/log2.h
index 25b8086..248f69c 100644
--- a/include/linux/log2.h
+++ b/include/linux/log2.h
@@ -49,11 +49,18 @@ int __ilog2_u64(u64 n)
  */
 
 static inline __attribute__((const))
-bool is_power_of_2(unsigned long n)
+bool __is_power_of_2(unsigned long n)
 {
 	return (n != 0 && ((n & (n - 1)) == 0));
 }
 
+#define is_power_of_2(n)					\
+(								\
+	__builtin_constant_p(n) ?				\
+		(((n) != 0) && (((n) & ((n) - 1)) == 0)) :	\
+		__is_power_of_2(n)				\
+)
+
 /*
  * round up to nearest power of two
  */
