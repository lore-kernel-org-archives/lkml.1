Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbYHVUCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbYHVUCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 16:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbYHVUCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 16:02:16 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:56330 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249AbYHVUBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 16:01:44 -0400
Message-ID: <48AF1B6A.80408@keyaccess.nl>
Date: Fri, 22 Aug 2008 22:02:50 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Airlie <airlied@gmail.com>, "Li, Shaohua" <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@codemonkey.org.uk>
Subject: [PATCH] x86: have set_memory_array_{uc,wb} coalesce memtypes.
References: <20080820100440.GE28492@elte.hu> <48ABF6DC.8070305@keyaccess.nl> <48AC29CA.1060203@keyaccess.nl> <20080820194127.GA10887@linux-os.sc.intel.com> <48AC8F69.4050201@keyaccess.nl> <21d7e9970808201446k3c1a6bc1naf04568a8ad06ed4@mail.gmail.com> <20080820221630.GA3598@linux-os.sc.intel.com> <20080821120626.GG5615@elte.hu> <48ADA2C2.8090905@keyaccess.nl> <48ADF3FC.7070002@keyaccess.nl> <20080822041544.GF30284@elte.hu>
In-Reply-To: <20080822041544.GF30284@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------060807050705080505040700"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060807050705080505040700
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 22-08-08 06:15, Ingo Molnar wrote:

>> Actually, might as well simply reconstruct the memtype list at free 
>> time I guess. How is this for a coalescing version of the array 
>> functions?
> 
> impressive! Rarely do we get this much bang for such a low linecount :-)

Thanks. Stared at it a little longer now and there  was a small cut and 
paste error in the error path (s/start/tmp/) but other than that, yes, 
I'll stand by this. set_memory_array_{uc,wb}() set all pages to the same
type, so coalescing them makes sense in any usage case it seems.

The attached version fixes the out path, is otherwise identical and this 
time comes with a proper changelog and a sign-off. Given that you needed 
the changelog and the sign-off anyway, I thought there wouldn't be much 
point in doing that incrementally, but if you disagree and refactor -- a 
changelog for the out path fix would be a simple:

===
x86: fix "have set_memory_array_{uc,wb} coalesce memtypes".

Fix copy and paste error in out path

Signed-off-by: Rene Herman <rene.herman@gmail.com>
===

> I'd do this in v2.6.27 but i forced myself to be reasonable and applied 
> your patches to tip/x86/pat instead, for tentative v2.6.28 merging 
> (assuming it all passes testing, etc.):

Yes, I agree not for .27

>  # 9a79f4f: x86: {reverve,free}_memtype() take a physical address
>  # c5e147c: x86: have set_memory_array_{uc,wb} coalesce memtypes.
>  # 5f310b6: agp: enable optimized agp_alloc_pages methods
> 
> ( note that i flipped them around a bit and have put your 
>   enable-agp_alloc_pages()-widely patch last, so that we get better 
>   bisection behavior. )
> 
> The frontside cache itself is in x86/urgent:
> 
>  # 80c5e73: x86: fix Xorg startup/shutdown slowdown with PAT
> 
> ... and should at least solve the symptom that you've hit in practice 
> (the slowdown), without changing the underlying PAT machinery. (which 
> would be way too dangerous for v2.6.27)

Well, please note that that specific commit only fixes X startup -- it 
doesn't do anything for shutdown. With only that one, I'm still at 14 
seconds for X shutdown (first time after boot that is, 5 seconds 
subsequent shutdowns) versus 1 (or sub 1, feels immediate) normally.

It's also a black-screen "hang", so we'll probably be getting a lot of 
"long hang at shutdown" reports without something additionally for .27.

Venki?

> And it's all merged up in tip/master, you might want to test that too to 
> check whether all the pieces fit together nicely.

Wasn't in tip/master when I just now fetched it. It does indeed sit in 
tip/x86/pat.

Rene.

--------------060807050705080505040700
Content-Type: text/plain;
 name="0001-x86-have-set_memory_array_-uc-wb-coalesce-memtypes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-x86-have-set_memory_array_-uc-wb-coalesce-memtypes.patc";
 filename*1="h"

>From 1a9bfbada3769e1bd9eecddd43ade9ebc4671c3d Mon Sep 17 00:00:00 2001
From: Rene Herman <rene.herman@gmail.com>
Date: Fri, 22 Aug 2008 21:27:45 +0200
Subject: [PATCH] x86: have set_memory_array_{uc,wb} coalesce memtypes.

Have set_memory_array_{uc,wb}() coalesce memtype entries so as to
avoid having unusefully many of them.

Especially in the case of AGP with its order 0 allocations for the
AGP memory the memtype list otherwise ends up with tens of thousands
of entries, slowing processing to a crawl. With this (and the former
changes to make AGP use this interface) AGP memory will just take as
many entries as needed -- which often means just one.

Note that the error path in set_memory_array_uc() just reconstructs
the entries from start again: no need to keep an expensive list of
regions around for an error condition which isn't going to happen.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
---
 arch/x86/mm/pageattr.c |   38 ++++++++++++++++++++++++++++++++------
 1 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index d49e4db..c7563b6 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -942,21 +942,38 @@ EXPORT_SYMBOL(set_memory_uc);
 
 int set_memory_array_uc(unsigned long *addr, int addrinarray)
 {
+	unsigned long start;
+	unsigned long end;
 	int i;
 	/*
 	 * for now UC MINUS. see comments in ioremap_nocache()
 	 */
 	for (i = 0; i < addrinarray; i++) {
-		if (reserve_memtype(__pa(addr[i]), __pa(addr[i]) + PAGE_SIZE,
-			    _PAGE_CACHE_UC_MINUS, NULL))
+		start = __pa(addr[i]);
+		for (end = start + PAGE_SIZE; i < addrinarray - 1; end += PAGE_SIZE) {
+			if (end != __pa(addr[i + 1]))
+				break;
+			i++;
+		}
+		if (reserve_memtype(start, end, _PAGE_CACHE_UC_MINUS, NULL))
 			goto out;
 	}
 
 	return change_page_attr_set(addr, addrinarray,
 				    __pgprot(_PAGE_CACHE_UC_MINUS), 1);
 out:
-	while (--i >= 0)
-		free_memtype(__pa(addr[i]), __pa(addr[i]) + PAGE_SIZE);
+	for (i = 0; i < addrinarray; i++) {
+		unsigned long tmp = __pa(addr[i]);
+
+		if (tmp == start)
+			break;
+		for (end = tmp + PAGE_SIZE; i < addrinarray - 1; end += PAGE_SIZE) {
+			if (end != __pa(addr[i + 1]))
+				break;
+			i++;
+		}
+		free_memtype(tmp, end);
+	}
 	return -EINVAL;
 }
 EXPORT_SYMBOL(set_memory_array_uc);
@@ -997,9 +1014,18 @@ EXPORT_SYMBOL(set_memory_wb);
 int set_memory_array_wb(unsigned long *addr, int addrinarray)
 {
 	int i;
-	for (i = 0; i < addrinarray; i++)
-		free_memtype(__pa(addr[i]), __pa(addr[i]) + PAGE_SIZE);
 
+	for (i = 0; i < addrinarray; i++) {
+		unsigned long start = __pa(addr[i]);
+		unsigned long end;
+
+		for (end = start + PAGE_SIZE; i < addrinarray - 1; end += PAGE_SIZE) {
+			if (end != __pa(addr[i + 1]))
+				break;
+			i++;
+		}
+		free_memtype(start, end);
+	}
 	return change_page_attr_clear(addr, addrinarray,
 				      __pgprot(_PAGE_CACHE_MASK), 1);
 }
-- 
1.5.5


--------------060807050705080505040700--
