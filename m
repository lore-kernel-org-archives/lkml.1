Return-Path: <linux-kernel-owner+w=401wt.eu-S933002Ab0AFXCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002Ab0AFXCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932951Ab0AFXCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:02:43 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:39262 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866Ab0AFXCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:02:42 -0500
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAIalREurR7H+/2dsb2JhbAC/a5NkhDAE
X-IronPort-AV: E=Sophos;i="4.49,232,1262563200"; 
   d="scan'208";a="285606046"
From: Roland Dreier <rdreier@cisco.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Bart Van Assche <bart.vanassche@gmail.com>,
       David Dillow <dave@thedillows.org>
Subject: [PATCH] Add BUILD_BUG_ON_NOT_POWER_OF_2()
References: <ada3a2jugqu.fsf@roland-alpha.cisco.com>
	<20100106123306.ac85e557.akpm@linux-foundation.org>
	<aday6kbt14a.fsf@roland-alpha.cisco.com>
	<20100106134232.0025e818.akpm@linux-foundation.org>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 06 Jan 2010 15:02:40 -0800
In-Reply-To: <20100106134232.0025e818.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 6 Jan 2010 13:42:32 -0800")
Message-ID: <adaeim2supb.fsf_-_@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Jan 2010 23:02:41.0280 (UTC) FILETIME=[59457800:01CA8F24]
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

As suggested by akpm, rather than monkeying around with is_power_of_2()
and risking gcc warts about constant expressions, just create a macro
BUILD_BUG_ON_NOT_POWER_OF_2() to encapsulate this common requirement.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
--- 
 > mm..  I think _something_ is worth it.  The requirement that a constant
 > be a power of two is a very common one in the kernel.

Fair enough... here's your suggestion of BUILD_BUG_ON_NOT_POWER_OF_2().
<linux/kernel.h> does seem to be going the way of a gazillion very
specific helper macros, so I guess this fits right in.

 include/linux/kernel.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 3fc9f5a..a1b6652 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -734,6 +734,10 @@ struct sysinfo {
 /* Force a compilation error if condition is constant and true */
 #define MAYBE_BUILD_BUG_ON(cond) ((void)sizeof(char[1 - 2 * !!(cond)]))
 
+/* Force a compilation error if expression is not a power of 2 */
+#define BUILD_BUG_ON_NOT_POWER_OF_2(n)			\
+	BUILD_BUG_ON(((n) != 0 && (((n) & ((n) - 1)) == 0)))
+
 /* Force a compilation error if condition is true, but also produce a
    result (of value 0 and type size_t), so the expression can be used
    e.g. in a structure initializer (or where-ever else comma expressions
