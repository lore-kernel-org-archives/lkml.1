Return-Path: <linux-kernel-owner+w=401wt.eu-S1752251AbZCKFxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbZCKFxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 01:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbZCKFxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 01:53:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:40142 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbZCKFx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 01:53:29 -0400
Message-ID: <49B751E5.1060305@kernel.org>
Date: Wed, 11 Mar 2009 14:53:41 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Sachin P. Sant" <sachinp@in.ibm.com>
CC: linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PATCH tj-percpu] percpu: fix spurious alignment WARN in legacy
 SMP percpu allocator
References: <20090310195534.8f8f3c7a.sfr@canb.auug.org.au> <49B67552.5070307@in.ibm.com> <49B73B15.3040101@in.ibm.com>
In-Reply-To: <49B73B15.3040101@in.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 11 Mar 2009 05:53:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: remove spurious WARN on legacy SMP percpu allocator

Commit f2a8205c4ef1af917d175c36a4097ae5587791c8 incorrectly added too
tight WARN_ON_ONCE() on alignments for UP and legacy SMP percpu
allocator.  Commit e317603694bfd17b28a40de9d65e1a4ec12f816e fixed it
for UP but legacy SMP allocator was forgotten.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Sachin P. Sant <sachinp@in.ibm.com>
---

Oops, that was a stupid omission.  This patch should fix it.  Ingo,
please pull from the following git vector to receive the first first
four patches from the use-dynamic-percpu-allocator-by-default patchset
(without the actual conversion which can disrupt archs) + this patch.
I moved the actual conversion patch into #tj-percpu-exp branch, so the
pull should be safe.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

Thanks.

 mm/allocpercpu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/allocpercpu.c b/mm/allocpercpu.c
index 3653c57..1882923 100644
--- a/mm/allocpercpu.c
+++ b/mm/allocpercpu.c
@@ -120,7 +120,7 @@ void *__alloc_percpu(size_t size, size_t align)
 	 * on it.  Larger alignment should only be used for module
 	 * percpu sections on SMP for which this path isn't used.
 	 */
-	WARN_ON_ONCE(align > __alignof__(unsigned long long));
+	WARN_ON_ONCE(align > SMP_CACHE_BYTES);
 
 	if (unlikely(!pdata))
 		return NULL;
-- 
1.6.0.2

