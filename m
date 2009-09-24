Return-Path: <linux-kernel-owner+w=401wt.eu-S1753115AbZIXSqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbZIXSqB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 14:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbZIXSp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 14:45:57 -0400
Received: from smtp-out.google.com ([216.239.33.17]:54270 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbZIXSp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 14:45:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=km0ThGdGiZ1ZGxZB9pLIaqX2XEdfePHpwVvuJf3l3u4NPHN+VYp0NavTrNlsayys2
	EBLJC1aU55uLyA9Xpns0g==
Date: Thu, 24 Sep 2009 11:45:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: David Howells <dhowells@redhat.com>
cc: torvalds@osdl.org, akpm@linux-foundation.org, ebmunson@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HugeTLB: Fix unused variable warning
In-Reply-To: <20090924100232.19291.70594.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.DEB.1.00.0909241143400.2673@chino.kir.corp.google.com>
References: <20090924100232.19291.70594.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009, David Howells wrote:

> Fix an unused variable warning:
> 
> 	mm/mmap.c: In function 'do_mmap_pgoff':
> 	mm/mmap.c:953: warning: unused variable 'user'
> 
> by converting the CONFIG_HUGETLBFS=n version of hugetlb_file_setup() into an
> inline function instead of a macro.
> 
> Introduced by:
> 
> 	commit 4e52780d41a741fb4861ae1df2413dd816ec11b1
> 	Author: Eric B Munson <ebmunson@us.ibm.com>
> 	Date:   Mon Sep 21 17:03:47 2009 -0700
> 	hugetlb: add MAP_HUGETLB for mmaping pseudo-anonymous huge page regions
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Andrew added hugetlb_file_setup-use-c-not-cpp.patch to -mm on Tuesday and 
it should appear in the next mmotm.


From: Andrew Morton <akpm@linux-foundation.org>

why macros are always wrong:

mm/mmap.c: In function 'do_mmap_pgoff':
mm/mmap.c:953: warning: unused variable 'user'

also, move a couple of struct forward-decls outside `#ifdef
CONFIG_HUGETLB_PAGE' - it's pointless and frequently harmful to make these
conditional (eg, this patch needed `struct user_struct').

Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Eric Whitney <eric.whitney@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN include/linux/hugetlb.h~hugetlb_file_setup-use-c-not-cpp include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb_file_setup-use-c-not-cpp
+++ a/include/linux/hugetlb.h
@@ -3,15 +3,15 @@

 #include <linux/fs.h>

+struct ctl_table;
+struct user_struct;
+
 #ifdef CONFIG_HUGETLB_PAGE

 #include <linux/mempolicy.h>
 #include <linux/shm.h>
 #include <asm/tlbflush.h>

-struct ctl_table;
-struct user_struct;
-
 int PageHuge(struct page *page);

 static inline int is_vm_hugetlb_page(struct vm_area_struct *vma)
@@ -187,7 +187,11 @@ static inline void set_file_hugepages(st

 #define is_file_hugepages(file)                        0
 #define set_file_hugepages(file)               BUG()
-#define hugetlb_file_setup(name,size,acct,user,creat)  ERR_PTR(-ENOSYS)
+static inline struct file *hugetlb_file_setup(const char *name, size_t size, int acctflag,
+                               struct user_struct **user, int creat_flags)
+{
+       return ERR_PTR(-ENOSYS);
+}

 #endif /* !CONFIG_HUGETLBFS */
 
