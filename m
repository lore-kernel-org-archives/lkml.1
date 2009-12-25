Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbZLYBva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbZLYBva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 20:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245AbZLYBv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 20:51:29 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58071 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120AbZLYBv3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 20:51:29 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] futex: Fix ZERO_PAGE cause infinite loop
Cc: kosaki.motohiro@jp.fujitsu.com, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhltc@us.ibm.com>,
       Ulrich Drepper <drepper@gmail.com>
In-Reply-To: <1261647565.4937.177.camel@laptop>
References: <20091224182630.3DCB.A69D9226@jp.fujitsu.com> <1261647565.4937.177.camel@laptop>
Message-Id: <20091225083305.AA78.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 25 Dec 2009 10:51:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > diff --git a/kernel/futex.c b/kernel/futex.c
> > index 8e3c3ff..79b89cc 100644
> > --- a/kernel/futex.c
> > +++ b/kernel/futex.c
> > @@ -254,6 +254,8 @@ again:
> >  
> >  	page = compound_head(page);
> >  	lock_page(page);
> > +	if (is_zero_pfn(page_to_pfn(page)))
> > +		goto anon_key;
> >  	if (!page->mapping) {
> >  		unlock_page(page);
> >  		put_page(page);
> > @@ -268,6 +270,7 @@ again:
> >  	 * the object not the particular process.
> >  	 */
> >  	if (PageAnon(page)) {
> > + anon_key:
> >  		key->both.offset |= FUT_OFF_MMSHARED; /* ref taken on mm */
> >  		key->private.mm = mm;
> >  		key->private.address = address;
> 
> Doesn't it make more sense to simply fail the futex op?
> 
> What I mean is, all (?) futex ops assume userspace actually wrote
> something to the address in question to begin with, therefore it can
> never be the zero page.
> 
> So it being the zero page means someone goofed up, and we should bail,
> no?

Hm. probably we need to discuss more.

Firstly, if we assume current glibc implimentation, you are right,
we can assume userland always initialize the page explicitly before using
futex. then we never seen zero page in futex.

but, I don't think futex itself assume it now. at least man page
doesn't describe such limilation. so, if you prefer bail and man fix,
I'm acceptable maybe.

I don't know any library except glibc use futex directly, or not. 
but we don't have any reason to assume futex is used only glibc.
(plus, glibc might change its implementation in future release, perhaps)

following testcase is more practice than last mail's one.
if we add zero page bail logic, this testcase mihgt be fail.

----------------------------------------------------------------
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <syscall.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <linux/futex.h>
#include <pthread.h>

void * futex_wait(void *arg)
{
	void *addr = arg;
	int ret;

	fprintf(stderr, "futex wait\n");
	ret = syscall( SYS_futex, addr, FUTEX_WAIT, 0, NULL, NULL, NULL);
	if (ret != 0 && errno != EWOULDBLOCK) {
		perror("futex error.\n");
		exit(1);
	}
	fprintf(stderr, "futex_wait: ret = %d, errno = %d\n", ret, errno);

	return NULL;
}

int main(int argc, char **argv)
{
	long page_size;
	pthread_t thr;
	int ret;
	void *buf;

	page_size = sysconf(_SC_PAGESIZE);

	buf = mmap(NULL, page_size, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 0, 0);
	if (buf == (void *)-1) {
		perror("mmap error.\n");
		exit(1);
	}

	ret = pthread_create(&thr, NULL, futex_wait, buf);
	if (ret < 0) {
		fprintf(stderr, "pthread_create error\n");
		exit(1);
	}

	sleep(10);

	fprintf(stderr, "futex wake\n");
	*((int*)buf) = 1;
	ret = syscall( SYS_futex, buf, FUTEX_WAKE, 1, NULL, NULL, NULL);
	fprintf(stderr, "futex_wake: ret = %d, errno = %d\n", ret, errno);	

	fprintf(stderr, "join\n");
	pthread_join(thr, NULL);

	return 0;
}
--------------------------------------------------------------------------

man page fix has another difficulty. in past days, zero pages was perfectly
transparent from userland. then any man page don't describe "what's zero page".
then some administrator don't know about zero page at all.

So, if your main disliked point is goto statement, following patch is ok
to me.

Finally, I agree this is really corner case issue. I can agree man page fix
too. but I hope to know which point you dislike in my patch.

Thanks.




>From 09b0a7426c707e2fab5ac8e1ef8feec14415ee62 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 24 Dec 2009 18:07:42 +0900
Subject: [PATCH] futex: Fix ZERO_PAGE cause infinite loop

commit a13ea5b7 (mm: reinstate ZERO_PAGE) made the unfortunate regression.
following test program never finish and waste 100% cpu time.

At the making commit 38d47c1b7 (rely on get_user_pages() for shared
futexes). There isn't zero page in linux kernel. then, futex developers
thought gup retry is safe. but we reinstated zero page later...

This patch fixes it.

futex-zero.c
---------------------------------------------------------------------
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/mman.h>
 #include <syscall.h>
 #include <sys/time.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <unistd.h>
 #include <errno.h>
 #include <linux/futex.h>
 #include <pthread.h>

int main(int argc, char **argv)
{
        long page_size;
        int ret;
        void *buf;

        page_size = sysconf(_SC_PAGESIZE);

        buf = mmap(NULL, page_size, PROT_READ|PROT_WRITE,
			MAP_PRIVATE|MAP_ANONYMOUS, 0, 0);
        if (buf == (void *)-1) {
                perror("mmap error.\n");
                exit(1);
        }

        fprintf(stderr, "futex wait\n");
        ret = syscall( SYS_futex, buf, FUTEX_WAIT, 1, NULL, NULL, NULL);
        if (ret != 0 && errno != EWOULDBLOCK) {
                perror("futex error.\n");
                exit(1);
        }
        fprintf(stderr, "futex_wait: ret = %d, errno = %d\n", ret, errno);

        return 0;
}
---------------------------------------------------------------------

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/linux/mm.h |   16 ++++++++++++++++
 kernel/futex.c     |    6 ++++--
 mm/memory.c        |   14 --------------
 3 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2265f28..dd755ea 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -751,6 +751,22 @@ struct zap_details {
 	unsigned long truncate_count;		/* Compare vm_truncate_count */
 };
 
+#ifndef is_zero_pfn
+extern unsigned long zero_pfn;
+static inline int is_zero_pfn(unsigned long pfn)
+{
+	return pfn == zero_pfn;
+}
+#endif
+
+#ifndef my_zero_pfn
+extern unsigned long zero_pfn;
+static inline unsigned long my_zero_pfn(unsigned long addr)
+{
+	return zero_pfn;
+}
+#endif
+
 struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 		pte_t pte);
 
diff --git a/kernel/futex.c b/kernel/futex.c
index 8e3c3ff..ad72989 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -222,6 +222,7 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
 	struct mm_struct *mm = current->mm;
 	struct page *page;
 	int err;
+	int is_zero_page;
 
 	/*
 	 * The futex address must be "naturally" aligned.
@@ -253,8 +254,9 @@ again:
 		return err;
 
 	page = compound_head(page);
+	is_zero_page = is_zero_pfn(page_to_pfn(page));
 	lock_page(page);
-	if (!page->mapping) {
+	if (!is_zero_page && !page->mapping) {
 		unlock_page(page);
 		put_page(page);
 		goto again;
@@ -267,7 +269,7 @@ again:
 	 * it's a read-only handle, it's expected that futexes attach to
 	 * the object not the particular process.
 	 */
-	if (PageAnon(page)) {
+	if (is_zero_page || PageAnon(page)) {
 		key->both.offset |= FUT_OFF_MMSHARED; /* ref taken on mm */
 		key->private.mm = mm;
 		key->private.address = address;
diff --git a/mm/memory.c b/mm/memory.c
index 09e4b1b..3743fb5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -457,20 +457,6 @@ static inline int is_cow_mapping(unsigned int flags)
 	return (flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
 }
 
-#ifndef is_zero_pfn
-static inline int is_zero_pfn(unsigned long pfn)
-{
-	return pfn == zero_pfn;
-}
-#endif
-
-#ifndef my_zero_pfn
-static inline unsigned long my_zero_pfn(unsigned long addr)
-{
-	return zero_pfn;
-}
-#endif
-
 /*
  * vm_normal_page -- This function gets the "struct page" associated with a pte.
  *
-- 
1.6.5.2



