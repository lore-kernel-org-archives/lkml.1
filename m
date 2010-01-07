Return-Path: <linux-kernel-owner+w=401wt.eu-S1756362Ab0AGHwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362Ab0AGHwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 02:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756127Ab0AGHwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 02:52:11 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:33407 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab0AGHwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 02:52:09 -0500
Authentication-Results: sj-iport-2.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAOchRUurR7Hu/2dsb2JhbAC9ZJNdhDAE
X-IronPort-AV: E=Sophos;i="4.49,234,1262563200"; 
   d="scan'208";a="231203089"
From: Roland Dreier <rdreier@cisco.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       David Dillow <dave@thedillows.org>
Subject: Re: [PATCH] Add BUILD_BUG_ON_NOT_POWER_OF_2()
References: <ada3a2jugqu.fsf@roland-alpha.cisco.com>
	<20100106123306.ac85e557.akpm@linux-foundation.org>
	<aday6kbt14a.fsf@roland-alpha.cisco.com>
	<20100106134232.0025e818.akpm@linux-foundation.org>
	<adaeim2supb.fsf_-_@roland-alpha.cisco.com>
	<e2e108261001062333p2a626bf6h4b25de0ac919ef1d@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 06 Jan 2010 23:51:53 -0800
In-Reply-To: <e2e108261001062333p2a626bf6h4b25de0ac919ef1d@mail.gmail.com>
	(Bart Van Assche's message of "Thu, 7 Jan 2010 08:33:21 +0100")
Message-ID: <adaskaiqrmu.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 Jan 2010 07:51:54.0195 (UTC) FILETIME=[477BCA30:01CA8F6E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Can you please change the above into the following, such that the
 > macro does what its name suggests:

Argh!  Good catch, thanks -- I even tested my patch, but with my brain
in reverse so I sent the bad patch.

Andrew, please replace with this one, which includes your update to the
comment as well:

===

Add BUILD_BUG_ON_NOT_POWER_OF_2()

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
 include/linux/kernel.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 3fc9f5a..328bca6 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -734,6 +734,10 @@ struct sysinfo {
 /* Force a compilation error if condition is constant and true */
 #define MAYBE_BUILD_BUG_ON(cond) ((void)sizeof(char[1 - 2 * !!(cond)]))
 
+/* Force a compilation error if a constant expression is not a power of 2 */
+#define BUILD_BUG_ON_NOT_POWER_OF_2(n)			\
+	BUILD_BUG_ON((n) == 0 || (((n) & ((n) - 1)) != 0))
+
 /* Force a compilation error if condition is true, but also produce a
    result (of value 0 and type size_t), so the expression can be used
    e.g. in a structure initializer (or where-ever else comma expressions
