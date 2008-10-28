Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbYJ1Aq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbYJ1Aq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 20:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbYJ1Aqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 20:46:50 -0400
Received: from ozlabs.org ([203.10.76.45]:36749 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbYJ1Aqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 20:46:50 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: Re: [PATCH -tip/cpus4096-v2] cpumask: fix cpumask =?iso-8859-1?q?of=09call=5Ffunction=5Fdata?=
Date: Tue, 28 Oct 2008 11:46:26 +1100
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <49015358.9050308@ct.jp.nec.com> <20081027133248.GA1007@elte.hu> <490649AE.6050905@ct.jp.nec.com>
In-Reply-To: <490649AE.6050905@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810281146.28491.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2008 10:07:26 Hiroshi Shimamoto wrote:
> So, kmalloc(8, flags) for cpumask_var_t at alloc_cpumask_var().
> But the content is treated as cpumask_t, it causes slab corruption
> with overwritten when the mask data is copied.

Yes.  This is another one.

Ingo, please fold.

Subject: Fix slab corruption when using CONFIG_CPUMASK_OFFSTACK

Found by Hiroshi Shimamoto; using assignment on a cpumask_t causes slab
corruption, as we do not allocate sizeof(struct cpumask).

It looks like we will have to stick with allocating all NR_CPUS bits until the
end of the patchset (in the future) where we have eliminated all the
cpumask_t assignments.

(Note: this ban will be enforced by compiler when we get rid of the 'struct
cpumask' definition, which is what we're slowly working towards).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index d1f22ee..004da56 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -182,7 +182,8 @@ int cpumask_any_but(const struct cpumask *mask, unsigned int cpu);
 
 static inline size_t cpumask_size(void)
 {
-	return BITS_TO_LONGS(nr_cpumask_bits) * sizeof(long);
+	/* FIXME: Use nr_cpumask_bits once all cpumask_t assignments banished */
+	return BITS_TO_LONGS(NR_CPUS) * sizeof(long);
 }
 
 /* Deprecated. */

