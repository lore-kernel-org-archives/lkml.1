Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbZCFIDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbZCFIDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 03:03:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZCFIDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 03:03:36 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47168 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbZCFIDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 03:03:36 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Davi Arnaut <davi.arnaut@gmail.com>
Subject: Re: [RFC][PATCH] kmemdup_from_user(): introduce
Cc: kosaki.motohiro@jp.fujitsu.com, Americo Wang <xiyou.wangcong@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <20090306163600.3469.A69D9226@jp.fujitsu.com>
References: <20090306072328.GL22605@hack.private> <20090306163600.3469.A69D9226@jp.fujitsu.com>
Message-Id: <20090306164445.7BE4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri,  6 Mar 2009 17:03:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc to Davi Arnaut)

> > > /**
> > >+ * kmemdup_from_user - duplicate memory region from user space
> > >+ *
> > >+ * @src: source address in user space
> > >+ * @len: number of bytes to copy
> > >+ * @gfp: GFP mask to use
> > >+ */
> > >+void *kmemdup_from_user(const void __user *src, size_t len, gfp_t gfp)
> > >+{
> > >+	void *p;
> > >+
> > >+	p = kmalloc_track_caller(len, gfp);
> > 
> > 
> > Well, you use kmalloc_track_caller, instead of kmalloc as you showed
> > above. :) Why don't you mention this?
> 
> kmalloc() wrapper function must use kmalloc_track_caller().

I find another kmalloc() usage in the same file.
Davi, Can you agree following patch?


==
Subject: [PATCH] Don't use kmalloc() in strndup_user(). instead, use kmalloc_track_caller().

kmalloc() wrapper function should use kmalloc_track_caller() instead
kmalloc().

slab.h talk about the reason. 

/*
 * kmalloc_track_caller is a special version of kmalloc that records the
 * calling function of the routine calling it for slab leak tracking instead
 * of just the calling function (confusing, eh?).
 * It's useful when the call to kmalloc comes from a widely-used standard
 * allocator where we care about the real place the memory allocation
 * request comes from.
 */


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/util.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/util.c b/mm/util.c
index 37eaccd..202da19 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -167,7 +167,7 @@ char *strndup_user(const char __user *s, long n)
 	if (length > n)
 		return ERR_PTR(-EINVAL);
 
-	p = kmalloc(length, GFP_KERNEL);
+	p = kmalloc_track_caller(length, GFP_KERNEL);
 
 	if (!p)
 		return ERR_PTR(-ENOMEM);
-- 
1.6.1.2



