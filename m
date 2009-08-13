Return-Path: <linux-kernel-owner+w=401wt.eu-S932354AbZHMUHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354AbZHMUHA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756140AbZHMUG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:06:57 -0400
Received: from kroah.org ([198.145.64.141]:41823 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206AbZHMT7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:46 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:30 2009
Message-Id: <20090813195130.664882602@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Dave Airlie <airlied@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 41/74] x86, pat: Fix set_memory_wc related corruption
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=x86-pat-fix-set_memory_wc-related-corruption.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>

commit bdc6340f4eb68295b1e7c0ade2356b56dca93d93 upstream.

Changeset 3869c4aa18835c8c61b44bd0f3ace36e9d3b5bd0
that went in after 2.6.30-rc1 was a seemingly small change to _set_memory_wc()
to make it complaint with SDM requirements. But, introduced a nasty bug, which
can result in crash and/or strange corruptions when set_memory_wc is used.
One such crash reported here
http://lkml.org/lkml/2009/7/30/94

Actually, that changeset introduced two bugs.
* change_page_attr_set() takes &addr as first argument and can the addr value
  might have changed on return, even for single page change_page_attr_set()
  call. That will make the second change_page_attr_set() in this routine
  operate on unrelated addr, that can eventually cause strange corruptions
  and bad page state crash.
* The second change_page_attr_set() call, before setting _PAGE_CACHE_WC, should
  clear the earlier _PAGE_CACHE_UC_MINUS, as otherwise cache attribute will not
  be WC (will be UC instead).

The patch below fixes both these problems. Sending a single patch to fix both
the problems, as the change is to the same line of code. The change to have a
addr_copy is not very clean. But, it is simpler than making more changes
through various routines in pageattr.c.

A huge thanks to Jerome for reporting this problem and providing a simple test
case that helped us root cause the problem.

Reported-by: Jerome Glisse <glisse@freedesktop.org>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20090730214319.GA1889@linux-os.sc.intel.com>
Acked-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/pageattr.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1002,12 +1002,15 @@ EXPORT_SYMBOL(set_memory_array_uc);
 int _set_memory_wc(unsigned long addr, int numpages)
 {
 	int ret;
+	unsigned long addr_copy = addr;
+
 	ret = change_page_attr_set(&addr, numpages,
 				    __pgprot(_PAGE_CACHE_UC_MINUS), 0);
-
 	if (!ret) {
-		ret = change_page_attr_set(&addr, numpages,
-				    __pgprot(_PAGE_CACHE_WC), 0);
+		ret = change_page_attr_set_clr(&addr_copy, numpages,
+					       __pgprot(_PAGE_CACHE_WC),
+					       __pgprot(_PAGE_CACHE_MASK),
+					       0, 0, NULL);
 	}
 	return ret;
 }


