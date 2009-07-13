Return-Path: <linux-kernel-owner+w=401wt.eu-S1752078AbZGMFrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbZGMFrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 01:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbZGMFrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 01:47:46 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40887 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbZGMFrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 01:47:45 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 13 Jul 2009 14:45:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       npiggin@suse.de,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       avi@redhat.com, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, aarcange@redhat.com
Subject: Re: [PATCH 0/2] ZERO PAGE again v3.
Message-Id: <20090713144550.764c8f82.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090709122428.8c2d4232.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090709122428.8c2d4232.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do you think this kind of document is necessary for v4 ? 
Any commetns are welcome.
Maybe some amount of people are busy at Montreal, then I'm not in hurry ;)

==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Add a documenation about zero page at re-introducing it.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 Documentation/vm/zeropage.txt |   77 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

Index: zeropage-trialv4/Documentation/vm/zeropage.txt
===================================================================
--- /dev/null
+++ zeropage-trialv4/Documentation/vm/zeropage.txt
@@ -0,0 +1,77 @@
+Zero Page.
+
+ZERO Page is a page filled with Zero and never modified (write-protected).
+Each arch has its own ZERO_PAGE in the kernel and macro ZERO_PAGE(addr) is
+provided. Now, usage of ZERO_PAGE() is limited.
+
+This documentation explains ZERO_PAGE() for private anonymous mappings.
+
+If CONFIG_SUPPORT_ANON_ZERO_PAGE==y, ZERO_PAGE is used for private anonymous
+mapping. If a read fault to anonymous private mapping occurs, ZERO_PAGE is
+mapped for the faulted address instead of an usual anonymous page. This mapped
+ZERO_PAGE is write-protected and the user process will do copy-on-write when
+it writes there. ZERO_PAGE is used only when vma is for PRIVATE mapping and
+has no vm_ops.
+
+Implementation Details
+ - ZERO_PAGE uses pte_special() for implementation. Then, an arch has to support
+   pte_special() to support ZERO_PAGE for Anon.
+ - ZERO_PAGE for anon has no reference counter manipulation at map/unmap.
+ - When get_user_pages() finds ZERO_PAGE, page->count is got/put.
+ - By passing special flags FOLL_NOZERO, the caller can ignore zero pages.
+ - Because ZERO_PAGE is used only when a read fault on MAP_PRIVATE anonymous
+   MAP_POPULATE may map ZERO_PAGE when it handles read only PRIVATE anonymous
+   mapping. Then, usual anonymous pages will be used in such case.
+ - At coredump, ZERO PAGE will be used for not-existing memory.
+
+For User Applications.
+
+ZERO Page is not the best solution for applications in many case. It's tend
+to be the second best if you have enough time to improve your applications.
+
+Pros. of ZERO Page
+ - not consume extra memory
+ - cpu cache over head is small.(if your cache is physically tagged.)
+ - page's reference count overhead is hidden. This is good for fork()/exec()
+   processes.
+
+Cons. of ZERO Page
+ - Just available for read-faulted anonymous private mappings.
+ - If applications depend on ZERO_PAGE, it means it consume extra TLB.
+ - you can only reduce the memory usage of read-faulted pages.
+
+ZERO Page is helpful in some cases but you can use following techniques.
+Followings are typical solutions for avoiding ZERO Pages. But please note, there
+are always trade-off among designs.
+
+ => Avoid large continuous mapping and use small mmaps.
+    If # of mmap doesn't increase very much, this is good because your
+    application can avoid TLB pollution by ZERO Page and never do unnecessary
+    access.
+
+ => Use large continuous mapping and see /proc/<pid>/pagemap
+    You can check "Which ptes are valid ?" by checking /proc/<pid>/pagemap
+    and avoid unnecessary fault at scanning memory range. But reading
+    /proc/<pid>/pagemap is not very low cost, then the benefit of this technique
+    is depends on usage.
+
+ => Use KSM.(to be implemented..)
+    KSM(kernel shared memory) can merge your anonymous mapped pages with pages
+    of the same contents. Then, ZERO Page will be merged and more pages will
+    be merged. But in bad case, pages are heavily shared and it may affects
+    performance of fork/exit/exec. Behavior depends on the latest KSM
+    implementations, please check.
+
+For kernel developers.
+ Your arch has to support pte_special() and add ARCH_SUPPORT_ANON_ZERO_PAGE=y
+ to use ZERO PAGE. If your arch's cpu-cache is virtually tagged, it's
+ recommended to turn off this feature. To test this, following case should
+ be checked.
+ - mmap/munmap/fork/exit/exec and touch anonymous private pages by READ.
+ - MAP_POPULATE in above test.
+ - mlock()
+ - coredump
+ - /dev/zero PRIVATE mapping
+
+
+

