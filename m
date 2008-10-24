Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbYJXLP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbYJXLP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 07:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbYJXLPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 07:15:18 -0400
Received: from ozlabs.org ([203.10.76.45]:37707 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbYJXLPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 07:15:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: Re: [PATCH -tip/cpus4096-v2] cpumask: fix cpumask of call_function_data
Date: Fri, 24 Oct 2008 22:15:17 +1100
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org
References: <49015358.9050308@ct.jp.nec.com>
In-Reply-To: <49015358.9050308@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810242215.19440.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 October 2008 15:47:20 Hiroshi Shimamoto wrote:
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Ingo, because of these concerns I recommend you revert
d4de5ac3b5e70928c86e3e5ac311f16cbf2e9ab3 (cpumask: smp_call_function_many())
for now, and apply this less contentious version.

Subject: cpumask: smp_call_function_many()
From: Rusty Russell <rusty@rustcorp.com.au>

Transition from cpumask_t-taking smp_call_function_mask() to a new
smp_call_function_many() which takes a struct cpumask * instead.

(Naming is inspired by smp_call_function_single).

Unfortunately, converting the function implementation properly is
non-trivial, but what we care about is the API, so this simply wraps
it.

Note that the new one returns void: the old one couldn't fail either
unless there was a logic bug.

The old smp_call_function_mask() isn't marked __deprecated, because
sparc64 builds with -Werr in arch/sparc (thanks Stephen).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r cdd2da35b209 include/linux/smp.h
--- a/include/linux/smp.h	Fri Oct 24 14:10:08 2008 +1100
+++ b/include/linux/smp.h	Fri Oct 24 22:08:55 2008 +1100
@@ -64,8 +64,17 @@ extern void smp_cpus_done(unsigned int m
  * Call a function on all other processors
  */
 int smp_call_function(void(*func)(void *info), void *info, int wait);
+/* Deprecated: use smp_call_function_many() which uses a cpumask ptr. */
 int smp_call_function_mask(cpumask_t mask, void(*func)(void *info), void *info,
 				int wait);
+
+static inline void smp_call_function_many(const struct cpumask *mask,
+					  void (*func)(void *info), void *info,
+					  int wait)
+{
+	smp_call_function_mask(*mask, func, info, wait);
+}
+
 int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
 				int wait);
 void __smp_call_function_single(int cpuid, struct call_single_data *data);


