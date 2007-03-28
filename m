Return-Path: <linux-kernel-owner+w=401wt.eu-S933890AbXC1XeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933890AbXC1XeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 19:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933921AbXC1XeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 19:34:25 -0400
Received: from smtp.osdl.org ([65.172.181.24]:35621 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933890AbXC1XeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 19:34:25 -0400
Date: Wed, 28 Mar 2007 16:34:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zach Brown <zach.brown@oracle.com>
Cc: Ken Chen <kenchen@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] cache pipe buf page address for non-highmem arch
Message-Id: <20070328163416.133d109a.akpm@linux-foundation.org>
In-Reply-To: <3F0B1567-B32C-44F4-9B90-0737ADDACC56@oracle.com>
References: <b040c32a0703221751x54417524l5237742f345eeda9@mail.gmail.com>
	<20070322170122.ee2589a1.akpm@linux-foundation.org>
	<b040c32a0703231748s112beda6i3d51ebcd658005c4@mail.gmail.com>
	<20070326201552.b8ad7dda.akpm@linux-foundation.org>
	<b040c32a0703271047vba81938q538d182c9c984f42@mail.gmail.com>
	<3D4D126C-0B26-4B00-A2E4-68BD84555B51@oracle.com>
	<20070328161420.3c8f9688.akpm@linux-foundation.org>
	<3F0B1567-B32C-44F4-9B90-0737ADDACC56@oracle.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007 16:21:04 -0700
Zach Brown <zach.brown@oracle.com> wrote:

> > Does this look OK?
> 
> Almost...
> 
> > #ifdef CONFIG_HIGHMEM
> > static inline void pipe_kunmap_atomic(void *addr, enum km_type type)
> > #else	/* CONFIG_HIGHMEM */
> > static inline void pipe_kunmap_atomic(struct page *page, enum  
> > km_type type)
> 

OK, I give up.  What are you telling me here?

<compiles it>

argh, enum km_type isn't defined if !CONFIG_HIGHMEM, which is extravagantly
dumb.


From: Andrew Morton <akpm@linux-foundation.org>

Cc: "Ken Chen" <kenchen@google.com>
Cc: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |   31 +++++++++++++++++++++++++------
 1 files changed, 25 insertions(+), 6 deletions(-)

diff -puN fs/pipe.c~cache-pipe-buf-page-address-for-non-highmem-arch-fix-tidy fs/pipe.c
--- a/fs/pipe.c~cache-pipe-buf-page-address-for-non-highmem-arch-fix-tidy
+++ a/fs/pipe.c
@@ -22,17 +22,36 @@
 #include <asm/ioctls.h>
 
 #ifdef CONFIG_HIGHMEM
-#define pipe_kmap		kmap
-#define pipe_kmap_atomic	kmap_atomic
-#define pipe_kunmap		kunmap
-#define pipe_kunmap_atomic	kunmap_atomic
+static inline void *pipe_kmap(struct page *page)
+{
+	return kmap(page);
+}
+
+static inline void pipe_kunmap(struct page *page)
+{
+	kunmap(page);
+}
+
+static inline void *pipe_kmap_atomic(struct page *page, enum km_type type)
+{
+	return kmap_atomic(page, type);
+}
+
+static inline void pipe_kunmap_atomic(void *addr, enum km_type type)
+{
+	kunmap_atomic(addr, type);
+}
 #else	/* CONFIG_HIGHMEM */
 static inline void *pipe_kmap(struct page *page)
 {
-	return (void *) page->private;
+	return (void *)page->private;
 }
+
+static inline void pipe_kunmap(struct page *page)
+{
+}
+
 #define pipe_kmap_atomic(page, type)	pipe_kmap(page)
-#define pipe_kunmap(page)		do { } while (0)
 #define pipe_kunmap_atomic(page, type)	do { } while (0)
 #endif
 
_

